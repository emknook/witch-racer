[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$GodotArguments = @()
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$version = (Get-Content (Join-Path $repositoryRoot ".godot-version") -Raw).Trim()
$executable = Join-Path $repositoryRoot ".tools/godot/$version/godot.exe"
$gameDirectory = Join-Path $repositoryRoot "game"

if ($env:OS -ne "Windows_NT") {
    throw "This script supports Windows. On Linux, use start-game.sh."
}

if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) {
    & (Join-Path $PSScriptRoot "setup-godot.ps1")
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

& $executable --path $gameDirectory @GodotArguments | Out-Host
exit $LASTEXITCODE
