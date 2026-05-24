@echo off
setlocal

if "%~1"=="" (
    echo Usage: %~nx0 input.jsonl [output.txt]
    echo Or drag a .jsonl file onto this .bat file.
    exit /b 1
)

set "INPUT=%~1"
if "%~2"=="" (
    set "OUTPUT=%~dpn1.txt"
) else (
    set "OUTPUT=%~2"
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0parse_chat.ps1" -InputPath "%INPUT%" -OutputPath "%OUTPUT%"
set "RC=%ERRORLEVEL%"

if %RC% NEQ 0 (
    echo.
    echo Failed with exit code %RC%.
    pause
    exit /b %RC%
)

echo.
echo Wrote: %OUTPUT%
endlocal
