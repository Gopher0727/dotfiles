cmake_minimum_required(VERSION 3.10)
project(MyProject C CXX)

if(DEFINED ENV{CC})
  set(CMAKE_C_COMPILER $ENV{CC})
else()
  set(CMAKE_C_COMPILER /opt/homebrew/bin/gcc-16)
endif()
if(DEFINED ENV{CXX})
  set(CMAKE_CXX_COMPILER $ENV{CXX})
else()
  set(CMAKE_CXX_COMPILER /opt/homebrew/bin/g++-16)
endif()

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
add_compile_definitions(LOCAL)

find_program(CCACHE ccache)
if(CCACHE)
  set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
endif()

add_executable(main 
  main.cpp
  # main.c
)
