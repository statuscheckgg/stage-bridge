# Stage Bridge 0.1.0-beta.6

Beta 6 is an unsigned import-and-edit preview for SketchUp Make 2017. It corrects two mechanical prop mappings and confirms the requested white-center target stacks.

## What Changed

- Turns the selected full-size Big Prop popper (`Group#180`) 180 degrees internally so its mechanism falls in the same direction as the Practisim model.
- Maps `uspsa-swinger` and `uspsa-swinger-right` to the complete Big Prop swinger (`Group#167`) with stand, pivot arms, target, and counterweight.
- Keeps white-center two-stack props on Big Prop `Group#275`; the visible white no-shoot band is between the target bodies and leaves the upper headbox tan.
- Uses a new component schema so a fresh import does not reuse beta 5's cached popper or swinger definitions.
- Keeps **Validate Stage** and **Export Practisim Stage** visibly disabled.

## Requirements

- Windows x64.
- SketchUp Make 2017.2.2555.
- An existing Practisim `.STG` file.

## Install

Download the RBZ below, then follow the illustrated [Install and Test Guide](https://github.com/statuscheckgg/stage-bridge/blob/main/Docs/Install-And-Test.md). This prerelease is unsigned; only approve it when downloaded from this official repository.

After upgrading, start a new SketchUp model and re-import the original STG. Do not judge beta 6 from a SketchUp model saved by an earlier beta.

## Known Limits

- This beta imports and edits for visual testing; it does not export a Practisim-readable STG.
- Unsupported props remain tagged magenta placeholders.
- SketchUp Web, current SketchUp releases, macOS, and iPad are not supported.
- SketchUp Make 2017 is no longer supported by Trimble.

Stage Bridge is independent and is not affiliated with or endorsed by Practisim, SketchUp, or Trimble.
