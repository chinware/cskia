# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/03.

option(CSKIA_BUILD_UNITTESTS "Generate build targets for the cskia library unittests." ON)

# skia build options
option(CSKIA_IS_OFFICIAL_BUILD "Enable official release mode: optimize size, disable debug symbols, and dynamically link system libraries" OFF)
option(CSKIA_ENABLE_PDF "Enable PDF rendering support." OFF)
option(CSKIA_ENABLE_SVG "Enable SVG rendering support." ON)
option(CSKIA_USE_X11 "Using X11 protocol support (Linux)." ON)
option(CSKIA_USE_WAYLAND "Using Wayland protocol support (Linux)." ON)
