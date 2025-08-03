# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/03.

macro(print_summary)
    message(STATUS "--------------------------------------------------------------------------------------")
    message(STATUS "Thank for using CSkia project, have a lot of fun!")
    message(STATUS "--------------------------------------------------------------------------------------")

    message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
    message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
    message(STATUS "PROJECT_BINARY_DIR: ${PROJECT_BINARY_DIR}")
    message(STATUS "PROJECT_SOURCE_DIR: ${PROJECT_SOURCE_DIR}")
    message(STATUS "CMAKE_ROOT: ${CMAKE_ROOT}")
    message(STATUS "CMAKE_SYSTEM: ${CMAKE_SYSTEM}")
    message(STATUS "CMAKE_SYSTEM_PROCESSOR: ${CMAKE_SYSTEM_PROCESSOR}")
    message(STATUS "CMAKE_SKIP_RPATH: ${CMAKE_SKIP_RPATH}")
    message(STATUS "CMAKE_VERBOSE_MAKEFILE: ${CMAKE_VERBOSE_MAKEFILE}")
    message(STATUS "CMAKE_C_COMPILER: ${CMAKE_C_COMPILER}")
    message(STATUS "CMAKE_C_COMPILER_VERSION: ${CMAKE_C_COMPILER_VERSION}")
    message(STATUS "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
    message(STATUS "CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER}")
    message(STATUS "CMAKE_CXX_COMPILER_VERSION: ${CMAKE_CXX_COMPILER_VERSION}")
    message(STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
    message(STATUS "CMAKE_EXE_LINKER_FLAGS: ${CMAKE_EXE_LINKER_FLAGS}")
    message(STATUS "--------------------------------------------------------------------------------------")
endmacro()
