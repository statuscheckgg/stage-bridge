# Verification - 2026-07-20

## Authoritative SketchUp Environment

- Application: SketchUp Make 2017 for Windows x64
- Installed executable: `C:\Program Files\SketchUp\SketchUp 2017\SketchUp.exe`
- Product version: `17.2.2555`
- Embedded Ruby: `2.2.4`
- Installer SHA-256: `9841792F170D803AE95A2741C44CCE38E618660F98A1A3816335E9BF1B45A337`

The installer is user-owned and is not copied into or distributed with this project.

## Passing Tests

- Ruby 2.2-compatible core suite: 35 checks.
- Synthetic import/export: 4 props, zero diagnostics.
- Tagged edit scenario: move, vertical rotation, scale, add, duplicate, delete, and new-ID assignment; 5 resulting props.
- Packaged-component regression: 13 hash-verified SketchUp 2017 assets with centered, grounded wrapper definitions.
- Popper regression: `Group#180` loads with a 180-degree internal vertical turn while the tagged STG transform remains unchanged.
- Swinger regression: `Group#167` loads as a complete 55.396 x 20 x 62.885-inch stand, target, pivot, and counterweight assembly.
- Stack regression: `uspsa-two-stack-noshoot` and `uspsa-two-noshoot-vert` select white-center `Group#275`; the hard-cover mapping uses an isolated white-to-black runtime recolor.
- `CrabLegs-Jason Brant.STG`: 43 props, zero diagnostics, maximum position delta `1.1368683772161603e-13` source units, maximum yaw delta `1.2722218725854067e-14` degrees.
- `Bay7-Clostivator-JB.STG`: 45 props, zero diagnostics, maximum position delta `5.684341886080802e-14` source units, maximum yaw delta `1.2722218725854067e-14` degrees.
- RBZ structure: 30 entries, one root loader, one namespaced support folder, 13 hash-verified component assets, one source manifest, and no unexpected roots.

Real reference stages stayed external to the repository. The Garage fixture used in earlier baselines was not available for this run.

## Release Candidate

- Unsigned RBZ: `C:\Vibes\Projects\Personal\practisim-sketchup-bridge\dist\stage-bridge-0.1.0-beta.6.rbz`
- Unsigned RBZ size: `1,448,415` bytes
- Unsigned RBZ SHA-256: `50A82EEADDCF9E9A60B5EA3177DBFDEA7C9BC7360007048EA6330DA80D4D2D63`
- Public MVP command state: `Validate Stage` and `Export Practisim Stage` remain disabled by release constants.
- Signing status: pending authenticated upload to SketchUp's Extension Signature Portal.

The unsigned package is suitable for an explicitly labeled GitHub prerelease. It must not be described as signed until a portal-produced package passes a clean-profile install under `Identified Extensions Only`.
