# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/03.

find_package(Git REQUIRED)
find_package(Python3 REQUIRED)

if(NOT EXISTS "${CSKIA_SKIA_GN_EXECUTABLE}")
    execute_process(
        COMMAND ${Python3_EXECUTABLE} fetch-gn
        WORKING_DIRECTORY ${CSKIA_SKIA_BIN_DIR}
        RESULT_VARIABLE CSKIA_FETCH_GN_AVAILABLE
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(${CSKIA_FETCH_GN_AVAILABLE} EQUAL 0)
        message(STATUS "Fetch GN successfully")
    else()
        message(STATUS "Fetch GN failed")
    endif()
endif()

