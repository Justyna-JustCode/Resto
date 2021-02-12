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

#include "settings.h"

#include <QDateTime>

const QLatin1String Settings::sc_systemGroupName = QLatin1String("system");
const QLatin1String Settings::sc_logicGroupName = QLatin1String("logic");
const QLatin1String Settings::sc_updateGroupName = QLatin1String("update");
const QLatin1String Settings::sc_viewGroupName = QLatin1String("view");

const QLatin1String Settings::sc_trayAvailableKey = QLatin1String("trayAvailable");
const QLatin1String Settings::sc_showTrayInfoKey = QLatin1String("showTrayInfo");

const QLatin1String Settings::sc_includeBreaksKey = QLatin1String("includeBreaks");
const QLatin1String Settings::sc_breakDurationKey = QLatin1String("breakDuration");
const QLatin1String Settings::sc_breakIntervalKey = QLatin1String("breakInterval");

const QLatin1String Settings::sc_cyclesModeKey = QLatin1String("cyclesMode");
const QLatin1String Settings::sc_cycleBreakDurationKey = QLatin1String("cycleBreakDuration");
const QLatin1String Settings::sc_cycleIntervals = QLatin1String("cycleIntervals");

const QLatin1String Settings::sc_workTimeKey = QLatin1String("workTime");
const QLatin1String Settings::sc_postponeTimeKey = QLatin1String("postponeTime");

const QLatin1String Settings::sc_autoStartKey = QLatin1String("autoStart");
const QLatin1String Settings::sc_autoHideKey = QLatin1String("autoHide");
const QLatin1String Settings::sc_hideOnCloseKey = QLatin1String("hideOnClose");

const QLatin1String Settings::sc_updateVersionKey = QLatin1String("updateVersion");
const QLatin1String Settings::sc_nextUpdateCheckKey = QLatin1String("nextUpdateCheck");

const QLatin1String Settings::sc_windowPositionXKey = QLatin1String("window-x");
const QLatin1String Settings::sc_windowPositionYKey = QLatin1String("window-y");
const QLatin1String Settings::sc_windowWidthKey = QLatin1String("window-width");
const QLatin1String Settings::sc_windowHeightKey = QLatin1String("window-height");
const QLatin1String Settings::sc_applicationColorIndexKey = QLatin1String("mainColorIndex");

const int Settings::sc_defaultBreakDuration = 5*60;  //! 5 min
const int Settings::sc_defaultCycleBreakDuration = 30*60;  //! 30 min
const int Settings::sc_defaultlCycleIntervals = 3;
const int Settings::sc_defaultBreakInterval = 25*60; //! 25 min
const int Settings::sc_defaultWorkTime = 8*60*60;  //! 8 h
const int Settings::sc_defaultPostponeTime = 5*60;   //! 5 min

const QSize Settings::sc_defaultWindowSize = { 460, 240 };  // px
int Settings::sc_defaultApplicationColorIndex = 0;

Settings::Settings(const QString organization, const QString name)
    : m_settings(QSettings::UserScope, organization, name)
{}

bool Settings::trayAvailable() const
{
    return value(sc_systemGroupName, sc_trayAvailableKey, false).toBool();
}

void Settings::setTrayAvailable(bool available)
{
    setValue(sc_systemGroupName, sc_trayAvailableKey, available);
}

bool Settings::showTrayInfo() const
{
    return value(sc_systemGroupName, sc_showTrayInfoKey, true).toBool();
}

void Settings::setShowTrayInfo(bool show)
{
    setValue(sc_systemGroupName, sc_showTrayInfoKey, show);
}

bool Settings::includeBreaks() const
{
    return value(sc_logicGroupName, sc_includeBreaksKey, true).toBool();
}

void Settings::setIncluseBreaks(bool include)
{
    setValue(sc_logicGroupName, sc_includeBreaksKey, include);
}

int Settings::breakDuration() const
{
    return value(sc_logicGroupName, sc_breakDurationKey, sc_defaultBreakDuration).toInt();
}
void Settings::setBreakDuration(int duration)
{
    setValue(sc_logicGroupName, sc_breakDurationKey, duration);
}

bool Settings::cyclesMode() const
{
    return value(sc_logicGroupName, sc_cyclesModeKey, false).toBool();
}

void Settings::setCyclesMode(bool on)
{
    setValue(sc_logicGroupName, sc_cyclesModeKey, on);
}

int Settings::cycleBreakDuration() const
{
    return value(sc_logicGroupName, sc_cycleBreakDurationKey, sc_defaultCycleBreakDuration).toInt();
}

