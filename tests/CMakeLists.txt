cmake_minimum_required (VERSION 2.6)
project (test_lexer)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

find_package(RE2C REQUIRED)

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} -std=c++14")

# Run RE2C to generate the lexer
add_custom_command (
  OUTPUT lexer.cpp
  COMMAND ${RE2C} -o lexer.cpp ${PROJECT_SOURCE_DIR}/../lexer.re
  MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/../lexer.re
  )

# Run bison to generate the parser
add_custom_command (
  OUTPUT parser.cpp tokens.h
  COMMAND bison -o parser.cpp -rall --defines=tokens.h ${PROJECT_SOURCE_DIR}/../parser.y
  MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/../parser.y
  )
  
include_directories(${PROJECT_SOURCE_DIR})
include_directories(${PROJECT_SOURCE_DIR}/../)
include_directories(${PROJECT_SOURCE_DIR}/build)


add_executable(test_parser lexer.cpp parser.cpp
                          main.cpp)