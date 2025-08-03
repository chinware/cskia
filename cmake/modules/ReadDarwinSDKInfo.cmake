# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/03.

# Use `xcrun` to get MacOS SDK path and version. They are used for compiling CSKIA standard libraries.

execute_process(
    COMMAND xcrun --sdk macosx --show-sdk-path
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    RESULT_VARIABLE CSKIA_MACOSX_SDK_PATH_AVAILABLE
    OUTPUT_VARIABLE CSKIA_MACOSX_SDK_PATH
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)
if(${CSKIA_MACOSX_SDK_PATH_AVAILABLE} EQUAL 0)
    message(STATUS "CSKIA_MACOSX_SDK_PATH: ${CSKIA_MACOSX_SDK_PATH}")
else()
    message(STATUS "CSKIA_MACOSX_SDK_PATH: Not Available")
endif()

execute_process(
    COMMAND xcrun --sdk macosx --show-sdk-version
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    RESULT_VARIABLE CSKIA_MACOSX_SDK_VERSION_AVAILABLE
    OUTPUT_VARIABLE CSKIA_MACOSX_SDK_VERSION
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE)
if(${CSKIA_MACOSX_SDK_PATH_AVAILABLE} EQUAL 0)
    message(STATUS "CSKIA_MACOSX_SDK_VERSION: ${CSKIA_MACOSX_SDK_VERSION}")
else()
    message(STATUS "CSKIA_MACOSX_SDK_VERSION: Not Available")
endif()
