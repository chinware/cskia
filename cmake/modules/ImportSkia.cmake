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

macro(cskia_import_skia)
    if(NOT CSKIA_SKIA_BUILD)
        set(CSKIA_GN_ARGS "is_official_build=true")
    else()
        set(CSKIA_GN_ARGS "is_official_build=false")
    endif()

    if(CSKIA_SKIA_BUILD)
        list(APPEND CSKIA_GN_ARGS "is_debug=true")
    else()
        list(APPEND CSKIA_GN_ARGS "is_debug=false")
    endif()

    if(CSKIA_ENABLE_SVG)
        list(APPEND CSKIA_GN_ARGS "skia_enable_svg=true")
    else()
        list(APPEND CSKIA_GN_ARGS "skia_enable_svg=false")
    endif()

    if(CSKIA_ENABLE_PDF)
        list(APPEND CSKIA_GN_ARGS "skia_enable_pdf=true")
    else()
        list(APPEND CSKIA_GN_ARGS "skia_enable_pdf=false")
    endif()

    list(APPEND CSKIA_GN_ARGS "skia_enable_skottie=true")
    list(APPEND CSKIA_GN_ARGS "skia_use_xps=false")
    list(APPEND CSKIA_GN_ARGS "skia_use_dng_sdk=false")

    if(CSKIA_USE_GL OR CSKIA_USE_VULKAN OR CSKIA_USE_METAL OR CSKIA_USE_DIRECT3D)
        list(APPEND CSKIA_GN_ARGS "skia_enable_gpu=true")
    else()
        list(APPEND CSKIA_GN_ARGS "skia_enable_gpu=false")
    endif()

    if(CSKIA_USE_GL)
        list(APPEND CSKIA_GN_ARGS "skia_use_gl=true")
    else()
        list(APPEND CSKIA_GN_ARGS "skia_use_gl=false")
    endif()

    if(CSKIA_USE_EGL)
        list(APPEND CSKIA_GN_ARGS "skia_use_egl=true")
    else()
        list(APPEND CSKIA_GN_ARGS "skia_use_egl=false")
    endif()

    if(CSKIA_USE_X11)
        list(APPEND CSKIA_GN_ARGS "skia_use_x11=true")
    else()
        list(APPEND CSKIA_GN_ARGS "skia_use_x11=false")
    endif()

    if(CSKIA_SKIA_USE_SYSTEM_LIBRARIES)
        list(APPEND CSKIA_GN_ARGS "skia_use_system_libpng=true")
        list(APPEND CSKIA_GN_ARGS "skia_use_system_zlib=true")
    else()
        list(APPEND CSKIA_GN_ARGS "skia_use_system_libpng=false")
        list(APPEND CSKIA_GN_ARGS "skia_use_system_zlib=false")
    endif()

    if(CSKIA_ENABLE_WEBP_ENCODE)
        list(APPEND CSKIA_GN_ARGS "skia_use_libwebp_encode=true")
    else()
        list(APPEND CSKIA_GN_ARGS "skia_use_libwebp_encode=false")
    endif()

    if(CSKIA_ENABLE_WEBP_DECODE)
        list(APPEND CSKIA_GN_ARGS "skia_use_libwebp_decode=true")
    else()
        list(APPEND CSKIA_GN_ARGS "skia_use_libwebp_decode=false")
    endif()

    if(CSKIA_USE_VULKAN)
        list(APPEND CSKIA_GN_ARGS "skia_use_vulkan=true")
        list(APPEND CSKIA_GN_ARGS "skia_enable_spirv_validation=false")
    endif()

    set(CSKIA_GN_ARGS ${CSKIA_GN_ARGS} PARENT_SCOPE)

    string(REPLACE ";" " " CSKIA_GN_ARGS_STR "${CSKIA_GN_ARGS}")
endmacro()

macro(cskia_print_gn_arg name value)
    string(LENGTH "${name}" name_length)
    math(EXPR padding_length "40 - ${name_length}")
    string(REPEAT "." ${padding_length} padding)
    message(STATUS "${name} ${padding} ${value}")
endmacro()

macro(cskia_gn_summary)
    message(STATUS "Skia GN Build Configuration:")
    message(STATUS "--------------------------------------------------------------------------------------")
    foreach(item IN LISTS CSKIA_GN_ARGS)
        string(REGEX MATCH "([^=]+)=(.+)" matched ${item})

        if(matched)
            set(key ${CMAKE_MATCH_1})
            set(value ${CMAKE_MATCH_2})
            cskia_print_gn_arg(${key} ${value})
        else()
            message(WARNING "Invalid key-value format: ${item}")
        endif()
    endforeach()
    message(STATUS "--------------------------------------------------------------------------------------")
endmacro()
