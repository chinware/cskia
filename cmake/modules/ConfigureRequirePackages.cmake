# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/03.

find_package(Git REQUIRED)
find_package(Python3 REQUIRED)

if(NOT EXISTS "${CSKIA_SKIA_GN_EXECUTABLE}" OR ${CSKIA_FORCE_SYNC_DEPS})
    cskia_fetch_gn()
endif()

is_directory_empty(${CSKIA_SKIA_EXTERNALS_DIR} externals_exist)

if(${externals_exist} OR ${CSKIA_FORCE_SYNC_DEPS})
    cskia_sync_deps()
endif()
