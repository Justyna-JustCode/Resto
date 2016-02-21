#include "timercontroller.h"

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

void TimerController::start(bool restart)
{
    if (restart)
    {
        // set initial state
        setElapsedBreakDurationChanged(0);
        setElapsedWorkPeriodChanged(0);
        setElapsedWorkTimeChanged(0);
    }

    m_timer.start();
}
void TimerController::stop()
{
    m_timer.stop();
}

void TimerController::countBreakTime()
{
    setElapsedBreakDurationChanged(0);
    m_periodType = PeriodType::Break;
}
void TimerController::countWorkTime()
{
    setElapsedWorkPeriodChanged(0);
    m_periodType = PeriodType::Work;
}

void TimerController::setElapsedBreakDurationChanged(int elapsedBreakDuration)
{
    if (m_elapsedBreakDuration == elapsedBreakDuration)
    {
        return;
    }

    m_elapsedBreakDuration = elapsedBreakDuration;
    emit elapsedBreakDurationChanged(elapsedBreakDuration);
}
void TimerController::setElapsedWorkPeriodChanged(int elapsedWorkPeriod)
{
    if (m_elapsedWorkPeriod == elapsedWorkPeriod)
    {
        return;
    }

    m_elapsedWorkPeriod = elapsedWorkPeriod;
    emit elapsedWorkPeriodChanged(elapsedWorkPeriod);
}
void TimerController::setElapsedWorkTimeChanged(int elapsedWorkTime)
{
    if (m_elapsedWorkTime == elapsedWorkTime)
    {
        return;
    }

    m_elapsedWorkTime = elapsedWorkTime;
    emit elapsedWorkTimeChanged(elapsedWorkTime);
}

void TimerController::incrementWorkTime()
{
    setElapsedWorkPeriodChanged(elapsedWorkPeriod() + 1);
    setElapsedWorkTimeChanged(elapsedWorkTime() + 1);
}
void TimerController::incrementBreakTime()
{
    setElapsedBreakDurationChanged(elapsedBreakDuration() + 1);
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
