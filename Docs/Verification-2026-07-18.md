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

- Ruby 2.2-compatible core suite: 33 checks, including public-preview command gates, reflected yaw, adjustable fault-line endpoint mapping, double-X and swinger catalog mappings, popper/stack asset selection, hard-cover recolor configuration, activation links, and safe write/overwrite/backup behavior
- Synthetic import/export: 4 props; zero diagnostics
- Tagged edit scenario: move, yaw rotation, non-uniform scale, add, duplicate, delete, and new-ID assignment; 5 resulting props
- Invalid transform scenario: mirrored component rejected
- Adjustable fault-line visual regression: source scale `24.384` renders at approximately `96` inches
- Adjustable fault-line endpoint regression: the component's minimum local X remains at the imported Practisim translation, and custom instance color is preserved
- Dedicated double-X start-position and swinger geometry regressions
- Negative source-Z visual regression: prop is displayed above ground while export returns the untouched source Z
- Packaged component regression: 12 component assets present; tested walls, targets, popper, stacked targets, barrels, and start-position dimensions with bottom-center origins
- Template-person regression: a top-level `Sang` template component is removed during STG import
- Stack color regression: the no-shoot stack retains its white center while the hard-cover stack receives a private black center without changing the shared source asset
- Plain wall regression: 4 x 6 ft `Group#286` and 8 x 6 ft `Group#336` assemblies include both supports and feet, preserve native proportions, ground correctly, and display green panels
- `Garage-Test3.STG`: 16 props, zero diagnostics, maximum position delta `0.0` source units, maximum yaw delta `1.2722218725854067e-14` degrees
- `CrabLegs-Jason Brant.STG`: 43 props, zero diagnostics, maximum position delta `1.1368683772161603e-13` source units, maximum yaw delta `1.2722218725854067e-14` degrees
- `Bay7-Clostivator-JB.STG`: 45 props, zero diagnostics, maximum position delta `5.684341886080802e-14` source units, maximum yaw delta `1.2722218725854067e-14` degrees
- Visual review: Bay 7 reference model contained no stock human; props were upright and grounded; common walls used the solid green supported assemblies; full poppers and white/black stacked targets used the beta 5 mappings; adjustable fault lines began at their source endpoints with red/green colors
- RBZ structure: 29 entries, one root loader, one namespaced support folder, 12 hash-verified component assets, one source manifest, and no unexpected roots

Real reference stages stayed external to the repository. Generated `.skp` review artifacts live under `C:\Vibes\Temp\practisim-sketchup-bridge`.
The beta 5 release verification run passed CrabLegs and Bay 7 through `Run-SketchUp2017Smoke.ps1 -ReferenceStagePaths <paths>`. The Garage result above is retained from the beta 4 baseline because that external fixture was not available during the beta 5 run. Local source paths are intentionally not stored in the public repository.

## Release Candidate

- Unsigned RBZ: `C:\Vibes\Projects\Personal\practisim-sketchup-bridge\dist\stage-bridge-0.1.0-beta.5.rbz`
- Unsigned RBZ size: `1,378,784` bytes
- Unsigned RBZ SHA-256: `5CB27465548081EA44E9DC679229E173FFAF8C557C61BEA4D7867B746A013DF0`
- Public MVP command state: `Validate Stage` and `Export Practisim Stage` disabled by release constants; clean-profile visual confirmation remains part of the signing/install gate
- Signing status: pending authenticated upload to SketchUp's Extension Signature Portal

The unsigned package is suitable for the explicitly labeled GitHub prerelease. It must not be described as signed until a portal-produced package passes a clean-profile install under `Identified Extensions Only`.
