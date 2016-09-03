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

class Controller;

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
     * \param controller    a pointer to a controller class
     * \param mainWindow    a pointer to a main window class
     * \param parent        a parent object
     */
    explicit TrayManager(Controller &controller, QQuickWindow *mainWindow, QObject *parent = 0);

    bool isAvailable() const;

signals:

public slots:

private:
    bool m_isAvailable; //! Defines if system tray is available for current system

    Controller &m_controller;                   //! A pointer to a controller class
    QPointer<QQuickWindow> m_mainWindow;        //! A pointer for a main window class
    QSystemTrayIcon m_trayIcon;
    QScopedPointer<QMenu> m_trayMenu;
    QPointer<QAction> m_breakAction;           //! A break action pointer

#ifdef Q_OS_LINUX
    /*!
     * \brief This functions checks if user graphical interface is GNOME.
     * Tray functions are not currently supported on GNOME.
     */
    bool checkIsGnome();
#endif

private slots:
    void onWindowVisibilityChanged(QWindow::Visibility visibility);
    void onWindowClosed();
    void onTrayActivated(QSystemTrayIcon::ActivationReason activationReason);

    void showInformationDialog();

    void checkBreakAvailability();
    void takeBreak();

    void changeVisibility();
    void showWindow();
    void showSettings();
    void showAbout();
    void quit();

};

#endif // TRAYMANAGER_H
