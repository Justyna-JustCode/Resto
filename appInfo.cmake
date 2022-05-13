# application info
set(APP_NAME "Resto")
set(APP_DESCRIPTION "A small application for work time management")

set(APP_VERSION 1.0.6)
execute_process(COMMAND git --git-dir ${CMAKE_SOURCE_DIR}/.git --work-tree ${CMAKE_SOURCE_DIR} log --pretty=format:%h -n 1
                OUTPUT_VARIABLE BUILD_NUMBER
                ERROR_QUIET)

if (DELIVERY_BUILD)
  set(APP_VERSION_URL "${ORG_DOMAIN}/applications/${APP_NAME}/version")
  set(DEVELOP_BUILD false)
else()
  set(APP_VERSION_URL "${ORG_DOMAIN}/applications/${APP_NAME}/version_develop")
  set(DEVELOP_BUILD true)
endif()

# add defines
add_compile_definitions(APP_NAME=\"${APP_NAME}\")
add_compile_definitions(APP_DESCRIPTION=\"${APP_DESCRIPTION}\")
add_compile_definitions(APP_VERSION=\"${APP_VERSION}\")
add_compile_definitions(APP_VERSION_URL=\"${APP_VERSION_URL}\")
add_compile_definitions(BUILD_NUMBER=\"${BUILD_NUMBER}\")
add_compile_definitions(DEVELOP_BUILD=\"${DEVELOP_BUILD}\")
