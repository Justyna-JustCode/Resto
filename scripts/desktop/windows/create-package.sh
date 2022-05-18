#!/bin/bash
set -e	# to exit the script if any subcommand fail

usage="$(basename "$0") [-h -z] buildDir outputDir -- create an output package directory for a given build

where:
    buildDir	a directory containing the executable
    outputDir	an output directory for a package

    -h	show this help text
    -z	create a zipped folder instead of a simple directory"

SCRIPTS_DIR=$(dirname "$0")

# ========================================================================
# positional parameters ==================================================

ZIPPED=false
while getopts ':hz' option; do
  case "$option" in
    h) echo "$usage" >&2
       exit
       ;;
    z) ZIPPED=true
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

if [ "${ZIPPED}" = false ]; then
	if [[ -e ${OUTPUT_DIR} ]]; then
		echo "Output directory already exist." >&2
		exit 1
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
(cd ${TEMP_DIR} && $WINDEPLOYQT_FILE --no-compiler-runtime --qmldir=${PROJECT_DIR}/qml ${TEMP_PACKAGE_DIR}/)
echo -e "------------------------------------------------\n"

VC_REDIST_FILES="msvcp${VC_REDIST_NUM}.dll vcruntime${VC_REDIST_NUM}.dll msvcp${VC_REDIST_NUM}_1.dll vcruntime${VC_REDIST_NUM}_1.dll"
echo "Copying VC redist files:"
for file in $VC_REDIST_FILES; do
	filePath="${VC_REDIST_DIR}/$file"
	echo -e "\t$filePath"
	cp -f "$filePath" "${TEMP_PACKAGE_DIR}/"
done
echo -e "------------------------------------------------\n"

if [ "${ZIPPED}" = false ]; then
	mv "${TEMP_PACKAGE_DIR}" "${OUTPUT_DIR}"
else
	(cd "${TEMP_PACKAGE_DIR}/.." && 7z a -tzip "${OUTPUT_DIR}/${APP_NAME}.zip" "*")
fi

echo "DONE."

