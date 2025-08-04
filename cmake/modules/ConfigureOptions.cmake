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
option(CSKIA_ENABLE_TEXTLAYOUT "Enable text layout support, Modules skshaper and skparagraph." OFF)
option(CSKIA_ENABLE_WEBP_ENCODE "Enable Support the encoding of bitmap data to the WEBP image format." OFF)
option(CSKIA_ENABLE_WEBP_DECODE "Enable Support the decoding of the WEBP image format to bitmap data." OFF)
option(CSKIA_ENABLE_EMBED_FREETYPE "Enable freetype embed support." OFF)
option(CSKIA_ENABLE_FREETYPE_WOFF2 "Enable freetype woff2 support." OFF)
option(CSKIA_USE_X11 "Using X11 protocol support (Linux)." OFF)
option(CSKIA_USE_EGL "Using Embedded Graphics Library, If you set X11, setting this to false will use LibGL (GLX)." OFF)
option(CSKIA_USE_GL "Using Open Graphics Library." OFF)
option(CSKIA_USE_WAYLAND "Using Wayland protocol support, This requires EGL, as GLX does not work on Wayland." OFF)
option(CSKIA_USE_VULKAN "Using the Vulkan graphics API." OFF)
option(CSKIA_USE_METAL "Using the Apple Meta graphics API." OFF)
option(CSKIA_USE_DIRECT3D "Using the Microsoft Direct3D graphics API." OFF)
