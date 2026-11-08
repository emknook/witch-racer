$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Save-GodotArchive {
    param(
        [string]$Uri,
        [string]$ArchivePath,
        [string]$ExpectedHash
    )

    $PSNativeCommandUseErrorActionPreference = $false
    Write-Host "Downloading Godot from $Uri..."
    & curl.exe --fail --location --silent --show-error --retry 2 --retry-max-time 210 --connect-timeout 20 --max-time 90 --output $ArchivePath $Uri
    if ($LASTEXITCODE -ne 0) {
        throw "Godot download failed (curl exit code $LASTEXITCODE)."
    }

    if ((Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash -ne $ExpectedHash) {
        throw "Godot archive SHA-256 did not match the official release."
    }
}

if ($env:OS -ne "Windows_NT") {
    throw "This script supports Windows. On Linux, use setup-godot.sh."
}

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$version = (Get-Content (Join-Path $repositoryRoot ".godot-version") -Raw).Trim()
$installDirectory = Join-Path $repositoryRoot ".tools/godot/$version"
$executable = Join-Path $installDirectory "godot.exe"

if (Test-Path -LiteralPath $executable -PathType Leaf) {
    & $executable --version
    Write-Host "Godot already installed: $executable"
    exit 0
}

# Published by the official Godot 4.7.2 stable release for Windows x64.
$archiveHashes = @{
    "4.7.2" = "731980f9608d61333e5baf54a2ef17210acc7a538446c0cb9969f002aca1e953"
}
$expectedHash = $archiveHashes[$version]
if (-not $expectedHash) {
    throw "No Windows x64 archive checksum is configured for Godot $version."
}

$archiveName = "Godot_v$version-stable_win64.exe.zip"
$primaryUrl = "https://github.com/godotengine/godot/releases/download/$version-stable/$archiveName"
$mirrorUrl = "https://downloads.godotengine.org/?version=$version&flavor=stable&slug=win64.exe.zip&platform=windows.64"
$stagingDirectory = Join-Path $installDirectory ([guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $stagingDirectory -Force | Out-Null
$archivePath = Join-Path $stagingDirectory $archiveName

try {
    try {
        Save-GodotArchive -Uri $primaryUrl -ArchivePath $archivePath -ExpectedHash $expectedHash
    }
    catch {
        Write-Warning "$($_.Exception.Message) Trying the official Godot download mirror."
        Remove-Item -LiteralPath $archivePath -ErrorAction SilentlyContinue
        Save-GodotArchive -Uri $mirrorUrl -ArchivePath $archivePath -ExpectedHash $expectedHash
    }

    $extractedDirectory = Join-Path $stagingDirectory "extracted"
    Expand-Archive -LiteralPath $archivePath -DestinationPath $extractedDirectory
    $downloadedExecutable = Join-Path $extractedDirectory "Godot_v$version-stable_win64.exe"
    Move-Item -LiteralPath $downloadedExecutable -Destination $executable -Force
    & $executable --version
    Write-Host "Godot installed: $executable"
}
finally {
    Remove-Item -LiteralPath $stagingDirectory -Recurse -Force
}
