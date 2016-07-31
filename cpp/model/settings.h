#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>
#include <QPoint>
#include <QSize>
#include <QColor>

/*!
 * \brief Utility class to access application settings.
 */
class Settings final : public QObject
{
    Q_OBJECT

public:
    Settings(const QString organization, const QString name);

    /* ============== logic accessors ============== */
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
    int workTime() const;
    /*!
     * \brief Sets work day duratinon in seconds.
     *
     * \see workTime()
     */
    void setWorkTime(int time);

    /*!
     * \brief Returns duration for postpone in seconds.
     */
    int postponeTime() const;
    /*!
     * \brief Sets duration for postpone in seconds.
     */
    void setPostponeTime(int time);

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
    /* ============================================= */

    /* =============== view accessors ============== */
    /*!
     * \brief Returns the lastest position of the main window.
     */
    QPoint windowPosition() const;
    /*!
     * \brief Sets a current positon of the main window.
     */
    void setWindowPosition(const QPoint &position);

    /*!
     * \brief Returns the lastest size of the main window.
     */
    QSize windowSize() const;
    /*!
     * \brief Sets a current size of the main window.
     */
    void setWindowSize(const QSize &size);

    /*!
     * \brief Returns the application main color.
     */
    QColor applicationColor() const;
    /*!
     * \brief Sets the application main color.
     */
    void setApplicationColor(const QColor &color);
    /* ============================================= */

    static void setDefaultApplicationColor(const QColor &value);

private:
    QSettings m_settings;

    static const QLatin1String sc_logicGroupName;    //!< a name for the logic settings group
    static const QLatin1String sc_viewGroupName;    //!< a name for the view settings group

    // logic keys
    static const QLatin1String sc_breakDurationKey;     //!< key used for settings: break duration
    static const QLatin1String sc_breakIntervalKey;     //!< key used for settings: break interval
    static const QLatin1String sc_workTimeKey;   //!< key used for settings: work day duration
    static const QLatin1String sc_postponeTimeKey;      //!< key used for settings: postpone time
    static const QLatin1String sc_autoStartKey;         //!< key used for settings: auto start
    // view keys
    static const QLatin1String sc_windowPositionXKey;    //!< key used for settings: window position x value
    static const QLatin1String sc_windowPositionYKey;    //!< key used for settings: window position y value
    static const QLatin1String sc_windowWidthKey;  //!< key used for settings: window width
    static const QLatin1String sc_windowHeightKey; //!< key used for settings: window height
    static const QLatin1String sc_applicationColorKey; //!< key used for settings: application main color

    // logic default
    static const int sc_defaultBreakDuration;   //!< default braak duration \see breakDuration()
    static const int sc_defaultBreakInterval;   //!< default break interval \see breakInterval()
    static const int sc_defaultWorkTime; //!< default work day duration \see workTime()
    static const int sc_defaultPostponeTime;    //!< default postpone time \see postponeTime()
    // view default
    static const QSize sc_defaultWindowSize;    //!< default postpone time \see postponeTime()
    static QColor sc_defaultApplicationColor;    //!< default postpone time \see postponeTime()

    void setValue(const QString &groupName, const QString &key, const QVariant &value);
    QVariant value(const QString &groupName, const QString &key, const QVariant &defaultValue = QVariant()) const;
};

#endif // SETTINGS_H
