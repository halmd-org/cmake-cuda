
#=============================================================================
# Copyright 2002-2009 Kitware, Inc.
# Copyright 2008-2010 Peter Colberg
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

IF(NOT CMAKE_CUDA_COMPILER)
  SET(CMAKE_CUDA_COMPILER_INIT NOTFOUND)

  # prefer the environment variable CUDACC
  IF($ENV{CUDACC} MATCHES ".+")
    GET_FILENAME_COMPONENT(CMAKE_CUDA_COMPILER_INIT $ENV{CUDACC} PROGRAM PROGRAM_ARGS CMAKE_CUDA_FLAGS_ENV_INIT)
    IF(CMAKE_CUDA_FLAGS_ENV_INIT)
      SET(CMAKE_CUDA_COMPILER_ARG1 "${CMAKE_CUDA_FLAGS_ENV_INIT}" CACHE STRING "First argument to CUDA compiler")
    ENDIF(CMAKE_CUDA_FLAGS_ENV_INIT)
    IF(NOT EXISTS ${CMAKE_CUDA_COMPILER_INIT})
      MESSAGE(FATAL_ERROR "Could not find compiler set in environment variable CUDACC:\n$ENV{CUDACC}.\n${CMAKE_CUDA_COMPILER_INIT}")
    ENDIF(NOT EXISTS ${CMAKE_CUDA_COMPILER_INIT})
  ENDIF($ENV{CUDACC} MATCHES ".+")

  # next prefer the generator specified compiler
  IF(CMAKE_GENERATOR_CUDA)
    IF(NOT CMAKE_CUDA_COMPILER_INIT)
      SET(CMAKE_CUDA_COMPILER_INIT ${CMAKE_GENERATOR_CUDA})
    ENDIF(NOT CMAKE_CUDA_COMPILER_INIT)
  ENDIF(CMAKE_GENERATOR_CUDA)

  # finally list compilers to try
  IF(CMAKE_CUDA_COMPILER_INIT)
    SET(CMAKE_CUDA_COMPILER_LIST ${CMAKE_CUDA_COMPILER_INIT})
  ELSE(CMAKE_CUDA_COMPILER_INIT)
    SET(CMAKE_CUDA_COMPILER_LIST nvcc)
  ENDIF(CMAKE_CUDA_COMPILER_INIT)

  # Find the compiler.
  FIND_PROGRAM(CMAKE_CUDA_COMPILER
    NAMES ${CMAKE_CUDA_COMPILER_LIST}
    HINTS $ENV{CUDA_TOOLKIT_ROOT_DIR}
    PATH_SUFFIXES bin
    DOC "CUDA C compiler"
  )

  IF(CMAKE_CUDA_COMPILER_INIT AND NOT CMAKE_CUDA_COMPILER)
    SET(CMAKE_CUDA_COMPILER "${CMAKE_CUDA_COMPILER_INIT}" CACHE FILEPATH "CUDA C compiler" FORCE)
  ENDIF(CMAKE_CUDA_COMPILER_INIT AND NOT CMAKE_CUDA_COMPILER)
ELSE(NOT CMAKE_CUDA_COMPILER)

# we only get here if CMAKE_CUDA_COMPILER was specified using -D or a pre-made CMakeCache.txt
# (e.g. via ctest) or set in CMAKE_TOOLCHAIN_FILE
#
# if CMAKE_CUDA_COMPILER is a list of length 2, use the first item as
# CMAKE_CUDA_COMPILER and the 2nd one as CMAKE_CUDA_COMPILER_ARG1

  LIST(LENGTH CMAKE_CUDA_COMPILER _CMAKE_CUDA_COMPILER_LIST_LENGTH)
  IF("${_CMAKE_CUDA_COMPILER_LIST_LENGTH}" EQUAL 2)
    LIST(GET CMAKE_CUDA_COMPILER 1 CMAKE_CUDA_COMPILER_ARG1)
    LIST(GET CMAKE_CUDA_COMPILER 0 CMAKE_CUDA_COMPILER)
  ENDIF("${_CMAKE_CUDA_COMPILER_LIST_LENGTH}" EQUAL 2)

# if a compiler was specified by the user but without path,
# now try to find it with the full path
# if it is found, force it into the cache,
# if not, don't overwrite the setting (which was given by the user) with "NOTFOUND"
# if the CUDA compiler already had a path, reuse it for searching the C compiler
  GET_FILENAME_COMPONENT(_CMAKE_USER_CUDA_COMPILER_PATH "${CMAKE_CUDA_COMPILER}" PATH)
  IF(NOT _CMAKE_USER_CUDA_COMPILER_PATH)
    FIND_PROGRAM(CMAKE_CUDA_COMPILER_WITH_PATH NAMES ${CMAKE_CUDA_COMPILER})
    MARK_AS_ADVANCED(CMAKE_CUDA_COMPILER_WITH_PATH)
    IF(CMAKE_CUDA_COMPILER_WITH_PATH)
      SET(CMAKE_CUDA_COMPILER ${CMAKE_CUDA_COMPILER_WITH_PATH} CACHE STRING "CUDA C compiler" FORCE)
    ENDIF(CMAKE_CUDA_COMPILER_WITH_PATH)
  ENDIF(NOT _CMAKE_USER_CUDA_COMPILER_PATH)
ENDIF(NOT CMAKE_CUDA_COMPILER)
MARK_AS_ADVANCED(CMAKE_CUDA_COMPILER)

IF(NOT CMAKE_CUDA_COMPILER_ID_RUN)
  SET(CMAKE_CUDA_COMPILER_ID_RUN 1)

  # Each entry in this list is a set of extra flags to try
  # adding to the compile line to see if it helps produce
  # a valid identification file.
  SET(CMAKE_CUDA_COMPILER_ID_TEST_FLAGS
    # Try compiling to an object file only.
    "-c"
  )

  # Try to identify the compiler.
  SET(CMAKE_CUDA_COMPILER_ID)
  FILE(READ ${CMAKE_ROOT}/Modules/CMakePlatformId.h.in
    CMAKE_CUDA_COMPILER_ID_PLATFORM_CONTENT)
  INCLUDE(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerId.cmake)
  CMAKE_DETERMINE_COMPILER_ID(CUDA CUDAFLAGS CMakeCUDACompilerId.cu)
ENDIF(NOT CMAKE_CUDA_COMPILER_ID_RUN)

# configure all variables set in this file
CONFIGURE_FILE(${CMAKE_ROOT}/Modules/CMakeCUDACompiler.cmake.in
  ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeCUDACompiler.cmake
  @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
)

SET(CMAKE_CUDA_COMPILER_ENV_VAR "CUDACC")
