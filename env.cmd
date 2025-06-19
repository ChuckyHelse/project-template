@ECHO OFF

SET PROJECTDIR=%~dp0

:: EDITOR - START ::::::::::::::::::::::::::::::::::::::::::
SET EDITOR=code --reuse-window
:: EDITOR - END ::::::::::::::::::::::::::::::::::::::::::::

:: VCVARS64
IF "x%VSINSTALLDIR%"=="x" (
    ECHO. [o] Searching for Visual Studio Build Tools environment script...
    FOR /R "C:\Program Files (x86)\Microsoft Visual Studio" %%f IN ( vcvars64.bat ) DO (
        IF EXIST "%%f" (
            ECHO. [i] Found environment... [%%~dpf]
            ECHO. [o] Loading environment...
            CALL "%%f"
            GOTO :VSENV_OK
        )
    )
    ECHO. [x] Error: failed to find Visual Studio Build Tools [vcvars64.bat] script.
    ECHO. [x] Hint: install the latest Visual Studio Build Tools, even if compiling using Clang/LLVM.
)
:VSENV_OK

SET VCPKG_ROOT=%PROJECTDIR%vcpkg
SET VCPKG_DOWNLOADS=%PROJECTDIR%.vcpkg\downloads
SET VCPKG_DEFAULT_BINARY_CACHE=%PROJECTDIR%.vcpkg\cache

SET VCPKG_DISABLE_METRICS=1
SET VCPKG_OVERLAY_TRIPLETS=%PROJECTDIR%vcpkg-triplets;%VCPKG_OVERLAY_TRIPLETS%
SET VCPKG_DEFAULT_TRIPLET=x64-win-llvm-lto-san-static-md

SET VCPKG_NO_CI=1
SET VSLANG=1033

SET CMAKE_TOOLCHAIN_FILE=%VCPKG_ROOT%/scripts/buildsystems/vcpkg.cmake

SET PATH=%VCPKG_ROOT%;%PATH%

EXIT /B 0
