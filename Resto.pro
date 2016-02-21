TEMPLATE = app

QT += qml quick
CONFIG += c++11

INCLUDEPATH += cpp/

SOURCES += cpp/main.cpp \
    cpp/controller/controller.cpp \
    cpp/model/settings.cpp \
    cpp/controller/settingscontroller.cpp \
    cpp/controller/timercontroller.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    cpp/controller/controller.h \
    cpp/model/settings.h \
    cpp/controller/settingscontroller.h \
    cpp/controller/timercontroller.h

DISTFILES += \
    qml/components/TimeProgressBar.qml \
    qml/main.qml \
    qml/dialogs/BreakDialog.qml \
    qml/dialogs/BreakRequestDialog.qml \
    qml/dialogs/EndWorkRequestDialog.qml \
    qml/dialogs/CustomDialog.qml \
    resources/font.ttf \
    resources/background.png \
    resources/pattern.png \
    qml/components/Background.qml \
    qml/Style.qml \
    qml/components/Label.qml \
    qml/components/BarGradient.qml

