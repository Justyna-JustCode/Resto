#include "settingscontroller.h"

const QStringList SettingsController::sc_availableColors = { "#19886F", "#EC811B", "#682C90", "#C0159B", "#008000", "#0958EC", "#666666" };

SettingsController::SettingsController(QObject *parent)
    : QObject(parent), m_settings(QStringLiteral("JustCode"), QStringLiteral("Resto"))
{
    m_settings.setDefaultApplicationColor(sc_availableColors.first());
}

int SettingsController::breakDuration() const
{
    return m_settings.breakDuration();
}
int SettingsController::breakInterval() const
{
    return m_settings.breakInterval();
}
int SettingsController::workTime() const
{
    return m_settings.workTime();
}
int SettingsController::postponeTime() const
{
    return m_settings.postponeTime();
}
bool SettingsController::autoStart() const
{
    return m_settings.autoStart();
}

QPoint SettingsController::windowPosition() const
{
    return m_settings.windowPosition();
}

QSize SettingsController::windowSize() const
{
    return m_settings.windowSize();
}

QStringList SettingsController::availableColors() const
{
    return sc_availableColors;
}

QColor SettingsController::applicationColor() const
{
    return m_settings.applicationColor();
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
void SettingsController::setWorkTime(int _workTime)
{
    if (workTime() == _workTime)
        return;

    m_settings.setWorkTime(_workTime);
    emit workTimeChanged(_workTime);
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

void SettingsController::setWindowPosition(const QPoint &_windowPosition)
{
    if (windowPosition() == _windowPosition)
        return;

    m_settings.setWindowPosition(_windowPosition);
    emit windowPositionChanged(_windowPosition);
}

void SettingsController::setWindowSize(const QSize &_windowSize)
{
    if (m_settings.windowSize() == _windowSize)
        return;

    m_settings.setWindowSize(_windowSize);
    emit windowSizeChanged(_windowSize);
}

void SettingsController::setApplicationColor(QColor color)
{
    if (m_settings.applicationColor() == color)
        return;

    m_settings.setApplicationColor(color);
    emit applicationColorChanged(color);
}
