# determine the compiler to use for NVIDIA CUDA programs
# NOTE, a generator may set CMAKE_CUDA_COMPILER before
# loading this file to force a compiler.
# use environment variable NVCC first if defined by user, next use
# the cmake variable CMAKE_GENERATOR_NVCC which can be defined by a generator
# as a default compiler
#
# Sets the following variables:
#   CMAKE_CUDA_COMPILER
#   CMAKE_AR
#   CMAKE_RANLIB

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
# (To distributed this file outside of CMake, substitute the full
#  License text for the above reference.)

IF(NOT CMAKE_CUDA_COMPILER)
  SET(CMAKE_CUDA_COMPILER_INIT NOTFOUND)

  # prefer the environment variable NVCC
  IF($ENV{NVCC} MATCHES ".+")
    GET_FILENAME_COMPONENT(CMAKE_CUDA_COMPILER_INIT $ENV{NVCC} PROGRAM PROGRAM_ARGS CMAKE_CUDA_FLAGS_ENV_INIT)
    IF(CMAKE_CUDA_FLAGS_ENV_INIT)
      SET(CMAKE_CUDA_COMPILER_ARG1 "${CMAKE_CUDA_FLAGS_ENV_INIT}" CACHE STRING "First argument to CUDA compiler")
    ENDIF(CMAKE_CUDA_FLAGS_ENV_INIT)
    IF(NOT EXISTS ${CMAKE_CUDA_COMPILER_INIT})
      MESSAGE(FATAL_ERROR "Could not find compiler set in environment variable NVCC:\n$ENV{NVCC}.\n${CMAKE_CUDA_COMPILER_INIT}")
    ENDIF(NOT EXISTS ${CMAKE_CUDA_COMPILER_INIT})
  ENDIF($ENV{NVCC} MATCHES ".+")

  # next prefer the generator specified compiler
  IF(CMAKE_GENERATOR_NVCC)
    IF(NOT CMAKE_CUDA_COMPILER_INIT)
      SET(CMAKE_CUDA_COMPILER_INIT ${CMAKE_GENERATOR_NVCC})
    ENDIF(NOT CMAKE_CUDA_COMPILER_INIT)
  ENDIF(CMAKE_GENERATOR_NVCC)

  # finally list compilers to try
  IF(CMAKE_CUDA_COMPILER_INIT)
    SET(CMAKE_CUDA_COMPILER_LIST ${CMAKE_CUDA_COMPILER_INIT})
  ELSE(CMAKE_CUDA_COMPILER_INIT)
    SET(CMAKE_CUDA_COMPILER_LIST nvcc)
  ENDIF(CMAKE_CUDA_COMPILER_INIT)

  SET(CMAKE_CUDA_BIN_PATH
    $ENV{CUDA_BIN_PATH}
    /usr/local/cuda/bin
    /usr/lib/cuda/bin
    /usr/shared/cuda/bin
    /usr/local/bin
    /usr/bin
    /opt/cuda/bin
    )
  # Find the compiler.
  FIND_PROGRAM(CMAKE_CUDA_COMPILER NAMES ${CMAKE_CUDA_COMPILER_LIST} PATHS ${CMAKE_CUDA_BIN_PATH} DOC "CUDA compiler")

  IF(CMAKE_CUDA_COMPILER_INIT AND NOT CMAKE_CUDA_COMPILER)
    SET(CMAKE_CUDA_COMPILER "${CMAKE_CUDA_COMPILER_INIT}" CACHE FILEPATH "CUDA compiler" FORCE)
  ENDIF(CMAKE_CUDA_COMPILER_INIT AND NOT CMAKE_CUDA_COMPILER)
ENDIF(NOT CMAKE_CUDA_COMPILER)
MARK_AS_ADVANCED(CMAKE_CUDA_COMPILER)

INCLUDE(CMakeFindBinUtils)

# configure all variables set in this file
CONFIGURE_FILE(${CMAKE_ROOT}/Modules/CMakeCUDACompiler.cmake.in
  ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeCUDACompiler.cmake
  @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
  )

SET(CMAKE_CUDA_COMPILER_ENV_VAR "NVCC")
