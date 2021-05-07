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
#include <QFile>
#include <QDir>
#include <QProcess>

#include "controller/settingscontroller.h"

#ifdef Q_OS_LINUX
    const QString UpdateController::sc_updaterAppName = QStringLiteral("Uninstall");
#elif defined(Q_OS_WIN)
    const QString UpdateController::sc_updaterAppName = QStringLiteral("Update.exe");
#endif

UpdateController::UpdateController(SettingsController &settingsController, const QUrl &versionUrl, QObject *parent)
    : QObject(parent), m_settingsController(settingsController), m_versionUrl(versionUrl),
#ifdef Q_OS_LINUX
      m_updaterAppPath(QDir::current().filePath(sc_updaterAppName))
#elif defined(Q_OS_WIN)
      m_updaterAppPath(QDir(QApplication::applicationDirPath()).filePath(sc_updaterAppName))
#endif
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

bool UpdateController::updatePossible() const
{
    return QFile::exists(m_updaterAppPath);
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

void UpdateController::update()
{
    if (!updatePossible()) {
        qWarning() << "[UpdateManager]" << "Trying to update, but update not possible.";
        return;
    }

    auto started = false;
#ifdef Q_OS_LINUX
    started = QProcess::startDetached(m_updaterAppPath, { "--updater", }, QApplication::applicationDirPath()); // TODO: better solution? with Update.desktop
#elif defined(Q_OS_WIN)
    started = QProcess::startDetached(m_updaterAppPath, {}, QApplication::applicationDirPath());
#endif

    if (started) {
        emit updateStarted();
    } else {
        qWarning() << "[UpdateManager]" << "Error while starting an updater application:" << m_updaterAppPath;
    }
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

int UpdateController::compareVersions(const QString &vStr1, const QString &vStr2) const
{
    auto suffixIdx1 = 0, suffixIdx2 = 0;
    auto v1 = QVersionNumber::fromString(vStr1, &suffixIdx1);
    auto v2 = QVersionNumber::fromString(vStr2, &suffixIdx2);
    auto res = QVersionNumber::compare(v1, v2);

    if (res == 0) {
        // same versions - check suffixes
        auto suffixLen1 = vStr1.length() - suffixIdx1;
        auto suffixLen2 = vStr2.length() - suffixIdx2;
        res = (suffixLen2 - suffixLen1);
    }
    return res;
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

    auto updateAvailable = (compareVersions(QApplication::applicationVersion(), versionString) < 0);
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
