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

#include <QApplication>
#include <QCommandLineParser>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QIcon>
#include <QQuickWindow>

#include "controller/controller.h"
#include "view/traymanager.h"
#include "workers/singleappmanager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/resources/images/app-logo.png"));
    app.setOrganizationName(ORG_NAME);
    app.setOrganizationDomain(ORG_DOMAIN);
    app.setApplicationName(APP_NAME);
    app.setApplicationVersion(APP_VERSION);

    QCommandLineParser cmdParser;
    auto checkDevelopOption = QCommandLineOption{"d", QCoreApplication::translate("develop", "Checks if is a develop version of the application")};
    cmdParser.addOption(checkDevelopOption);
    cmdParser.addVersionOption();
    cmdParser.process(app);
    if (cmdParser.isSet(checkDevelopOption)) {
        fputs(qPrintable(DEVELOP_BUILD), stdout);
        return 0;
    }

    SingleAppManager sam;
    if (!sam.tryRun())
        return 1;

    Controller controller;
    qmlRegisterUncreatableType<Controller>("Resto.Types", 1, 0, "Controller", "Controller class");
    QObject::connect(&controller, &Controller::exitRequest, &app, &QApplication::quit);

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("developBuild", DEVELOP_BUILD);
    engine.rootContext()->setContextProperty("buildNumber", BUILD_NUMBER);
    engine.rootContext()->setContextProperty("controller", &controller);
    engine.rootContext()->setContextProperty("app", &app);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    Q_ASSERT(engine.rootObjects().size() == 1);

    TrayManager tray(controller, dynamic_cast<QQuickWindow*>(
                         engine.rootObjects().first()) );
    QObject::connect(&sam, &SingleAppManager::anotherAppStarted, &tray, &TrayManager::showWindow);

    if (tray.isAvailable())
        app.setQuitOnLastWindowClosed(false);
    return app.exec();
}

