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

#include "cyclescontroller.h"

CyclesController::CyclesController(SettingsController &settingsController, QObject *parent)
    : QObject(parent), m_settingsController(settingsController)
{
    connect(this, &CyclesController::currentCycleChanged, this, [this] { emit isCycleFinishedChanged(isCycleFinished()); });
}

int CyclesController::maxCyclesNumber() const
{
    return sc_maxCyclesNumber;
}

int CyclesController::currentCycle() const
{
    return m_settingsController.cyclesMode() ? m_currentCycle
                                             : 0;
}

bool CyclesController::isCycleFinished() const
{
    return m_settingsController.cyclesMode()
            ? (m_currentCycle == m_settingsController.cyclesNumber())
            : 0;
}

void CyclesController::setCurrentCycle(int cycle)
{
    if (m_currentCycle == cycle)
        return;

    if (cycle > m_settingsController.cyclesNumber()) {
        cycle = 1;
    }

    m_currentCycle = cycle;
    emit currentCycleChanged(m_currentCycle);
}

void CyclesController::resetCurrentCycle()
{
    setCurrentCycle(0);
}

void CyclesController::incrementCurrentCycle()
{
    setCurrentCycle(m_currentCycle + 1);
}
