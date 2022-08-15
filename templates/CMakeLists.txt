cmake_minimum_required(VERSION "3.14.2")
project(TODO)

include_directories()

aux_source_directory(. SRC)

add_executable(${PROJECT_NAME} $SRC)

target_link_libraries(${PROJECT_NAME} TODO)