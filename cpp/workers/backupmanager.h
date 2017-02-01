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

#ifndef BACKUPMANAGER_H
#define BACKUPMANAGER_H

#include <QObject>
#include <QTimer>
#include <QFile>

/*!
 * \brief Class to handle backups.
 * It is used to save and restore current state
 * after any application or system breakdown.
 */
class BackupManager final : public QObject
{
    Q_OBJECT
public:
    /*!
     * \brief Structure used to save and restore the data.
     */
    struct Data {
        int elapsedWorkPeriod = 0;
        int elapsedWorkTime = 0;

        bool isEmpty();
    };

    explicit BackupManager(QObject *parent = 0);
    BackupManager(int interval, QObject *parent = 0);
    ~BackupManager();

    int interval() const;
    void setInterval(int interval);

    void start();   //! start process of backups
    void stop();    //! stop prcoess of backups

    /*!
     * \brief Cleaning all data.
     * Used when application is closed properly.
     */
    void cleanup();

    /*!
     * \brief Doing a backup even if interval not yet passed.
     */
    void forceBackup();

    QString backupPath() const;

    Data &data();

signals:
    void backupData(const Data &data);

public slots:
    /*!
     * \brief Initialize the object and start backups.
     */
    void initialize();

private:
    static const int sc_defaultInterval = 5*60;   // default interval (in secs)
    static const QLatin1String sc_fileName;

    QTimer m_timer; //! used to trigger next backup
    int m_interval;  //! interval between each backup (in seconds)

    QFile m_dataFile;   //! file used to store and restore the data
    Data m_data;        //! currently storred data

private slots:
    /*!
     * \brief Setups file with backup data.
     * Make it valid for open.
     */
    void setupFile();
    /*!
     * \brief Reinitialize timer with current interval.
     */
    void updateInterval();

    /*!
     * \brief Cheks if previous backup exist and restore it.
     * Has to be called after file setup and before first backup.
     */
    void checkAndRestore();
    void doBackup();
};

QDataStream &operator<<(QDataStream &stream, const BackupManager::Data &data);
QDataStream &operator>>(QDataStream &stream, BackupManager::Data &data);

#endif // BACKUPMANAGER_H
