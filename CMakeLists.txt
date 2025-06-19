cmake_minimum_required(VERSION 3.19)

project(my-application VERSION 1.0 LANGUAGES CXX)

if(NOT DEFINED CURRENT_PRESET)
  message(FATAL_ERROR "Variable CURRENT_PRESET is undefined. Please run CMake with the required preset. For instance: cmake --preset vcpkg")
endif()
message(STATUS "Current Preset: ${CURRENT_PRESET}")

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_SOURCE_DIR}/vcpkg/scripts/buildsystems/vcpkg.cmake"
        CACHE STRING "Toolchain file for vcpkg")
endif()

set(CMAKE_CXX_STANDARD 17)
set(BUILD_SHARED_LIBS OFF)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

add_executable(my-application "${CMAKE_CURRENT_SOURCE_DIR}/src/main.cpp")
target_precompile_headers(my-application PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/src/pch.hpp")

# header-only version
find_package(spdlog CONFIG REQUIRED)
target_link_libraries(my-application PRIVATE spdlog::spdlog_header_only)

# header-only version
find_package(fmt CONFIG REQUIRED)
target_link_libraries(my-application PRIVATE fmt::fmt-header-only)

# header-only version
find_package(glm CONFIG REQUIRED)
target_link_libraries(my-application PRIVATE glm::glm-header-only)

find_package(SDL3 CONFIG REQUIRED)
target_link_libraries(my-application PRIVATE SDL3::SDL3)

# this is heuristically generated, and may not be correct
find_package(imgui CONFIG REQUIRED)
target_link_libraries(my-application PRIVATE imgui::imgui)

find_package(SDL3_image CONFIG REQUIRED)
target_link_libraries(my-application PRIVATE $<IF:$<TARGET_EXISTS:SDL3_image::SDL3_image-shared>,SDL3_image::SDL3_image-shared,SDL3_image::SDL3_image-static>)

find_package(SDL3_ttf CONFIG REQUIRED)
target_link_libraries(my-application PRIVATE SDL3_ttf::SDL3_ttf)
