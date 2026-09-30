cmake_minimum_required(VERSION 3.16)

project(SPREAD_Backend)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(spread_backend
    src/main.cpp
)

target_include_directories(spread_backend PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
)