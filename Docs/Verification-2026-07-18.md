# Verification - 2026-07-18

## Authoritative SketchUp Environment

- Application: SketchUp Make 2017 for Windows x64
- Installed executable: `C:\Program Files\SketchUp\SketchUp 2017\SketchUp.exe`
- Product version: `17.2.2555`
- Embedded Ruby: `2.2.4`
- Installer filename: `sketchupmake-2017-2-2555-90782-en-x64.exe` (user-owned Downloads folder)
- Installer SHA-256: `9841792F170D803AE95A2741C44CCE38E618660F98A1A3816335E9BF1B45A337`
- Installer Authenticode status at setup: valid; signer Trimble Navigation

The installer is user-owned and is not copied into or distributed with this project.

## Passing Tests

- Ruby 2.2-compatible core suite: 29 checks, including public-preview command gates, reflected yaw, adjustable fault-line endpoint mapping, double-X and swinger catalog mappings, activation links, and safe write/overwrite/backup behavior
- Synthetic import/export: 4 props; zero diagnostics
- Tagged edit scenario: move, yaw rotation, non-uniform scale, add, duplicate, delete, and new-ID assignment; 5 resulting props
- Invalid transform scenario: mirrored component rejected
- Adjustable fault-line visual regression: source scale `24.384` renders at approximately `96` inches
- Adjustable fault-line endpoint regression: the component's minimum local X remains at the imported Practisim translation, and custom instance color is preserved
- Dedicated double-X start-position and swinger geometry regressions
- Negative source-Z visual regression: prop is displayed above ground while export returns the untouched source Z
- Packaged component regression: 10 component assets present; tested walls, targets, barrels, and start-position dimensions with bottom-center origins
- Plain wall regression: 4 x 6 ft `Group#286` and 8 x 6 ft `Group#336` assemblies include both supports and feet, preserve native proportions, ground correctly, and display green panels
- `Garage-Test3.STG`: 16 props, zero diagnostics, maximum position delta `0.0` source units, maximum yaw delta `1.2722218725854067e-14` degrees
- `CrabLegs-Jason Brant.STG`: 43 props, zero diagnostics, maximum position delta `1.1368683772161603e-13` source units, maximum yaw delta `1.2722218725854067e-14` degrees
- `Bay7-Clostivator-JB.STG`: 45 props, zero diagnostics, maximum position delta `5.684341886080802e-14` source units, maximum yaw delta `1.2722218725854067e-14` degrees
- Visual review: Bay 7 reference model props were upright and grounded; common walls used the new solid green supported assemblies; adjustable fault lines began at their source endpoints with red/green colors; the double-X start marker and swinger were no longer magenta placeholders
- RBZ structure: 27 entries, one root loader, one namespaced support folder, 10 hash-verified component assets, one source manifest, and no unexpected roots

Real reference stages stayed external to the repository. Generated `.skp` review artifacts live under `C:\Vibes\Temp\practisim-sketchup-bridge`.
The release verification run passed all three external files through `Run-SketchUp2017Smoke.ps1 -ReferenceStagePaths <paths>`; their local source paths are intentionally not stored in the public repository.

## Release Candidate

- Unsigned RBZ: `C:\Vibes\Projects\Personal\practisim-sketchup-bridge\dist\stage-bridge-0.1.0-beta.4.rbz`
- Unsigned RBZ size: `1,219,841` bytes
- Unsigned RBZ SHA-256: `6CA9294A4262A349D438C1C8B80674A557EE8C12C3837465D3EBBAE22CC55F12`
- Public MVP command state: `Validate Stage` and `Export Practisim Stage` disabled by release constants; clean-profile visual confirmation remains part of the signing/install gate
- Signing status: pending authenticated upload to SketchUp's Extension Signature Portal

The unsigned package is suitable for local development testing. Do not call it the signed public beta until the portal-produced package passes a clean-profile install under `Identified Extensions Only`.
