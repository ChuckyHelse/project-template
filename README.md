# Platform-Specific Build Instructions

This document provides comprehensive build instructions for the project on different platforms, including Windows, Linux, and macOS.

## Prerequisites
- CMake (version 3.19 or higher)
- Compiler (GCC for Linux, Clang for macOS, MSVC for Windows)
- Ninja (optional, for faster builds)
- Make (optional for Linux)
- Visual Studio (for Windows, optional)
- Xcode (for macOS, optional)

## Windows Build Instructions
1. **Install Prerequisites**:
   - Download and install [Visual Studio](https://visualstudio.microsoft.com/downloads/) with C++ development tools.
   - Install CMake from [here](https://cmake.org/download/).

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/ChuckyHelse/project-template.git
   cd project-template
   ```

3. **Create a Build Directory**:
   ```bash
   mkdir build && cd build
   ```

4. **Configure the Project with CMake**:
   - Using Visual Studio:
   ```bash
   cmake .. -G "Visual Studio 16 2019"
   ```  
   - Using Ninja:
   ```bash
   cmake .. -G Ninja
   ```

5. **Build the Project**:
   - Using Visual Studio:
   ```bash
   cmake --build . --config Release
   ```
   - Using Ninja:
   ```bash
   ninja
   ```

## Linux Build Instructions
1. **Install Prerequisites**:
   ```bash
   sudo apt install build-essential cmake ninja-build
   ```

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/ChuckyHelse/project-template.git
   cd project-template
   ```

3. **Create a Build Directory**:
   ```bash
   mkdir build && cd build
   ```

4. **Configure the Project with CMake**:
   ```bash
   cmake .. -G Ninja
   ```

5. **Build the Project**:
   ```bash
   ninja
   ```

## macOS Build Instructions
1. **Install Prerequisites**:
   ```bash
   brew install cmake ninja
   ```

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/ChuckyHelse/project-template.git
   cd project-template
   ```

3. **Create a Build Directory**:
   ```bash
   mkdir build && cd build
   ```

4. **Configure the Project with CMake**:
   ```bash
   cmake .. -G Ninja
   ```

5. **Build the Project**:
   ```bash
   ninja
   ```

## CMake Presets Usage
- You can define `CMakePresets.json` and use custom presets for different build configurations.
- Presets streamline the build configuration process and allow for easier switching between different settings.

## Debug vs Release Configurations
- **Debug Configuration**: Enables debugging symbols and disables optimizations.
- **Release Configuration**: Optimizes the code for performance, suitable for production.

You can specify the configuration like this:
```bash
cmake --build . --config Debug
```

## Dependency Customization
- You can customize dependencies using CMake options. Simply pass them during configuration:
```bash
cmake .. -DOPTION_NAME=VALUE
```

## Troubleshooting
- If you experience issues during building or generating the project files, make sure:
  - All prerequisites are installed.
  - You're in the correct directory.
  - You're using a compatible version of CMake and the compiler.
  - Check logs for any error messages to guide troubleshooting steps.