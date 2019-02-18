# deploy help data
help_data.commands = $$QMAKE_COPY $$PWD/help.pdf $$OUT_PWD/
QMAKE_EXTRA_TARGETS += help_data
PRE_TARGETDEPS += help_data
