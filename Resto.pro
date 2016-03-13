TEMPLATE = app

QT += qml quick
CONFIG += c++11

INCLUDEPATH += cpp/

SOURCES += cpp/main.cpp \
    cpp/controller/controller.cpp \
    cpp/model/settings.cpp \
    cpp/controller/settingscontroller.cpp \
    cpp/controller/timercontroller.cpp \
    cpp/workers/backupmanager.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    cpp/controller/controller.h \
    cpp/model/settings.h \
    cpp/controller/settingscontroller.h \
    cpp/controller/timercontroller.h \
    cpp/workers/backupmanager.h

DISTFILES += \
    qml/components/TimeProgressBar.qml \
    qml/main.qml \
    qml/dialogs/BreakDialog.qml \
    qml/dialogs/BreakRequestDialog.qml \
    qml/dialogs/EndWorkRequestDialog.qml \
    qml/dialogs/CustomDialog.qml \
    qml/components/Background.qml \
    qml/style/Style.qml \
    qml/components/Label.qml \
    qml/components/helpers/BarGradient.qml \
    qml/components/helpers/BarTextGradient.qml \
    qml/style/StyleFont.qml \
    qml/style/qmldir \
    qml/components/ImageButton.qml

