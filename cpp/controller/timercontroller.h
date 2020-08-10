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

#ifndef TIMERCONTROLLER_H
#define TIMERCONTROLLER_H

#include <QObject>
#include <QTimer>

class TimerController final : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int elapsedBreakDuration READ elapsedBreakDuration NOTIFY elapsedBreakDurationChanged)
    Q_PROPERTY(int elapsedWorkPeriod READ elapsedWorkPeriod WRITE setElapsedWorkPeriod NOTIFY elapsedWorkPeriodChanged)
    Q_PROPERTY(int elapsedWorkTime READ elapsedWorkTime WRITE setElapsedWorkTime NOTIFY elapsedWorkTimeChanged)
    Q_PROPERTY(PeriodType activePeriodType READ activePeriodType NOTIFY activePeriodTypeChanged)

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

    PeriodType activePeriodType() const;

signals:
    void elapsedBreakDurationChanged(int elapsedBreakDuration) const;
    void elapsedWorkPeriodChanged(int elapsedWorkPeriod) const;
    void elapsedWorkTimeChanged(int elapsedWorkTime) const;
    void timerStopRequest() const;

    void activePeriodTypeChanged(PeriodType activePeriodType) const;

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
