#include "settings.h"

const QLatin1String Settings::sc_breakDurationKey = QLatin1String("breakDuration");
const QLatin1String Settings::sc_breakIntervalKey = QLatin1String("breakInterval");
const QLatin1String Settings::sc_workTimeKey = QLatin1String("workTime");
const QLatin1String Settings::sc_postponeTimeKey = QLatin1String("postponeTime");
const QLatin1String Settings::sc_autoStartKey = QLatin1String("autoStart");

const int Settings::sc_defaultBreakDuration = 10*60;  //!< 10 min
const int Settings::sc_defaultBreakInterval = 45*60; //!< 45 min
const int Settings::sc_defaultWorkTime = 8*60*60;  //!< 8 h
const int Settings::sc_defaultPostponeTime = 5*60;   //!< 5 min

Settings::Settings(const QString organization, const QString name)
    : m_settings(QSettings::UserScope, organization, name)
{
#ifdef QT_DEBUG // TODO: remove it before release
    setAutoStart(false);
    setWorkTime(5*60);      // 5 min
    setBreakDuration(15);   // 15 sec
    setBreakInterval(30);   // 30 sec
    setPostponeTime(10);    // 10 sec
#endif
}

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

int Settings::workTime() const
{
    return m_settings.value(sc_workTimeKey, sc_defaultWorkTime).toInt();
}
void Settings::setWorkTime(int time)
{
    m_settings.setValue(sc_workTimeKey, time);
}

int Settings::postponeTime() const
{
    return m_settings.value(sc_postponeTimeKey, sc_defaultPostponeTime).toInt();
}
void Settings::setPostponeTime(int time)
{
    m_settings.setValue(sc_postponeTimeKey, time);
}

bool Settings::autoStart() const
{
    return m_settings.value(sc_autoStartKey).toBool();
}
void Settings::setAutoStart(bool start)
{
    m_settings.setValue(sc_autoStartKey, start);
}

