@echo off
set "gameFlagFile=%~dp0..\utils\game_filter.enabled"
set "LISTS_PATH=%~dp0..\lists\"
if not exist "%gameFlagFile%" (
  set "GameFilterStatus=disabled"
  set "GameFilter=12"
  set "GameFilterTCP=12"
  set "GameFilterUDP=12"
  goto _gbzap_lists_users
)
set "GameFilterMode="
for /f "usebackq delims=" %%A in ("%gameFlagFile%") do (
  if not defined GameFilterMode set "GameFilterMode=%%A"
)
if /i "%GameFilterMode%"=="all" (
  set "GameFilterStatus=enabled (TCP and UDP)"
  set "GameFilter=1024-65535"
  set "GameFilterTCP=1024-65535"
  set "GameFilterUDP=1024-65535"
) else if /i "%GameFilterMode%"=="tcp" (
  set "GameFilterStatus=enabled (TCP)"
  set "GameFilter=1024-65535"
  set "GameFilterTCP=1024-65535"
  set "GameFilterUDP=12"
) else (
  set "GameFilterStatus=enabled (UDP)"
  set "GameFilter=1024-65535"
  set "GameFilterTCP=12"
  set "GameFilterUDP=1024-65535"
)
:_gbzap_lists_users
if not exist "%LISTS_PATH%ipset-exclude-user.txt" (
  echo 203.0.113.113/32>"%LISTS_PATH%ipset-exclude-user.txt"
)
if not exist "%LISTS_PATH%list-general-user.txt" (
  echo # Never leave this file empty>"%LISTS_PATH%list-general-user.txt"
  echo domain.example.abc>>"%LISTS_PATH%list-general-user.txt"
)
if not exist "%LISTS_PATH%list-exclude-user.txt" (
  echo domain.example.abc>"%LISTS_PATH%list-exclude-user.txt"
)
exit /b 0
