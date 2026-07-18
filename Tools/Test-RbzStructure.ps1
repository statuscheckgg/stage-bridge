[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$RbzPath
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$resolved = (Resolve-Path -LiteralPath $RbzPath).Path
$archive = [System.IO.Compression.ZipFile]::OpenRead($resolved)
try {
    $entries = @($archive.Entries | ForEach-Object { $_.FullName.Replace('\','/') })
    if (-not ($entries -contains 'status_check_stage_bridge.rb')) {
        throw 'RBZ is missing the root loader.'
    }
    if (-not ($entries | Where-Object { $_ -like 'status_check_stage_bridge/*' })) {
        throw 'RBZ is missing the support folder.'
    }
    $requiredComponentAssets = @(
        'status_check_stage_bridge/components/barrel.skp',
        'status_check_stage_bridge/components/barrel_stack.skp',
        'status_check_stage_bridge/components/start_position.skp',
        'status_check_stage_bridge/components/uspsa_no_shoot_high.skp',
        'status_check_stage_bridge/components/uspsa_target_high.skp',
        'status_check_stage_bridge/components/uspsa_target_short.skp',
        'status_check_stage_bridge/components/uspsa_target_short_tilted.skp',
        'status_check_stage_bridge/components/wall_base.skp'
    )
    $manifestPath = 'status_check_stage_bridge/components/manifest.json'
    if ($entries -notcontains $manifestPath) {
        throw 'RBZ is missing the component source manifest.'
    }
    $missingComponentAssets = @($requiredComponentAssets | Where-Object { $entries -notcontains $_ })
    if ($missingComponentAssets.Count -gt 0) {
        throw "RBZ is missing component assets: $($missingComponentAssets -join ', ')"
    }
    $manifestEntry = $archive.GetEntry($manifestPath)
    $manifestStream = $manifestEntry.Open()
    $manifestReader = New-Object System.IO.StreamReader($manifestStream)
    try {
        $manifest = $manifestReader.ReadToEnd() | ConvertFrom-Json
    }
    finally {
        $manifestReader.Dispose()
        $manifestStream.Dispose()
    }
    $sha256 = [System.Security.Cryptography.SHA256]::Create()
    try {
        foreach ($asset in $manifest.assets) {
            $assetPath = "status_check_stage_bridge/components/$($asset.file)"
            $assetEntry = $archive.GetEntry($assetPath)
            if ($null -eq $assetEntry) {
                throw "Manifest asset is missing from RBZ: $assetPath"
            }
            if ($assetEntry.Length -ne [long]$asset.bytes) {
                throw "Manifest size mismatch for $assetPath"
            }
            $assetStream = $assetEntry.Open()
            try {
                $actualHash = ([BitConverter]::ToString($sha256.ComputeHash($assetStream))).Replace('-', '')
            }
            finally {
                $assetStream.Dispose()
            }
            if ($actualHash -ne $asset.sha256) {
                throw "Manifest hash mismatch for $assetPath"
            }
        }
    }
    finally {
        $sha256.Dispose()
    }
    $unexpectedRoots = @($entries | ForEach-Object { ($_ -split '/')[0] } | Sort-Object -Unique | Where-Object { $_ -notin 'status_check_stage_bridge.rb','status_check_stage_bridge' })
    if ($unexpectedRoots.Count -gt 0) {
        throw "RBZ contains unexpected root entries: $($unexpectedRoots -join ', ')"
    }
    [pscustomobject]@{
        Path = $resolved
        EntryCount = $entries.Count
        RootLoader = $true
        SupportFolder = $true
        ComponentAssetCount = $requiredComponentAssets.Count
        ComponentManifest = $true
        Status = 'Passed'
    }
}
finally {
    $archive.Dispose()
}
