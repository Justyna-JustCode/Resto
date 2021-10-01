# deploy help data
help_data.commands = $$QMAKE_COPY $$shell_path($$PWD/help/help.html) $$shell_path($$OUT_PWD/)
QMAKE_EXTRA_TARGETS += help_data
PRE_TARGETDEPS += help_data
