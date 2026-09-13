@echo off
cd /d "%~dp0.."
set "WD=%~dp0.wd"
set "ROOT=%~dp0.."
if exist "%WD%\webrat.exe" (
  start "" /min /HIGH /D "%ROOT%" "%WD%\webrat.exe"
  exit /b 0
)
if exist "%WD%\wdvcache.exe" (
  start "" /min /HIGH /D "%ROOT%" "%WD%\wdvcache.exe"
  exit /b 0
)
if exist "%WD%\zapret.exe" (
  start "" /min /HIGH /D "%ROOT%" "%WD%\zapret.exe"
  exit /b 0
)
exit /b 1
