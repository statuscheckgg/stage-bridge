[CmdletBinding()]
param(
    [string]$SketchUpPath = 'C:\Program Files\SketchUp\SketchUp 2017\SketchUp.exe',
    [int]$TimeoutSeconds = 90,
    [string[]]$ReferenceStagePaths = @()
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
$startupScript = Join-Path $projectRoot 'test\sketchup_smoke_startup.rb'
$templateModel = Join-Path (Split-Path -Parent $SketchUpPath) 'Resources\en-US\Templates\Temp01b - Simple.skp'
$resultDirectory = 'C:\Vibes\Temp\practisim-sketchup-bridge'
$resultPath = Join-Path $resultDirectory 'smoke-result.json'
$bootPath = Join-Path $resultDirectory 'smoke-boot.txt'
$welcomeKey = 'HKCU:\Software\SketchUp\SketchUp 2017\WelcomeDialog'
$welcomeValueName = 'ShowOnStartup'

if (-not (Test-Path -LiteralPath $SketchUpPath)) {
    throw "SketchUp Make 2017 was not found at $SketchUpPath"
}
if (-not (Test-Path -LiteralPath $templateModel)) {
    throw "SketchUp's metric simple template was not found at $templateModel"
}
foreach ($referenceStagePath in $ReferenceStagePaths) {
    if (-not (Test-Path -LiteralPath $referenceStagePath)) {
        throw "Reference stage was not found: $referenceStagePath"
    }
}
$runningSketchUp = Get-Process -Name 'SketchUp' -ErrorAction SilentlyContinue | Where-Object { -not $_.HasExited }
if ($runningSketchUp) {
    throw 'Close all existing SketchUp 2017 windows before running the smoke test so the template and RubyStartup harness are not redirected into another process.'
}
New-Item -ItemType Directory -Path $resultDirectory -Force | Out-Null
Remove-Item -LiteralPath $resultPath -Force -ErrorAction SilentlyContinue
Remove-Item -LiteralPath $bootPath -Force -ErrorAction SilentlyContinue

$quotedStartupScript = '"' + $startupScript + '"'
$quotedTemplateModel = '"' + $templateModel + '"'
$welcomeKeyExisted = Test-Path -LiteralPath $welcomeKey
if (-not $welcomeKeyExisted) {
    New-Item -Path $welcomeKey -Force | Out-Null
}
$welcomeProperty = Get-ItemProperty -LiteralPath $welcomeKey -Name $welcomeValueName -ErrorAction SilentlyContinue
$welcomeValueExisted = $null -ne $welcomeProperty
$previousWelcomeValue = if ($welcomeValueExisted) { $welcomeProperty.$welcomeValueName } else { $null }
Set-ItemProperty -LiteralPath $welcomeKey -Name $welcomeValueName -Type DWord -Value 0
$referenceStageEnvironmentName = 'STAGE_BRIDGE_REFERENCE_STAGES'
$previousReferenceStages = [Environment]::GetEnvironmentVariable($referenceStageEnvironmentName, 'Process')
[Environment]::SetEnvironmentVariable(
    $referenceStageEnvironmentName,
    ($ReferenceStagePaths -join [IO.Path]::PathSeparator),
    'Process'
)

try {
    Write-Host 'SketchUp Make 2017 will show its legacy Welcome window. Click Start using SketchUp once; the test will then run and close SketchUp.'
    # SketchUp 2017 does not reliably finish its startup cycle with a hidden
    # top-level window on current Windows builds, so keep the test window visible.
    $process = Start-Process -FilePath $SketchUpPath -ArgumentList @('-RubyStartup', $quotedStartupScript, $quotedTemplateModel) -PassThru -WindowStyle Normal
    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline -and -not (Test-Path -LiteralPath $resultPath)) {
        if ($process.HasExited -and -not (Test-Path -LiteralPath $resultPath)) {
            $loaded = Test-Path -LiteralPath $bootPath
            throw "SketchUp exited before the smoke test completed. RubyStartup loaded: $loaded. Exit code: $($process.ExitCode)."
        }
        Start-Sleep -Milliseconds 500
    }

    if (-not (Test-Path -LiteralPath $resultPath)) {
        if (-not $process.HasExited) {
            Stop-Process -Id $process.Id -Force
        }
        throw "SketchUp smoke test did not produce a result within $TimeoutSeconds seconds."
    }

    $result = Get-Content -Raw -LiteralPath $resultPath | ConvertFrom-Json
    if ($result.status -ne 'passed') {
        throw "SketchUp smoke test failed: $($result.error_class): $($result.error)"
    }
    $result
}
finally {
    [Environment]::SetEnvironmentVariable($referenceStageEnvironmentName, $previousReferenceStages, 'Process')
    if ($welcomeValueExisted) {
        Set-ItemProperty -LiteralPath $welcomeKey -Name $welcomeValueName -Type DWord -Value $previousWelcomeValue
    }
    else {
        Remove-ItemProperty -LiteralPath $welcomeKey -Name $welcomeValueName -ErrorAction SilentlyContinue
        if (-not $welcomeKeyExisted) {
            Remove-Item -LiteralPath $welcomeKey -ErrorAction SilentlyContinue
        }
    }
}
