# Stage Bridge

Stage Bridge is a local-only SketchUp Make 2017 extension for round-tripping existing Practisim `.STG` stages. It imports supported stage props as tagged SketchUp components, preserves the original stage JSON, and merges safe layout edits back into a new `.STG` file. Mapped targets, walls, barrels, and start markers use packaged SketchUp 2017 stage-building components; procedural geometry remains as an offline fallback.

Stage Bridge is an independent compatibility tool. It is not affiliated with or endorsed by Practisim, SketchUp, or Trimble.

## Compatibility

- Windows x64
- SketchUp Make 2017.2.2555
- Ruby 2.2.4 embedded in SketchUp
- Existing Practisim `.STG` files only
- No network, account, telemetry, or update service

SketchUp Make 2017 is unsupported by Trimble. The SketchUp installer is not included or redistributed by this project.

## Install

1. Build or download the signed `stage-bridge-<version>.rbz` package.
2. Open SketchUp Make 2017.
3. Open `Window > Extension Manager`.
4. Choose `Install Extension` and select the `.rbz` file.
5. Restart SketchUp if prompted.

## Workflow

1. Choose `File > Import` and select `Practisim Stage (*.STG)`, or use `Extensions > Stage Bridge > Import Practisim Stage`.
2. Double-click the `Stage Bridge - <stage name>` group to edit tagged props.
3. Use normal SketchUp Move, Rotate, Scale, Copy, and Delete operations on tagged components.
4. Use `Extensions > Stage Bridge > Add Practisim Prop` for supported new props.
5. Run `Validate Stage`.
6. Run `Export Practisim Stage` and choose a new `.STG` filename.
7. Open the exported file in Practisim and review scoring and layout before match use.

Untagged geometry is never guessed or exported. Mirrored, sheared, pitched, rolled, exploded, or otherwise unsafe props block export.

Models imported with `0.1.0-beta.1` must be re-imported from their original `.STG` file after upgrading. Beta 2 corrects the reflected yaw convention, adjustable fault-line base size, and visual ground placement; exporting an older imported model is intentionally blocked.

For a complete hands-on beta pass, follow `Docs/Manual-Beta-Test.md`.

## Development

```powershell
.\Tools\Record-SketchUp2017Environment.ps1
.\Tools\Run-SketchUp2017Smoke.ps1
$rbz = .\Tools\Build-Rbz.ps1
.\Tools\Test-RbzStructure.ps1 -RbzPath $rbz
```

SketchUp Make always displays its legacy Welcome window on this build. When the smoke runner opens it, click `Start using SketchUp`; the Ruby harness then runs and closes SketchUp automatically. Close any other SketchUp windows before starting the test.

Real stages remain outside the repository. The checked-in fixture is synthetic and contains no Practisim geometry assets.

## Release

The first release lane is a free signed RBZ beta distributed outside Extension Warehouse. Upload the unsigned RBZ produced by `Build-Rbz.ps1` to SketchUp's Extension Signature Portal, download the signed result, and repeat the clean-profile installation test under the `Identified Extensions Only` loading policy.

GitHub Actions builds and validates an **unsigned** RBZ for every main-branch update and pull request. Public GitHub release assets must use the portal-produced signed RBZ. Follow `Docs/Release-Checklist.md` and use `Docs/Release-0.1.0-beta.2.md` as the beta 2 release body.
