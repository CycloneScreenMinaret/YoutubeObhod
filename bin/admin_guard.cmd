@echo off
fsutil dirty query %systemdrive% >nul 2>&1
if %errorlevel%==0 exit /b 0
if not exist "%~f1" exit /b 1
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process -LiteralPath '%~f1' -WorkingDirectory '%~dp1.' -Verb RunAs"
exit /b 0
