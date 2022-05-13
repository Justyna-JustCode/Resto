cmake_minimum_required(VERSION 3.14)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

OPTION(DELIVERY_BUILD "Build an application in a delivery mode." OFF)

include(orgInfo.cmake) # organization details
include(appInfo.cmake) # application details
include(platforms/platforms.cmake) # platfrom specific setup

project(Resto VERSION ${APP_VERSION} LANGUAGES CXX)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Widgets)

include_directories(cpp)
set(PROJECT_HEADERS
    cpp/controller/controller.h
    cpp/model/settings.h
    cpp/controller/settingscontroller.h
    cpp/controller/timercontroller.h
    cpp/workers/backupmanager.h
    cpp/view/traymanager.h
    cpp/workers/singleappmanager.h
    cpp/workers/savemanager.h
    cpp/utility/helpers.h
    cpp/controller/updatecontroller.h
)

set(PROJECT_SOURCES
    cpp/main.cpp
    cpp/controller/controller.cpp
    cpp/model/settings.cpp
    cpp/controller/settingscontroller.cpp
    cpp/controller/timercontroller.cpp
    cpp/workers/backupmanager.cpp
    cpp/view/traymanager.cpp
    cpp/workers/singleappmanager.cpp
    cpp/workers/savemanager.cpp
    cpp/utility/helpers.cpp
    cpp/controller/updatecontroller.cpp
)

set(QRC_FILES
    qml.qrc
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt6_add_resources(${QRC_FILES})
else()
    qt5_add_resources(${QRC_FILES})
endif()

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(Resto
        MANUAL_FINALIZATION
        ${PROJECT_SOURCES}
    )
else()
    add_executable(Resto
        ${PROJECT_SOURCES}
        ${QRC_FILES}
        ${APP_ICON_RESOURCE_WINDOWS}
    )
endif()

target_compile_definitions(Resto
    PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(Resto
    PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::Widgets)

set_target_properties(Resto PROPERTIES
    WIN32_EXECUTABLE TRUE
)

if(QT_VERSION_MAJOR EQUAL 6)
    qt_import_qml_plugins(Resto)
    qt_finalize_executable(Resto)
endif()

# add deployment actions
include(deployment.cmake)
