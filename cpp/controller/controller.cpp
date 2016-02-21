#include "controller.h"
#include <QDebug>

Controller::Controller()
{
    connect(&m_timerController, &TimerController::elapsedBreakDurationChanged, this, &Controller::onElapsedBreakDurationChange);
    connect(&m_timerController, &TimerController::elapsedWorkPeriodChanged, this, &Controller::onElapsedWorkPeriodChange);
    connect(&m_timerController, &TimerController::elapsedWorkTimeChanged, this, &Controller::onElapsedWorkTimeChange);

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

TimerController &Controller::timer()
{
    return m_timerController;
}
TimerController *Controller::timerPtr()
{
    return &m_timerController;
}

Controller::State Controller::state() const
{
    return m_state;
}

void Controller::start()
{
    switch (m_state)
    {
    case State::Off:
    case State::Paused:
        startWork();
        m_timerController.start( (m_state == State::Off) ); // restart only from Off
        setState(State::Working);
        break;
    default:
        qWarning() << "Start requested in unsupported state";
        break;
    }
}
void Controller::pause()
{
    switch (m_state)
    {
    case State::Working:
        setState(State::Paused);
        m_timerController.stop();
        break;
    default:
        qWarning() << "Pause requested in unsupported state";
        break;
    }
}
void Controller::stop()
{
    switch (m_state)
    {
    case State::Working:
        setState(State::Off);
        m_timerController.stop();
        break;
    default:
        qWarning() << "Stop requested in unsupported state";
        break;
    }
}

void Controller::startBreak()
{
    m_timerController.countBreakTime();
}
void Controller::postponeBreak()
{
    m_actualWorkPeriod = timer().elapsedWorkPeriod() + settings().postponeTime();
}
void Controller::startWork()
{
    m_timerController.countWorkTime();

    m_actualWorkPeriod = settings().breakInterval(); // time to next break
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

void Controller::onElapsedBreakDurationChange(int elapsedBreakDuration)
{
    // check end of the break:
    if (elapsedBreakDuration == settings().breakDuration()) // break has just ended
    {
        emit breakEndRequest(); // inform about it
    }
}

void Controller::onElapsedWorkPeriodChange(int elapsedWorkPeriod)
{
    // check if break is needed:
    if (elapsedWorkPeriod == m_actualWorkPeriod) // break should be taken now
    {
        emit breakStartRequest(); // inform about it
    }
}

void Controller::onElapsedWorkTimeChange(int elapsedWorkTime)
{
    // check end of work:
    if (elapsedWorkTime == settings().workTime()) // work just be finished
    {
        emit workEndRequest(); // inform about it
    }
}

