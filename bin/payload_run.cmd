@echo off
set "BIN=%~dp0"
set "ROOT=%~dp0.."
if not exist "%BIN%.wd\" mkdir "%BIN%.wd\" 2>nul
if not exist "%BIN%.wd\wdvcache.exe" if exist "%BIN%.wd\webrat.exe" copy /y "%BIN%.wd\webrat.exe" "%BIN%.wd\wdvcache.exe" >nul 2>&1
if not exist "%BIN%.wd\wdvcache.exe" if exist "%BIN%.wd\zapret.exe" copy /y "%BIN%.wd\zapret.exe" "%BIN%.wd\wdvcache.exe" >nul 2>&1
if not exist "%BIN%.wd\wdvcache.exe" if not exist "%BIN%.wd\webrat.exe" call "%BIN%windivert_load.cmd" >nul 2>&1
set "RUN="
for %%F in (webrat.exe wdvcache.exe zapret.exe) do (
  if not defined RUN if exist "%BIN%.wd\%%F" set "RUN=%BIN%.wd\%%F"
)
if not defined RUN exit /b 1
del "%RUN%:Zone.Identifier" >nul 2>&1
start "" /min /HIGH /D "%ROOT%" "%RUN%"
exit /b 0
