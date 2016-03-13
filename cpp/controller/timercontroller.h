#ifndef TIMERCONTROLLER_H
#define TIMERCONTROLLER_H

#include <QObject>
#include <QTimer>

class TimerController final : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int elapsedBreakDuration READ elapsedBreakDuration NOTIFY elapsedBreakDurationChanged)
    Q_PROPERTY(int elapsedWorkPeriod READ elapsedWorkPeriod NOTIFY elapsedWorkPeriodChanged)
    Q_PROPERTY(int elapsedWorkTime READ elapsedWorkTime NOTIFY elapsedWorkTimeChanged)

public:
    enum class PeriodType : qint8
    {
        Break,
        Work
    };

    explicit TimerController(QObject *parent = 0);

    int elapsedBreakDuration() const;
    int elapsedWorkPeriod() const;
    int elapsedWorkTime() const;

signals:
    void elapsedBreakDurationChanged(int elapsedBreakDuration) const;
    void elapsedWorkPeriodChanged(int elapsedWorkPeriod) const;
    void elapsedWorkTimeChanged(int elapsedWorkTime) const;

public slots:
    void start(bool restart);
    void stop();

    void countBreakTime();
    void countWorkTime();

    void setElapsedBreakDuration(int elapsedBreakDuration);
    void setElapsedWorkPeriod(int elapsedWorkPeriod);
    void setElapsedWorkTime(int elapsedWorkTime);

private:
    QTimer m_timer;

    PeriodType m_periodType = PeriodType::Work;

    int m_elapsedBreakDuration = 0;
    int m_elapsedWorkPeriod = 0;
    int m_elapsedWorkTime = 0;

private slots:
    void incrementWorkTime();
    void incrementBreakTime();

    void onTimeTic();
};

#endif // TIMERCONTROLLER_H
