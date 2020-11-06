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

#include <chrono>

using namespace std::chrono_literals;

namespace
{
    constexpr std::chrono::seconds MAX_TIME_LIMIT = std::chrono::hours(99) // max available hours
        + std::chrono::minutes(59) + std::chrono::seconds(59);
    constexpr int MAX_TIME_LIMIT_SEC = static_cast<int>(MAX_TIME_LIMIT.count());    // TODO: remove this after switch to chrono
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

int TimerController::elapsedBreakInterval() const
{
    return m_elapsedBreakInterval;
}

int TimerController::elapsedWorkTime() const
{
    return m_elapsedWorkTime;
}

TimerController::PeriodType TimerController::activePeriodType() const
{
    return m_periodType;
}

void TimerController::start()
{
    m_timer.start();
}

void TimerController::stop(bool reset)
{
    if (reset)
    {
        this->reset();
    }

    m_timer.stop();
}

void TimerController::reset()
{
    // set initial state
    setElapsedBreakDuration(0);
    setElapsedBreakInterval(0);
    setElapsedWorkTime(0);
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

void TimerController::setElapsedBreakInterval(int elapsedBreakInterval)
{
    int tmpElapsedBreakInterval = qMin(elapsedBreakInterval, MAX_TIME_LIMIT_SEC);
    if (m_elapsedBreakInterval == tmpElapsedBreakInterval)
    {
        return;
    }

    m_elapsedBreakInterval = tmpElapsedBreakInterval;
    emit elapsedBreakIntervalChanged(m_elapsedBreakInterval);
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
    setElapsedBreakInterval(elapsedBreakInterval() + 1);
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
