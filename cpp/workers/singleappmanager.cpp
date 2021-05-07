#include "singleappmanager.h"

#include <QFile>

const QLatin1String SingleAppManager::sc_serverName = QLatin1String("RESTO_SINGLE-APP-SERVER");
const QLatin1String SingleAppManager::sc_pingCommand = QLatin1String("PING!");

SingleAppManager::SingleAppManager(QObject *parent) : QObject(parent)
{
    connect(&m_server, &QLocalServer::newConnection, [this]() {
        while (m_server.hasPendingConnections()) {
            auto connection = m_server.nextPendingConnection();

            connect(connection, &QLocalSocket::readyRead, this, &SingleAppManager::checkPing);
        }
    });
}

SingleAppManager::~SingleAppManager()
{
    disconnect(); // disconnect all signals
}

bool SingleAppManager::tryRun()
{
    if (isAnotherRunned())  // check for windows
        return false;

    if (!createServer())
        return false;

    return true;
}

bool SingleAppManager::isAnotherRunned()
{
    QLocalSocket testSocket;
    testSocket.connectToServer(sc_serverName, QLocalSocket::WriteOnly);
    auto connected = testSocket.waitForConnected();
    if (connected) {
        // write ping to another instance
        testSocket.write(sc_pingCommand.data());
        testSocket.waitForBytesWritten();
        testSocket.disconnectFromServer();
        if (testSocket.state() != QLocalSocket::UnconnectedState) {
            testSocket.waitForDisconnected();
        }
        return true;
    }

    return false;
}

bool SingleAppManager::createServer()
{
    auto success = m_server.listen(sc_serverName);
    if (!success &&
            m_server.serverError() == QAbstractSocket::AddressInUseError) {
        QLocalServer::removeServer(sc_serverName);

        success = m_server.listen(sc_serverName);
    }

    return success;
}

void SingleAppManager::checkPing()
{
    auto socket = dynamic_cast<QLocalSocket*>(sender());
    Q_ASSERT(socket);
    if (!socket) {
        qCritical() << Q_FUNC_INFO << "sender is not a socket!";
        return;
    }

    auto readedData = socket->readAll();
    if (readedData.startsWith(sc_pingCommand.data())) {
        emit anotherAppStarted();
    }

    socket->deleteLater();
}
