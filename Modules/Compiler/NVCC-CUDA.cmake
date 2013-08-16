
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

# Feature flags.
set(CMAKE_CUDA_VERBOSE_FLAG "-v")
set(CMAKE_SHARED_LIBRARY_CUDA_FLAGS "-Xcompiler -fPIC")
set(CMAKE_SHARED_LIBRARY_CREATE_CUDA_FLAGS "-shared")

# Initial configuration flags.
set(CMAKE_CUDA_FLAGS_INIT "")
set(CMAKE_CUDA_FLAGS_DEBUG_INIT "-g")
# NVCC compiler does not support "-Os" flag for host code optimization level
set(CMAKE_CUDA_FLAGS_MINSIZEREL_INIT "-DNDEBUG")
set(CMAKE_CUDA_FLAGS_RELEASE_INIT "-O3 -DNDEBUG")
set(CMAKE_CUDA_FLAGS_RELWITHDEBINFO_INIT "-O2 -g -DNDEBUG")
set(CMAKE_CUDA_CREATE_PREPROCESSED_SOURCE "<CMAKE_CUDA_COMPILER> <DEFINES> <FLAGS> -E <SOURCE> > <PREPROCESSED_SOURCE>")
set(CMAKE_CUDA_CREATE_ASSEMBLY_SOURCE "<CMAKE_CUDA_COMPILER> <DEFINES> <FLAGS> -ptx <SOURCE> -o <ASSEMBLY_SOURCE>")
