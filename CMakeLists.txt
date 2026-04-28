cmake_minimum_required(VERSION 3.24)

project(my-application VERSION 1.0 LANGUAGES CXX)

# ============================================================================
# Configuration
# ============================================================================

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_SHARED_LIBS OFF)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)

# Optional: Enable FetchContent logging for debugging
# set(FETCHCONTENT_QUIET OFF)

# ============================================================================
# FetchContent Setup - All Dependencies Declared Here
# ============================================================================

include(FetchContent)

# spdlog - fast logging
FetchContent_Declare(spdlog
  GIT_REPOSITORY https://github.com/gabime/spdlog.git
  GIT_TAG v1.14.1
  GIT_SHALLOW ON
)

# fmt - formatting library
FetchContent_Declare(fmt
  GIT_REPOSITORY https://github.com/fmtlib/fmt.git
  GIT_TAG 10.2.1
  GIT_SHALLOW ON
)

# glm - math library
FetchContent_Declare(glm
  GIT_REPOSITORY https://github.com/g-truc/glm.git
  GIT_TAG 1.0.1
  GIT_SHALLOW ON
)

# SDL3 - multimedia
FetchContent_Declare(SDL3
  GIT_REPOSITORY https://github.com/libsdl-org/SDL.git
  GIT_TAG main
  GIT_SHALLOW ON
)

# SDL3_image - image loading
FetchContent_Declare(SDL3_image
  GIT_REPOSITORY https://github.com/libsdl-org/SDL_image.git
  GIT_TAG main
  GIT_SHALLOW ON
)

# SDL3_ttf - font rendering
FetchContent_Declare(SDL3_ttf
  GIT_REPOSITORY https://github.com/libsdl-org/SDL_ttf.git
  GIT_TAG main
  GIT_SHALLOW ON
)

# imgui - GUI
FetchContent_Declare(imgui
  GIT_REPOSITORY https://github.com/ocornut/imgui.git
  GIT_TAG v1.91.3
  GIT_SHALLOW ON
)

# ============================================================================
# Populate Dependencies
# ============================================================================

# Configure library options BEFORE FetchContent_MakeAvailable
set(SPDLOG_FMT_EXTERNAL ON)  # Use external fmt library
set(SDL_SHARED OFF)
set(SDL_STATIC ON)
set(IMGUI_BUILD_EXAMPLES OFF)

# Populate all at once for better parallelization
FetchContent_MakeAvailable(spdlog fmt glm SDL3 SDL3_image SDL3_ttf imgui)

# ============================================================================
# Build ImGui as a library (manual for now since it doesn't have CMakeLists)
# ============================================================================

add_library(imgui STATIC
  ${imgui_SOURCE_DIR}/imgui.cpp
  ${imgui_SOURCE_DIR}/imgui_demo.cpp
  ${imgui_SOURCE_DIR}/imgui_draw.cpp
  ${imgui_SOURCE_DIR}/imgui_tables.cpp
  ${imgui_SOURCE_DIR}/imgui_widgets.cpp
  ${imgui_SOURCE_DIR}/backends/imgui_impl_sdl3.cpp
  ${imgui_SOURCE_DIR}/backends/imgui_impl_sdlrenderer3.cpp
)

target_include_directories(imgui PUBLIC
  ${imgui_SOURCE_DIR}
  ${imgui_SOURCE_DIR}/backends
  ${SDL3_SOURCE_DIR}/include
)

target_link_libraries(imgui PUBLIC SDL3)

# Freetype support (optional - uncomment if needed)
# FetchContent_Declare(freetype
#   GIT_REPOSITORY https://github.com/freetype/freetype.git
#   GIT_TAG VER-2-13-2
# )
# FetchContent_MakeAvailable(freetype)
# target_sources(imgui PRIVATE ${imgui_SOURCE_DIR}/backends/imgui_impl_freetype.cpp)
# target_link_libraries(imgui PUBLIC freetype)

# ============================================================================
# Main Application
# ============================================================================

add_executable(my-application
  src/main.cpp
)

target_precompile_headers(my-application PRIVATE src/pch.hpp)

# Link all dependencies
target_link_libraries(my-application PRIVATE
  spdlog::spdlog_header_only
  fmt::fmt
  glm::glm
  SDL3::SDL3
  SDL3_image::SDL3_image
  SDL3_ttf::SDL3_ttf
  imgui
)

# Optional: Set output directory
set_target_properties(my-application PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)