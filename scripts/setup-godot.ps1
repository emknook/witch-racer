$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$version = (Get-Content (Join-Path $repositoryRoot ".godot-version") -Raw).Trim()
$installDirectory = Join-Path $repositoryRoot ".tools/godot/$version"
$executable = Join-Path $installDirectory "godot.exe"

if ($env:OS -ne "Windows_NT") {
    throw "This script supports Windows. On Linux, use setup-godot.sh."
}

if (Test-Path $executable) {
    & $executable --version
    Write-Host "Godot already installed: $executable"
    exit 0
}

New-Item -ItemType Directory -Path $installDirectory -Force | Out-Null
$archivePath = Join-Path $env:TEMP "witch-racer-godot-$version.zip"
$downloadUrl = "https://github.com/godotengine/godot/releases/download/$version-stable/Godot_v$version-stable_win64.exe.zip"

try {
    Write-Host "Downloading Godot $version for Windows x64..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $archivePath
    Expand-Archive -LiteralPath $archivePath -DestinationPath $installDirectory -Force
    $downloadedExecutable = Join-Path $installDirectory "Godot_v$version-stable_win64.exe"
    Move-Item -LiteralPath $downloadedExecutable -Destination $executable -Force
    & $executable --version
    Write-Host "Godot installed: $executable"
}
finally {
    Remove-Item -LiteralPath $archivePath -ErrorAction SilentlyContinue
}
