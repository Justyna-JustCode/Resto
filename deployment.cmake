# deploy help data
OPTION(DEPLOY_HELP "Build an application for production." ON)

if (DEPLOY_HELP)
    set(HTML2STANDALONE "monolith")
    add_custom_command(TARGET Resto POST_BUILD COMMAND ${HTML2STANDALONE} file:${CMAKE_SOURCE_DIR}/help/help.html -o ${CMAKE_BINARY_DIR}/help.html)
endif()
