# application info
APP_NAME = "Resto"
APP_DESCRIPTION = "A small application for work time management"

APP_DELIVERY_VERSION = 1.0.6
BUILD_NUMBER = $$system(git --git-dir $$PWD/.git --work-tree $$PWD log --pretty=format:'%h' -n 1)
delivery {
    APP_VERSION = $${APP_DELIVERY_VERSION}
} else {
    APP_VERSION = $${APP_DELIVERY_VERSION}.$${BUILD_NUMBER}
}

delivery {
    APP_VERSION_URL = "$${ORG_DOMAIN}/applications/$${APP_NAME}/version"
} else {
    APP_VERSION_URL = "$${ORG_DOMAIN}/applications/$${APP_NAME}/version_develop"
}

# add defines
DEFINES += APP_NAME='"\\\"$$APP_NAME\\\""'
DEFINES += APP_DESCRIPTION='"\\\"$$APP_DESCRIPTION\\\""'
DEFINES += APP_VERSION_URL='"\\\"$$APP_VERSION_URL\\\""'

DEFINES += APP_DELIVERY_VERSION='"\\\"$$APP_DELIVERY_VERSION\\\""'
DEFINES += APP_VERSION='"\\\"$$APP_VERSION\\\""'

# set qmake variables
VERSION = $$APP_DELIVERY_VERSION
QMAKE_TARGET_PRODUCT = $$APP_NAME
QMAKE_TARGET_DESCRIPTION = $$APP_DESCRIPTION
