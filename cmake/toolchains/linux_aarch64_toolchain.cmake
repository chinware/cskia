# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/07.

get_filename_component(CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
include("${CMAKE_DIR}/linux_toolchain.cmake")
set(CMAKE_SYSTEM_PROCESSOR "aarch64")

if("${CMAKE_SYSTEM_NAME}" STREQUAL "${CMAKE_HOST_SYSTEM_NAME}" AND "${CMAKE_SYSTEM_PROCESSOR}" STREQUAL
    "${CMAKE_HOST_SYSTEM_PROCESSOR}")
    set(CMAKE_CROSSCOMPILING OFF)
endif()

if(CMAKE_CROSSCOMPILING)
    add_compile_definitions(__aarch64_linux_gnu__)
    add_compile_definitions(OPENSSL_ARM64_PLATFORM)
    set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} -Wno-effc++ -Wno-unused-variable -Wno-missing-declarations -Wno-unused-result")
endif()
