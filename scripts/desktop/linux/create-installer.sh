#!/bin/bash
set -e	# to exit the script if any subcommand fail

# help message and parameters =============================================

usage="$(basename "$0") [-h] buildDir outputFile -- create an installer for a given build

where:
    buildDir	a directory containing the executable
    outputFile	an output installer file

    -h	show this help text"

while getopts ':hi' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    *) echo "$usage"
       exit 1
       ;;
  esac
done
shift $(( OPTIND - 1 ))

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
OUTPUT_FILE=$(readlink -m "$2")

# ========================================================================

echo "Build directory: ${BUILD_DIR}"
echo "Creating an installer: ${OUTPUT_FILE}"

echo -e "================================================\n"

source ${SCRIPTS_DIR}/variables.sh

VersionInfo=($("${BUILD_DIR}/${APP_NAME}" -v))
APP_VERSION=${VersionInfo[1]}


PACKAGE_DIR="$(mktemp -d)/package"
echo "Creating a package for a build in:"
echo "${PACKAGE_DIR}"

source ${SCRIPTS_DIR}/create-package.sh ${BUILD_DIR} ${PACKAGE_DIR} > /dev/null
echo -e "------------------------------------------------\n"

INSTALLER_DATA_DIR="${PROJECT_DIR}/installers"

ConfigOutputFile="${INSTALLER_DATA_DIR}/config/config.xml"
echo "Creating an installer config file:"
echo ${ConfigOutputFile}
ConfigTemplateFile="${COMMON_SCRIPTS_DIR}/data/installer/config.xml"
export "APP_NAME=${APP_NAME}" "ORG_NAME=${ORG_NAME}" "APP_VERSION=${APP_VERSION}" "APP_URL=${APP_URL}"
envsubst < "${ConfigTemplateFile}" > "${ConfigOutputFile}"
echo -e "------------------------------------------------\n"


FileInfo=($(file "${BUILD_DIR}/${APP_NAME}"))
APP_BIT=${FileInfo[2]}
ControlOutputFile="${INSTALLER_DATA_DIR}/config/control.qs"
echo "Creating a control file:"
echo ${ControlOutputFile}
ControlTemplateFile="${COMMON_SCRIPTS_DIR}/data/installer/control.qs"
export "APP_BIT=${APP_BIT}"
envsubst < "${ControlTemplateFile}" > "${ControlOutputFile}"
echo -e "------------------------------------------------\n"


PACKAGE_NAME="org.$(echo ${ORG_NAME} | tr '[:upper:]' '[:lower:]').$(echo ${APP_NAME} | tr '[:upper:]' '[:lower:]')"


RELEASE_DATE=$(date +'%Y-%m-%d')
PackageOutputFile="${INSTALLER_DATA_DIR}/packages/${PACKAGE_NAME}/meta/package.xml"
echo "Creating an installer package file:"
echo ${PackageOutputFile}
PackageTemplateFile="${COMMON_SCRIPTS_DIR}/data/installer/package.xml"
export "APP_DESC=${APP_DESC}" "PACKAGE_NAME=${PACKAGE_NAME}" "RELEASE_DATE=${RELEASE_DATE}"
envsubst < "${PackageTemplateFile}" > "${PackageOutputFile}"
echo -e "------------------------------------------------\n"

DesktopEntryTemplateFile="${SCRIPTS_DIR}/data/entry.desktop"
export "APP_DESC=${APP_DESC}" "APP_CATEGORIES=${APP_CATEGORIES}" "DE_EXEC=@TargetDir@/AppRun" "DE_ICON=@TargetDir@/Resto.png"
DE_DATA=$(envsubst < "${DesktopEntryTemplateFile}" | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g')
export "DE_DATA=${DE_DATA}"

InstallscriptOutputFile="${INSTALLER_DATA_DIR}/packages/${PACKAGE_NAME}/meta/installscript.qs"
echo "Creating an installscript file:"
echo ${InstallscriptOutputFile}
InstallscriptTemplateFile="${COMMON_SCRIPTS_DIR}/data/installer/installscript.qs"
envsubst < "${InstallscriptTemplateFile}" > "${InstallscriptOutputFile}"
echo -e "================================================\n"


ArchiveDataFile="${INSTALLER_DATA_DIR}/packages/${PACKAGE_NAME}/data/data.7z"
echo "Creating a data archive:"
echo ${ArchiveDataFile}
${QT_INSTALLER_FRAMEWORK_BIN}/archivegen "${ArchiveDataFile}" "${PACKAGE_DIR}/*"
echo -e "------------------------------------------------\n"

mkdir -p $(dirname ${OUTPUT_FILE})

echo "Running a binary creator..."
${QT_INSTALLER_FRAMEWORK_BIN}/binarycreator -c "${INSTALLER_DATA_DIR}/config/config.xml" -p "${INSTALLER_DATA_DIR}/packages" "${OUTPUT_FILE}"
echo "Done."
