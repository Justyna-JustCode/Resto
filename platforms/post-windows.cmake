set_target_properties(Resto PROPERTIES
    WIN32_EXECUTABLE TRUE
)

set_target_properties(Resto PROPERTIES
                        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<0:>
                        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<0:>
                        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<0:>)
