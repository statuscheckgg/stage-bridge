# Verification - 2026-07-20

## Authoritative SketchUp Environment

- Application: SketchUp Make 2017 for Windows x64
- Installed executable: `C:\Program Files\SketchUp\SketchUp 2017\SketchUp.exe`
- Product version: `17.2.2555`
- Embedded Ruby: `2.2.4`
- Installer SHA-256: `9841792F170D803AE95A2741C44CCE38E618660F98A1A3816335E9BF1B45A337`

The installer is user-owned and is not copied into or distributed with this project.

## Passing Tests

- Ruby 2.2-compatible core suite: 38 checks.
- Synthetic import/export: 4 props, zero diagnostics.
- Tagged edit scenario: move, vertical rotation, scale, add, duplicate, delete, and new-ID assignment; 5 resulting props.
- Packaged-component regression: 13 hash-verified SketchUp 2017 assets with centered, grounded wrapper definitions.
- Short-target regression: `uspsa-full-target-short` resolves to Big Prop `USPSA target and stand#7`; the loaded component is upright, grounded, and measures 20 x 18 x 43.693 inches on SketchUp X/Y/Z.
- Two-foot fault-line regression: both Bay7 `faultline-2ft` props resolve to yellow `faultline_2ft` components measuring 24 x 3.5 x 1.5 inches instead of magenta placeholders.
- Popper regression: `Group#180` loads with a 180-degree internal vertical turn while the tagged STG transform remains unchanged.
- Swinger regression: `Group#167` loads as a complete 55.396 x 20 x 62.885-inch stand, target, pivot, and counterweight assembly.
- Stack regression: `uspsa-two-stack-noshoot` and `uspsa-two-noshoot-vert` select white-center `Group#275`; the hard-cover mapping uses an isolated white-to-black runtime recolor.
- `CrabLegs-Jason Brant.STG`: 43 props, zero diagnostics, maximum position delta `1.1368683772161603e-13` source units, maximum yaw delta `1.2722218725854067e-14` degrees.
- `Bay7-Clostivator-JB.STG`: 43 props, zero diagnostics, maximum position delta `5.684341886080802e-14` source units, maximum yaw delta `6.3611093629270335e-15` degrees.
- RBZ structure: 30 entries, one root loader, one namespaced support folder, 13 hash-verified component assets, one source manifest, and no unexpected roots.
- Smoke harness: project-local sources are explicitly loaded so an older installed extension cannot mask candidate behavior.

Real reference stages stayed external to the repository. The Garage fixture used in earlier baselines was not available for this run.

## Release Candidate

- Unsigned RBZ: `C:\Vibes\Projects\Personal\practisim-sketchup-bridge\dist\stage-bridge-0.1.0-beta.6.rbz`
- Unsigned RBZ size: `1,443,848` bytes
- Unsigned RBZ SHA-256: `E6AA2538D2F160090B719BC9F7D25D3D4EB59CF8543BED33A735F226A632CB90`
- Public MVP command state: `Validate Stage` and `Export Practisim Stage` remain disabled by release constants.
- Signing status: pending authenticated upload to SketchUp's Extension Signature Portal.

The unsigned package is suitable for an explicitly labeled GitHub prerelease. It must not be described as signed until a portal-produced package passes a clean-profile install under `Identified Extensions Only`.
