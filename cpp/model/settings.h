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

    /* ============== system accessors ============= */
    /*!
     * \brief Returns information if system tray
     * is available for current system.
     */
    bool trayAvailable() const;
    /*!
     * \brief Sets information if system tray
     * is available for current system.
     */
    void setTrayAvailable(bool available);

    /*!
     * \brief Returns information if system tray
     * warning message should be displayed.
     */
    bool showTrayInfo() const;
    /*!
     * \brief Sets information if system tray
     * warning message should be displayed.
     */
    void setShowTrayInfo(bool show);
    /* ============================================= */

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

    /*!
     * \brief Returns information if application
     * should be hidden automatically after run.
     */
    bool autoHide() const;
    /*!
     * \brief Sets information if application
     * should be hidden automatically after run.
     */
    void setAutoHide(bool hide);

    /*!
     * \brief Returns information if application
     * should be hidden instead quit on close action.
     */
    bool hideOnClose() const;
    /*!
     * \brief Sets information if application
     * should be hidden instead quit on close action.
     */
    void setHideOnClose(bool hide);
    /* ============================================= */

    /* ============== update accessors ============== */
    /*!
     * \brief Returns previous update version check.
     */
    QString updateVersion() const;
    /*!
     * \brief Sets update version check.
     */
    void setUpdateVersion(const QString &version);

    /*!
     * \brief Returns next update check date.
     */
    QDateTime nextUpdateCheck() const;
    /*!
     * \brief Sets next update check date.
     */
    void setNextUpdateCheck(const QDateTime &checkDate);
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
     * \brief Returns the application main color index.
     */
    int applicationColorIndex() const;
    /*!
     * \brief Sets the application main color index.
     */
    void setApplicationColorIndex(const int colorIndex);
    /* ============================================= */

    static void setDefaultApplicationColorIndex(const int value);

private:
    QSettings m_settings;

    static const QLatin1String sc_systemGroupName;  //! a name for the system settings group
    static const QLatin1String sc_logicGroupName;   //! a name for the logic settings group
    static const QLatin1String sc_updateGroupName;   //! a name for the logic settings group
    static const QLatin1String sc_viewGroupName;    //! a name for the view settings group

    // system keys
    static const QLatin1String sc_trayAvailableKey;     //! key used for settings: tray available
    static const QLatin1String sc_showTrayInfoKey;      //! key used for settings: show tray info
    // logic keys
    static const QLatin1String sc_breakDurationKey;     //! key used for settings: break duration
    static const QLatin1String sc_breakIntervalKey;     //! key used for settings: break interval
    static const QLatin1String sc_workTimeKey;   //! key used for settings: work day duration
    static const QLatin1String sc_postponeTimeKey;      //! key used for settings: postpone time
    static const QLatin1String sc_autoStartKey;         //! key used for settings: auto start
    static const QLatin1String sc_autoHideKey;          //! key used for settings: auto hide
    static const QLatin1String sc_hideOnCloseKey;       //! key used for settings: hide on close
    // update keys
    static const QLatin1String sc_updateVersionKey;     //! key used for settings: update version
    static const QLatin1String sc_nextUpdateCheckKey;   //! key used for settings: next update check
    // view keys
    static const QLatin1String sc_windowPositionXKey;    //! key used for settings: window position x value
    static const QLatin1String sc_windowPositionYKey;    //! key used for settings: window position y value
    static const QLatin1String sc_windowWidthKey;  //! key used for settings: window width
    static const QLatin1String sc_windowHeightKey; //! key used for settings: window height
    static const QLatin1String sc_applicationColorIndexKey; //! key used for settings: application main color index

    // logic default
    static const int sc_defaultBreakDuration;   //! default braak duration \see breakDuration()
    static const int sc_defaultBreakInterval;   //! default break interval \see breakInterval()
    static const int sc_defaultWorkTime; //! default work day duration \see workTime()
    static const int sc_defaultPostponeTime;    //! default postpone time \see postponeTime()
    // view default
    static const QSize sc_defaultWindowSize;    //! default window size  \see windowSize()
    static int sc_defaultApplicationColorIndex;    //! default color index  \see applicationColorIndex()

    void setValue(const QString &groupName, const QString &key, const QVariant &value);
    QVariant value(const QString &groupName, const QString &key, const QVariant &defaultValue = QVariant()) const;
};

#endif // SETTINGS_H
