[CmdletBinding()]
param(
    [string]$OutputDirectory
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
if ([string]::IsNullOrWhiteSpace($OutputDirectory)) {
    $OutputDirectory = Join-Path $projectRoot 'dist'
}

$rootLoader = Join-Path $projectRoot 'status_check_stage_bridge.rb'
$supportFolder = Join-Path $projectRoot 'status_check_stage_bridge'
if (-not (Test-Path -LiteralPath $rootLoader) -or -not (Test-Path -LiteralPath $supportFolder)) {
    throw 'The extension root loader or support folder is missing.'
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$versionLine = Select-String -LiteralPath (Join-Path $supportFolder 'constants.rb') -Pattern "VERSION = '([^']+)'" | Select-Object -First 1
if (-not $versionLine) {
    throw 'Could not read the extension version.'
}
$version = $versionLine.Matches[0].Groups[1].Value
$zipPath = Join-Path $OutputDirectory "stage-bridge-$version.zip"
$rbzPath = Join-Path $OutputDirectory "stage-bridge-$version.rbz"
Remove-Item -LiteralPath $zipPath,$rbzPath -Force -ErrorAction SilentlyContinue
Compress-Archive -LiteralPath $rootLoader,$supportFolder -DestinationPath $zipPath -CompressionLevel Optimal
Move-Item -LiteralPath $zipPath -Destination $rbzPath

Write-Output $rbzPath
