set(CVSROOT ":pserver:anonymous@cmake.org:/cmake.git")

get_filename_component(SCRIPT_PATH "${CMAKE_CURRENT_LIST_FILE}" PATH)

# default to self extracting tgz, tgz, and tar.Z
if(NOT DEFINED CPACK_BINARY_GENERATORS)
  set(CPACK_BINARY_GENERATORS "STGZ TGZ TZ")
endif(NOT DEFINED CPACK_BINARY_GENERATORS)
if(DEFINED EXTRA_COPY)
  set(HAS_EXTRA_COPY 1)
endif(DEFINED EXTRA_COPY)
if(NOT DEFINED CMAKE_RELEASE_DIRECTORY)
  set(CMAKE_RELEASE_DIRECTORY "~/CMakeReleaseDirectory")
endif(NOT DEFINED CMAKE_RELEASE_DIRECTORY)
if(NOT DEFINED SCRIPT_NAME)
  set(SCRIPT_NAME "${HOST}")
endif(NOT DEFINED SCRIPT_NAME)
if(NOT DEFINED MAKE_PROGRAM)
  message(FATAL_ERROR "MAKE_PROGRAM must be set")
endif(NOT DEFINED MAKE_PROGRAM)
if(NOT DEFINED MAKE)
  set(MAKE "${MAKE_PROGRAM}")
endif(NOT DEFINED MAKE)
if(NOT DEFINED RUN_SHELL)
  set(RUN_SHELL "/bin/sh")
endif(NOT DEFINED RUN_SHELL)
if(NOT DEFINED PROCESSORS)
  set(PROCESSORS 1)
endif(NOT DEFINED PROCESSORS)
if(NOT DEFINED CMAKE_CREATE_VERSION)
  message(FATAL_ERROR "CMAKE_CREATE_VERSION not defined")
endif(NOT DEFINED CMAKE_CREATE_VERSION)
if(NOT DEFINED CVS_COMMAND)
  set(CVS_COMMAND cvs)
endif(NOT DEFINED CVS_COMMAND)

if(${CMAKE_CREATE_VERSION} MATCHES "^(release|maint|next)$")
  set(GIT_BRANCH origin/${CMAKE_CREATE_VERSION})
else()
  set(GIT_BRANCH ${CMAKE_CREATE_VERSION})
endif()
set( CMAKE_CHECKOUT "${CVS_COMMAND} -q -d ${CVSROOT} co -d ${CMAKE_CREATE_VERSION} ${CMAKE_CREATE_VERSION}")


if(NOT DEFINED FINAL_PATH )
  set(FINAL_PATH ${CMAKE_RELEASE_DIRECTORY}/${CMAKE_CREATE_VERSION}-build)
endif(NOT DEFINED FINAL_PATH )

if(NOT HOST)
  message(FATAL_ERROR "HOST must be specified with -DHOST=host")
endif(NOT HOST)
if(NOT DEFINED MAKE)
  message(FATAL_ERROR "MAKE must be specified with -DMAKE=\"make -j2\"")
endif(NOT DEFINED MAKE)
  
message("Creating CMake release ${CMAKE_CREATE_VERSION} on ${HOST} with parallel = ${PROCESSORS}")

# define a macro to run a remote command
macro(remote_command comment command)
  message("${comment}")
  if(${ARGC} GREATER 2)
    message("ssh ${HOST} ${EXTRA_HOP} ${command}")
    execute_process(COMMAND ssh ${HOST} ${EXTRA_HOP} ${command} RESULT_VARIABLE result INPUT_FILE ${ARGV2})
  else(${ARGC} GREATER 2)
    message("ssh ${HOST} ${EXTRA_HOP} ${command}") 
    execute_process(COMMAND ssh ${HOST} ${EXTRA_HOP} ${command} RESULT_VARIABLE result) 
  endif(${ARGC} GREATER 2)
  if(${result} GREATER 0)
    message(FATAL_ERROR "Error running command: ${command}, return value = ${result}")
  endif(${result} GREATER 0)
endmacro(remote_command)

# set this so configure file will work from script mode
# create the script specific for the given host
set(SCRIPT_FILE release_cmake-${SCRIPT_NAME}.sh)
configure_file(${SCRIPT_PATH}/release_cmake.sh.in ${SCRIPT_FILE} @ONLY)

# run the script by starting a shell on the remote machine
# then using the script file as input to the shell
IF(RUN_LOCAL)
  message(FATAL_ERROR "run this command: ${RUN_SHELL} ${SCRIPT_FILE}")
ELSE(RUN_LOCAL)
  remote_command("run release_cmake-${HOST}.sh on server"
    "${RUN_SHELL}" ${SCRIPT_FILE})
ENDIF(RUN_LOCAL)

# now figure out which types of packages were created 
set(generators ${CPACK_BINARY_GENERATORS} ${CPACK_SOURCE_GENERATORS})
separate_arguments(generators)
foreach(gen ${generators})
  if("${gen}" STREQUAL "TGZ")
    set(SUFFIXES ${SUFFIXES} "*.tar.gz")
  endif("${gen}" STREQUAL "TGZ")
  if("${gen}" STREQUAL "STGZ")
    set(SUFFIXES ${SUFFIXES} "*.sh")
  endif("${gen}" STREQUAL "STGZ")
  if("${gen}" STREQUAL "PackageMaker")
    set(SUFFIXES ${SUFFIXES} "*.dmg")
  endif("${gen}" STREQUAL "PackageMaker")
  if("${gen}" STREQUAL "TBZ2")
    set(SUFFIXES ${SUFFIXES} "*.tar.bz2")
  endif("${gen}" STREQUAL "TBZ2")
  if("${gen}" MATCHES "Cygwin")
    set(SUFFIXES ${SUFFIXES} "*.tar.bz2")
    set(extra_files setup.hint)
  endif("${gen}" MATCHES "Cygwin")
  if("${gen}" STREQUAL "TZ")
    set(SUFFIXES ${SUFFIXES} "*.tar.Z")
  endif("${gen}" STREQUAL "TZ")
  if("${gen}" STREQUAL "ZIP")
    set(SUFFIXES ${SUFFIXES} "*.zip")
  endif("${gen}" STREQUAL "ZIP")
  if("${gen}" STREQUAL "NSIS")
    set(SUFFIXES ${SUFFIXES} "*.exe")
  endif("${gen}" STREQUAL "NSIS")
endforeach(gen)
# copy all the files over from the remote machine
set(PROJECT_PREFIX cmake-)
foreach(suffix ${SUFFIXES})
  message("scp ${HOST}:${FINAL_PATH}/${PROJECT_PREFIX}${suffix} .")
  execute_process(COMMAND 
    scp ${HOST}:${FINAL_PATH}/${PROJECT_PREFIX}${suffix} .
    RESULT_VARIABLE result)   
  if(${result} GREATER 0)
    message("error getting file back scp ${HOST}:${FINAL_PATH}/${PROJECT_PREFIX}${suffix} .")
  endif(${result} GREATER 0)
endforeach(suffix)

# if there are extra files to copy get them as well
if(extra_files)
  foreach(f ${extra_files})
    message("scp ${HOST}:${FINAL_PATH}/${f} .")
    execute_process(COMMAND 
      scp ${HOST}:${FINAL_PATH}/${f} .
      RESULT_VARIABLE result)
    if(${result} GREATER 0)
      message("error getting file back scp ${HOST}:${FINAL_PATH}/${f} .")
    endif(${result} GREATER 0)
  endforeach(f)
endif(extra_files)
