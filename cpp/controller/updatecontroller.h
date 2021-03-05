/********************************************
**
** Copyright 2017 Justyna JustCode
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

#ifndef UPDATEMANAGER_H
#define UPDATEMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QUrl>

class QNetworkReply;
class SettingsController;

/*!
 * \brief Class to check availability of new software version.
 */
class UpdateController final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool updateAvailable READ updateAvailable NOTIFY updateAvailableChanged)
    Q_PROPERTY(bool updatePossible READ updatePossible CONSTANT)
    Q_PROPERTY(QString newestVersion READ newestVersion NOTIFY newestVersionChanged)
    Q_PROPERTY(QString releaseNotes READ releaseNotes NOTIFY releaseNotesChanged)
    Q_PROPERTY(QUrl platformDownloadUrl READ platformDownloadUrl WRITE setPlatformDownloadUrl NOTIFY platformDownloadUrlChanged)

public:
    UpdateController(SettingsController &settingsController, const QUrl &versionUrl, QObject *parent = 0);

    bool updateAvailable() const;
    bool updatePossible() const;
    QString newestVersion() const;

    QString releaseNotes() const;
    QUrl platformDownloadUrl() const;

    Q_INVOKABLE int compareVersions(const QString &vStr1, const QString &vStr2) const;

public slots:
    /*!
     * \brief Check if new version of software is available.
     */
    void checkUpdateAvailable();

    /*!
     * \brief Downloads the newest package.
     */
    void download();
    /*!
     * \brief Runs the updater application.
     */
    void update();
    /*!
     * \brief Postpones download (remind me later).
     */
    void postpone();
    /*!
     * \brief Skips current newest version.
     */
    void skip();

signals:
    void updateAvailableChanged(bool updateAvailable) const;
    void newestVersionChanged(QString newestVersion) const;
    void releaseNotesChanged(QString releaseNotes) const;
    void platformDownloadUrlChanged(QUrl platformDownloadUrl) const;

    void checkFinished() const;
    void checkError() const;
    void updateStarted() const;

private:
    static const int sc_retryInterval = 1000; // ms
    static const int sc_retryMaxCount = 5;
    static const int sc_postponeInterval = 7;   // days

    static const QString sc_updaterAppName;

    SettingsController &m_settingsController;

    QUrl m_versionUrl;
    QString m_platformType; // os
    QString m_platformWordSize; // 32bit or 64bit

    QString m_updaterAppPath;
    bool m_updateAvailable = false;
    QString m_newestVersion;
    QString m_releaseNotes;
    QUrl m_platformDownloadUrl;

    QNetworkAccessManager m_nam;
    QNetworkReply *m_curReply = nullptr;
    int m_retryCounter = 0;

    void checkPlatformInfo();

    void getVersionResponse();
    void parseVersionResponse(const QByteArray &response);

private slots:
    void setUpdateAvailable(bool updateAvailable);
    void setNewestVersion(QString newestVersion);
    void setReleaseNotes(QString releaseNotes);
    void setPlatformDownloadUrl(QUrl platformDownloadUrl);

    void onNetworReply(QNetworkReply *reply);
};

#endif // UPDATEMANAGER_H
