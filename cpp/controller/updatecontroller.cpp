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

#include "updatecontroller.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QApplication>
#include <QVersionNumber>
#include <QTimer>
#include <QDesktopServices>

#include "controller/settingscontroller.h"

UpdateController::UpdateController(SettingsController &settingsController, const QUrl &versionUrl, QObject *parent)
    : QObject(parent), m_settingsController(settingsController), m_versionUrl(versionUrl)
{
    checkPlatformInfo();

    // connections
    connect(&m_nam, &QNetworkAccessManager::finished,
            this, &UpdateController::onNetworReply);
}

bool UpdateController::updateAvailable() const
{
    return m_updateAvailable;
}

void UpdateController::checkUpdateAvailable()
{
    if (m_curReply && !m_curReply->isFinished()) {
        // if reply is processing, we just need to reset retry counter
        m_retryCounter = 0;
        return;
    }

    getVersionResponse();
}

void UpdateController::download()
{
    QDesktopServices::openUrl(m_platformDownloadUrl);
}

void UpdateController::postpone()
{
    m_settingsController.setUpdateVersion(m_newestVersion);
    m_settingsController.setNextUpdateCheck(QDateTime::currentDateTime().addDays(sc_postponeInterval));
}

void UpdateController::skip()
{
    m_settingsController.setUpdateVersion(m_newestVersion);
    m_settingsController.setNextUpdateCheck({});
}

QString UpdateController::newestVersion() const
{
    return m_newestVersion;
}

QString UpdateController::releaseNotes() const
{
    return m_releaseNotes;
}

QUrl UpdateController::platformDownloadUrl() const
{
    return m_platformDownloadUrl;
}

void UpdateController::checkPlatformInfo()
{
#ifdef Q_OS_LINUX
    m_platformType = "linux";
#elif defined(Q_OS_WIN)
    m_platformType = "windows";
#endif

    if (sizeof(void *) == 4) {
        m_platformWordSize = "32bit";
    } else if (sizeof(void *) == 8) {
        m_platformWordSize = "64bit";
    }
}

void UpdateController::getVersionResponse()
{
    m_curReply = m_nam.get(QNetworkRequest(m_versionUrl));
}

void UpdateController::setUpdateAvailable(bool updateAvailable)
{
    if (m_updateAvailable == updateAvailable)
        return;

    m_updateAvailable = updateAvailable;
    emit updateAvailableChanged(updateAvailable);
}

void UpdateController::setNewestVersion(QString newestVersion)
{
    if (m_newestVersion == newestVersion)
        return;

    m_newestVersion = newestVersion;
    emit newestVersionChanged(newestVersion);
}

void UpdateController::setReleaseNotes(QString releaseNotes)
{
    if (m_releaseNotes == releaseNotes)
        return;

    m_releaseNotes = releaseNotes;
    emit releaseNotesChanged(releaseNotes);
}

void UpdateController::setPlatformDownloadUrl(QUrl platformDownloadUrl)
{
    if (m_platformDownloadUrl == platformDownloadUrl)
        return;

    m_platformDownloadUrl = platformDownloadUrl;
    emit platformDownloadUrlChanged(platformDownloadUrl);
}

void UpdateController::parseVersionResponse(const QByteArray &response)
{
    auto updateInfoObj = QJsonDocument::fromJson(response).object();

    auto versionString = updateInfoObj.value("version").toString();
    setNewestVersion(versionString);

    auto curVersion = QVersionNumber::fromString(QApplication::applicationVersion());
    auto newestVersion = QVersionNumber::fromString(versionString);
    auto updateAvailable = curVersion < newestVersion;

    if (updateAvailable) {
        setReleaseNotes(updateInfoObj.value("releaseNotes").toString());

        auto downloadUrl = updateInfoObj.value("urls").toObject()
                .value(m_platformType).toObject().value(m_platformWordSize).toString();
        setPlatformDownloadUrl(downloadUrl);
    }
    setUpdateAvailable(updateAvailable);
}

void UpdateController::onNetworReply(QNetworkReply *reply)
{
    Q_ASSERT (reply == m_curReply);

    auto httpStatusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (reply->error() == QNetworkReply::NoError
            && (httpStatusCode == 200 || httpStatusCode == 301)) {
        if (httpStatusCode == 301) { // redirect
            m_versionUrl = reply->attribute(QNetworkRequest::RedirectionTargetAttribute).toUrl();
            getVersionResponse();
        } else {
            parseVersionResponse(reply->readAll());
            emit checkFinished();
        }
    } else {
        qWarning() << "[UpdateManager]" << "Network error:" << httpStatusCode << reply->errorString();
        if (m_retryCounter++ < sc_retryMaxCount) {
            QTimer::singleShot(sc_retryInterval, this, &UpdateController::getVersionResponse);
        } else {
            emit checkError();
        }
    }
}
