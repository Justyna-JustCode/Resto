#!/bin/bash
set -e	# to exit the script if any subcommand fail

usage="$(basename "$0") buildDir outputDir -- create a full delivery data for a given build

where:
    buildDir	a directory containing the executable
    outputFile	an output data directory"

SCRIPTS_DIR=$(dirname "$0")

# ========================================================================
# positional parameters ==================================================

if [[ $# -lt 1 ]]; then
	echo "You have to specify the input, build directory with an executable." >&2
	exit 1
fi
if [[ $# -lt 2 ]]; then
	echo "You have to specify an output directory." >&2
	exit 1
fi
if [[ $# -gt 2 ]]; then
	echo "Too many arguments." >&2
	echo "$usage" >&2
	exit 1
fi

BUILD_DIR=$(readlink -m "$1")
OUTPUT_DIR=$(readlink -m "$2")

source ${SCRIPTS_DIR}/variables.sh

VersionInfo=($("${BUILD_DIR}/${APP_NAME}" -v))
APP_VERSION=${VersionInfo[1]}

${SCRIPTS_DIR}/create-package.sh -i "${BUILD_DIR}" "${OUTPUT_DIR}"
${SCRIPTS_DIR}/create-installer.sh -o "${BUILD_DIR}" "${OUTPUT_DIR}/${APP_NAME}_${APP_VERSION}_offline-installer"
${SCRIPTS_DIR}/create-installer.sh -r "${OUTPUT_DIR}/${APP_NAME}_${APP_VERSION}_repository" "${BUILD_DIR}" "${OUTPUT_DIR}/${APP_NAME}_${APP_VERSION}_installer"
