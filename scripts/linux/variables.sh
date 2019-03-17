#!/bin/bash

SCRIPTS_DIR=$(dirname "$0")
PROJECT_DIR=$(readlink -m "${SCRIPTS_DIR}/../../")

# setup up this with your variables ==================
# QT:
QT_PATH="/home/tester/Qt/"
QT_VERSION="5.12.1"
QT_COMPILER="gcc_64"
LINUXDEPLOYQT_FILE="/home/tester/Qt/Tools/linuxdeployqt-6-x86_64.AppImage"
# ====================================================

QMAKE_FILE=$(readlink -m "/$QT_PATH/$QT_VERSION/$QT_COMPILER/bin/qmake")
