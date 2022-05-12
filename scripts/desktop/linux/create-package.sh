#!/bin/bash
set -e	# to exit the script if any subcommand fail

usage="$(basename "$0") [-h -i] buildDir outputDir -- create an output package directory for a given build

where:
    buildDir	a directory containing the executable
    outputDir	an output directory for a package

    -h	show this help text
    -i	creates an appImage instead of a simple directory"

SCRIPTS_DIR=$(dirname "$0")

# ========================================================================
# positional parameters ==================================================

APP_IMAGE=""

while getopts ':hi' option; do
  case "$option" in
    i) APP_IMAGE="-appimage"
       ;;
    h) echo "$usage" >&2
       exit
       ;;
    *) echo "Invalid option: -${OPTARG}" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $(( OPTIND - 1 ))

if [[ $# -lt 1 ]]; then
	echo "You have to specify the input, build directory with an executable." >&2
	exit 1
fi
if [[ $# -lt 2 ]]; then
	echo "You have to specify an output directory for the package." >&2
	exit 1
fi
if [[ $# -gt 2 ]]; then
	echo "Too many arguments." >&2
	echo "$usage" >&2
	exit 1
fi

BUILD_DIR=$(readlink -m "$1")
OUTPUT_DIR=$(readlink -m "$2")

if [ -z "$APP_IMAGE" ]; then
	if [[ -e ${OUTPUT_DIR} ]]; then
		echo "Output directory already exist." >&2
		exit 1
	fi
else
	mkdir -p "${OUTPUT_DIR}"
fi

TEMP_DIR="$(mktemp -d)"
TEMP_PACKAGE_DIR="${TEMP_DIR}/package"

RUN_DIR=${PWD}

# ========================================================================

echo "Build directory: ${BUILD_DIR}"
if [ -z "$APP_IMAGE" ]; then
	echo "Creating a package in: ${OUTPUT_DIR}"
else
	echo "Creating an application image in: ${OUTPUT_DIR}"
fi

echo "Temporary directory: ${TEMP_DIR}"
echo -e "================================================\n"

source ${SCRIPTS_DIR}/variables.sh

BUILD_PACKAGE_FILES="${APP_NAME} help.html"
echo "Copying build package files:"
for file in $BUILD_PACKAGE_FILES; do
	fileSubdir=$(dirname $file)
	filePath=$BUILD_DIR/$file
	echo -e "\t$filePath"
	mkdir -p "${TEMP_PACKAGE_DIR}/usr/bin/$fileSubdir"
	cp -f "$filePath" "$TEMP_PACKAGE_DIR/usr/bin/$fileSubdir/"
done

echo -e "\n"
USER_PACKAGE_FILES="help.html"
echo "Copying user package files:"
for file in $USER_PACKAGE_FILES; do
	filePath=$BUILD_DIR/$file
	echo -e "\t$filePath"
	mkdir -p "${TEMP_PACKAGE_DIR}/"
	cp -f "$filePath" "$TEMP_PACKAGE_DIR/"
done
echo -e "------------------------------------------------\n"

DesktopEntryTemplateFile="${SCRIPTS_DIR}/data/entry.desktop"
DesktopEntryOutputFile="${TEMP_PACKAGE_DIR}/usr/share/applications/${APP_NAME}.desktop"

echo "Creating a desktop entry:"
echo ${DesktopEntryOutputFile}
mkdir -p "$(dirname ${DesktopEntryOutputFile})"
export "APP_NAME=${APP_NAME}" "APP_VERSION=${APP_VERSION}" "APP_DESC=${APP_DESC}" "APP_CATEGORIES=${APP_CATEGORIES}" "DE_EXEC=${APP_NAME}" "DE_ICON=${APP_NAME}"
envsubst < "${DesktopEntryTemplateFile}" > "${DesktopEntryOutputFile}"
echo -e "------------------------------------------------\n"

IconSourceFile="${PROJECT_DIR}/resources/images/app-logo.png"
IconSize=128
IconOutputFile="${TEMP_PACKAGE_DIR}/usr/share/icons/hicolor/${IconSize}x${IconSize}/apps/${APP_NAME}.png"

echo "Copying an icon file:"
echo "${IconSourceFile} > ${IconOutputFile}"
mkdir -p "$(dirname ${IconOutputFile})"
cp -f "${IconSourceFile}" "${IconOutputFile}"
echo -e "------------------------------------------------\n"

echo "Running linuxdeployqt tool:"
echo "using qmake: $QMAKE_FILE"
# workaround for -unsupported-allow-new-glibc option
mkdir -p ${TEMP_PACKAGE_DIR}/usr/share/doc/libc6/
touch ${TEMP_PACKAGE_DIR}/usr/share/doc/libc6/copyright
(cd ${TEMP_DIR} && $LINUXDEPLOYQT_FILE ${TEMP_PACKAGE_DIR}/usr/share/applications/${APP_NAME}.desktop -qmake=$QMAKE_FILE ${APP_IMAGE} -bundle-non-qt-libs -qmldir=${PROJECT_DIR}/qml -unsupported-allow-new-glibc)
echo -e "------------------------------------------------\n"


if [ -z "$APP_IMAGE" ]; then
	AppRunSourceFile="${SCRIPTS_DIR}/data/AppRun"
	AppRunOutputFile="${TEMP_PACKAGE_DIR}/AppRun"
	DesktopEntryRunExec='bash -c '"'"'$(dirname %k)/AppRun'"'"''
	DesktopEntryRunFile="${TEMP_PACKAGE_DIR}/${APP_NAME}.desktop"

	echo "Adjusting application runners:"
	echo ${AppRunOutputFile}
	rm "${AppRunOutputFile}"
	cp -f "${AppRunSourceFile}" "${AppRunOutputFile}"
	chmod +x "${AppRunOutputFile}"

	echo ${DesktopEntryRunFile}
	rm ${DesktopEntryRunFile}
	echo -e "${DesktopEntryRun}" > "${DesktopEntryRunFile}"
	export "DE_EXEC=${DesktopEntryRunExec}"
	envsubst < "${DesktopEntryTemplateFile}" > "${DesktopEntryRunFile}"
	chmod +x "${DesktopEntryRunFile}"
	echo -e "------------------------------------------------\n"
fi

if [ -z "$APP_IMAGE" ]; then
	mv "${TEMP_PACKAGE_DIR}" "${OUTPUT_DIR}"
else
	mv "${TEMP_DIR}"/${APP_NAME}*.AppImage "${OUTPUT_DIR}/${APP_NAME}.AppImage"
fi

echo "DONE."

