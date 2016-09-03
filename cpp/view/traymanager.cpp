#include "traymanager.h"

#include <QApplication>
#include <QMessageBox>
#include <QCheckBox>
#ifdef Q_OS_LINUX
#include <QProcess>
#endif

#include "controller/controller.h"

TrayManager::TrayManager(Controller &controller, QQuickWindow *mainWindow, QObject *parent)
    : QObject(parent), m_controller(controller), m_mainWindow(mainWindow)
{
    Q_ASSERT_X(mainWindow, Q_FUNC_INFO, "Main Window class for Tray Manager cannot be null.");

    m_isAvailable = QSystemTrayIcon::isSystemTrayAvailable();
#ifdef Q_OS_LINUX
    if (checkIsGnome()) {   // tray functions are not currently supported on GNOME
        m_isAvailable = false;
    }
#endif
    m_controller.settings().setTrayAvailable(m_isAvailable);

    if (m_isAvailable) {
        m_trayIcon.setIcon(QApplication::windowIcon());
        connect(&m_trayIcon, &QSystemTrayIcon::activated,
                this, &TrayManager::onTrayActivated);

        connect(m_mainWindow.data(), &QQuickWindow::visibilityChanged,
                this, &TrayManager::onWindowVisibilityChanged);
        connect(m_mainWindow.data(), SIGNAL(closing(QQuickCloseEvent*)), // QTBUG-36453 -> cannot use C++11 style connect
                this, SLOT(onWindowClosed()) );

        // tray menu
        m_trayMenu.reset(new QMenu(QApplication::applicationName()) );
        auto action = m_trayMenu->addAction(QApplication::windowIcon(), QApplication::applicationName());
        connect(action, &QAction::triggered, this, &TrayManager::showWindow);
        m_trayMenu->addSeparator();

        action = m_trayMenu->addAction(QIcon(":/resources/images/break.png"), tr("Take a break!"));
        connect(action, &QAction::triggered, this, &TrayManager::takeBreak);
        m_breakAction = action;
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

        // change enable for break action
        connect(&m_controller, &Controller::stateChanged, this, &TrayManager::checkBreakAvailability);
        connect(&m_controller.timer(), &TimerController::activePeriodTypeChanged,
                this, &TrayManager::checkBreakAvailability);
        checkBreakAvailability();

        // check default visibility state
        if (m_controller.settings().autoHide()) {
            m_mainWindow->setVisibility(QWindow::Hidden);
        }
    }
}

bool TrayManager::isAvailable() const
{
    return m_isAvailable;
}

#ifdef Q_OS_LINUX
bool TrayManager::checkIsGnome()
{
    QProcess envCheck;
    envCheck.start("sh", { "-c", "echo $XDG_CURRENT_DESKTOP" }, QProcess::ReadOnly);
    envCheck.waitForFinished();
    auto result = envCheck.readAll();
    envCheck.close();

    return QString(result).startsWith("GNOME", Qt::CaseInsensitive);
}
#endif

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
    if (m_controller.settings().hideOnClose()) {
        showInformationDialog();
    }
    else {
        quit();
    }
}

void TrayManager::onTrayActivated(QSystemTrayIcon::ActivationReason activationReason)
{
    if (activationReason == QSystemTrayIcon::Trigger) {
        changeVisibility();
    }
}

void TrayManager::showInformationDialog()
{
    if (!m_controller.settings().showTrayInfo())
        return;

    QMessageBox infoMessage(QMessageBox::Icon::Information,
                           tr("Please note"), tr("Application will be hidden into the system tray.\n"
                                                 "If you want to open it, just click on an icon or use a context menu option.\n"
                                                 "Break notification will continue to be displayed normally.\n"),
                           QMessageBox::Ok);
    infoMessage.setCheckBox(new QCheckBox(tr("Do not show this any more"), &infoMessage));
    infoMessage.checkBox()->setChecked(true);

    infoMessage.exec();
    m_controller.settings().setShowTrayInfo(infoMessage.checkBox()->checkState() != Qt::Checked);
}

void TrayManager::checkBreakAvailability()
{
    m_breakAction->setEnabled(m_controller.state() == Controller::State::Working &&
                              m_controller.timer().activePeriodType() == TimerController::PeriodType::Work);
}

void TrayManager::takeBreak()
{
    m_controller.startBreak();
    QMetaObject::invokeMethod(m_mainWindow, "showBreakDialog");
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
