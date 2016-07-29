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
    Q_PROPERTY(int workTime READ workTime WRITE setWorkTime NOTIFY workTimeChanged)
    Q_PROPERTY(int postponeTime READ postponeTime WRITE setPostponeTime NOTIFY postponeTimeChanged)
    Q_PROPERTY(bool autoStart READ autoStart WRITE setAutoStart NOTIFY autoStartChanged)

    Q_PROPERTY(QPoint windowPosition READ windowPosition WRITE setWindowPosition NOTIFY windowPositionChanged)
    Q_PROPERTY(QSize windowSize READ windowSize WRITE setWindowSize NOTIFY windowSizeChanged)

    Q_PROPERTY(QStringList availableColors READ availableColors CONSTANT)
    Q_PROPERTY(QColor applicationColor READ applicationColor WRITE setApplicationColor NOTIFY applicationColorChanged)

public:
    explicit SettingsController(QObject *parent = 0);

    int breakDuration() const;
    int breakInterval() const;
    int workTime() const;
    int postponeTime() const;
    bool autoStart() const;

    QPoint windowPosition() const;
    QSize windowSize() const;

    QStringList availableColors() const;
    QColor applicationColor() const;

signals:
    void breakDurationChanged(int breakDuration) const;
    void breakIntervalChanged(int breakInterval) const;
    void workTimeChanged(int workTime) const;
    void postponeTimeChanged(int postponeTime) const;
    void autoStartChanged(bool autoStart) const;

    void windowPositionChanged(const QPoint &windowPosition) const;
    void windowSizeChanged(const QSize &windowSize) const;
    void applicationColorChanged(QColor applicationColor) const;

public slots:
    void setBreakDuration(int breakDuration);
    void setBreakInterval(int breakInterval);
    void setWorkTime(int workTime);
    void setPostponeTime(int postponeTime);
    void setAutoStart(bool autoStart);

    void setWindowPosition(const QPoint &windowPosition);
    void setWindowSize(const QSize &windowSize);
    void setApplicationColor(QColor applicationColor);

private:
    /*!
     * \brief Settings model class.
     */
    Settings m_settings;

    static const QStringList sc_availableColors;
};



#endif // SETTINGSCONTROLLER_H
