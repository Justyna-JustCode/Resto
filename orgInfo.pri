# application info
ORG_NAME = "JustCode"
ORG_DOMAIN = "just-code.org"

# add defines
DEFINES += ORG_NAME='"\\\"$$ORG_NAME\\\""'
DEFINES += ORG_DOMAIN=\\\"$$ORG_DOMAIN\\\"

# set qmake variables
QMAKE_TARGET_COMPANY = $$ORG_NAME
QMAKE_TARGET_COPYRIGHT = $$ORG_NAME
