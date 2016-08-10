#include "backupmanager.h"

#include <QDebug>
#include <QCoreApplication>
#include <QDir>
#include <QDataStream>

const QLatin1String BackupManager::sc_fileName = QLatin1String(".backup.dat"); // hidden file

BackupManager::BackupManager(QObject *parent)
    : BackupManager(sc_defaultInterval, parent)
{}
BackupManager::BackupManager(int backupInterval, QObject *parent)
    : QObject(parent), m_interval(backupInterval)
{}

BackupManager::~BackupManager()
{
    cleanup();
}

int BackupManager::interval() const
{
    return m_interval;
}
void BackupManager::setInterval(int backupInterval)
{
    m_interval = backupInterval;
    restartTimer();
}

void BackupManager::initialize()
{
    // check if previous backup file exist and restore if so
    setupFile();
    checkAndRestore();

    // initialize next backup checking
    connect(&m_timer, &QTimer::timeout, this, &BackupManager::doBackup);
    restartTimer();
}

BackupManager::Data &BackupManager::data()
{
    return m_data;
}

void BackupManager::setupFile()
{
    m_dataFile.setFileName(QDir(QCoreApplication::applicationDirPath()).absoluteFilePath(sc_fileName));
}

void BackupManager::restartTimer()
{
    m_timer.setInterval(m_interval);
    m_timer.start();
}

void BackupManager::cleanup()
{
    /* write empty data in case
     * of removing failiture */
    m_data = Data();
    doBackup();

    // remove file
    m_dataFile.remove();
}

void BackupManager::checkAndRestore()
{
    /* if file not exist, it means that
     * apllication has been closed normaly */
    if (!m_dataFile.exists()) {
        return;
    }

    m_dataFile.open(QFile::ReadOnly);
    if (!m_dataFile.isOpen()) {
        qWarning() << "Cannot open previous backup file:"
                   << m_dataFile.errorString();
        return;
    }

    QDataStream dataStream(&m_dataFile);
    Data readedData;
    dataStream >> readedData;

    // jeśli poprawnie przeczytano dane
    if (!readedData.isEmpty()) {
        emit backupData(readedData);
    }

    m_dataFile.close();
}

void BackupManager::doBackup()
{
    m_dataFile.open(QFile::WriteOnly | QFile::Truncate);
    if (!m_dataFile.isOpen()) {
        qWarning() << "Cannot open backup file:"
                   << m_dataFile.errorString();
        return;
    }

    QDataStream dataStream(&m_dataFile);
    dataStream << m_data;

    m_dataFile.close();
}

bool BackupManager::Data::isEmpty()
{
    return (elapsedWorkPeriod == 0 &&
            elapsedWorkTime == 0 );
}

QDataStream &operator<<(QDataStream &stream, const BackupManager::Data &data)
{
    stream << data.elapsedWorkPeriod << data.elapsedWorkTime;
    return stream;
}
QDataStream &operator>>(QDataStream &stream, BackupManager::Data &data)
{
    stream >> data.elapsedWorkPeriod;
    stream >> data.elapsedWorkTime;
    return stream;
}