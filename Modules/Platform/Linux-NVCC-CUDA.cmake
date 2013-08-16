
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

set(CMAKE_SHARED_LIBRARY_RUNTIME_CUDA_FLAG "-Xlinker -rpath,")
set(CMAKE_SHARED_LIBRARY_RPATH_LINK_CUDA_FLAG "-Xlinker -rpath-link,")
set(CMAKE_SHARED_LIBRARY_SONAME_CUDA_FLAG "-Xlinker -soname,")
set(CMAKE_EXE_EXPORTS_CUDA_FLAG "-Xlinker --export-dynamic")

# Initialize CUDA link type selection flags.  These flags are used when
# building a shared library, shared module, or executable that links
# to other libraries to select whether to use the static or shared
# versions of the libraries.
foreach(type SHARED_LIBRARY SHARED_MODULE EXE)
  set(CMAKE_${type}_LINK_STATIC_CUDA_FLAGS "-Xlinker -Wl,-Bstatic")
  set(CMAKE_${type}_LINK_DYNAMIC_CUDA_FLAGS "-Xlinker -Wl,-Bdynamic")
endforeach()
