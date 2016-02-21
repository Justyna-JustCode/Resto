#ifndef SETTINGSCONTROLLER_H
#define SETTINGSCONTROLLER_H

#include <QObject>

#include "model/settings.h"

/*!
 * \brief Controller class to handle settings.
 */
class SettingsController final : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int breakDuration READ breakDuration WRITE setBreakDuration NOTIFY breakDurationChanged)
    Q_PROPERTY(int breakInterval READ breakInterval WRITE setBreakInterval NOTIFY breakIntervalChanged)
    Q_PROPERTY(int workDayDuration READ workDayDuration WRITE setWorkDayDuration NOTIFY workDayDurationChanged)
    Q_PROPERTY(int postponeTime READ postponeTime WRITE setPostponeTime NOTIFY postponeTimeChanged)
    Q_PROPERTY(bool autoStart READ autoStart WRITE setAutoStart NOTIFY autoStartChanged)

public:
    explicit SettingsController(QObject *parent = 0);

    int breakDuration() const;
    int breakInterval() const;
    int workDayDuration() const;
    int postponeTime() const;
    bool autoStart() const;

signals:
    void breakDurationChanged(int breakDuration) const;
    void breakIntervalChanged(int breakInterval) const;
    void workDayDurationChanged(int workDayDuration) const;
    void postponeTimeChanged(int postponeTime) const;
    void autoStartChanged(bool autoStart) const;

public slots:
    void setBreakDuration(int breakDuration);
    void setBreakInterval(int breakInterval);
    void setWorkDayDuration(int workDayDuration);
    void setPostponeTime(int postponeTime);
    void setAutoStart(bool autoStart);

private:
    /*!
     * \brief Settings model class.
     */
    Settings m_settings;
};



#endif // SETTINGSCONTROLLER_H
