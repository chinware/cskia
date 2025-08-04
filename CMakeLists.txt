# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/03.

cmake_minimum_required(VERSION 3.28)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules")

include(CSkiaVersion)
include(FeatureSummary)

project(cskia VERSION ${CSKIA_VERSION})

enable_language(CXX C)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_C_STANDARD 11)
set(CMAKE_OSX_DEPLOYMENT_TARGET 11)

include(SummaryOutput)

if(NOT CMAKE_INCLUDE_SYSTEM_FLAG_CXX)
    set(CXX_SYSTEM_INCLUDE_CONFIGURATION_FLAG /experimental:external /external:W0)
    set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX /external:I)
endif()

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "No build type selected, default to Debug")
    set(CMAKE_BUILD_TYPE
        "Debug"
        CACHE STRING "Build type (default Debug)" FORCE)
endif()

string(TOUPPER "${CMAKE_BUILD_TYPE}" uppercase_CMAKE_BUILD_TYPE)

if(CMAKE_BUILD_TYPE AND NOT ("${uppercase_CMAKE_BUILD_TYPE}" MATCHES "^(DEBUG|RELEASE|RELWITHDEBINFO)$"))
    message(FATAL_ERROR "Invalid value for CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
endif()

message(STATUS "Build type for the current project: ${CMAKE_BUILD_TYPE}")

include(Utils)
include(ConfgureTriple)
include(ConfigureRequirePackages)
include(AddCSkiaTargetUtils)
include(ConfigureOptions)
include(ConfigureStdPath)
include(ImportSkia)

if(DARWIN)
    include(ReadDarwinSDKInfo)
    set(CMAKE_OSX_DEPLOYMENT_TARGET 12.0.0)
endif()

if(NOT (CMAKE_BUILD_TYPE MATCHES Debug))
    add_definitions(-DNDEBUG)
endif()

if(CMAKE_BUILD_TYPE MATCHES Release)
    add_definitions(-DRELEASE)
endif()

add_compile_options(${CXX_SYSTEM_INCLUDE_CONFIGURATION_FLAG})

if(CSKIA_LINK_JOB_POOL AND CMAKE_GENERATOR MATCHES "Ninja")
    set_property(GLOBAL APPEND PROPERTY JOB_POOLS link_job_pool=${CSKIA_LINK_JOB_POOL})
    set(CMAKE_JOB_POOL_LINK link_job_pool)
endif()

string(TOLOWER "${CMAKE_SYSTEM_NAME}" TARGET_OS)
add_compile_definitions(__${TARGET_OS}__)

if(CSKIA_BUILD_UNITTESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

add_subdirectory(include/cskia)
add_subdirectory(src)
add_subdirectory(thirdparty)

print_summary()
