#include "traymanager.h"

#include <QApplication>
#include <QMessageBox>
#include <QCheckBox>

#include "controller/settingscontroller.h"

TrayManager::TrayManager(SettingsController &settings, QQuickWindow *mainWindow, QObject *parent)
    : QObject(parent), m_settings(settings), m_mainWindow(mainWindow)
{
//    Q_ASSERT_X(settings, Q_FUNC_INFO, "Settings Controller class for Tray Manager cannot be null.");
    Q_ASSERT_X(mainWindow, Q_FUNC_INFO, "Main Window class for Tray Manager cannot be null.");

    m_isAvailable = QSystemTrayIcon::isSystemTrayAvailable();
    m_settings.setTrayAvailable(m_isAvailable);

    if (m_isAvailable) {
        m_trayIcon.setIcon(QApplication::windowIcon());
        connect(&m_trayIcon, &QSystemTrayIcon::activated,
                this, &TrayManager::changeVisibility);

        connect(m_mainWindow.data(), &QQuickWindow::visibilityChanged,
                this, &TrayManager::onWindowVisibilityChanged);
        connect(m_mainWindow.data(), SIGNAL(closing(QQuickCloseEvent*)), // QTBUG-36453 -> cannot use C++11 style connect
                this, SLOT(onWindowClosed()) );

        // tray menu
        m_trayMenu.reset(new QMenu(QApplication::applicationName()) );
        auto action = m_trayMenu->addAction(QApplication::windowIcon(), QApplication::applicationName());
        connect(action, &QAction::triggered, this, &TrayManager::showWindow);
        m_trayMenu->addSeparator();

        action = m_trayMenu->addAction(QIcon(":/resources/images/settings.png"), tr("Settings"));
        connect(action, &QAction::triggered, this, &TrayManager::showSettings);
        action = m_trayMenu->addAction(QIcon(":/resources/images/about.png"), tr("About"));
        connect(action, &QAction::triggered, this, &TrayManager::showAbout);
        m_trayMenu->addSeparator();

        action = m_trayMenu->addAction(tr("Quit"));
        connect(action, &QAction::triggered, this, &TrayManager::quit);

        m_trayIcon.setContextMenu(m_trayMenu.data());

        m_trayIcon.show();

        // check default visibility state
        if (m_settings.autoHide()) {
            m_mainWindow->setVisibility(QWindow::Hidden);
        }
    }
}

bool TrayManager::isAvailable() const
{
    return m_isAvailable;
}

void TrayManager::onWindowVisibilityChanged(QWindow::Visibility visibility)
{
    switch(visibility) {
    case QWindow::Minimized:
        showInformationDialog();
        m_mainWindow->setVisibility(QWindow::Hidden);
        break;
    default:
        break;
    }
}

void TrayManager::onWindowClosed()
{
    if (m_settings.hideOnClose()) {
        showInformationDialog();
    }
    else {
        quit();
    }
}

void TrayManager::showInformationDialog()
{
    if (!m_settings.showTrayInfo())
        return;

    QMessageBox infoMessage(QMessageBox::Icon::Information,
                           tr("Please note"), tr("Application will be hidden into the system tray.\n"
                                                 "If you want to open it, just click on an icon or use a context menu option.\n"
                                                 "Break notification will continue to be displayed normally.\n"),
                           QMessageBox::Ok);
    infoMessage.setCheckBox(new QCheckBox(tr("Do not show this any more"), &infoMessage));
    infoMessage.checkBox()->setChecked(true);

    infoMessage.exec();
    m_settings.setShowTrayInfo(infoMessage.checkBox()->checkState() != Qt::Checked);
}

void TrayManager::changeVisibility()
{
    if (m_mainWindow->isVisible()) {
        m_mainWindow->hide();
    }
    else {
        m_mainWindow->show();
    }
}

void TrayManager::showWindow()
{
    m_mainWindow->show();
}

void TrayManager::showSettings()
{
    QMetaObject::invokeMethod(m_mainWindow, "showSettingsDialog");
}

void TrayManager::showAbout()
{
    QMetaObject::invokeMethod(m_mainWindow, "showAboutDialog");
}

void TrayManager::quit()
{
    QApplication::quit();
}
