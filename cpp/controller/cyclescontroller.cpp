/********************************************
**
** Copyright 2021 Justyna JustCode
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

#include "cyclescontroller.h"

CyclesController::CyclesController(SettingsController &settingsController, QObject *parent)
    : QObject(parent), m_settingsController(settingsController)
{
    connect(this, &CyclesController::currentIntervalChanged, this, [this] { emit isCycleFinishedChanged(isCycleFinished()); });
}

int CyclesController::maxCycleIntervals() const
{
    return sc_maxCycleIntervals;
}

int CyclesController::currentInterval() const
{
    return m_settingsController.cyclesMode() ? m_currentInterval
                                             : 0;
}

bool CyclesController::isCycleFinished() const
{
    return m_settingsController.cyclesMode() &&
            (m_currentInterval == m_settingsController.cycleIntervals());
}

void CyclesController::setCurrentInterval(int currentInterval)
{
    if (m_currentInterval == currentInterval) {
        return;
    }

    if (currentInterval > m_settingsController.cycleIntervals()) {
        currentInterval = 1;
    }

    m_currentInterval = currentInterval;
    emit currentIntervalChanged(m_currentInterval);
}

void CyclesController::resetCurrentInterval()
{
    setCurrentInterval(0);
}

void CyclesController::incrementCurrentInterval()
{
    setCurrentInterval(m_currentInterval + 1);
}
