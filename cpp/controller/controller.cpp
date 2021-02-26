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
    : m_cyclesController(m_settingsController),
      m_updateController(m_settingsController, QUrl(QString("http://%1").arg(APP_VERSION_URL)) ),
      m_saveManager(m_backupManager)
{
    connect(&m_timerController, &TimerController::elapsedBreakDurationChanged, this, &Controller::onElapsedBreakDurationChange);
    connect(&m_timerController, &TimerController::elapsedBreakIntervalChanged, this, &Controller::onElapsedBreakIntervalChange);
    connect(&m_timerController, &TimerController::elapsedWorkTimeChanged, this, &Controller::onElapsedWorkTimeChange);
    connect(&m_timerController, &TimerController::timerStopRequest, this, &Controller::onTimerStopRequested);

    connect(&m_cyclesController, &CyclesController::currentIntervalChanged, this, &Controller::onCurrentCycleIntervalChange);

    connect(&m_settingsController, &SettingsController::breakIntervalChanged, this, &Controller::onBreakIntervalChanged);
    connect(&m_settingsController, &SettingsController::workTimeChanged, this, &Controller::onWorkTimeChanged);
    connect(&m_settingsController, &SettingsController::cyclesModeChanged, this, &Controller::onCyclesModeChanged);

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

TimerController &Controller::timer()
{
    return m_timerController;
}

CyclesController &Controller::cycles()
{
    return m_cyclesController;
}

UpdateController &Controller::updater()
{
    return m_updateController;
}

SettingsController *Controller::settingsPtr()
{
    return &m_settingsController;
}

TimerController *Controller::timerPtr()
{
    return &m_timerController;
}

CyclesController *Controller::cyclesPtr()
{
    return &m_cyclesController;
}

UpdateController *Controller::updaterPtr()
{
    return &m_updateController;
}

Controller::State Controller::state() const
{
    return m_state;
}

bool Controller::isWorking() const
{
    return (m_state == State::Working);
}

int Controller::currentBreakDuration() const
{
    return m_cyclesController.isCycleFinished()
            ? m_settingsController.cycleBreakDuration()
            : m_settingsController.breakDuration();
}

void Controller::save()
{
    if (isWorking()) {
        m_saveManager.save();
    }
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

void Controller::start()
{
    switch (m_state)
    {
    case State::Off:
        startWork();
        [[fallthrough]];
    case State::Paused:
    case State::Recovered:
        m_timerController.start(); // restart only from Off
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
        m_timerController.stop();
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
        m_timerController.stop(true);
        m_cyclesController.resetCurrentInterval();
        m_backupManager.stop();
        m_backupManager.cleanup();
        break;
    default:
        qWarning() << "Stop requested in unsupported state";
        break;
    }
}

void Controller::startBreak()
{
    m_timerController.setElapsedBreakDuration(0);
    m_timerController.countBreakTime();
}
void Controller::postponeBreak()
{
    m_postponeDuration +=
            (m_timerController.elapsedBreakInterval() - m_lastRequestTime)
            + settings().postponeTime();
}
void Controller::startWork()
{
    m_cyclesController.incrementCurrentInterval();

    m_postponeDuration = m_lastRequestTime = 0;
    m_timerController.setElapsedBreakInterval(0);

    if (m_settingsController.includeBreaks()) {
        const auto breakTimeToInclude = qMin(m_timerController.elapsedBreakDuration(), currentBreakDuration());
        m_timerController.setElapsedWorkTime(m_timerController.elapsedWorkTime() + breakTimeToInclude);
    }


    m_timerController.countWorkTime();
}

void Controller::setState(Controller::State state)
{
    if (m_state == state) {
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

    m_timerController.setElapsedBreakDuration(0);
    m_timerController.setElapsedBreakInterval(data.elapsedBreakInterval);
    m_timerController.setElapsedWorkTime(data.elapsedWorkTime);
    if (data.elapsedBreakInterval >= settings().breakInterval()) {
        postponeBreak();
    }

    m_cyclesController.setCurrentInterval(data.currentCycleInterval);

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

void Controller::onElapsedBreakIntervalChange(int elapsedBreakInterval)
{
    // check if break is needed:
    if (elapsedBreakInterval == settings().breakInterval() + m_postponeDuration) // break should be taken now
    {
        m_lastRequestTime = elapsedBreakInterval;
        emit breakStartRequest(); // inform about it
    }

    // update backup manager
    m_backupManager.data().elapsedBreakInterval = elapsedBreakInterval;
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

void Controller::onCurrentCycleIntervalChange(int currentInterval)
{
    // update backup manager
    m_backupManager.data().currentCycleInterval = currentInterval;
}

void Controller::onBreakIntervalChanged(int breakInterval)
{
    m_postponeDuration = 0; // clear postpones
    auto elapsedBreakInterval = m_timerController.elapsedBreakInterval();
    if (elapsedBreakInterval > breakInterval) // break should be taken now
    {
        m_lastRequestTime = breakInterval;
        emit breakStartRequest(); // inform about it
    }
}

void Controller::onWorkTimeChanged(int workTime)
{
    auto elapsedWorkTime = m_timerController.elapsedWorkTime();
    if (elapsedWorkTime > workTime) // work should be finished now
    {
        emit workEndRequest(); // inform about it
    }
}

void Controller::onTimerStopRequested()
{
    // this is to support for example paused state
    if(m_state != State::Working)
    {
        start();
    }

    stop();
}

void Controller::onCyclesModeChanged(bool cyclesMode)
{
    m_cyclesController.resetCurrentInterval();
    if (cyclesMode && m_state > State::Off) {
        m_cyclesController.incrementCurrentInterval();
    }
}
