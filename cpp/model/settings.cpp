#include "settings.h"

const QLatin1String Settings::sc_logicGroupName = QLatin1String("logic");
const QLatin1String Settings::sc_viewGroupName = QLatin1String("view");

const QLatin1String Settings::sc_breakDurationKey = QLatin1String("breakDuration");
const QLatin1String Settings::sc_breakIntervalKey = QLatin1String("breakInterval");
const QLatin1String Settings::sc_workTimeKey = QLatin1String("workTime");
const QLatin1String Settings::sc_postponeTimeKey = QLatin1String("postponeTime");
const QLatin1String Settings::sc_autoStartKey = QLatin1String("autoStart");

const QLatin1String Settings::sc_windowPositionXKey = QLatin1String("window-x");
const QLatin1String Settings::sc_windowPositionYKey = QLatin1String("window-y");
const QLatin1String Settings::sc_windowWidthKey = QLatin1String("window-width");
const QLatin1String Settings::sc_windowHeightKey = QLatin1String("window-height");
const QLatin1String Settings::sc_applicationColorKey = QLatin1String("mainColor");

const int Settings::sc_defaultBreakDuration = 10*60;  //!< 10 min
const int Settings::sc_defaultBreakInterval = 45*60; //!< 45 min
const int Settings::sc_defaultWorkTime = 8*60*60;  //!< 8 h
const int Settings::sc_defaultPostponeTime = 5*60;   //!< 5 min

const QSize Settings::sc_defaultWindowSize = { 400, 200 };  // px
QColor Settings::sc_defaultApplicationColor;

Settings::Settings(const QString organization, const QString name)
    : m_settings(QSettings::UserScope, organization, name)
{}

int Settings::breakDuration() const
{
    return value(sc_logicGroupName, sc_breakDurationKey, sc_defaultBreakDuration).toInt();
}
void Settings::setBreakDuration(int duration)
{
    setValue(sc_logicGroupName, sc_breakDurationKey, duration);
}

int Settings::breakInterval() const
{
    return value(sc_logicGroupName, sc_breakIntervalKey, sc_defaultBreakInterval).toInt();
}
void Settings::setBreakInterval(int interval)
{
    setValue(sc_logicGroupName, sc_breakIntervalKey, interval);
}

int Settings::workTime() const
{
    return value(sc_logicGroupName, sc_workTimeKey, sc_defaultWorkTime).toInt();
}
void Settings::setWorkTime(int time)
{
    setValue(sc_logicGroupName, sc_workTimeKey, time);
}

int Settings::postponeTime() const
{
    return value(sc_logicGroupName, sc_postponeTimeKey, sc_defaultPostponeTime).toInt();
}
void Settings::setPostponeTime(int time)
{
    setValue(sc_logicGroupName, sc_postponeTimeKey, time);
}

bool Settings::autoStart() const
{
    return value(sc_logicGroupName, sc_autoStartKey).toBool();
}
void Settings::setAutoStart(bool start)
{
    setValue(sc_logicGroupName, sc_autoStartKey, start);
}

QPoint Settings::windowPosition() const
{
    return { value(sc_viewGroupName, sc_windowPositionXKey).toInt(),
                value(sc_viewGroupName, sc_windowPositionYKey).toInt() };
}

void Settings::setWindowPosition(const QPoint &position)
{
    setValue(sc_viewGroupName, sc_windowPositionXKey, position.x());
    setValue(sc_viewGroupName, sc_windowPositionYKey, position.y());
}

QSize Settings::windowSize() const
{
    return { value(sc_viewGroupName, sc_windowWidthKey, sc_defaultWindowSize.width()).toInt(),
                value(sc_viewGroupName, sc_windowHeightKey, sc_defaultWindowSize.height()).toInt() };
}

void Settings::setWindowSize(const QSize &size)
{
    setValue(sc_viewGroupName, sc_windowWidthKey, size.width());
    setValue(sc_viewGroupName, sc_windowHeightKey, size.height());
}

QColor Settings::applicationColor() const
{
    return value(sc_viewGroupName, sc_applicationColorKey, sc_defaultApplicationColor).toString();
}

void Settings::setApplicationColor(const QColor &color)
{
    setValue(sc_viewGroupName, sc_applicationColorKey, color.name(QColor::HexRgb));
}

void Settings::setDefaultApplicationColor(const QColor &value)
{
    sc_defaultApplicationColor = value;
}

void Settings::setValue(const QString &groupName, const QString &key, const QVariant &value)
{
    m_settings.beginGroup(groupName);
    m_settings.setValue(key, value);
    m_settings.endGroup();
}

QVariant Settings::value(const QString &groupName, const QString &key, const QVariant &defaultValue) const
{
    return m_settings.value(groupName + '/' + key, defaultValue);
}

