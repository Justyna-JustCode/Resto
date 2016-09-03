#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QIcon>
#include <QQuickWindow>

#include "controller/controller.h"
#include "view/traymanager.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/resources/images/app-logo.png"));
    app.setOrganizationName(ORG_NAME);
    app.setOrganizationDomain(ORG_DOMAIN);
    app.setApplicationName(APP_NAME);
    app.setApplicationVersion(APP_VERSION);

    Controller controller;
    qmlRegisterUncreatableType<Controller>("Resto.Types", 1, 0, "Controller", "Controller class");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("controller", &controller);
    engine.rootContext()->setContextProperty("app", &app);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    Q_ASSERT(engine.rootObjects().size() == 1);

    TrayManager tray(controller, dynamic_cast<QQuickWindow*>(
                         engine.rootObjects().first()) );
    Q_UNUSED(tray);

    app.setQuitOnLastWindowClosed(false);
    return app.exec();
}

