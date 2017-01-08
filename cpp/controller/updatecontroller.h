/********************************************
**
** Copyright 2017 JustCode Justyna Kulinska
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

/*!
 * \brief Class to check availability of new software version.
 */
class UpdateController final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool updateAvailable READ updateAvailable WRITE setUpdateAvailable NOTIFY updateAvailableChanged)
    Q_PROPERTY(QString newestVersion READ newestVersion WRITE setNewestVersion NOTIFY newestVersionChanged)
    Q_PROPERTY(QUrl platformDownloadUrl READ platformDownloadUrl WRITE setPlatformDownloadUrl NOTIFY platformDownloadUrlChanged)

public:
    UpdateController(const QUrl &versionUrl, QObject *parent = 0);

    bool updateAvailable() const;
    QString newestVersion() const;
    QUrl platformDownloadUrl() const;

public slots:
    /*!
     * \brief Check if new version of software is available.
     */
    void checkUpdateAvailable();

signals:
    void updateAvailableChanged(bool updateAvailable) const;
    void newestVersionChanged(QString newestVersion) const;
    void platformDownloadUrlChanged(QUrl platformDownloadUrl) const;

    void checkFinished() const;
    void checkError() const;

private:
    static const int sc_retryInterval = 1000; // ms
    static const int sc_retryMaxCount = 5;

    QUrl m_versionUrl;
    QString m_platformType; // os
    QString m_platformWordSize; // 32bit or 64bit

    bool m_updateAvailable = false;
    QString m_newestVersion;
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
    void setPlatformDownloadUrl(QUrl platformDownloadUrl);

    void onNetworReply(QNetworkReply *reply);
};

#endif // UPDATEMANAGER_H
