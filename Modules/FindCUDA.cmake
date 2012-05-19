# - Find CUDA
# Find the NVIDIA CUDA includes and libraries
#
# This module defines
#  CUDA_FOUND
#  CUDA_INCLUDE_DIR
#  CUDA_LIBRARIES
#  CUDA_CUDA_FOUND
#  CUDA_CUDA_LIBRARY
#  CUDA_CUDART_FOUND
#  CUDA_CUDART_LIBRARY
#

#=============================================================================
# Copyright 2002-2009 Kitware, Inc.
# Copyright 2008-2012 Peter Colberg
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

if(NOT CUDA_FIND_COMPONENTS)
  set(CUDA_FIND_COMPONENTS cuda cudart)
  if(CUDA_FIND_REQUIRED)
    foreach(comp ${CUDA_FIND_COMPONENTS})
      set(CUDA_FIND_REQUIRED_${comp} TRUE)
    endforeach()
  endif()
endif()

find_path(CUDA_INCLUDE_DIR cuda_runtime.h
  HINTS
  $ENV{CUDA_TOOLKIT_ROOT_DIR}
  PATH_SUFFIXES include/cuda include
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr/local/cuda
  /usr
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
  /opt
  /opt/cuda
)
mark_as_advanced(CUDA_INCLUDE_DIR)

set(CUDA_LIBRARIES)

foreach(comp ${CUDA_FIND_COMPONENTS})
  string(TOUPPER ${comp} var)
  find_library(CUDA_${var}_LIBRARY NAMES ${comp}
    HINTS
    $ENV{CUDA_TOOLKIT_ROOT_DIR}
    PATH_SUFFIXES lib64 lib
    PATHS
    ~/Library/Frameworks
    /Library/Frameworks
    /usr/local
    /usr/local/cuda
    /usr
    /sw # Fink
    /opt/local # DarwinPorts
    /opt/csw # Blastwave
    /opt
    /opt/cuda
  )
  mark_as_advanced(CUDA_${var}_LIBRARY)
  if(CUDA_${var}_LIBRARY)
    list(APPEND CUDA_LIBRARIES ${CUDA_${var}_LIBRARY})
    set(CUDA_${var}_FOUND TRUE)
    set(CUDA_${comp}_FOUND TRUE)
  else()
    set(CUDA_${var}_FOUND FALSE)
    set(CUDA_${comp}_FOUND FALSE)
  endif()
  unset(var)
endforeach()

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)

find_package_handle_standard_args(CUDA HANDLE_COMPONENTS REQUIRED_VARS CUDA_INCLUDE_DIR)

foreach(comp ${CUDA_FIND_COMPONENTS})
  unset(CUDA_${comp}_FOUND)
endforeach()
