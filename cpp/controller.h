#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QTimer>

#include "settings.h"

class Controller : public QObject
{
    Q_OBJECT
    Q_ENUMS(State)
    Q_PROPERTY(Settings* settings READ qmlSettings CONSTANT)
    Q_PROPERTY(State state READ state NOTIFY stateChanged)
    Q_PROPERTY(int breakTime READ breakTime NOTIFY breakTimeChanged)
    Q_PROPERTY(int timeToBreak READ timeToBreak NOTIFY timeToBreakChanged)
    Q_PROPERTY(int workTime READ workTime NOTIFY workTimeChanged)

public:
    enum class State
    {
        Off,    //!< Timer was not started or already finished
        Work,   //!< Work time counting
        Break,  //!< Break time counting
        Pause   //!< Timer was paused
    };

    Controller();

    /*!
     * \brief Return settings object.
     *
     * \see Settings
     */
    Settings& settings();

    State state() const;

    int breakTime() const;
    int timeToBreak() const;
    int workTime() const;

signals:
    void stateChanged(State state) const;

    void breakTimeChanged(int breakTime) const;
    void timeToBreakChanged(int timeToBreak) const;
    void workTimeChanged(int workTime) const;

    void breakRequest() const;
    void endOfBreakRequest() const;
    void endOfWorkRequest() const;

public slots:
    void start();
    void pause();
    void stop();

    void startWork(bool force = false);
    void startBreak();
    void postponeBreak();

private:
    Settings m_settings;

    State m_state {State::Off}; //!< current state
    QTimer m_timer;

    int m_breakTime {0};    //!< break time passed
    int m_timeToBreak {0};  //!< time to next break
    int m_workTime {0};     //!< work time passed

    int m_nextBreak {0};    //!< next break time

    Settings* qmlSettings();

    void workTimeTic();
    void breakTimeTic();

private slots:
    void setState(State state);

    void setBreakTime(int time);
    void setTimeToBreak(int time);
    void setWorkTime(int time);

    void onTimeTic();
};

#endif // CONTROLLER_H
