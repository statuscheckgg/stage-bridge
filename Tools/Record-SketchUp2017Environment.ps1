[CmdletBinding()]
param(
    [string]$InstallerPath = (Join-Path ([Environment]::GetFolderPath('UserProfile')) 'Downloads\sketchupmake-2017-2-2555-90782-en-x64.exe'),
    [string]$SketchUpPath = 'C:\Program Files\SketchUp\SketchUp 2017\SketchUp.exe'
)

$ErrorActionPreference = 'Stop'
$installer = Get-Item -LiteralPath $InstallerPath
$executable = Get-Item -LiteralPath $SketchUpPath
$signature = Get-AuthenticodeSignature -LiteralPath $InstallerPath
$hash = Get-FileHash -LiteralPath $InstallerPath -Algorithm SHA256

[pscustomobject]@{
    RecordedAt = (Get-Date).ToString('o')
    InstallerPath = $installer.FullName
    InstallerLength = $installer.Length
    InstallerProductVersion = $installer.VersionInfo.ProductVersion
    InstallerSHA256 = $hash.Hash
    InstallerSignatureStatus = $signature.Status.ToString()
    InstalledExecutable = $executable.FullName
    InstalledProductVersion = $executable.VersionInfo.ProductVersion
}
