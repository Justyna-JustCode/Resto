TEMPLATE = app

QT += qml quick widgets
CONFIG += c++11

INCLUDEPATH += cpp/

SOURCES += cpp/main.cpp \
    cpp/controller/controller.cpp \
    cpp/model/settings.cpp \
    cpp/controller/settingscontroller.cpp \
    cpp/controller/timercontroller.cpp \
    cpp/workers/backupmanager.cpp \
    cpp/view/traymanager.cpp \
    cpp/workers/singleappmanager.cpp \
    cpp/workers/savemanager.cpp \
    cpp/utility/helpers.cpp \
    cpp/controller/updatecontroller.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

HEADERS += \
    cpp/controller/controller.h \
    cpp/model/settings.h \
    cpp/controller/settingscontroller.h \
    cpp/controller/timercontroller.h \
    cpp/workers/backupmanager.h \
    cpp/view/traymanager.h \
    cpp/workers/singleappmanager.h \
    cpp/workers/savemanager.h \
    cpp/utility/helpers.h \
    cpp/controller/updatecontroller.h

include(appInfo.pri)

win32:RC_ICONS += resources/images/app-logo.ico
