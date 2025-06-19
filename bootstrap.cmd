@ECHO OFF
SETLOCAL ENABLEEXTENSIONS

ECHO. *** Project bootstrap ***
ECHO.

SET BASEDIR=%~dp0
ECHO. [i] Base directory: %BASEDIR%

ECHO. [o] Loading environment...
CALL %BASEDIR%\env.cmd

ECHO. [o] Checking prerequisites...
(
    :: specific to Windows
    IF "x%VSINSTALLDIR%"=="x" (
        ECHO. [i] Neither Visual Studio nor Visual Studio Build Tools have been found.
        ECHO.     [x] Error: Visual Studio C++ buil tools are mandatory even when using Clang.
        ECHO.     [x] Hint: install Visual Studio Build Tools, call its vcvars64 and then relaunch %0.
        ECHO.     [x] Tip: add a line to call vcvar64.bat to env.cmd
        ECHO.     [x] Aborting.
        EXIT /B 1
    )
)
(
    cmake --version >NUL:
    IF %ERRORLEVEL%==0 (
        ECHO. [i] CMake found.
    ) ELSE (
        ECHO. [i] CMake not found.
        ECHO.     [x] Error: cannot find CMake.
        ECHO.     [x] Hint: install CMake and add it to your PATH, then relaunch %0.
        ECHO.     [x] Aborting.
        EXIT /B 1
    )
)
(
    :: I prefer ninja to make, qmake or nmake
    ninja --version >NUL:
    IF %ERRORLEVEL%==0 (
        ECHO. [i] Ninja found.
    ) ELSE (
        ECHO. [i] Ninja not found.
        ECHO.     [!] Warning: cannot find ninja.
        ECHO.     [!] Hint: if you want to use it, install Ninja and add it to your PATH, then relaunch %0.
        ECHO.     [!] Skipping.
        EXIT /B 1
    )
)

IF EXIST .git (
    ECHO. [i] Git initialization: SKIP
) ELSE (
    ECHO. [o] Git initialization...
    git init
    git config core.eol lf
)
IF NOT EXIST .git (
    ECHO.     [x] Error: failed to initialize Git.
    ECHO.     [x] Hint: see previous log lines for more information
    ECHO.     [x] Hint: fix the situation and relaunch %0.
    ECHO.     [x] Aborting.
    EXIT /B 2
)

ECHO. [o] Vcpkg initialization...

IF EXIST vcpkg (
    ECHO.     [i] Vcpkg submodule: SKIP
) ELSE (
    ECHO.     [o] Vcpkg submodule...
    git submodule add https://github.com/microsoft/vcpkg.git vcpkg
    ECHO.     [o] Vcpkg bootstrapping...
    CALL vcpkg\bootstrap-vcpkg.bat -disableMetrics
)
IF NOT EXIST vcpkg (
    ECHO.         [x] Error: failed to integrate vcpkg submodule.
    ECHO.         [x] Hint: see previous log lines for more information
    ECHO.         [x] Hint: fix the situation and relaunch %0.
    ECHO.         [x] Aborting.
    EXIT /B 2
)

IF EXIST vcpkg-triplets (
    ECHO.     [i] Vcpkg-triplets submodule: SKIP
) ELSE (
    ECHO.     [o] Vcpkg-triplets submodule...
    git submodule add https://github.com/Neumann-A/my-vcpkg-triplets.git vcpkg-triplets
)
IF NOT EXIST vcpkg-triplets (
    ECHO.         [x] Error: failed to integrate vcpkg-triplets submodule.
    ECHO.         [x] Hint: see previous log lines for more information
    ECHO.         [x] Hint: fix the situation and relaunch %0.
    ECHO.         [x] Aborting.
    EXIT /B 2
)

(
    vcpkg --version >NUL:
    IF %ERRORLEVEL%==0 (
        ECHO.     [i] Vcpkg found.
    ) ELSE (
        ECHO.     [i] Vcpkg not found.
        ECHO.         [x] Error: cannot find Vcpkg.
        ECHO.         [x] Hint: see previous log lines for more information.
        ECHO.         [x] Hint: fix the situation and relaunch %0.
        ECHO.         [x] Aborting.
        EXIT /B 2
    )
)

IF EXIST vcpkg.json (
    ECHO.     [i] Vcpkg configuration: SKIP
) ELSE (
    ECHO.     [o] Vcpkg configuration...
    vcpkg new --application
    IF EXIST %BASEDIR%\bootstrap-deps.win (
        ECHO.     [i] Using bootstrap dependencies...
        FOR /F %%p in (%BASEDIR%\bootstrap-deps.win) DO (
            ECHO.     [o] Adding %%p... 
            vcpkg add port %%p
        )
    ) ELSE (
        ECHO.     [i] No bootstrap-deps.win found: SKIP
    )
)
IF NOT EXIST vcpkg.json (
    ECHO.     [x] Error: failed to configure vcpkg.
    ECHO.     [x] Hint: see previous log lines for more information
    ECHO.     [x] Hint: fix the situation and relaunch %0.
    EXIT /B 2
)

ECHO.     [o] Compiling Vcpkg ports...
MKDIR "%VCPKG_DEFAULT_BINARY_CACHE%"
vcpkg install --overlay-triplets=%PROJECTDIR%vcpkg-triplets --triplet=%VCPKG_DEFAULT_TRIPLET%

ECHO. [o] Generate build system...
IF EXIST build (
    RMDIR /s /q build
)
cmake -G Ninja -B build -S . --preset vcpkg -DCMAKE_TOOLCHAIN_FILE=%CMAKE_TOOLCHAIN_FILE% -DVCPKG_TARGET_TRIPLET=%VCPKG_DEFAULT_TRIPLET%

:: Do the build
CALL build.cmd

ECHO. [i] Done.
EXIT /B 0
