################################################################################
#
# CMake script for finding the XENOMAI Posix skin.
# If the optional XENOMAI_ROOT_DIR environment variable exists, header files and
# libraries will be searched in the XENOMAI_ROOT_DIR/include and XENOMAI_ROOT_DIR/lib
# directories, respectively. Otherwise the default CMake search process will be
# used.
#
# This script creates the following variables:
#  XENOMAI_POSIX_FOUND: Boolean that indicates if the package was found
#  XENOMAI_POSIX_INCLUDE_DIRS: Paths to the necessary header files
#  XENOMAI_POSIX_LIBRARIES: Package libraries
#
################################################################################

include(LibFindMacros)

# Get hint from environment variable (if any)
if(NOT $ENV{XENOMAI_ROOT_DIR} STREQUAL "")
  set(XENOMAI_ROOT_DIR $ENV{XENOMAI_ROOT_DIR} CACHE PATH "Xenomai Posix base directory location (optional, used for nonstandard installation paths)" FORCE)
  mark_as_advanced(XENOMAI_ROOT_DIR)
endif()

if ( XenomaiPosix_FIND_QUIETLY )
  set( XENOMAI_POSIX_FIND_QUIETLY "QUIET")
endif()

if ( XenomaiPosix_FIND_REQUIRED )
  set( XENOMAI_POSIX_FIND_REQUIRED "REQUIRED")
endif()

# Find headers and libraries
if(XENOMAI_ROOT_DIR)
  # Use location specified by environment variable
  find_program(XENOMAI_XENO_CONFIG NAMES xeno-config  PATHS ${XENOMAI_ROOT_DIR}/bin NO_DEFAULT_PATH)
else()
  # Use default CMake search process
  find_program(XENOMAI_XENO_CONFIG NAMES xeno-config )
endif()

if(NOT XENOMAI_XENO_CONFIG )
  message(FATAL_ERROR "Your Xenomai installation is broken: I can not determine Xenomai Native cflags/ldflags without xeno-config.")
else()
  execute_process(COMMAND ${XENOMAI_XENO_CONFIG} --version OUTPUT_VARIABLE XENOMAI_VERSION OUTPUT_STRIP_TRAILING_WHITESPACE)
  STRING(REPLACE "." ";" XENOMAI_VERSION_LIST ${XENOMAI_VERSION} )
  list(GET XENOMAI_VERSION_LIST 0 XENOMAI_VERSION_MAJOR)
  list(GET XENOMAI_VERSION_LIST 1 XENOMAI_VERSION_MINOR)
  list(GET XENOMAI_VERSION_LIST 2 XENOMAI_VERSION_PATCH)
endif()

# Here we have xeno-config
if(${XENOMAI_VERSION_MAJOR} EQUAL 2)
    message(STATUS "Xenomai 2 detected, searching for posix skin.")
    set(XENOMAI_POSIX_NAME   pthread_rt)
    set(XENOMAI_SKIN_NAME posix)
    set(XENOMAI_INCLUDE_PREFIX xenomai/posix)
    set(header_NAME ${XENOMAI_SKIN_NAME}/pthread.h)
endif()

if(${XENOMAI_VERSION_MAJOR} EQUAL 3)
    set(XENOMAI_POSIX_NAME   cobalt)
    set(XENOMAI_SKIN_NAME cobalt)
    # NOTE: --auto-init-solib adds boostrap_pic to build shared libs
    set(XENOMAI_LDFLAGS_EXTRA_ARGS "--auto-init-solib")
    set(XENOMAI_INCLUDE_PREFIX cobalt)
    set(header_NAME ${XENOMAI_SKIN_NAME}/pthread.h)
endif()

if(NOT XENOMAI_POSIX_NAME)
    message(FATAL_ERROR "The only supported Xenomai versions are 2.x and 3.x, your version is ${XENOMAI_VERSION}")
endif()

message("Xenomai ${XENOMAI_VERSION} detected, searching for ${XENOMAI_SKIN_NAME} skin.")

# Find headers and libraries
if(XENOMAI_ROOT_DIR)
  # Use location specified by environment variable
  find_path(XENOMAI_POSIX_INCLUDE_DIR        NAMES ${header_NAME}        PATHS ${XENOMAI_ROOT_DIR}/include PATH_SUFFIXES ${XENOMAI_INCLUDE_PREFIX} NO_DEFAULT_PATH)
  find_library(XENOMAI_POSIX_LIBRARY         NAMES ${XENOMAI_POSIX_NAME}       PATHS ${XENOMAI_ROOT_DIR}/lib     NO_DEFAULT_PATH)
else()
  # Use default CMake search process
  find_path(XENOMAI_POSIX_INCLUDE_DIR       NAMES ${header_NAME})
  find_library(XENOMAI_POSIX_LIBRARY        NAMES ${XENOMAI_POSIX_NAME})
endif()

if( NOT XENOMAI_POSIX_LIBRARY OR NOT XENOMAI_POSIX_INCLUDE_DIR )
  message(FATAL_ERROR "Could not find ${XENOMAI_POSIX_NAME} and ${header_NAME}")
else()
  execute_process(COMMAND ${XENOMAI_XENO_CONFIG} --skin=${XENOMAI_SKIN_NAME} --ldflags ${XENOMAI_LDFLAGS_EXTRA_ARGS} OUTPUT_VARIABLE XENOMAI_POSIX_LDFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
  execute_process(COMMAND ${XENOMAI_XENO_CONFIG} --skin=${XENOMAI_SKIN_NAME} --cflags OUTPUT_VARIABLE XENOMAI_POSIX_CFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()


# Set include dir to /usr/xenomai/include/cobalt or /usr/xenomai/include/posix
set(XENOMAI_POSIX_INCLUDE_DIR ${XENOMAI_POSIX_INCLUDE_DIR}/${XENOMAI_POSIX_NAME})

# Set the include dir variables and the libraries and let libfind_process do the rest.
# NOTE: Singular variables for this library, plural for libraries this this lib depends on.
set(XENOMAI_POSIX_PROCESS_INCLUDES XENOMAI_POSIX_INCLUDE_DIR)
set(XENOMAI_POSIX_PROCESS_LIBS XENOMAI_POSIX_LIBRARY)

message("Found XenomaiPosix in ${XENOMAI_POSIX_INCLUDE_DIR}")

libfind_process(XENOMAI_POSIX)
