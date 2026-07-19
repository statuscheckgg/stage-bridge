# Stage Bridge 0.1.0-beta.4

This is an import-and-edit MVP for evaluating Practisim-to-SketchUp prop coordination. It remembers the last import folder while retaining the beta 3 geometry corrections.

## Highlights

- Imports existing STG stages for visual review and normal SketchUp manipulation.
- Keeps `Validate Stage` and `Export Practisim Stage` visibly disabled while mapping and Practisim reopen testing continue.
- Remembers the folder from the most recent successful STG import.
- Opens the next Stage Bridge import dialog in that folder.
- Keeps the preference across SketchUp restarts.
- Falls back to the imported stage folder or user home folder if the remembered directory is unavailable.
- Retains corrected adjustable fault-line endpoints/colors, double-X start markers, and swinger assemblies from beta 3.
- Uses solid green, fully supported Big Prop assemblies for the common 4 x 6 ft and 8 x 6 ft walls.

## Requirements

- Windows x64.
- SketchUp Make 2017.2.2555.
- An existing Practisim `.STG` file. Blank-stage creation is not supported in this beta.

The SketchUp installer is not included, linked, or redistributed.

## Install or Upgrade

1. Download the signed `stage-bridge-0.1.0-beta.4.rbz` release asset.
2. Open SketchUp Make 2017.
3. Open `Window > Extension Manager`.
4. Select `Install Extension`, choose the RBZ, and restart SketchUp if prompted.
5. Beta 3 models remain compatible. Models imported with beta 1 or beta 2 must still be re-imported from the original `.STG`.

## Preview Workflow

1. Select `Extensions > Stage Bridge > Import Practisim Stage` and choose an STG file.
2. Edit only the tagged components inside the `Stage Bridge` group.
3. Compare the props and layout with Practisim.
4. Report incorrect mappings, dimensions, orientations, or placeholders through GitHub Issues.
5. The next Stage Bridge import dialog will start in the last successful import folder.

## Known Limitations

- STG validation and export are deliberately unavailable in this MVP.
- Saving a SketchUp model does not produce a Practisim-readable stage.
- SketchUp's general `File > Import` dialog is owned by SketchUp; Stage Bridge records its successful selection, while the dedicated Stage Bridge menu command consistently uses the remembered folder.
- Unsupported props appear as tagged magenta placeholders.
- Untagged SketchUp geometry is ignored with a warning.
- Exploded, mirrored, sheared, pitched, or rolled tagged components cannot be exported.
- SketchUp Web, current SketchUp releases, macOS, and iPad are not supported.
- SketchUp Make 2017 is no longer supported by Trimble.

Stage Bridge is an independent compatibility tool and is not affiliated with or endorsed by Practisim, SketchUp, or Trimble.
