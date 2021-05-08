cmake_minimum_required (VERSION 2.6) # cmake version

project(timecli) # project name

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/$ENV{ABI}) # set output path

aux_source_directory(${PROJECT_SOURCE_DIR}/../timecli SRC_FILES) # scan source code files

add_executable(term ${SRC_FILES}) # add source code files to library, and set build type to dynamic library.
