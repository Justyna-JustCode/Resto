#include "controller.h"
#include <QDebug>

Controller::Controller()
{
    m_timer.setInterval(1000);
    connect(&m_timer, &QTimer::timeout, this, &Controller::onTimeTic);

    if (settings().autoStart())
    {
        start();
    }
}

SettingsController &Controller::settings()
{
    return m_settingsController;
}

SettingsController *Controller::settingsPtr()
{
    return &m_settingsController;
}

Controller::State Controller::state() const
{
    return m_state;
}

int Controller::breakTime() const
{
    return m_breakTime;
}
int Controller::timeToBreak() const
{
    return m_timeToBreak;
}
int Controller::workTime() const
{
    return m_workTime;
}

void Controller::start()
{
    if (m_state != State::Off &&
            m_state != State::Pause)
    {
        return;
    }

    if (m_state == State::Off)
    {
        setBreakTime(0);
        setTimeToBreak(0);
        setWorkTime(0);
    }

    setState(State::Work);
    startWork(true);
    m_timer.start();
}
void Controller::pause()
{
    if (m_state == State::Off)
    {
        return;
    }

    m_timer.stop();
    setState(State::Pause);
}
void Controller::stop()
{
    m_timer.stop();
    setState(State::Off);
}

void Controller::startWork(bool force)
{
    if (m_state != State::Break &&
            !(m_state == State::Work && force) )
    {
        return;
    }

    m_nextBreak = settings().breakInterval();
    setTimeToBreak(0);
    setState(State::Work);
}
void Controller::startBreak()
{
    if (m_state != State::Work)
    {
        return;
    }

    setBreakTime(0);
    setState(State::Break);
}

void Controller::postponeBreak()
{
    m_nextBreak = m_timeToBreak + settings().postponeTime();
}

void Controller::workTimeTic()
{
    setTimeToBreak(timeToBreak()+1);
    setWorkTime(workTime()+1);

    if (workTime() == settings().workTime())
    {
        emit endOfWorkRequest();
    }
    else if (timeToBreak() == m_nextBreak)
    {
        emit breakRequest();
    }
}

void Controller::breakTimeTic()
{
    setBreakTime(breakTime()+1);

    if (breakTime() == settings().breakDuration())
    {
        emit endOfBreakRequest();
    }
}

void Controller::setState(Controller::State state)
{
    if (m_state == state)
    {
        return;
    }

    m_state = state;
    emit stateChanged(state);
}

void Controller::setBreakTime(int time)
{
    if (m_breakTime == time)
    {
        return;
    }

    m_breakTime = time;
    emit breakTimeChanged(time);
}
void Controller::setTimeToBreak(int time)
{
    if (m_timeToBreak == time)
    {
        return;
    }

    m_timeToBreak = time;
    emit timeToBreakChanged(time);
}
void Controller::setWorkTime(int time)
{
    if (m_workTime == time)
    {
        return;
    }

    m_workTime = time;
    emit workTimeChanged(time);
}

void Controller::onTimeTic()
{
    switch (m_state)
    {
    case State::Work:
        workTimeTic();
        break;
    case State::Break:
        breakTimeTic();
        break;
    default:
        qWarning() << "Time is ticking in state:" << (int)m_state; // TODO: print text
        break;
    }
}

