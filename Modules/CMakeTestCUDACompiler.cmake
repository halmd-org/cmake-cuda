
#=============================================================================
# Copyright 2003-2009 Kitware, Inc.
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

if(CMAKE_CUDA_COMPILER_FORCED)
  # The compiler configuration was forced by the user.
  # Assume the user has configured all compiler information.
  set(CMAKE_CUDA_COMPILER_WORKS TRUE)
  return()
endif()

include(CMakeTestCompilerCommon)

# Remove any cached result from an older CMake version.
# We now store this in CMakeCUDACompiler.cmake.
unset(CMAKE_CUDA_COMPILER_WORKS CACHE)

# This file is used by EnableLanguage in cmGlobalGenerator to
# determine that that selected CUDA compiler can actually compile
# and link the most basic of programs.   If not, a fatal error
# is set and cmake stops processing commands and will not generate
# any makefiles or projects.
if(NOT CMAKE_CUDA_COMPILER_WORKS)
  PrintTestCompilerStatus("CUDA" "")
  file(WRITE ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testCUDACompiler.cu
    "__global__ void test(){}\n"
    "int main(){test<<< 32, 128 >>>(); return 0;}\n")
  try_compile(CMAKE_CUDA_COMPILER_WORKS ${CMAKE_BINARY_DIR}
    ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeTmp/testCUDACompiler.cu
    OUTPUT_VARIABLE __CMAKE_CUDA_COMPILER_OUTPUT)
  # Move result from cache to normal variable.
  set(CMAKE_CUDA_COMPILER_WORKS ${CMAKE_CUDA_COMPILER_WORKS})
  unset(CMAKE_CUDA_COMPILER_WORKS CACHE)
  set(CUDA_TEST_WAS_RUN 1)
endif()

if(NOT CMAKE_CUDA_COMPILER_WORKS)
  PrintTestCompilerStatus("CUDA" " -- broken")
  file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeError.log
    "Determining if the CUDA compiler works failed with "
    "the following output:\n${__CMAKE_CUDA_COMPILER_OUTPUT}\n\n")
  message(FATAL_ERROR "The CUDA compiler \"${CMAKE_CUDA_COMPILER}\" "
    "is not able to compile a simple test program.\nIt fails "
    "with the following output:\n ${__CMAKE_CUDA_COMPILER_OUTPUT}\n\n"
    "CMake will not be able to correctly generate this project.")
else()
  if(CUDA_TEST_WAS_RUN)
    PrintTestCompilerStatus("CUDA" " -- works")
    file(APPEND ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/CMakeOutput.log
      "Determining if the CUDA compiler works passed with "
      "the following output:\n${__CMAKE_CUDA_COMPILER_OUTPUT}\n\n")
  endif()

  # Try to identify the ABI and configure it into CMakeCUDACompiler.cmake
  include(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerABI.cmake)
  CMAKE_DETERMINE_COMPILER_ABI(CUDA ${CMAKE_ROOT}/Modules/CMakeCUDACompilerABI.cu)

  # Re-configure to save learned information.
  configure_file(
    ${CMAKE_ROOT}/Modules/CMakeCUDACompiler.cmake.in
    ${CMAKE_PLATFORM_INFO_DIR}/CMakeCUDACompiler.cmake
    @ONLY IMMEDIATE # IMMEDIATE must be here for compatibility mode <= 2.0
    )
  include(${CMAKE_PLATFORM_INFO_DIR}/CMakeCUDACompiler.cmake)

  if(CMAKE_CUDA_SIZEOF_DATA_PTR)
    foreach(f ${CMAKE_CUDA_ABI_FILES})
      include(${f})
    endforeach()
    unset(CMAKE_CUDA_ABI_FILES)
  endif()
endif()
