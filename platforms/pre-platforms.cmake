if (UNIX)
  include(platforms/pre-linux.cmake)
elseif(WIN32)
  include(platforms/pre-windows.cmake)
endif()