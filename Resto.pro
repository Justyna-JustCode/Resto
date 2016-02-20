TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += cpp/main.cpp \
    cpp/controller.cpp \
    cpp/settings.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    cpp/controller.h \
    cpp/settings.h

DISTFILES += \
    qml/components/TimeProgressBar.qml \
    qml/main.qml \
    qml/dialogs/BreakDialog.qml \
    qml/dialogs/BreakRequestDialog.qml \
    qml/dialogs/EndWorkRequestDialog.qml \
    qml/dialogs/CustomDialog.qml

