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

#ifndef SETTINGSCONTROLLER_H
#define SETTINGSCONTROLLER_H

#include <QObject>
#include <QDateTime>

#include "model/settings.h"

/*!
 * \brief Controller class to handle settings.
 */
class SettingsController final : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool includeBreaks READ includeBreaks WRITE setIncludeBreaks NOTIFY includeBreaksChanged)
    Q_PROPERTY(int breakDuration READ breakDuration WRITE setBreakDuration NOTIFY breakDurationChanged)
    Q_PROPERTY(int breakInterval READ breakInterval WRITE setBreakInterval NOTIFY breakIntervalChanged)

    Q_PROPERTY(bool cyclesMode READ cyclesMode WRITE setCyclesMode NOTIFY cyclesModeChanged)
    Q_PROPERTY(int cycleBreakDuration READ cycleBreakDuration WRITE setCycleBreakDuration NOTIFY cycleBreakDurationChanged)
    Q_PROPERTY(int cyclesNumber READ cyclesNumber WRITE setCyclesNumber NOTIFY cyclesNumberChanged)

    Q_PROPERTY(int workTime READ workTime WRITE setWorkTime NOTIFY workTimeChanged)
    Q_PROPERTY(int postponeTime READ postponeTime WRITE setPostponeTime NOTIFY postponeTimeChanged)

    Q_PROPERTY(bool autoStart READ autoStart WRITE setAutoStart NOTIFY autoStartChanged)

    Q_PROPERTY(QPoint windowPosition READ windowPosition WRITE setWindowPosition NOTIFY windowPositionChanged)
    Q_PROPERTY(QSize windowSize READ windowSize WRITE setWindowSize NOTIFY windowSizeChanged)
    Q_PROPERTY(QSize defaultWindowSize READ defaultWindowSize CONSTANT)

    Q_PROPERTY(int applicationColorIndex READ applicationColorIndex WRITE setApplicationColorIndex NOTIFY applicationColorIndexChanged)

    Q_PROPERTY(bool trayAvailable READ trayAvailable WRITE setTrayAvailable NOTIFY trayAvailableChanged)
    Q_PROPERTY(bool showTrayInfo READ showTrayInfo WRITE setShowTrayInfo NOTIFY showTrayInfoChanged)
    Q_PROPERTY(bool autoHide READ autoHide WRITE setAutoHide NOTIFY autoHideChanged)
    Q_PROPERTY(bool hideOnClose READ hideOnClose WRITE setHideOnClose NOTIFY hideOnCloseChanged)

    Q_PROPERTY(QString updateVersion READ updateVersion WRITE setUpdateVersion NOTIFY updateVersionChanged)
    Q_PROPERTY(QDateTime nextUpdateCheck READ nextUpdateCheck WRITE setNextUpdateCheck NOTIFY nextUpdateCheckChanged)

public:
    explicit SettingsController(QObject *parent = nullptr);

    bool includeBreaks() const;
    int breakDuration() const;
    int breakInterval() const;

    bool cyclesMode() const;
    int cycleBreakDuration() const;
    int cyclesNumber() const;

    int workTime() const;
    int postponeTime() const;

    bool autoStart() const;

    QPoint windowPosition() const;
    QSize windowSize() const;
    QSize defaultWindowSize() const;

    int applicationColorIndex() const;

    bool trayAvailable() const;
    bool showTrayInfo() const;
    bool autoHide() const;
    bool hideOnClose() const;

    QString updateVersion() const;
    QDateTime nextUpdateCheck() const;

signals:
    void includeBreaksChanged(bool includeBreaks) const;
    void breakDurationChanged(int breakDuration) const;
    void breakIntervalChanged(int breakInterval) const;

    void cyclesModeChanged(bool cyclesMode) const;
    void cycleBreakDurationChanged(int cycleBreakDuration) const;
    void cyclesNumberChanged(int cyclesNumber) const;

    void workTimeChanged(int workTime) const;
    void postponeTimeChanged(int postponeTime) const;

    void autoStartChanged(bool autoStart) const;

    void windowPositionChanged(const QPoint &windowPosition) const;
    void windowSizeChanged(const QSize &windowSize) const;
    void applicationColorIndexChanged(const int applicationColorIndex) const;

    void trayAvailableChanged(bool trayAvailable) const;
    void showTrayInfoChanged(bool showTrayInfo) const;
    void autoHideChanged(bool autoHide) const;
    void hideOnCloseChanged(bool hideOnClose) const;

    void updateVersionChanged(QString updateVersion) const;
    void nextUpdateCheckChanged(QDateTime nextUpdateCheck) const;

public slots:
    void setIncludeBreaks(bool includeBreaks);
    void setBreakDuration(int breakDuration);
    void setBreakInterval(int breakInterval);

    void setCyclesMode(bool cyclesMode);
    void setCycleBreakDuration(int cycleBreakDuration);
    void setCyclesNumber(int cyclesNumber);

    void setWorkTime(int workTime);
    void setPostponeTime(int postponeTime);

    void setAutoStart(bool autoStart);

    void setWindowPosition(const QPoint &windowPosition);
    void setWindowSize(const QSize &windowSize);
    void setApplicationColorIndex(const int applicationColorIndex);

    void setTrayAvailable(bool trayAvailable);
    void setShowTrayInfo(bool showTrayInfo);
    void setAutoHide(bool autoHide);
    void setHideOnClose(bool hideOnClose);

    void setUpdateVersion(const QString &updateVersion);
    void setNextUpdateCheck(const QDateTime &nextUpdateCheck);

private:
    /*!
     * \brief Settings model class.
     */
    Settings m_settings;
};

#endif // SETTINGSCONTROLLER_H
