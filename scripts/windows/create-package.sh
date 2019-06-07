#!/bin/bash
set -e	# to exit the script if any subcommand fail

# help message and parameters =============================================

usage="$(basename "$0") [-h -z] buildDir outputDir -- create an output package directory for a given build

where:
    buildDir	a directory containing the executable
    outputDir	an output directory for a package

    -h	show this help text
    -z	create a zipped folder instead of a simple directory"

ZIPPED=false
while getopts ':hz' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    z) ZIPPED=true
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
OUTPUT_DIR=$(readlink -m "$2")

if [ "${ZIPPED}" = false ]; then
	if [[ -e ${OUTPUT_DIR} ]]; then
		echo "Output directory already exist."
		exit
	fi
else
	mkdir -p "${OUTPUT_DIR}"
fi
# ========================================================================

source ${SCRIPTS_DIR}/variables.sh

TEMP_DIR="$(mktemp -d)"
if [ "${ZIPPED}" = false ]; then
	TEMP_PACKAGE_DIR="${TEMP_DIR}/package/"
else
	TEMP_PACKAGE_DIR="${TEMP_DIR}/package/${APP_NAME}/"
fi

RUN_DIR=${PWD}

echo "Build directory: ${BUILD_DIR}"
if [ "${ZIPPED}" = false ]; then
	echo "Creating a package in: ${OUTPUT_DIR}"
else
	echo "Creating a zipped package in: ${OUTPUT_DIR}"
fi

echo "Temporary directory: ${TEMP_DIR}"
echo -e "================================================\n"

BUILD_PACKAGE_FILES="${APP_NAME}.exe help.pdf"
echo "Copying build package files:"
for file in $BUILD_PACKAGE_FILES; do
	fileSubdir=$(dirname $file)
	filePath=$BUILD_DIR/$file
	echo -e "\t$filePath"
	mkdir -p "${TEMP_PACKAGE_DIR}/$fileSubdir"
	cp -f "$filePath" "$TEMP_PACKAGE_DIR/$fileSubdir/"
done
echo -e "------------------------------------------------\n"

echo "Running a windeployqt tool:"
echo "using qmake: $QMAKE_FILE"
(cd ${TEMP_DIR} && $WINDEPLOYQT_FILE -qmldir=${PROJECT_DIR}/qml ${TEMP_PACKAGE_DIR}/)
echo -e "------------------------------------------------\n"

if [ "${ZIPPED}" = false ]; then
	mv "${TEMP_PACKAGE_DIR}" "${OUTPUT_DIR}"
else
	(cd "${TEMP_PACKAGE_DIR}/.." && "${SEVEN_ZIP}" a -tzip "${OUTPUT_DIR}/${APP_NAME}.zip" "*")
fi

echo "DONE."

