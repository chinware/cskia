
if(NOT TRIPLE)
    string(TOLOWER "${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}-gnu" TRIPLE)
endif()

if(MINGW)
    set(TRIPLE x86_64-w64-mingw32)
endif()

if(CMAKE_CROSSCOMPILING)
    message(STATUS "CROSS COMPILING libs from ${CMAKE_HOST_SYSTEM_PROCESSOR}-${CMAKE_HOST_SYSTEM_NAME} to ${TRIPLE}")
endif()

message(STATUS "Building with target=${TRIPLE}")
