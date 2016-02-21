#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>

#include "controller/controller.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    Controller controller;

    qmlRegisterUncreatableType<Controller>("Resto.Types", 1, 0, "Controller", "Controller class");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("controller", &controller);

    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}

