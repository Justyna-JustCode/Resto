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
    void showWindow();

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

    void initTrayIcon();
    void initTrayMenu();
    void checkInitState();

private slots:
    void onWindowVisibilityChanged(QWindow::Visibility visibility);
    void onWindowClosed();
    void onTrayActivated(QSystemTrayIcon::ActivationReason activationReason);

    void showInformationDialog();

    void checkBreakAvailability();
    void takeBreak();

    void changeVisibility();
    void updateToolTip();

    void showSettings();
    void showAbout();
    void saveAndQuit();
    void quit();

};

#endif // TRAYMANAGER_H
