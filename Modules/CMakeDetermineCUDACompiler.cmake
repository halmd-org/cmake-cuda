
#=============================================================================
# Copyright 2002-2009 Kitware, Inc.
# Copyright 2008-2010 Peter Colberg
# Copyright 2013      Felix Höfling
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

# determine the compiler to use for CUDA C programs
# NOTE, a generator may set CMAKE_CUDA_COMPILER before
# loading this file to force a compiler.
# use environment variable CUDACC first if defined by user, next use
# the cmake variable CMAKE_GENERATOR_CUDA which can be defined by a generator
# as a default compiler
#
# Sets the following variables:
#   CMAKE_CUDA_COMPILER
#   CMAKE_AR
#   CMAKE_RANLIB
#

include(${CMAKE_ROOT}/Modules/CMakeDetermineCompiler.cmake)

# Load system-specific compiler preferences for this language.
include(Platform/${CMAKE_SYSTEM_NAME}-CUDA OPTIONAL)
if(NOT CMAKE_CUDA_COMPILER_NAMES)
  set(CMAKE_CUDA_COMPILER_NAMES nvcc)
endif()

if(${CMAKE_GENERATOR} MATCHES "Visual Studio")
elseif("${CMAKE_GENERATOR}" MATCHES "Xcode")
  set(CMAKE_CUDA_COMPILER_XCODE_TYPE sourcecode.cpp.cpp)
else()
  if(NOT CMAKE_CUDA_COMPILER)
    set(CMAKE_CUDA_COMPILER_INIT NOTFOUND)

    # prefer the environment variable CUDACC
    if($ENV{CUDACC} MATCHES ".+")
      get_filename_component(CMAKE_CUDA_COMPILER_INIT $ENV{CUDACC} PROGRAM PROGRAM_ARGS CMAKE_CUDA_FLAGS_ENV_INIT)
      if(CMAKE_CUDA_FLAGS_ENV_INIT)
        set(CMAKE_CUDA_COMPILER_ARG1 "${CMAKE_CUDA_FLAGS_ENV_INIT}" CACHE STRING "First argument to CUDA compiler")
      endif()
      if(NOT EXISTS ${CMAKE_CUDA_COMPILER_INIT})
        message(FATAL_ERROR "Could not find compiler set in environment variable CUDACC:\n$ENV{CUDACC}.")
      endif()
    endif()

    # next try prefer the compiler specified by the generator
    if(CMAKE_GENERATOR_CUDA)
      if(NOT CMAKE_CUDA_COMPILER_INIT)
        set(CMAKE_CUDA_COMPILER_INIT ${CMAKE_GENERATOR_CUDA})
      endif()
    endif()

    # finally list compilers to try
    if(NOT CMAKE_CUDA_COMPILER_INIT)
      set(CMAKE_CUDA_COMPILER_LIST nvcc)
    endif()

    _cmake_find_compiler(CUDA)

  else()
    # we only get here if CMAKE_CUDA_COMPILER was specified using -D or a pre-made CMakeCache.txt
    # (e.g. via ctest) or set in CMAKE_TOOLCHAIN_FILE
    # if CMAKE_CUDA_COMPILER is a list of length 2, use the first item as
    # CMAKE_CUDA_COMPILER and the 2nd one as CMAKE_CUDA_COMPILER_ARG1

    list(LENGTH CMAKE_CUDA_COMPILER _CMAKE_CUDA_COMPILER_LIST_LENGTH)
    if("${_CMAKE_CUDA_COMPILER_LIST_LENGTH}" EQUAL 2)
      list(GET CMAKE_CUDA_COMPILER 1 CMAKE_CUDA_COMPILER_ARG1)
      list(GET CMAKE_CUDA_COMPILER 0 CMAKE_CUDA_COMPILER)
    endif()

    # if a compiler was specified by the user but without path,
    # now try to find it with the full path
    # if it is found, force it into the cache,
    # if not, don't overwrite the setting (which was given by the user) with "NOTFOUND"
    # if the CUDA compiler already had a path, reuse it for searching the C compiler
    get_filename_component(_CMAKE_USER_CUDA_COMPILER_PATH "${CMAKE_CUDA_COMPILER}" PATH)
      if(NOT _CMAKE_USER_CUDA_COMPILER_PATH)
        find_program(CMAKE_CUDA_COMPILER_WITH_PATH NAMES ${CMAKE_CUDA_COMPILER})
        mark_as_advanced(CMAKE_CUDA_COMPILER_WITH_PATH)
        if(CMAKE_CUDA_COMPILER_WITH_PATH)
          setT(CMAKE_CUDA_COMPILER ${CMAKE_CUDA_COMPILER_WITH_PATH} CACHE STRING "CUDA C compiler" FORCE)
        endif()
      endif()
  endif()
  mark_as_advanced(CMAKE_CUDA_COMPILER)

  # Each entry in this list is a set of extra flags to try
  # adding to the compile line to see if it helps produce
  # a valid identification file.
  set(CMAKE_CUDA_COMPILER_ID_TEST_FLAGS
    # Try compiling to an object file only.
    "-c"
    )
endif()

# Build a small source file to identify the compiler.
if(NOT CMAKE_CUDA_COMPILER_ID_RUN)
  set(CMAKE_CUDA_COMPILER_ID_RUN 1)

  # Try to identify the compiler.
  set(CMAKE_CUDA_COMPILER_ID)
  file(READ ${CMAKE_ROOT}/Modules/CMakePlatformId.h.in
    CMAKE_CUDA_COMPILER_ID_PLATFORM_CONTENT)
  include(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerId.cmake)
  CMAKE_DETERMINE_COMPILER_ID(CUDA CUDAFLAGS CMakeCUDACompilerId.cu)
endif()

include(${CMAKE_ROOT}/Modules/CMakeClDeps.cmake)
include(CMakeFindBinUtils)
# configure variables set in this file for fast reload later on
configure_file(${CMAKE_ROOT}/Modules/CMakeCUDACompiler.cmake.in
  ${CMAKE_PLATFORM_INFO_DIR}/CMakeCUDACompiler.cmake
  @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
  )
set(CMAKE_CUDA_COMPILER_ENV_VAR "CUDACC")
