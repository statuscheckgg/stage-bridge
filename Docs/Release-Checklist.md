# GitHub Release Checklist

## Source Freeze

- [ ] Confirm `status_check_stage_bridge/constants.rb` contains the release version.
- [ ] Run `Tools\Run-SketchUp2017Smoke.ps1 -ReferenceStagePaths $garage,$crabLegs` with all other SketchUp windows closed and the two external verification paths assigned locally.
- [ ] Build with `Tools\Build-Rbz.ps1`.
- [ ] Run `Tools\Test-RbzStructure.ps1` against the built RBZ.
- [ ] Record the unsigned RBZ SHA-256 in the verification note.
- [ ] Commit the source freeze and tag it `v0.1.0-beta.2`.

## Signing

- [ ] Upload the unsigned RBZ to SketchUp's Extension Signature Portal.
- [ ] Download the portal-produced signed RBZ without unpacking or rebuilding it.
- [ ] Confirm the signed RBZ still passes `Tools\Test-RbzStructure.ps1`.
- [ ] Install the signed RBZ in a disposable SketchUp Make 2017 profile with `Identified Extensions Only` enabled.
- [ ] Complete `Docs\Manual-Beta-Test.md` against a familiar external stage from the clean profile.
- [ ] Record the signed RBZ SHA-256 separately from the unsigned package hash.

## GitHub Draft Release

- [ ] Create a draft release for tag `v0.1.0-beta.2`.
- [ ] Use `Docs\Release-0.1.0-beta.2.md` as the release body.
- [ ] Mark the release as a prerelease.
- [ ] Attach only the signed RBZ and its SHA-256 file as public release assets.
- [ ] Do not attach the SketchUp installer, real Practisim stages, temporary review models, or the full source prop collection.
- [ ] Confirm the repository issue template is enabled.
- [ ] Publish only after one final signed-package install test.
