#ifndef TRAYMANAGER_H
#define TRAYMANAGER_H

#include <QObject>
#include <QPointer>
#include <QScopedPointer>
#include <QQuickWindow>
#include <QSystemTrayIcon>
#include <QMenu>

class QQuickWindow;
class QQuickCloseEvent;

class SettingsController;

/*!
 * \brief The TrayManager class is responsible
 * for managing system tray icon and related menu.
 */
class TrayManager final : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isAvailable READ isAvailable CONSTANT)

public:
    /*!
     * \brief A default constructor for TrayManager class.
     * Require a main window class and settings controller pointers.
     *
     * \param settings      a pointer to settings controller class
     * \param mainWindow    a pointer to main window class
     * \param parent        a parent object
     */
    explicit TrayManager(SettingsController &settings, QQuickWindow *mainWindow, QObject *parent = 0);

    bool isAvailable() const;

signals:

public slots:

private:
    bool m_isAvailable; //! Defines if system tray is available for current system

    SettingsController &m_settings;    //! A pointer to settings controller class
    QPointer<QQuickWindow> m_mainWindow;        //! A pointer for main window class
    QSystemTrayIcon m_trayIcon;
    QScopedPointer<QMenu> m_trayMenu;

private slots:
    void onWindowVisibilityChanged(QWindow::Visibility visibility);
    void onWindowClosed();
    void onTrayActivated(QSystemTrayIcon::ActivationReason activationReason);

    void showInformationDialog();

    void changeVisibility();
    void showWindow();
    void showSettings();
    void showAbout();
    void quit();

};

#endif // TRAYMANAGER_H
