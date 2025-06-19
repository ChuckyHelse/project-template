@ECHO OFF
SETLOCAL ENABLEEXTENSIONS

IF "x%VCPKG_DEFAULT_TRIPLET%"=="" (
    ECHO. [o] Loading environment...
    call env.cmd
)

ECHO. [o] Building the project...
pushd %PROJECTDIR%build >NUL:
ninja
SET RC=%ERRORLEVEL%
popd >NUL:

ECHO. [i] Done.
ENDLOCAL

EXIT /B %RC%
