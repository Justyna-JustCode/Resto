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

#include "settingscontroller.h"
#include <QCoreApplication>

const QStringList SettingsController::sc_availableColors = { "#19886F", "#EC811B", "#682C90", "#C0159B", "#008000", "#0958EC", "#666666" };

SettingsController::SettingsController(QObject *parent)
    : QObject(parent), m_settings(QCoreApplication::organizationName(), QCoreApplication::applicationName())
{
    m_settings.setDefaultApplicationColor(sc_availableColors.first());
}

int SettingsController::breakDuration() const
{
    return m_settings.breakDuration();
}
int SettingsController::breakInterval() const
{
    return m_settings.breakInterval();
}
int SettingsController::workTime() const
{
    return m_settings.workTime();
}
int SettingsController::postponeTime() const
{
    return m_settings.postponeTime();
}
bool SettingsController::autoStart() const
{
    return m_settings.autoStart();
}

QPoint SettingsController::windowPosition() const
{
    return m_settings.windowPosition();
}

QSize SettingsController::windowSize() const
{
    return m_settings.windowSize();
}

QStringList SettingsController::availableColors() const
{
    return sc_availableColors;
}

QColor SettingsController::applicationColor() const
{
    return m_settings.applicationColor();
}

bool SettingsController::trayAvailable() const
{
    return m_settings.trayAvailable();
}

bool SettingsController::showTrayInfo() const
{
    return m_settings.showTrayInfo();
}

bool SettingsController::autoHide() const
{
    return m_settings.autoHide();
}

bool SettingsController::hideOnClose() const
{
    return m_settings.hideOnClose();
}

void SettingsController::setBreakDuration(int _breakDuration)
{
    if (breakDuration() == _breakDuration)
        return;

    m_settings.setBreakDuration(_breakDuration);
    emit breakDurationChanged(_breakDuration);
}
void SettingsController::setBreakInterval(int _breakInterval)
{
    if (breakInterval() == _breakInterval)
        return;

    m_settings.setBreakInterval(_breakInterval);
    emit breakIntervalChanged(_breakInterval);
}
void SettingsController::setWorkTime(int _workTime)
{
    if (workTime() == _workTime)
        return;

    m_settings.setWorkTime(_workTime);
    emit workTimeChanged(_workTime);
}
void SettingsController::setPostponeTime(int _postponeTime)
{
    if (postponeTime() == _postponeTime)
        return;

    m_settings.setPostponeTime(_postponeTime);
    emit postponeTimeChanged(_postponeTime);
}
void SettingsController::setAutoStart(bool _autoStart)
{
    if (autoStart() == _autoStart)
        return;

    m_settings.setAutoStart(_autoStart);
    emit autoStartChanged(_autoStart);
}

void SettingsController::setWindowPosition(const QPoint &_windowPosition)
{
    if (windowPosition() == _windowPosition)
        return;

    m_settings.setWindowPosition(_windowPosition);
    emit windowPositionChanged(_windowPosition);
}

void SettingsController::setWindowSize(const QSize &_windowSize)
{
    if (m_settings.windowSize() == _windowSize)
        return;

    m_settings.setWindowSize(_windowSize);
    emit windowSizeChanged(_windowSize);
}

void SettingsController::setApplicationColor(QColor color)
{
    if (m_settings.applicationColor() == color)
        return;

    m_settings.setApplicationColor(color);
    emit applicationColorChanged(color);
}

void SettingsController::setTrayAvailable(bool _trayAvailable)
{
    if (m_settings.trayAvailable() == _trayAvailable)
        return;

    m_settings.setTrayAvailable(_trayAvailable);
    emit trayAvailableChanged(_trayAvailable);
}

void SettingsController::setShowTrayInfo(bool _showTrayInfo)
{
    if (m_settings.showTrayInfo() == _showTrayInfo)
        return;

    m_settings.setShowTrayInfo(_showTrayInfo);
    emit showTrayInfoChanged(_showTrayInfo);
}

void SettingsController::setAutoHide(bool _autoHide)
{
    if (m_settings.autoHide() == _autoHide)
        return;

    m_settings.setAutoHide(_autoHide);
    emit autoHideChanged(_autoHide);
}

void SettingsController::setHideOnClose(bool _hideOnClose)
{
    if (m_settings.hideOnClose() == _hideOnClose)
        return;

    m_settings.setHideOnClose(_hideOnClose);
    emit hideOnCloseChanged(_hideOnClose);
}
