# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.17

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/Cellar/cmake/3.17.3/bin/cmake

# The command to remove a file.
RM = /usr/local/Cellar/cmake/3.17.3/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android/build/make-cache

# Include any dependencies generated for this target.
include CMakeFiles/term.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/term.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/term.dir/flags.make

CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.o: CMakeFiles/term.dir/flags.make
CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.o: /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android/build/make-cache/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.o"
	/Users/nightmare/Library/Android/sdk/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang --target=aarch64-none-linux-android21 --gcc-toolchain=/Users/nightmare/Library/Android/sdk/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64 --sysroot=/Users/nightmare/Library/Android/sdk/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/sysroot $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.o   -c /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c

CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.i"
	/Users/nightmare/Library/Android/sdk/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang --target=aarch64-none-linux-android21 --gcc-toolchain=/Users/nightmare/Library/Android/sdk/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64 --sysroot=/Users/nightmare/Library/Android/sdk/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/sysroot $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c > CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.i

CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.s"
	/Users/nightmare/Library/Android/sdk/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang --target=aarch64-none-linux-android21 --gcc-toolchain=/Users/nightmare/Library/Android/sdk/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64 --sysroot=/Users/nightmare/Library/Android/sdk/ndk/21.3.6528147/toolchains/llvm/prebuilt/darwin-x86_64/sysroot $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c -o CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.s

# Object files for target term
term_OBJECTS = \
"CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.o"

# External object files for target term
term_EXTERNAL_OBJECTS =

term: CMakeFiles/term.dir/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/src/night.c.o
term: CMakeFiles/term.dir/build.make
term: CMakeFiles/term.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android/build/make-cache/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable term"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/term.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/term.dir/build: term

.PHONY : CMakeFiles/term.dir/build

CMakeFiles/term.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/term.dir/cmake_clean.cmake
.PHONY : CMakeFiles/term.dir/clean

CMakeFiles/term.dir/depend:
	cd /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android/build/make-cache && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android/build/make-cache /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android/build/make-cache /Users/nightmare/Desktop/nightmare-space/nightmare_tool_cli/src/android/build/make-cache/CMakeFiles/term.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/term.dir/depend

