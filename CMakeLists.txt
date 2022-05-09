cmake_minimum_required(VERSION 3.14)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

### INCLUDES
#= orgInfo.pri
# application info
set(ORG_NAME "JustCode")
set(ORG_DOMAIN "just-code.org")

# add defines
add_compile_definitions(ORG_NAME=\"${ORG_NAME}\")
add_compile_definitions(ORG_DOMAIN=\"${ORG_DOMAIN}\")

#= appInfo.pri
# application info
set(APP_NAME, "Resto")
set(APP_DESCRIPTION, "A small application for work time management")

set(APP_VERSION, 1.0.7)
execute_process(COMMAND git --git-dir $$PWD/.git --work-tree $$PWD log --pretty=format:'%h' -n 1
                OUTPUT_VARIABLE BUILD_NUMBER
                ERROR_QUIET)

# TODO
#delivery {
#    APP_VERSION_URL = "$${ORG_DOMAIN}/applications/$${APP_NAME}/version"
#    DEVELOP_BUILD = false
#} else {
    set(APP_VERSION_URL "${ORG_DOMAIN}/applications/${APP_NAME}/version_develop")
#}

# add defines
add_compile_definitions(APP_NAME=\"${APP_NAME}\")
add_compile_definitions(APP_DESCRIPTION=\"${APP_DESCRIPTION}\")
add_compile_definitions(APP_VERSION=\"${APP_VERSION}\")
add_compile_definitions(APP_VERSION_URL=\"${APP_VERSION_URL}\")
add_compile_definitions(BUILD_NUMBER=\"${BUILD_NUMBER}\")
add_compile_definitions(DEVELOP_BUILD)
#======================================================================================================

project(Resto VERSION ${APP_VERSION} LANGUAGES CXX)

find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS Core Quick Widgets)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core Quick Widgets)

include_directories(cpp)
set(PROJECT_HEADERS
  cpp/controller/controller.h
  cpp/controller/cyclescontroller.h
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
  cpp/controller/cyclescontroller.cpp
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

# Define target properties for Android with Qt 6 as:
#    set_property(TARGET Resto APPEND PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
#                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
# For more information, see https://doc.qt.io/qt-6/qt-add-executable.html#target-creation
else()
    if(ANDROID)
        add_library(Resto SHARED
            ${PROJECT_SOURCES}
        )
# Define properties for Android with Qt 5 after find_package() calls as:
    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    else()
        add_executable(Resto
          ${PROJECT_SOURCES}
          ${QRC_FILES}
        )
    endif()
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
