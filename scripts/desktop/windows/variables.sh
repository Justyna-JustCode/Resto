#!/bin/bash

SCRIPTS_DIR=$(dirname "$0")
COMMON_SCRIPTS_DIR="$(dirname "$0")/../common"
PROJECT_DIR=$(readlink -m "${SCRIPTS_DIR}/../../../")

# setup up this with your variables ==================
# QT:
WINDEPLOYQT_FILE=$(readlink -m "${QT_PATH}/${QT_VERSION}/${QT_COMPILER_PATH}/bin/windeployqt.exe")
QT_INSTALLER_FRAMEWORK_BIN="${QT_PATH}/Tools/QtInstallerFramework/${QT_IFW_VERSION}/bin/"
# ====================================================

QMAKE_FILE=$(readlink -m "/$QT_PATH/$QT_VERSION/$QT_COMPILER/bin/qmake")

# application specific variables =====================
ORG_NAME="JustCode"
ORG_URL="http://just-code.org"
APP_NAME="Resto"
APP_VERSION=$(grep -m 1 -r "APP_VERSION" ./appInfo.cmake | cut -c17-21)
APP_DESC="Resto is a simple application to control work time and breaks."
APP_URL="${ORG_URL}/applications/${APP_NAME,,}"
APP_CATEGORIES="Utility;Office;"
# ====================================================
