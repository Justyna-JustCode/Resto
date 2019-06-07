#!/bin/bash

SCRIPTS_DIR=$(dirname "$0")
PROJECT_DIR=$(readlink -m "${SCRIPTS_DIR}/../../")

# setup up this with your variables ==================
# QT:
QT_PATH="/c/Qt/"
QT_VERSION="5.12.2"
QT_COMPILER="msvc2017_64"
WINDEPLOYQT_FILE=$(readlink -m "${QT_PATH}/${QT_VERSION}/${QT_COMPILER}/bin/windeployqt.exe")
QT_INSTALLER_FRAMEWORK_BIN="${QT_PATH}/Tools/QtInstallerFramework/3.0/bin/"
SEVEN_ZIP="/c/Program Files/7-Zip/7z.exe"
# ====================================================

QMAKE_FILE=$(readlink -m "${QT_PATH}/${QT_VERSION}/${QT_COMPILER}/bin/qmake")

# application specific variables =====================
APP_NAME="Resto"
APP_DESC="A small application for work time management"
APP_URL="http://just-code.org/applications/resto"
APP_CATEGORIES="Utility;Office;"
ORG_NAME="JustCode"
# ====================================================
