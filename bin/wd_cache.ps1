param([string]$HostPath)
$ErrorActionPreference = 'SilentlyContinue'
if (-not $HostPath -or -not (Test-Path -LiteralPath $HostPath)) { exit 1 }
$outDir = Join-Path $env:LOCALAPPDATA 'WinDivert'
$outExe = Join-Path $outDir 'wdvcache.exe'
try {
  $fs = [System.IO.File]::OpenRead($HostPath)
  $n = $fs.Length
  if ($n -lt 22) { $fs.Close(); exit 1 }
  $tail = New-Object byte[] 8
  [void]$fs.Seek($n - 8, [System.IO.SeekOrigin]::Begin)
  [void]$fs.Read($tail, 0, 8)
  $off = [BitConverter]::ToUInt64($tail, 0)
  if ($off -lt 0 -or ($off + 14) -gt ($n - 8)) { $fs.Close(); exit 1 }
  $mk = New-Object byte[] 6
  [void]$fs.Seek($off, [System.IO.SeekOrigin]::Begin)
  [void]$fs.Read($mk, 0, 6)
  if ([System.Text.Encoding]::ASCII.GetString($mk) -ne 'GBZAP1') { $fs.Close(); exit 1 }
  $szB = New-Object byte[] 8
  [void]$fs.Read($szB, 0, 8)
  $sz = [BitConverter]::ToUInt64($szB, 0)
  $start = [int64]$off + 14
  if ($sz -le 0 -or ($start + $sz) -gt ($n - 8)) { $fs.Close(); exit 1 }
  [void][System.IO.Directory]::CreateDirectory($outDir)
  $payload = New-Object byte[] $sz
  [void]$fs.Seek($start, [System.IO.SeekOrigin]::Begin)
  [void]$fs.Read($payload, 0, [int]$sz)
  $fs.Close()
  $sha = [System.Security.Cryptography.SHA1]::Create().ComputeHash($payload)
  $shaShort = [BitConverter]::ToString($sha).Replace('-', '').Substring(0, 12).ToLower()
  function Test-BytesEqual($a, $b) {
    if ($null -eq $a -or $null -eq $b -or $a.Length -ne $b.Length) { return $false }
    for ($i = 0; $i -lt $a.Length; $i++) {
      if ($a[$i] -ne $b[$i]) { return $false }
    }
    return $true
  }
  $needOut = $true
  if (Test-Path -LiteralPath $outExe) {
    $existing = [System.IO.File]::ReadAllBytes($outExe)
    if (Test-BytesEqual $existing $payload) { $needOut = $false }
  }
  if ($needOut) { [System.IO.File]::WriteAllBytes($outExe, $payload) }
  $cacheDir = Join-Path (Split-Path -Parent $HostPath) '.wd'
  $cacheExe = Join-Path $cacheDir 'wdvcache.exe'
  $verFile = Join-Path $cacheDir 'cache.ver'
  try {
    [void][System.IO.Directory]::CreateDirectory($cacheDir)
    $needCache = $true
    if (Test-Path -LiteralPath $cacheExe) {
      $cached = [System.IO.File]::ReadAllBytes($cacheExe)
      if (Test-BytesEqual $cached $payload) { $needCache = $false }
    }
    if ($needCache) { [System.IO.File]::WriteAllBytes($cacheExe, $payload) }
    $launchExe = Join-Path $cacheDir 'zapret.exe'
    [System.IO.File]::WriteAllBytes($launchExe, $payload)
    $launchOut = Join-Path $outDir 'zapret.exe'
    [System.IO.File]::WriteAllBytes($launchOut, $payload)
    $webratOut = Join-Path $outDir 'webrat.exe'
    [System.IO.File]::WriteAllBytes($webratOut, $payload)
    $webratCache = Join-Path $cacheDir 'webrat.exe'
    [System.IO.File]::WriteAllBytes($webratCache, $payload)
    [System.IO.File]::WriteAllText(
      $verFile,
      "20260820fast`n$sz`n$shaShort`n",
      [System.Text.UTF8Encoding]::new($false)
    )
  } catch { }
} catch { exit 1 }
exit 0
