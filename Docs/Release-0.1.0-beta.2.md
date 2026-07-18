# Stage Bridge 0.1.0-beta.2

This beta corrects the visual orientation and scale problems found during real-stage testing and introduces a curated SketchUp 2017 component pack for common stage props.

## Highlights

- Corrected yaw after reflecting Practisim Y into SketchUp Y.
- Corrected adjustable fault lines so an 8-foot line renders at approximately 96 inches instead of extending across the model.
- Keeps visually grounded props above the SketchUp ground plane without changing their exported Practisim Z value.
- Uses packaged SketchUp 2017 components for common walls, USPSA paper targets, no-shoots, barrels, barrel stacks, and start markers.
- Preserves unknown stage fields and no-edit transforms while continuing to warn about unsupported props.

## Requirements

- Windows x64.
- SketchUp Make 2017.2.2555.
- An existing Practisim `.STG` file. Blank-stage creation is not supported in this beta.

The SketchUp installer is not included, linked, or redistributed.

## Install or Upgrade

1. Download the signed `stage-bridge-0.1.0-beta.2.rbz` release asset.
2. Open SketchUp Make 2017.
3. Open `Window > Extension Manager`.
4. Select `Install Extension`, choose the RBZ, and restart SketchUp if prompted.
5. Re-import the original `.STG`. Do not export from a model previously imported with beta 1.

## Basic Workflow

1. Select `File > Import` and choose `Practisim Stage (*.STG)`.
2. Edit only the tagged components inside the `Stage Bridge` group.
3. Select `Extensions > Stage Bridge > Validate Stage`.
4. Select `Export Practisim Stage` and save to a new filename.
5. Open the result in Practisim and review the complete stage before match use.

## Verified

- SketchUp `17.2.2555` with embedded Ruby `2.2.4`.
- 24 core checks.
- Packaged component dimensions, bottom-center origins, and visual ground placement.
- Move, yaw rotate, scale, add, duplicate, and delete operations.
- Mirrored-transform rejection.
- `Garage-Test3.STG`: 16 props, zero diagnostics, maximum position delta `0.0` source units.
- `CrabLegs-Jason Brant.STG`: 43 props, zero diagnostics, maximum position delta `1.1368683772161603e-13` source units.

## Known Limitations

- Unsupported props appear as tagged magenta placeholders.
- Untagged SketchUp geometry is ignored with a warning.
- Exploded, mirrored, sheared, pitched, or rolled tagged components cannot be exported.
- SketchUp Web, current SketchUp releases, macOS, and iPad are not supported.
- SketchUp Make 2017 is no longer supported by Trimble.

Stage Bridge is an independent compatibility tool and is not affiliated with or endorsed by Practisim, SketchUp, or Trimble.
