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

#include "timercontroller.h"

namespace
{
    constexpr int MAX_HOUR_LIMIT = 99;
    constexpr int MAX_MINUTES_LIMIT = 59;
    constexpr int MAX_SECONDS_LIMIT = 59;
    constexpr int MAX_TIME_LIMIT_SEC = 60 * 60 * MAX_HOUR_LIMIT +
                                       60 * MAX_MINUTES_LIMIT +
                                       MAX_SECONDS_LIMIT;
}

TimerController::TimerController(QObject *parent)
    : QObject(parent)
{
    m_timer.setTimerType(Qt::PreciseTimer);
    m_timer.setInterval(1000);  // one second interval

    connect(&m_timer, &QTimer::timeout, this, &TimerController::onTimeTic);
}

int TimerController::elapsedBreakDuration() const
{
    return m_elapsedBreakDuration;
}

int TimerController::elapsedWorkPeriod() const
{
    return m_elapsedWorkPeriod;
}

int TimerController::elapsedWorkTime() const
{
    return m_elapsedWorkTime;
}

TimerController::PeriodType TimerController::activePeriodType() const
{
    return m_periodType;
}

void TimerController::start(bool restart)
{
    if (restart)
    {
        // set initial state
        setElapsedBreakDuration(0);
        setElapsedWorkPeriod(0);
        setElapsedWorkTime(0);
    }

    m_timer.start();
}
void TimerController::stop()
{
    m_timer.stop();
}

void TimerController::countBreakTime()
{
    if (m_periodType == PeriodType::Break)
    {
        return;
    }

    m_periodType = PeriodType::Break;
    emit activePeriodTypeChanged(m_periodType);
}
void TimerController::countWorkTime()
{
    if (m_periodType == PeriodType::Work)
    {
        return;
    }

    m_periodType = PeriodType::Work;
    emit activePeriodTypeChanged(m_periodType);
}

void TimerController::setElapsedBreakDuration(int elapsedBreakDuration)
{
    int tmpElapsedBreakDuration = qMin(elapsedBreakDuration, MAX_TIME_LIMIT_SEC);
    if (m_elapsedBreakDuration == tmpElapsedBreakDuration)
    {
        return;
    }

    m_elapsedBreakDuration = tmpElapsedBreakDuration;
    emit elapsedBreakDurationChanged(m_elapsedBreakDuration);
}

void TimerController::setElapsedWorkPeriod(int elapsedWorkPeriod)
{
    int tmpElapsedPeriod = qMin(elapsedWorkPeriod, MAX_TIME_LIMIT_SEC);
    if (m_elapsedWorkPeriod == tmpElapsedPeriod)
    {
        return;
    }

    m_elapsedWorkPeriod = tmpElapsedPeriod;
    emit elapsedWorkPeriodChanged(m_elapsedWorkPeriod);
}
void TimerController::setElapsedWorkTime(int elapsedWorkTime)
{
    int tmpElapsedWorkTime = qMin(elapsedWorkTime, MAX_TIME_LIMIT_SEC);
    if (m_elapsedWorkTime == tmpElapsedWorkTime)
    {
        return;
    }

    m_elapsedWorkTime = tmpElapsedWorkTime;
    emit elapsedWorkTimeChanged(m_elapsedWorkTime);

    if (m_elapsedWorkTime == MAX_TIME_LIMIT_SEC)
    {
        emit timerStopRequest();
    }
}

void TimerController::incrementWorkTime()
{
    setElapsedWorkPeriod(elapsedWorkPeriod() + 1);
    setElapsedWorkTime(elapsedWorkTime() + 1);
}
void TimerController::incrementBreakTime()
{
    setElapsedBreakDuration(elapsedBreakDuration() + 1);
}

void TimerController::onTimeTic()
{
    switch (m_periodType)
    {
    case PeriodType::Break:
        incrementBreakTime();
        break;
    case PeriodType::Work:
        incrementWorkTime();
        break;
    default:
        Q_ASSERT(false);
    }
}
