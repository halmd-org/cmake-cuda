#=============================================================================
# CMake - Cross Platform Makefile Generator
# Copyright 2000-2009 Kitware, Inc., Insight Software Consortium
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================

set( CURSES_SRCS
              CursesDialog/cmCursesBoolWidget
              CursesDialog/cmCursesCacheEntryComposite
              CursesDialog/cmCursesDummyWidget
              CursesDialog/cmCursesFilePathWidget
              CursesDialog/cmCursesForm
              CursesDialog/cmCursesLabelWidget
              CursesDialog/cmCursesLongMessageForm
              CursesDialog/cmCursesMainForm
              CursesDialog/cmCursesPathWidget
              CursesDialog/cmCursesStringWidget
              CursesDialog/cmCursesWidget
              CursesDialog/ccmake
   )

include_directories(${CMake_SOURCE_DIR}/Source/CursesDialog/form
                    ${CMake_BINARY_DIR}/Source/CursesDialog/form)
include_directories(${CURSES_INCLUDE_PATH})


add_executable(ccmake ${CURSES_SRCS} )
target_link_libraries(ccmake CMakeLib)
target_link_libraries(ccmake cmForm)

install(TARGETS ccmake DESTINATION bin)
