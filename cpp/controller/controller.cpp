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

#include "controller.h"
#include <QDebug>
#include <QDesktopServices>
#include <QUrl>
#include <QCoreApplication>
#include <QCursor>

Controller::Controller()
    : m_updateController(m_settingsController, QUrl(QString("http://%1").arg(APP_VERSION_URL)) ),
      m_saveManager(m_backupManager)
{
    connect(this, &Controller::currentIterationChanged, this, [this] { emit isCycleBreakChanged(isCycleBreak()); });

    connect(&m_timerController, &TimerController::elapsedBreakDurationChanged, this, &Controller::onElapsedBreakDurationChange);
    connect(&m_timerController, &TimerController::elapsedWorkPeriodChanged, this, &Controller::onElapsedWorkPeriodChange);
    connect(&m_timerController, &TimerController::elapsedWorkTimeChanged, this, &Controller::onElapsedWorkTimeChange);

    connect(&m_settingsController, &SettingsController::breakIntervalChanged, this, &Controller::onBreakIntervalChanged);
    connect(&m_settingsController, &SettingsController::workTimeChanged, this, &Controller::onWorkTimeChanged);

    connect(&m_updateController, &UpdateController::updateStarted, this, &Controller::exitRequest);
    connect(&m_backupManager, &BackupManager::backupData, this, &Controller::onBackupData);

    m_saveManager.initialize(); // need to be done before backup manager
    m_backupManager.initialize();

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

UpdateController &Controller::updater()
{
    return m_updateController;
}
TimerController *Controller::timerPtr()
{
    return &m_timerController;
}

UpdateController *Controller::updaterPtr()
{
    return &m_updateController;
}

void Controller::resetCurrentIteration()
{
    m_currentIteration = 0;
    emit currentIterationChanged(m_currentIteration);
}

void Controller::incrementCurrentIteration()
{
    if (m_currentIteration == m_settingsController.cycleIterations()) {
        m_currentIteration = 1;
    } else {
        m_currentIteration++;
    }

    emit currentIterationChanged(m_currentIteration);
}

Controller::State Controller::state() const
{
    return m_state;
}

bool Controller::isWorking() const
{
    return (m_state == State::Working);
}

void Controller::save()
{
    m_saveManager.save();
}

void Controller::clear()
{
    m_backupManager.cleanup();
}

QPoint Controller::cursorPos() const
{
    // this is needed as a workaround for Ubuntu window move issue
    return QCursor::pos();
}

void Controller::openHelp() const
{
    QDesktopServices::openUrl(QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/help.pdf"));
}

int Controller::currentIteration() const
{
    return m_currentIteration;
}

bool Controller::isCycleBreak() const
{
    return m_currentIteration == m_settingsController.cycleIterations();
}

void Controller::start()
{
    switch (m_state)
    {
    case State::Off:
    case State::Paused:
        startWork();
        [[fallthrough]];
    case State::Recovered:
        timer().start( (m_state == State::Off) ); // restart only from Off
        setState(State::Working);
        m_backupManager.start();
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
        timer().stop();
        m_backupManager.stop();
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
        timer().stop();
        m_backupManager.stop();
        m_backupManager.cleanup();
        break;
    default:
        qWarning() << "Stop requested in unsupported state";
        break;
    }

    resetCurrentIteration();
}

void Controller::startBreak()
{
    timer().setElapsedBreakDuration(0);
    timer().countBreakTime();

    // update backup manager
    m_backupManager.data().elapsedWorkTime = 0;
}
void Controller::postponeBreak()
{
    m_postponeDuration += (timer().elapsedWorkPeriod() - m_lastRequestTime) + settings().postponeTime();
}
void Controller::startWork()
{
    incrementCurrentIteration();

    m_postponeDuration = m_lastRequestTime = 0;
    timer().setElapsedWorkPeriod(0);

    if (m_settingsController.includeBreaks()) {
        const auto breakTimeSet = isCycleBreak() ? m_settingsController.cycleBreakDuration()
                                                 : m_settingsController.breakDuration();
        const auto breakTimeToInclude = qMin(timer().elapsedBreakDuration(), breakTimeSet);
        timer().setElapsedWorkTime(timer().elapsedWorkTime() + breakTimeToInclude);
    }


    timer().countWorkTime();
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

void Controller::onBackupData(const BackupManager::Data &data)
{
    bool wasWorking = false;
    if (isWorking()) { // autostarted
        stop();
        wasWorking = true;
    }

    timer().setElapsedBreakDuration(0);
    timer().setElapsedWorkPeriod(data.elapsedWorkPeriod);
    timer().setElapsedWorkTime(data.elapsedWorkTime);
    if (data.elapsedWorkPeriod >= settings().breakInterval()) {
        postponeBreak();
    }

    setState(State::Recovered); // set recovered state to avoid restart
    if (wasWorking) {
        start();
    }
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
    if (elapsedWorkPeriod == settings().breakInterval() + m_postponeDuration) // break should be taken now
    {
        m_lastRequestTime = elapsedWorkPeriod;
        emit breakStartRequest(); // inform about it
    }

    // update backup manager
    m_backupManager.data().elapsedWorkPeriod = elapsedWorkPeriod;
}

void Controller::onElapsedWorkTimeChange(int elapsedWorkTime)
{
    // check end of work:
    if (elapsedWorkTime == settings().workTime()) // work should be finished now
    {
        emit workEndRequest(); // inform about it
    }

    // update backup manager
    m_backupManager.data().elapsedWorkTime = elapsedWorkTime;
}

void Controller::onBreakIntervalChanged(int breakInterval)
{
    m_postponeDuration = 0; // clear postpones
    auto elapsedWorkPeriod = timer().elapsedWorkPeriod();
    if (elapsedWorkPeriod > breakInterval) // break should be taken now
    {
        m_lastRequestTime = breakInterval;
        emit breakStartRequest(); // inform about it
    }
}

void Controller::onWorkTimeChanged(int workTime)
{
    auto elapsedWorkTime = timer().elapsedWorkTime();
    if (elapsedWorkTime > workTime) // work should be finished now
    {
        emit workEndRequest(); // inform about it
    }
}

