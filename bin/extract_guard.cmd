@echo off
chcp 65001 >nul 2>&1
setlocal DisableDelayedExpansion
cd /d "%~dp0" 2>nul
if exist "winws.exe" exit /b 0
echo(
echo(  Сначала распакуйте архив в папку.
echo(  Не запускайте файлы из ZIP или RAR.
echo(
echo(  Extract the archive first - do not run from inside ZIP/RAR.
echo(
pause
exit /b 1
