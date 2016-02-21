#include "settings.h"

const QLatin1String Settings::sc_breakDurationKey = QLatin1String("breakDuration");
const QLatin1String Settings::sc_breakIntervalKey = QLatin1String("breakInterval");
const QLatin1String Settings::sc_workDayDurationKey = QLatin1String("workDayDuration");
const QLatin1String Settings::sc_postponeTimeKey = QLatin1String("postponeTime");
const QLatin1String Settings::sc_autoStartKey = QLatin1String("autoStart");

const int Settings::sc_defaultBreakDuration = 600;  //!< 10 min = 600 sec
const int Settings::sc_defaultBreakInterval = 2700; //!< 45 min = 2700 sec
const int Settings::sc_defaultWorkDayDuration = 28800;  //!< 8 h = 288000 sec
const int Settings::sc_defaultPostponeTime = 300;   //!< 5 min = 300 sec

Settings::Settings(const QString organization, const QString name)
    : m_settings(QSettings::UserScope, organization, name)
{}

int Settings::breakDuration() const
{
    return m_settings.value(sc_breakDurationKey, sc_defaultBreakDuration).toInt();
}
void Settings::setBreakDuration(int duration)
{
    m_settings.setValue(sc_breakDurationKey, duration);
}

int Settings::breakInterval() const
{
    return m_settings.value(sc_breakIntervalKey, sc_defaultBreakInterval).toInt();
}
void Settings::setBreakInterval(int interval)
{
    m_settings.setValue(sc_breakIntervalKey, interval);
}

int Settings::workDayDuration() const
{
    return m_settings.value(sc_workDayDurationKey, sc_defaultWorkDayDuration).toInt();
}
void Settings::setWorkDayDuration(int duration)
{
    m_settings.setValue(sc_workDayDurationKey, duration);
}

int Settings::postponeTime() const
{
    return m_settings.value(sc_postponeTimeKey, sc_defaultPostponeTime).toInt();
}
void Settings::setPostponeTime(int duration)
{
    m_settings.setValue(sc_postponeTimeKey, duration);
}

bool Settings::autoStart() const
{
    return m_settings.value(sc_autoStartKey).toBool();
}
void Settings::setAutoStart(bool start)
{
    m_settings.setValue(sc_autoStartKey, start);
}

