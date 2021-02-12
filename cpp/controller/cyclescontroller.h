/********************************************
**
** Copyright 2020 JustCode Justyna Kulinska
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

#ifndef CYCLESCONTROLLER_H
#define CYCLESCONTROLLER_H

#include <QObject>

#include "settingscontroller.h"

class CyclesController final : public QObject
{
    Q_OBJECT
    Q_ENUMS(State)

    Q_PROPERTY(int maxCycleIntervals READ maxCycleIntervals CONSTANT)
    Q_PROPERTY(int currentCycle READ currentCycle WRITE setCurrentCycle NOTIFY currentCycleChanged)
    Q_PROPERTY(bool isCycleFinished READ isCycleFinished NOTIFY isCycleFinishedChanged)

public:
    CyclesController(SettingsController &settingsController, QObject *parent = 0);

    int maxCycleIntervals() const;

    int currentCycle() const;
    bool isCycleFinished() const;

signals:
    void currentCycleChanged(int currentCycle) const;
    void isCycleFinishedChanged(bool isCycleFinished) const;

public slots:
    void setCurrentCycle(int cycle);
    void resetCurrentCycle();
    void incrementCurrentCycle();

private:
    static const int sc_maxCycleIntervals = 3;
    SettingsController &m_settingsController;

    int m_currentCycle = 0;
};

#endif // CYCLESCONTROLLER_H
