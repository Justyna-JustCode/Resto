#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>

#include "settingscontroller.h"
#include "timercontroller.h"

class Controller final : public QObject
{
    Q_OBJECT
    Q_ENUMS(State)

    Q_PROPERTY(SettingsController* settings READ settingsPtr CONSTANT)
    Q_PROPERTY(TimerController* timer READ timerPtr CONSTANT)

    Q_PROPERTY(State state READ state NOTIFY stateChanged)

public:
    enum class State : qint8
    {
        Off,
        Working,
        Paused
    };

    Controller();

    State state() const;

signals:
    void stateChanged(State state) const;

    void breakStartRequest() const;
    void breakEndRequest() const;
    void workEndRequest() const;

public slots:
    void start();
    void pause();
    void stop();

    void startBreak();
    void postponeBreak();
    void startWork();

private:
    SettingsController m_settingsController;
    TimerController m_timerController;

    State m_state = State::Off; //!< current state

    int m_actualWorkPeriod = 0; //!< work period taking into account postpones

    SettingsController &settings();
    SettingsController *settingsPtr();

    TimerController &timer();
    TimerController *timerPtr();

private slots:
    void setState(State state);

    /*!
     * \brief Method handling change in elapsed time of break.
     *
     * Check if end should be finished and informs about this.
     *
     * \param elapsedBreakDuration  elapsed time of break.
     */
    void onElapsedBreakDurationChange(int elapsedBreakDuration);
    /*!
     * \brief Method handling change in elapsed time of work period.
     *
     * Check if break is needed and informs about it.
     * Takes into account also postponing of break.
     *
     * \param elapsedWorkPeriod     elapsed time of work period.
     */
    void onElapsedWorkPeriodChange(int elapsedWorkPeriod);
    /*!
     * \brief Method handling change in total work time elapsed.
     *
     * Check if work should be finished and informs about it.
     *
     * \param elapsedWorkTime   total work time elapsed
     */
    void onElapsedWorkTimeChange(int elapsedWorkTime);
};

#endif // CONTROLLER_H
