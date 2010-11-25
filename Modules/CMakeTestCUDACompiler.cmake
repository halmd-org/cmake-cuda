
#=============================================================================
# Copyright 2003-2009 Kitware, Inc.
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

INCLUDE(CMakeTestCompilerCommon)

# This file is used by EnableLanguage in cmGlobalGenerator to
# determine that that selected CUDA C compiler can actually compile
# and link the most basic of programs.   If not, a fatal error
# is set and cmake stops processing commands and will not generate
# any makefiles or projects.
IF(NOT CMAKE_CUDA_COMPILER_WORKS)
  PrintTestCompilerStatus("CUDA C" "")
  FILE(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testCUDACompiler.cu
    "__global__ void test(){}\n"
    "int main(){test<<< 32, 128 >>>(); return 0;}\n")
  TRY_COMPILE(CMAKE_CUDA_COMPILER_WORKS ${CMAKE_BINARY_DIR}
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testCUDACompiler.cu
    OUTPUT_VARIABLE OUTPUT)
  SET(CUDA_TEST_WAS_RUN 1)
ENDIF(NOT CMAKE_CUDA_COMPILER_WORKS)

IF(NOT CMAKE_CUDA_COMPILER_WORKS)
  PrintTestCompilerStatus("CUDA C" " -- broken")
  # if the compiler is broken make sure to remove the platform file
  FILE(REMOVE ${CMAKE_PLATFORM_ROOT_BIN}/CMakeCUDAPlatform.cmake )
  FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if the CUDA C compiler works failed with "
    "the following output:\n${OUTPUT}\n\n")
  MESSAGE(FATAL_ERROR "The CUDA C compiler \"${CMAKE_CUDA_COMPILER}\" "
    "is not able to compile a simple test program.\nIt fails "
    "with the following output:\n ${OUTPUT}\n\n"
    "CMake will not be able to correctly generate this project.")
ELSE(NOT CMAKE_CUDA_COMPILER_WORKS)
  IF(CUDA_TEST_WAS_RUN)
    PrintTestCompilerStatus("CUDA C" " -- works")
    FILE(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if the CUDA C compiler works passed with "
      "the following output:\n${OUTPUT}\n\n")
  ENDIF(CUDA_TEST_WAS_RUN)
  SET(CMAKE_CUDA_COMPILER_WORKS 1 CACHE INTERNAL "")

  IF(CMAKE_CUDA_COMPILER_FORCED)
    # The compiler configuration was forced by the user.
    # Assume the user has configured all compiler information.
  ELSE(CMAKE_CUDA_COMPILER_FORCED)
    # Try to identify the ABI and configure it into CMakeCUDACompiler.cmake
    INCLUDE(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerABI.cmake)
    CMAKE_DETERMINE_COMPILER_ABI(CUDA ${CMAKE_ROOT}/Modules/CMakeCUDACompilerABI.cu)
    CONFIGURE_FILE(
      ${CMAKE_ROOT}/Modules/CMakeCUDACompiler.cmake.in
      ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeCUDACompiler.cmake
      @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
      )
    INCLUDE(${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeCUDACompiler.cmake)
  ENDIF(CMAKE_CUDA_COMPILER_FORCED)
ENDIF(NOT CMAKE_CUDA_COMPILER_WORKS)
