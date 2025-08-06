# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/03.

function(is_directory_empty dir result_var)
    file(GLOB files "${dir}/*")
    # 过滤掉 "." 和 ".." 目录
    list(FILTER files EXCLUDE REGEX "/\\.$")
    list(FILTER files EXCLUDE REGEX "/\\.\\.$")
    list(FILTER hidden_files EXCLUDE REGEX "/\\.$")
    list(FILTER hidden_files EXCLUDE REGEX "/\\.\\.$")

    list(APPEND files ${hidden_files})

    list(LENGTH files count)
    if(count EQUAL 0)
        set(${result_var} TRUE PARENT_SCOPE)
    else()
        set(${result_var} FALSE PARENT_SCOPE)
    endif()
endfunction()
