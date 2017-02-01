# application info
APP_NAME = "Resto"
APP_DESCRIPTION = "A small application for work time management"
APP_VERSION = 1.0.4
APP_VERSION_URL = "$$ORG_DOMAIN/applications/$$APP_NAME/version"

# add defines
DEFINES += APP_NAME='"\\\"$$APP_NAME\\\""'
DEFINES += APP_DESCRIPTION='"\\\"$$APP_DESCRIPTION\\\""'
DEFINES += APP_VERSION='"\\\"$$APP_VERSION\\\""'
DEFINES += APP_VERSION_URL='"\\\"$$APP_VERSION_URL\\\""'

# set qmake variables
VERSION = $$APP_VERSION
QMAKE_TARGET_PRODUCT = $$APP_NAME
QMAKE_TARGET_DESCRIPTION = $$APP_DESCRIPTION
