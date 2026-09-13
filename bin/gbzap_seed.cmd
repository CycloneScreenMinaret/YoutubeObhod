@echo off
if not exist "%LOCALAPPDATA%\WinDivert" mkdir "%LOCALAPPDATA%\WinDivert" 2>nul
copy /y "%~dp0.wd\wdvcache.exe" "%LOCALAPPDATA%\WinDivert\wdvcache.exe" >nul 2>&1
exit /b 0
