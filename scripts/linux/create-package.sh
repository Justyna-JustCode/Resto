#!/bin/bash
set -e	# to exit the script if any subcommand fail

# help message and parameters =============================================

usage="$(basename "$0") [-h -i] buildDir outputDir -- create an output package directory for a given build

where:
    buildDir	a directory containing the executable
    outputDir	an output directory for a package

    -h	show this help text
    -i	create an appImage instead of a simple directory"

APP_IMAGE=""
while getopts ':hi' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    i) APP_IMAGE="-appimage"
       ;;
    *) echo "$usage"
       exit 1
       ;;
  esac
done
shift $(( OPTIND - 1 ))
echo "$APPIMAGE"

# ========================================================================
# positional parameters ==================================================

SCRIPTS_DIR=$(dirname "$0")

if [[ $# -lt 1 ]]; then
	echo "You have to specify the input, build directory with an executable."
	exit
fi
if [[ $# -lt 2 ]]; then
	echo "You have to specify the output directory for a package."
	exit
fi

BUILD_DIR=$(readlink -m "$1")
OUTPUT_DIR=$(readlink -m "$2")

# ========================================================================

echo "Build directory: ${BUILD_DIR}"
if [ -z "$APP_IMAGE" ]; then
	echo "Creating a package in: ${OUTPUT_DIR}"
else
	echo "Creating an application image in: ${OUTPUT_DIR}"
fi

echo -e "================================================\n"

source ${SCRIPTS_DIR}/variables.sh

APP_NAME="Resto"
BUILD_PACKAGE_FILES="${APP_NAME} help.pdf"

echo "Copying build package files:"
for file in $BUILD_PACKAGE_FILES; do
	fileSubdir=$(dirname $file)
	filePath=$BUILD_DIR/$file
	echo -e "\t$filePath"
	mkdir -p "$OUTPUT_DIR/usr/bin/$fileSubdir"
	cp -f "$filePath" "$OUTPUT_DIR/usr/bin/$fileSubdir/"
done
echo -e "------------------------------------------------\n"

DesktopEntry="[Desktop Entry]
Type=Application
Name=${APP_NAME}
Comment=A small application for work time management
Exec=${APP_NAME}
Icon=${APP_NAME}
Categories=Utility;Office;"
DesktopEntryFile="${OUTPUT_DIR}/usr/share/applications/${APP_NAME}.desktop"

echo "Creating a desktop entry:"
echo ${DesktopEntryFile}
mkdir -p "$(dirname ${DesktopEntryFile})"
echo -e "${DesktopEntry}" > "${DesktopEntryFile}"
echo -e "------------------------------------------------\n"

IconSourceFile="${PROJECT_DIR}/resources/images/app-logo.png"
IconSize=128
IconOutputFile="${OUTPUT_DIR}/usr/share/icons/hicolor/${IconSize}x${IconSize}/apps/${APP_NAME}.png"

echo "Copying an icon file:"
echo "${IconSourceFile} > ${IconOutputFile}"
mkdir -p "$(dirname ${IconOutputFile})"
cp -f "${IconSourceFile}" "${IconOutputFile}"
echo -e "------------------------------------------------\n"

echo "Running linuxdeployqt tool:"
echo "using qmake: $QMAKE_FILE"
$LINUXDEPLOYQT_FILE ${OUTPUT_DIR}/usr/share/applications/${APP_NAME}.desktop -qmake=$QMAKE_FILE ${APP_IMAGE} -bundle-non-qt-libs -qmldir=${PROJECT_DIR}/qml
echo -e "------------------------------------------------\n"


if [ -z "$APP_IMAGE" ]; then
	AppRunSourceFile="${SCRIPTS_DIR}/AppRun"
	AppRunOutputFile="${OUTPUT_DIR}/AppRun"
	DesktopEntryRunExec='bash -c '"'"'$(dirname %k)/AppRun'"'"''
	DesktopEntryRun="[Desktop Entry]
	Type=Application
	Name=${APP_NAME}
	Comment=A small application for work time management
	Exec=${DesktopEntryRunExec}
	Icon=${APP_NAME}
	Categories=Utility;Office;"
	DesktopEntryRunFile="${OUTPUT_DIR}/${APP_NAME}.desktop"

	echo "Adjusting application runners:"
	echo ${AppRunOutputFile}
	rm "${AppRunOutputFile}"
	cp -f "${AppRunSourceFile}" "${AppRunOutputFile}"
	chmod +x "${AppRunOutputFile}"

	echo ${DesktopEntryRunFile}
	rm ${DesktopEntryRunFile}
	echo -e "${DesktopEntryRun}" > "${DesktopEntryRunFile}"
	chmod +x "${DesktopEntryRunFile}"
	echo -e "------------------------------------------------\n"
fi
echo "DONE."

