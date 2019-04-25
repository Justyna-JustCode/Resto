#!/bin/bash

SCRIPTS_DIR=$(dirname "$0")
PROJECT_DIR=$(readlink -m "${SCRIPTS_DIR}/../../")

# setup up this with your variables ==================
# QT:
QT_PATH="/home/tester/Qt/"
QT_VERSION="5.12.1"
QT_COMPILER="gcc_64"
LINUXDEPLOYQT_FILE="${QT_PATH}/Tools/linuxdeployqt.AppImage"
QT_INSTALLER_FRAMEWORK_BIN="${QT_PATH}/Tools/QtInstallerFramework/3.0/bin/"
# ====================================================

QMAKE_FILE=$(readlink -m "/$QT_PATH/$QT_VERSION/$QT_COMPILER/bin/qmake")

# application specific variables =====================
ORG_NAME="JustCode"
ORG_URL="http://just-code.org"
APP_NAME="Resto"
APP_DESC="A small application for work time management"
APP_URL="${ORG_URL}/applications/${APP_NAME,,}"
APP_CATEGORIES="Utility;Office;"
# ====================================================
