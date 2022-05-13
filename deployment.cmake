# deploy help data
add_custom_command(TARGET Resto POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/help.pdf ${CMAKE_BINARY_DIR}
)
