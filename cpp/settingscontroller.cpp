#include "settingscontroller.h"

SettingsController::SettingsController(QObject *parent)
    : QObject(parent), m_settings(QStringLiteral("JustCode"), QStringLiteral("Resto"))
{}

int SettingsController::breakDuration() const
{
    return m_settings.breakDuration();
}
int SettingsController::breakInterval() const
{
    return m_settings.breakInterval();
}
int SettingsController::workDayDuration() const
{
    return m_settings.workDayDuration();
}
int SettingsController::postponeTime() const
{
    return m_settings.postponeTime();
}
bool SettingsController::autoStart() const
{
    return m_settings.autoStart();
}

void SettingsController::setBreakDuration(int _breakDuration)
{
    if (breakDuration() == _breakDuration)
        return;

    m_settings.setBreakDuration(_breakDuration);
    emit breakDurationChanged(_breakDuration);
}
void SettingsController::setBreakInterval(int _breakInterval)
{
    if (breakInterval() == _breakInterval)
        return;

    m_settings.setBreakInterval(_breakInterval);
    emit breakIntervalChanged(_breakInterval);
}
void SettingsController::setWorkDayDuration(int _workDayDuration)
{
    if (workDayDuration() == _workDayDuration)
        return;

    m_settings.setWorkDayDuration(_workDayDuration);
    emit workDayDurationChanged(_workDayDuration);
}
void SettingsController::setPostponeTime(int _postponeTime)
{
    if (postponeTime() == _postponeTime)
        return;

    m_settings.setPostponeTime(_postponeTime);
    emit postponeTimeChanged(_postponeTime);
}
void SettingsController::setAutoStart(bool _autoStart)
{
    if (autoStart() == _autoStart)
        return;

    m_settings.setAutoStart(_autoStart);
    emit autoStartChanged(_autoStart);
}