void Settings::setCycleBreakDuration(int duration)
{
    setValue(sc_logicGroupName, sc_cycleBreakDurationKey, duration);
}

int Settings::cycleIntervals() const
{
    return value(sc_logicGroupName, sc_cycleIntervals, sc_defaultlCycleIntervals).toInt();
}

void Settings::setCycleIntervals(int cycleIntervals)
{
    setValue(sc_logicGroupName, sc_cycleIntervals, cycleIntervals);
}

int Settings::breakInterval() const
{
    return value(sc_logicGroupName, sc_breakIntervalKey, sc_defaultBreakInterval).toInt();
}
void Settings::setBreakInterval(int interval)
{
    setValue(sc_logicGroupName, sc_breakIntervalKey, interval);
}

int Settings::workTime() const
{
    return value(sc_logicGroupName, sc_workTimeKey, sc_defaultWorkTime).toInt();
}
void Settings::setWorkTime(int time)
{
    setValue(sc_logicGroupName, sc_workTimeKey, time);
}

int Settings::postponeTime() const
{
    return value(sc_logicGroupName, sc_postponeTimeKey, sc_defaultPostponeTime).toInt();
}
void Settings::setPostponeTime(int time)
{
    setValue(sc_logicGroupName, sc_postponeTimeKey, time);
}

bool Settings::autoStart() const
{
    return value(sc_logicGroupName, sc_autoStartKey, false).toBool();
}
void Settings::setAutoStart(bool start)
{
    setValue(sc_logicGroupName, sc_autoStartKey, start);
}

bool Settings::autoHide() const
{
    return value(sc_logicGroupName, sc_autoHideKey, false).toBool();
}

void Settings::setAutoHide(bool hide)
{
    setValue(sc_logicGroupName, sc_autoHideKey, hide);
}

bool Settings::hideOnClose() const
{
    return value(sc_logicGroupName, sc_hideOnCloseKey, true).toBool();
}

void Settings::setHideOnClose(bool hide)
{
    setValue(sc_logicGroupName, sc_hideOnCloseKey, hide);
}

QString Settings::updateVersion() const
{
    return value(sc_updateGroupName, sc_updateVersionKey).toString();
}

void Settings::setUpdateVersion(const QString &version)
{
    setValue(sc_updateGroupName, sc_updateVersionKey, version);
}

QDateTime Settings::nextUpdateCheck() const
{
    return QDateTime::fromString(value(sc_updateGroupName, sc_nextUpdateCheckKey).toString(), Qt::ISODate);
}

void Settings::setNextUpdateCheck(const QDateTime &checkDate)
{
    setValue(sc_updateGroupName, sc_nextUpdateCheckKey, checkDate.toString(Qt::ISODate));
}

QPoint Settings::windowPosition() const
{
    return { value(sc_viewGroupName, sc_windowPositionXKey, -1).toInt(),
                value(sc_viewGroupName, sc_windowPositionYKey, -1).toInt() };
}

void Settings::setWindowPosition(const QPoint &position)
{
    setValue(sc_viewGroupName, sc_windowPositionXKey, position.x());
    setValue(sc_viewGroupName, sc_windowPositionYKey, position.y());
}

QSize Settings::windowSize() const
{
    return { value(sc_viewGroupName, sc_windowWidthKey, sc_defaultWindowSize.width()).toInt(),
                value(sc_viewGroupName, sc_windowHeightKey, sc_defaultWindowSize.height()).toInt() };
}

QSize Settings::defaultWindowSize() const
{
    return sc_defaultWindowSize;
}

void Settings::setWindowSize(const QSize &size)
{
    setValue(sc_viewGroupName, sc_windowWidthKey, size.width());
    setValue(sc_viewGroupName, sc_windowHeightKey, size.height());
}

int Settings::applicationColorIndex() const
{
    return value(sc_viewGroupName, sc_applicationColorIndexKey, sc_defaultApplicationColorIndex).toInt();
}

void Settings::setApplicationColorIndex(const int colorIndex)
{
    setValue(sc_viewGroupName, sc_applicationColorIndexKey, colorIndex);
}

void Settings::setDefaultApplicationColorIndex(const int value)
{
    sc_defaultApplicationColorIndex = value;
}

void Settings::setValue(const QString &groupName, const QString &key, const QVariant &value)
{
    m_settings.beginGroup(groupName);
    m_settings.setValue(key, value);
    m_settings.endGroup();
}

QVariant Settings::value(const QString &groupName, const QString &key, const QVariant &defaultValue) const
{
    return m_settings.value(groupName + '/' + key, defaultValue);
}

