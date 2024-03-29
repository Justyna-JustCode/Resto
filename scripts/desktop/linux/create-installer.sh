#!/bin/bash
set -e	# to exit the script if any subcommand fail

usage="$(basename "$0") [-h -o -r repositoryDir] buildDir outputFile -- create an installer for a given build

where:
    buildDir	a directory containing the executable
    outputFile	an output installer file

    -h			show this help text
    -o			creates an offline-only installer
    -r repositoryDir 	creates also an online repository in a given directory"

SCRIPTS_DIR=$(dirname "$0")

# ========================================================================
# positional parameters ==================================================

REPO_DIR=""
OFFLINE_ONLY=""

while getopts ':hor:' option; do
  case "$option" in
    r) REPO_DIR=${OPTARG}
       ;;
    o) OFFLINE_ONLY="--offline-only"
       ;;
    h) echo "$usage" >&2
       exit
       ;;
    *) echo "Invlid option: -${OPTARG}" >&2
       echo "$usage" >&2
       exit 1
       ;;
    :) echo "Option -${OPTARG} requires an argument." >&2
       exit 1
       ;;
  esac
done
shift $(( OPTIND - 1 ))

if [ ! -z "${REPO_DIR}" ] && [ -e "${REPO_DIR}" ]; then
	echo "A repository directory already exists." >&2
	exit 1
fi

if [[ $# -lt 1 ]]; then
	echo "You have to specify the input, build directory with an executable." >&2
	exit 1
fi
if [[ $# -lt 2 ]]; then
	echo "You have to specify the installer output file." >&2
	exit 1
fi
if [[ $# -gt 2 ]]; then
	echo "Too many arguments." >&2
	echo "$usage" >&2
	exit 1
fi

BUILD_DIR=$(readlink -m "$1")
OUTPUT_FILE=$(readlink -m "$2")

# ========================================================================

echo "Build directory: ${BUILD_DIR}"
if [ -z "${OFFLINE_ONLY}" ]; then
	echo "Creating the installer: ${OUTPUT_FILE}"
else
	echo "Creating the offline-only installer: ${OUTPUT_FILE}"
fi

if [ ! -z "${REPO_DIR}" ]; then
    echo "Creating the online repository in: ${REPO_DIR}"
fi

echo -e "================================================\n"

source ${SCRIPTS_DIR}/variables.sh

APP_DEVELOP=""
if [ -z "${PRODUCTION_BUILD}" ] || [ ${PRODUCTION_BUILD} != true ]; then
	APP_DEVELOP="_develop"
fi

PACKAGE_DIR="$(mktemp -d)/package"
echo "Creating a package for a build in:"
echo "${PACKAGE_DIR}"

${SCRIPTS_DIR}/create-package.sh "${BUILD_DIR}" "${PACKAGE_DIR}" > /dev/null
echo -e "------------------------------------------------\n"

INSTALLER_DATA_DIR="${PROJECT_DIR}/installers"

ConfigOutputFile="${INSTALLER_DATA_DIR}/config/config.xml"
echo "Creating an installer config file:"
echo ${ConfigOutputFile}
ConfigTemplateFile="${SCRIPTS_DIR}/data/installer/config.xml"
export "APP_NAME=${APP_NAME}" "ORG_NAME=${ORG_NAME}" "APP_VERSION=${APP_VERSION}" "APP_URL=${APP_URL}" "ORG_URL=${ORG_URL}" "APP_NAME_LOWER=${APP_NAME,,}" "APP_DEVELOP=${APP_DEVELOP}"
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
# reading a template file, without the first line, changing new lines into '\\n' sign
DesktopEntryData=$(envsubst < "${DesktopEntryTemplateFile}" | tail -n +2 | sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g')
DE_DATA=${DesktopEntryData}
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
rm -f "${ArchiveDataFile}"
mkdir -p $( dirname -- "${ArchiveDataFile}")
${QT_INSTALLER_FRAMEWORK_BIN}/archivegen "${ArchiveDataFile}" "${PACKAGE_DIR}/*"
echo -e "------------------------------------------------\n"

echo "Running a binary creator..."
mkdir -p $(dirname ${OUTPUT_FILE})
${QT_INSTALLER_FRAMEWORK_BIN}/binarycreator ${OFFLINE_ONLY} -c "${INSTALLER_DATA_DIR}/config/config.xml" -p "${INSTALLER_DATA_DIR}/packages" "${OUTPUT_FILE}"

if [ ! -z "${REPO_DIR}" ]; then
    echo "Creating the online repository..."
    mkdir -p "${REPO_DIR}"
    ${QT_INSTALLER_FRAMEWORK_BIN}/repogen -p "${INSTALLER_DATA_DIR}/packages" "${REPO_DIR}"
fi
echo "Done."
