@echo off

:: Store original directory
set "ORIGINAL_DIR=%CD%"

:: Get script directory using %~dp0 (includes trailing backslash)
set "SCRIPT_DIR=%~dp0"
:: Remove trailing backslash
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Set relative path for config.json
set "RELATIVE_PATH=%SCRIPT_DIR%\..\config.json"

:: Run python script
python "%SCRIPT_DIR%\config_manager.py" --config="%RELATIVE_PATH%" --mode=deploy

:: Return to original directory
cd /d "%ORIGINAL_DIR%"
