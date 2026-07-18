# Stage Bridge 0.1.0-beta.3

This beta corrects adjustable fault-line placement and replaces two Bay 7 placeholders with dedicated stage props.

## Highlights

- Treats an adjustable fault line's Practisim position as its start endpoint rather than its center.
- Preserves custom red and green fault-line colors.
- Maps `ssi-double-x-start-box` to a double-X start-position marker.
- Maps `uspsa-swinger` and `uspsa-swinger-right` to tagged local swinger assemblies.
- Preserves unknown stage fields and reversible no-edit transforms.

## Requirements

- Windows x64.
- SketchUp Make 2017.2.2555.
- An existing Practisim `.STG` file. Blank-stage creation is not supported in this beta.

The SketchUp installer is not included, linked, or redistributed.

## Install or Upgrade

1. Download the signed `stage-bridge-0.1.0-beta.3.rbz` release asset.
2. Open SketchUp Make 2017.
3. Open `Window > Extension Manager`.
4. Select `Install Extension`, choose the RBZ, and restart SketchUp if prompted.
5. Re-import the original `.STG`. Do not export from a model previously imported with beta 1 or beta 2.

## Basic Workflow

1. Select `File > Import` and choose `Practisim Stage (*.STG)`.
2. Edit only the tagged components inside the `Stage Bridge` group.
3. Select `Extensions > Stage Bridge > Validate Stage`.
4. Select `Export Practisim Stage` and save to a new filename.
5. Open the result in Practisim and review the complete stage before match use.

## Verified

- SketchUp `17.2.2555` with embedded Ruby `2.2.4`.
- 27 core checks.
- Adjustable fault-line endpoint, length, and custom-color regressions.
- Dedicated double-X and swinger geometry regressions.
- Move, yaw rotate, scale, add, duplicate, and delete operations.
- Mirrored-transform rejection.
- `Garage-Test3.STG`: 16 props, zero diagnostics.
- `CrabLegs-Jason Brant.STG`: 43 props, zero diagnostics.
- `Bay7-Clostivator-JB.STG`: 45 props, zero diagnostics.

## Known Limitations

- The swinger is a clean local representation, not an animated SketchUp mechanism.
- Unsupported props still appear as tagged magenta placeholders.
- Untagged SketchUp geometry is ignored with a warning.
- Exploded, mirrored, sheared, pitched, or rolled tagged components cannot be exported.
- SketchUp Web, current SketchUp releases, macOS, and iPad are not supported.
- SketchUp Make 2017 is no longer supported by Trimble.

Stage Bridge is an independent compatibility tool and is not affiliated with or endorsed by Practisim, SketchUp, or Trimble.
