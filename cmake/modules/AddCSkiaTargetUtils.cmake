# Copyright (c) Qinware Technologies Co., Ltd. 2025. All rights reserved.
# Copyright (c) 2017 - 2025 CHINBOY <qinware@163.com>
# This source file is part of the cskia project
# See https://qinware.com/LICENSE.txt for license information
#
# Created by CHINBOY on 2025/08/03.

function(cskia_output_binary_dir varName)
    if(CSKIA_MERGE_BINARY_DIR)
        set(${varName} ${CSKIA_BINARY_DIR} PARENT_SCOPE)
    else()
        set(${varName} ${PROJECT_BINARY_DIR} PARENT_SCOPE)
    endif()
endfunction()

function(cskia_add_library name)
    cmake_parse_arguments(_arg "STATIC;OBJECT;FEATURE_INFO"
        "DESTINATION;COMPONENT;SOURCES_PREFIX;BUILD_DEFAULT"
        "CONDITION;DEPENDS;PUBLIC_DEPENDS;DEFINES;PUBLIC_DEFINES;INCLUDES;PUBLIC_INCLUDES;SOURCES;PROPERTIES" ${ARGN}
    )

    set(default_defines_copy ${DEFAULT_DEFINES})

    if(${_arg_UNPARSED_ARGUMENTS})
        message(FATAL_ERROR "cskia_add_library had unparsed arguments")
    endif()

    cskia_update_cached_list(__CSKIA_LIBRARIES "${name}")
    cskia_condition_info(_extra_text _arg_CONDITION)

    if(NOT _arg_CONDITION)
        set(_arg_CONDITION ON)
    endif()

    add_feature_info("Library ${name}" ON "${_extra_text}")

    set(library_type SHARED)
    if(_arg_STATIC)
        set(library_type STATIC)
    endif()
    if(_arg_OBJECT)
        set(library_type OBJECT)
    endif()

    add_library(${name} ${library_type})
    add_library(CSKIA::${name} ALIAS ${name})

    string(TOUPPER "CSKIA_LIBRARY" EXPORT_SYMBOL)

    if(cskia_WITH_TESTS)
        set(TEST_DEFINES WITH_TESTS SRCDIR="${CMAKE_CURRENT_SOURCE_DIR}")
    endif()

    if(_arg_STATIC AND UNIX)
        # not added by Qt if reduce_relocations is turned off for it
        set_target_properties(${name} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    endif()

    cskia_extend_target(${name}
        SOURCES_PREFIX ${_arg_SOURCES_PREFIX}
        SOURCES ${_arg_SOURCES}
        INCLUDES ${_arg_INCLUDES}
        PUBLIC_INCLUDES ${_arg_PUBLIC_INCLUDES}
        DEFINES ${EXPORT_SYMBOL} ${default_defines_copy} ${_arg_DEFINES} ${TEST_DEFINES}
        PUBLIC_DEFINES ${_arg_PUBLIC_DEFINES}
        DEPENDS ${_arg_DEPENDS} ${IMPLICIT_DEPENDS}
        PUBLIC_DEPENDS ${_arg_PUBLIC_DEPENDS}
    )

    # everything is different with SOURCES_PREFIX
    if(NOT _arg_SOURCES_PREFIX)
        target_include_directories(${name}
            PRIVATE
            "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>"
            PUBLIC
            "$<BUILD_INTERFACE:${CSKIA_BINARY_INCLUDE_DIR}>"
            "$<BUILD_INTERFACE:${CSKIA_INCLUDE_DIR}>"
            "$<INSTALL_INTERFACE:${CSKIA_HEADER_INSTALL_PATH}>"
        )
    endif()

    set(_DESTINATION "${CSKIA_BIN_PATH}")
    if(_arg_DESTINATION)
        set(_DESTINATION "${_arg_DESTINATION}")
    endif()

    cskia_output_binary_dir(_output_binary_dir)
    string(REGEX MATCH "^[0-9]*" cskia_VERSION_MAJOR ${cskia_VERSION})

    set_target_properties(${name} PROPERTIES
        LINK_DEPENDS_NO_SHARED ON
        SOURCES_DIR "${CMAKE_CURRENT_SOURCE_DIR}"
        MACHO_CURRENT_VERSION ${CSKIA_VERSION}
        MACHO_COMPATIBILITY_VERSION ${CSKIA_VERSION_COMPAT}
        CXX_EXTENSIONS OFF
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN ON
        BUILD_RPATH "${_LIB_RPATH};${CMAKE_BUILD_RPATH}"
        INSTALL_RPATH "${_LIB_RPATH};${CMAKE_INSTALL_RPATH}"
        RUNTIME_OUTPUT_DIRECTORY "${_output_binary_dir}/${_DESTINATION}"
        LIBRARY_OUTPUT_DIRECTORY "${_output_binary_dir}/${CSKIA_LIBRARY_PATH}"
        ARCHIVE_OUTPUT_DIRECTORY "${_output_binary_dir}/${CSKIA_LIBRARY_ARCHIVE_PATH}"
        ${_arg_PROPERTIES}
    )

    unset(NAMELINK_OPTION)
    if(library_type STREQUAL "SHARED")
        set(NAMELINK_OPTION NAMELINK_SKIP)
    endif()

    unset(COMPONENT_OPTION)
    if(_arg_COMPONENT)
        set(COMPONENT_OPTION "COMPONENT" "${_arg_COMPONENT}")
    endif()

    install(TARGETS ${name}
        EXPORT CSKIA
        RUNTIME
        DESTINATION "${_DESTINATION}"
        ${COMPONENT_OPTION}
        OPTIONAL
        LIBRARY
        DESTINATION "${CSKIA_LIBRARY_PATH}"
        ${NAMELINK_OPTION}
        ${COMPONENT_OPTION}
        OPTIONAL
        OBJECTS
        DESTINATION "${CSKIA_LIBRARY_PATH}"
        COMPONENT Devel EXCLUDE_FROM_ALL
        ARCHIVE
        DESTINATION "${CSKIA_LIBRARY_ARCHIVE_PATH}"
        COMPONENT Devel EXCLUDE_FROM_ALL
        OPTIONAL
    )

    if(CSKIA_WITH_SANITIZE)
        cskia_enable_sanitize(${SANITIZE_FLAGS})
    endif()

    if(NAMELINK_OPTION)
        install(TARGETS ${name}
            LIBRARY
            DESTINATION "${CSKIA_LIBRARY_PATH}"
            NAMELINK_ONLY
            COMPONENT Devel EXCLUDE_FROM_ALL
            OPTIONAL
        )
    endif()
endfunction()

function(cskia_extend_library target_name)
    cskia_library_enabled(_library_enabled ${target_name})
    if(NOT _library_enabled)
        return()
    endif()
    cskia_extend_target(${target_name} ${ARGN})
endfunction()

function(cskia_extend_test target_name)
    if(NOT (target_name IN_LIST __CSKIA_TESTS))
        message(FATAL_ERROR "cskia_extend_test: Unknown test target \"${target_name}\"")
    endif()
    if(TARGET ${target_name})
        cskia_extend_target(${target_name} ${ARGN})
    endif()
endfunction()

function(cskia_add_executable name)
    cmake_parse_arguments(_arg ""
        "DESTINATION;COMPONENT;BUILD_DEFAULT"
        "CONDITION;DEPENDS;DEFINES;INCLUDES;SOURCES;PROPERTIES" ${ARGN})

    if(${_arg_UNPARSED_ARGUMENTS})
        message(FATAL_ERROR "cskia_add_executable had unparsed arguments!")
    endif()
    set(default_defines_copy ${DEFAULT_DEFINES})
    cskia_update_cached_list(__CSKIA_EXECUTABLES "${name}")

    if(NOT _arg_CONDITION)
        set(_arg_CONDITION ON)
    endif()

    string(TOUPPER "CSKIA_BUILD_EXECUTABLE_${name}" _build_executable_var)
    if(DEFINED _arg_BUILD_DEFAULT)
        set(_build_executable_default ${_arg_BUILD_DEFAULT})
    else()
        set(_build_executable_default ${CSKIA_BUILD_EXECUTABLES_BY_DEFAULT})
    endif()
    if(DEFINED ENV{${_build_executable_var}})
        set(_build_executable_default "$ENV{${_build_executable_var}}")
    endif()
    set(${_build_executable_var} "${_build_executable_default}" CACHE BOOL "Build executable ${name}.")

    if((${_arg_CONDITION}) AND ${_build_executable_var})
        set(_executable_enabled ON)
    else()
        set(_executable_enabled OFF)
    endif()
    if(NOT _executable_enabled)
        return()
    endif()

    set(_DESTINATION "${CSKIA_LIBEXEC_PATH}")
    if(_arg_DESTINATION)
        set(_DESTINATION "${_arg_DESTINATION}")
    endif()

    set(_EXECUTABLE_PATH "${_DESTINATION}")
    if(APPLE)
        # path of executable might be inside app bundle instead of DESTINATION directly
        cmake_parse_arguments(_prop "" "MACOSX_BUNDLE;OUTPUT_NAME" "" "${_arg_PROPERTIES}")
        if(_prop_MACOSX_BUNDLE)
            set(_BUNDLE_NAME "${name}")
            if(_prop_OUTPUT_NAME)
                set(_BUNDLE_NAME "${_prop_OUTPUT_NAME}")
            endif()
            set(_BUNDLE_CONTENTS_PATH "${_DESTINATION}/${_BUNDLE_NAME}.app/Contents")
            set(_EXECUTABLE_PATH "${_BUNDLE_CONTENTS_PATH}/MacOS")
            set(_EXECUTABLE_FILE_PATH "${_EXECUTABLE_PATH}/${_BUNDLE_NAME}")
            set(_BUNDLE_INFO_PLIST "${_BUNDLE_CONTENTS_PATH}/Info.plist")
        endif()
    endif()

    if(CSKIA_WITH_TESTS)
        set(TEST_DEFINES WITH_TESTS SRCDIR="${CMAKE_CURRENT_SOURCE_DIR}")
    endif()

    add_executable("${name}" ${_arg_SOURCES})

    cskia_extend_target("${name}"
        INCLUDES "${CMAKE_BINARY_DIR}/src" ${_arg_INCLUDES}
        DEFINES ${default_defines_copy} ${TEST_DEFINES} ${_arg_DEFINES}
        DEPENDS ${_arg_DEPENDS} ${IMPLICIT_DEPENDS}
    )

    file(RELATIVE_PATH relative_lib_path "/${_EXECUTABLE_PATH}" "/${CSKIA_LIBRARY_PATH}")

    set(build_rpath "${_RPATH_BASE}/${relative_lib_path}")
    set(install_rpath "${_RPATH_BASE}/${relative_lib_path}")
    if(NOT WIN32 AND NOT APPLE)
        set(install_rpath "${install_rpath};")
    endif()
    set(build_rpath "${build_rpath};${CMAKE_BUILD_RPATH}")
    set(install_rpath "${install_rpath};${CMAKE_INSTALL_RPATH}")

    cskia_output_binary_dir(_output_binary_dir)
    set_target_properties("${name}" PROPERTIES
        LINK_DEPENDS_NO_SHARED ON
        BUILD_RPATH "${build_rpath}"
        INSTALL_RPATH "${install_rpath}"
        RUNTIME_OUTPUT_DIRECTORY "${_output_binary_dir}/${_DESTINATION}"
        CXX_EXTENSIONS OFF
        CXX_VISIBILITY_PRESET hidden
        VISIBILITY_INLINES_HIDDEN ON
        ${_arg_PROPERTIES}
    )
endfunction()

function(cskia_extend_executable name)
    if(NOT (name IN_LIST __CSKIA_EXECUTABLES))
        message(FATAL_ERROR "cskia_extend_executable: Unknown executable target \"${name}\"")
    endif()
    if(TARGET ${name})
        cskia_extend_target(${name} ${ARGN})
    endif()
endfunction()

function(cskia_extend_target target_name)
    cmake_parse_arguments(_arg
        ""
        "SOURCES_PREFIX;SOURCES_PREFIX_FROM_TARGET;FEATURE_INFO"
        "CONDITION;DEPENDS;PUBLIC_DEPENDS;DEFINES;PUBLIC_DEFINES;INCLUDES;PUBLIC_INCLUDES;SOURCES;PROPERTIES"
        ${ARGN}
    )

    if(${_arg_UNPARSED_ARGUMENTS})
        message(FATAL_ERROR "cskia_extend_target had unparsed arguments")
    endif()

    cskia_condition_info(_extra_text _arg_CONDITION)
    if(NOT _arg_CONDITION)
        set(_arg_CONDITION ON)
    endif()
    if(${_arg_CONDITION})
        set(_feature_enabled ON)
    else()
        set(_feature_enabled OFF)
    endif()
    if(_arg_FEATURE_INFO)
        add_feature_info(${_arg_FEATURE_INFO} _feature_enabled "${_extra_text}")
    endif()
    if(NOT _feature_enabled)
        return()
    endif()

    if(_arg_SOURCES_PREFIX_FROM_TARGET)
        if(NOT TARGET ${_arg_SOURCES_PREFIX_FROM_TARGET})
            return()
        else()
            get_target_property(_arg_SOURCES_PREFIX ${_arg_SOURCES_PREFIX_FROM_TARGET} SOURCES_DIR)
        endif()
    endif()

    cskia_add_depends(${target_name}
        PRIVATE ${_arg_DEPENDS}
        PUBLIC ${_arg_PUBLIC_DEPENDS}
    )
    target_compile_definitions(${target_name}
        PRIVATE ${_arg_DEFINES}
        PUBLIC ${_arg_PUBLIC_DEFINES}
    )
    target_include_directories(${target_name} PRIVATE ${_arg_INCLUDES})

    cskia_set_public_includes(${target_name} "${_arg_PUBLIC_INCLUDES}")

    if(_arg_SOURCES_PREFIX)
        foreach(source IN LISTS _arg_SOURCES)
            list(APPEND prefixed_sources "${_arg_SOURCES_PREFIX}/${source}")
        endforeach()

        if(NOT IS_ABSOLUTE ${_arg_SOURCES_PREFIX})
            set(_arg_SOURCES_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/${_arg_SOURCES_PREFIX}")
        endif()
        target_include_directories(${target_name} PRIVATE $<BUILD_INTERFACE:${_arg_SOURCES_PREFIX}>)

        set(_arg_SOURCES ${prefixed_sources})
    endif()
    target_sources(${target_name} PRIVATE ${_arg_SOURCES})

    cskia_set_public_headers(${target_name} "${_arg_SOURCES}")

    if(_arg_PROPERTIES)
        set_target_properties(${target_name} PROPERTIES ${_arg_PROPERTIES})
    endif()
endfunction()
