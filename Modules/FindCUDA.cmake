# - Find CUDA
# Find the NVIDIA CUDA includes and libraries
#
# This module defines
#  CUDA_FOUND
#  CUDA_INCLUDE_DIR
#  CUDA_LIBRARIES
#  CUDA_LIBRARY
#  CUDA_RUNTIME_LIBRARY
#

#=============================================================================
# Copyright 2002-2009 Kitware, Inc.
# Copyright 2008-2011 Peter Colberg
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

FIND_PATH(CUDA_INCLUDE_DIR cuda_runtime.h
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

FIND_LIBRARY(CUDA_LIBRARY NAMES cuda
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

FIND_LIBRARY(CUDA_RUNTIME_LIBRARY NAMES cudart
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

IF(CUDA_LIBRARY AND CUDA_RUNTIME_LIBRARY)
  SET(CUDA_LIBRARIES ${CUDA_LIBRARY} ${CUDA_RUNTIME_LIBRARY})
ENDIF()

INCLUDE(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(CUDA DEFAULT_MSG
  CUDA_INCLUDE_DIR
  CUDA_LIBRARY
  CUDA_RUNTIME_LIBRARY
)

MARK_AS_ADVANCED(
  CUDA_INCLUDE_DIR
  CUDA_LIBRARY
  CUDA_RUNTIME_LIBRARY
)
