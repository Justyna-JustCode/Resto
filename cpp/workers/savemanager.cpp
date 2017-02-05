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

#include "savemanager.h"

#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QDebug>
#include <QStandardPaths>

#include "workers/backupmanager.h"

const QLatin1String SaveManager::sc_saveName = QLatin1String("saveData.dat");

SaveManager::SaveManager(BackupManager &manager, QObject *parent)
    : QObject(parent), m_backupManager(manager)
{}

void SaveManager::initialize()
{
    // this moves saved file to a backup file so it would be restored
    if (QFile::exists(savePath()) ) {
        auto backupPath = m_backupManager.backupPath();

        if (QFile::exists(backupPath)) {
            QFile::remove(backupPath);
        }

        QFile saveFile(savePath());
        if (!saveFile.rename(backupPath)) {
            qWarning() << "Cannot restore saved file.";
        }
    } else {
        auto savePathDir = QFileInfo(savePath()).absoluteDir();
        if (!savePathDir.exists())
            savePathDir.mkpath(savePathDir.absolutePath());
    }
}

bool SaveManager::save()
{
    m_backupManager.forceBackup();
    return QFile::copy(m_backupManager.backupPath(), savePath());
}

QString SaveManager::savePath() const
{
    return QDir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation)).absoluteFilePath(sc_saveName);
}
