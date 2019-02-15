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

delivery {
    CONFIG(debug, debug|release) {
        error("Cannot build a debug version for a delivery!")
    } else {
        message("Building a delivery version.")
    }
}

include(platforms/platforms.pri)

include(orgInfo.pri)
include(appInfo.pri)
