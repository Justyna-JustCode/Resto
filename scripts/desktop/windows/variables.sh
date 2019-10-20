#!/bin/bash

SCRIPTS_DIR=$(dirname "$0")
COMMON_SCRIPTS_DIR="$(dirname "$0")/../common"
PROJECT_DIR=$(readlink -m "${SCRIPTS_DIR}/../../../")

# setup up this with your variables ==================
# QT:
QT_PATH="/c/Qt/"
QT_VERSION="5.12.5"
QT_COMPILER="msvc2017_64"
WINDEPLOYQT_FILE=$(readlink -m "${QT_PATH}/${QT_VERSION}/${QT_COMPILER}/bin/windeployqt.exe")
QT_INSTALLER_FRAMEWORK_BIN="${QT_PATH}/Tools/QtInstallerFramework/3.1/bin/"

VC_REDIST_DIR="/c/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.16.27012/x64/Microsoft.VC141.CRT/"
VC_REDIST_NUM="140"
VC_REDIST_API_DIR="/c/Program Files (x86)/Windows Kits/10/Redist/ucrt/DLLs/x64/"
SEVEN_ZIP="/c/Program Files/7-Zip/7z.exe"
# ====================================================

QMAKE_FILE=$(readlink -m "${QT_PATH}/${QT_VERSION}/${QT_COMPILER}/bin/qmake")

# application specific variables =====================
ORG_NAME="JustCode"
ORG_URL="http://just-code.org"
APP_NAME="Resto"
APP_DESC="A small application for work time management"
APP_URL="${ORG_URL}/applications/${APP_NAME,,}"
APP_CATEGORIES="Utility;Office;"
# ====================================================
