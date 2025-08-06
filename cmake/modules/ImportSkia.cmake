# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/03.

set(CSKIA_SKIA_SOURCE_DIR "${CSKIA_THIRDPARTY_DIR}/skia")
set(CSKIA_SKIA_BIN_DIR "${CSKIA_SKIA_SOURCE_DIR}/bin")
set(CSKIA_SKIA_GN_EXECUTABLE "${CSKIA_SKIA_SOURCE_DIR}/bin/gn")
set(CSKIA_SKIA_BUILD_DIR "${CSKIA_BINARY_DIR}/skia-build")
set(CSKIA_SKIA_INSTALL_DIR "${CSKIA_BINARY_DIR}/skia-install")
set(CSKIA_SKIA_EXTERNALS_DIR "${CSKIA_SKIA_SOURCE_DIR}/third_party/externals")

function(cskia_fetch_gn)
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
endfunction()

function(cskia_sync_deps)
    execute_process(
        COMMAND ${Python3_EXECUTABLE} tools/git-sync-deps
        WORKING_DIRECTORY ${CSKIA_SKIA_SOURCE_DIR}
        RESULT_VARIABLE CSKIA_SYNC_DEPS_RESULT
        TIMEOUT 600
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    if(${CSKIA_SYNC_DEPS_RESULT} EQUAL 0)
        message(STATUS "Execute git-sync-deps successfully")
    else()
        message(STATUS "Execute git-sync-deps failed")
    endif()
endfunction()

macro(cskia_inport_skia)

endmacro()
