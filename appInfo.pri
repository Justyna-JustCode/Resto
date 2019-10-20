# application info
APP_NAME = "Resto"
APP_DESCRIPTION = "A small application for work time management"

APP_VERSION = 1.0.6
BUILD_NUMBER = $$system(git --git-dir $$PWD/.git --work-tree $$PWD log --pretty=format:'%h' -n 1)

delivery {
    APP_VERSION_URL = "$${ORG_DOMAIN}/applications/$${APP_NAME}/version"
    DEVELOP_BUILD = false
} else {
    APP_VERSION_URL = "$${ORG_DOMAIN}/applications/$${APP_NAME}/version_develop"
    DEVELOP_BUILD = true
}

# add defines
DEFINES += APP_NAME='"\\\"$$APP_NAME\\\""'
DEFINES += APP_DESCRIPTION='"\\\"$$APP_DESCRIPTION\\\""'
DEFINES += APP_VERSION='"\\\"$$APP_VERSION\\\""'
DEFINES += APP_VERSION_URL='"\\\"$$APP_VERSION_URL\\\""'
DEFINES += BUILD_NUMBER='"\\\"$$BUILD_NUMBER\\\""'
DEFINES += DEVELOP_BUILD='"\\\"$$DEVELOP_BUILD\\\""'

# set qmake variables
VERSION = $$APP_VERSION
QMAKE_TARGET_PRODUCT = $$APP_NAME
QMAKE_TARGET_DESCRIPTION = $$APP_DESCRIPTION
