# Stage Bridge

Import existing Practisim `.STG` stages into SketchUp Make 2017 and edit their props.

> **Beta preview:** Import and editing work. **Validate Stage** and **Export Practisim Stage** are disabled.

## Download

**[Download Stage Bridge 0.1.0-beta.7](https://github.com/statuscheckgg/stage-bridge/releases/tag/v0.1.0-beta.7)**

For Windows with SketchUp Make 2017.2.2555. This beta is unsigned.

## Install

1. Download the `.rbz` from the release above.
2. In SketchUp, open **Window > Extension Manager > Install Extension**.
3. Select the RBZ and restart SketchUp if asked.

[Illustrated installation guide](Docs/Install-And-Test.md)

## Use

1. Start a new SketchUp model.
2. Select **File > Import** and choose **Practisim Stage (*.STG)**.
3. Double-click the Stage Bridge group, then move, rotate, copy, scale, or delete its tagged props.

Use **Extensions > Stage Bridge > Add Practisim Prop** to add a supported prop.

Keep your original STG unchanged. Saving creates a SketchUp file only; this beta cannot export an STG.

## Notes

- Common targets, walls, barrels, fault lines, and start markers are mapped.
- Magenta boxes identify unsupported props.
- Stage Bridge works locally without accounts, telemetry, or cloud services.
- SketchUp Web, current SketchUp versions, macOS, and iPad are not supported.

## Help

- [Manual beta test](Docs/Manual-Beta-Test.md)
- [Supported props](Docs/Supported-Props.md)
- [Report a mapping problem](https://github.com/statuscheckgg/stage-bridge/issues)
- [Beta 7 release notes](Docs/Release-0.1.0-beta.7.md)

Stage Bridge is independent and is not affiliated with or endorsed by Practisim, SketchUp, or Trimble. SketchUp Make 2017 is unsupported by Trimble.
