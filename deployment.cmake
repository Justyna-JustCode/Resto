# deploy help data
add_custom_command(TARGET Resto POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/help/helpResources ${CMAKE_BINARY_DIR}/helpResources
)
add_custom_command(TARGET Resto POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/help/* ${CMAKE_BINARY_DIR}
)
