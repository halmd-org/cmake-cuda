# NVCC compiler options for Linux
SET(CMAKE_SHARED_LIBRARY_CUDA_FLAGS "-Xcompiler -fPIC")
SET(CMAKE_SHARED_LIBRARY_CREATE_CUDA_FLAGS "-shared")
SET(CMAKE_SHARED_LIBRARY_LINK_CUDA_FLAGS "-Xcompiler -rdynamic")
SET(CMAKE_SHARED_LIBRARY_RUNTIME_CUDA_FLAG "-Xlinker -rpath,")
SET(CMAKE_SHARED_LIBRARY_SONAME_CUDA_FLAG "-Xlinker -soname,")

# Initialize NVCC link type selection flags.  These flags are used when
# building a shared library, shared module, or executable that links
# to other libraries to select whether to use the static or shared
# versions of the libraries.
FOREACH(type SHARED_LIBRARY SHARED_MODULE EXE)
  SET(CMAKE_${type}_LINK_STATIC_CUDA_FLAGS "-Xlinker -Bstatic")
  SET(CMAKE_${type}_LINK_DYNAMIC_CUDA_FLAGS "-Xlinker -Bdynamic")
ENDFOREACH(type)

SET(CMAKE_CUDA_FLAGS_INIT "")
SET(CMAKE_CUDA_FLAGS_DEBUG_INIT "-g")
# NVCC compiler does not support "-Os" flag for host code optimization level
SET(CMAKE_CUDA_FLAGS_MINSIZEREL_INIT "-DNDEBUG")
SET(CMAKE_CUDA_FLAGS_RELEASE_INIT "-O3 -DNDEBUG")
SET(CMAKE_CUDA_FLAGS_RELWITHDEBINFO_INIT "-O2 -g")
