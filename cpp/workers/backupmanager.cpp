/********************************************
**
** Copyright 2016 JustCode Justyna Kulinska
**
** This file is part of Resto.
**
** Resto is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** any later version.
**
** Resto is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Resto; if not, write to the Free Software
** Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
**
********************************************/

#include "backupmanager.h"

#include <QDebug>
#include <QCoreApplication>
#include <QDir>
#include <QDataStream>
#include <QStandardPaths>

const QLatin1String BackupManager::sc_fileName = QLatin1String(".backup.dat"); // hidden file

BackupManager::BackupManager(QObject *parent)
    : BackupManager(sc_defaultInterval, parent)
{}
BackupManager::BackupManager(int backupInterval, QObject *parent)
    : QObject(parent), m_interval(backupInterval)
{}

BackupManager::~BackupManager()
{}

int BackupManager::interval() const
{
    return m_interval;
}
void BackupManager::setInterval(int backupInterval)
{
    m_interval = backupInterval;
    updateInterval();
}

void BackupManager::start()
{
    doBackup();
    m_timer.start();
}

void BackupManager::stop()
{
    m_timer.stop();
}

void BackupManager::cleanup()
{
    // remove file
    m_dataFile.remove();
}

void BackupManager::forceBackup()
{
    doBackup();
}

QString BackupManager::backupPath() const
{
    return QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)).absoluteFilePath(sc_fileName);
}

void BackupManager::initialize()
{
    // check if previous backup file exist and restore if so
    setupFile();
    checkAndRestore();

    // initialize next backup checking
    connect(&m_timer, &QTimer::timeout, this, &BackupManager::doBackup);
    updateInterval();
}

BackupManager::Data &BackupManager::data()
{
    return m_data;
}

void BackupManager::setupFile()
{
    auto backupPathDir = QFileInfo(backupPath()).absoluteDir();
    if (!backupPathDir.exists())
        backupPathDir.mkpath(backupPathDir.absolutePath());

    m_dataFile.setFileName(backupPath());
}

void BackupManager::updateInterval()
{
    m_timer.setInterval(m_interval*1000);
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
    return (elapsedBreakInterval == 0 &&
            elapsedWorkTime == 0 );
}

QDataStream &operator<<(QDataStream &stream, const BackupManager::Data &data)
{
    stream << data.elapsedBreakInterval << data.elapsedWorkTime << data.currentIteration;
    return stream;
}
QDataStream &operator>>(QDataStream &stream, BackupManager::Data &data)
{
    stream >> data.elapsedBreakInterval;
    stream >> data.elapsedWorkTime;
    stream >> data.currentIteration;
    return stream;
}
