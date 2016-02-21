#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>

/*!
 * \brief Utility class to access application settings.
 */
class Settings : public QObject
{
    Q_OBJECT

public:
    Settings(const QString organization, const QString name);

    /*!
     * \brief Returns break duration in seconds.
     */
    int breakDuration() const;
    /*!
     * \brief Sets break duration in seconds.
     */
    void setBreakDuration(int duration);

    /*!
     * \brief Returns break interval in seconds.
     *
     * Break interval is time between two breaks.
     */
    int breakInterval() const;
    /*!
     * \brief Sets break interval in seconds.
     *
     * \see breakInterval()
     */
    void setBreakInterval(int interval);

    /*!
     * \brief Returns work day duratinon in seconds.
     *
     * Work day duration is total time of
     * work time (time between breaks)
     * for one day.
     */
    int workDayDuration() const;
    /*!
     * \brief Sets work day duratinon in seconds.
     *
     * \see workDayDuration()
     */
    void setWorkDayDuration(int duration);

    /*!
     * \brief Returns duration for postpone in seconds.
     */
    int postponeTime() const;
    /*!
     * \brief Sets duration for postpone in seconds.
     */
    void setPostponeTime(int duration);

    /*!
     * \brief Returns information if application
     * should start automatically after run.
     */
    bool autoStart() const;
    /*!
     * \brief Sets information if application
     * should start automatically after run.
     */
    void setAutoStart(bool start);

private:
    QSettings m_settings;

    static const QLatin1String sc_breakDurationKey;     //!< keys used for settings: break duration
    static const QLatin1String sc_breakIntervalKey;     //!< keys used for settings: break interval
    static const QLatin1String sc_workDayDurationKey;   //!< keys used for settings: work day duration
    static const QLatin1String sc_postponeTimeKey;      //!< keys used for settings: postpone time
    static const QLatin1String sc_autoStartKey;         //!< keys used for settings: auto start

    static const int sc_defaultBreakDuration;   //!< default braak duration \see breakDuration()
    static const int sc_defaultBreakInterval;   //!< default break interval \see breakInterval()
    static const int sc_defaultWorkDayDuration; //!< default work day duration \see workDayDuration()
    static const int sc_defaultPostponeTime;    //!< default postpone time \see postponeTime()
};

#endif // SETTINGS_H
