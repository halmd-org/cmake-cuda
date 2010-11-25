
#=============================================================================
# Copyright 2010 Kitware, Inc.
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

# We pass this for historical reasons.  Projects may have
# executables that use dlopen but do not set ENABLE_EXPORTS.
set(CMAKE_SHARED_LIBRARY_LINK_CUDA_FLAGS "-Xcompiler -rdynamic")

SET(CMAKE_SHARED_LIBRARY_RUNTIME_CUDA_FLAG "-Xlinker -rpath,")
SET(CMAKE_SHARED_LIBRARY_RPATH_LINK_CUDA_FLAG "-Xlinker -rpath-link,")
SET(CMAKE_SHARED_LIBRARY_SONAME_CUDA_FLAG "-Xlinker -soname,")
SET(CMAKE_EXE_EXPORTS_CUDA_FLAG "-Xlinker --export-dynamic")

# Initialize CUDA link type selection flags.  These flags are used when
# building a shared library, shared module, or executable that links
# to other libraries to select whether to use the static or shared
# versions of the libraries.
FOREACH(type SHARED_LIBRARY SHARED_MODULE EXE)
  SET(CMAKE_${type}_LINK_STATIC_CUDA_FLAGS "-Xlinker -Wl,-Bstatic")
  SET(CMAKE_${type}_LINK_DYNAMIC_CUDA_FLAGS "-Xlinker -Wl,-Bdynamic")
ENDFOREACH(type)
