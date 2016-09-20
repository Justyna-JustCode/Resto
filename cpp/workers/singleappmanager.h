#ifndef QTSINGLEAPPMANAGER_H
#define QTSINGLEAPPMANAGER_H

#include <QObject>
#include <QLocalServer>
#include <QLocalSocket>

class SingleAppManager : public QObject
{
    Q_OBJECT
public:
    explicit SingleAppManager(QObject *parent = 0);
    virtual ~SingleAppManager();

    bool tryRun();

signals:
    void anotherAppStarted() const;

protected:
    QLocalServer m_server;

    bool isAnotherRunned();
    bool createServer();

    void checkPing();

private:
    static const QLatin1String sc_serverName;
    static const QLatin1String sc_pingCommand;
};

#endif // QTSINGLEAPPMANAGER_H
