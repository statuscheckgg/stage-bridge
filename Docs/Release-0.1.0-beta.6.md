# Stage Bridge 0.1.0-beta.6

Beta 6 is an unsigned import-and-edit preview for SketchUp Make 2017. It corrects mechanical, short-target, and two-foot fault-line mappings and confirms the requested white-center target stacks.

## What Changed

- Turns the selected full-size Big Prop popper (`Group#180`) 180 degrees internally so its mechanism falls in the same direction as the Practisim model.
- Maps `uspsa-swinger` and `uspsa-swinger-right` to the complete Big Prop swinger (`Group#167`) with stand, pivot arms, target, and counterweight.
- Keeps white-center two-stack props on Big Prop `Group#275`; the visible white no-shoot band is between the target bodies and leaves the upper headbox tan.
- Maps Practisim `uspsa-full-target-short` to the low upright Big Prop assembly `USPSA target and stand#7`.
- Maps Practisim `faultline-2ft` to a correctly sized yellow two-foot fault line instead of an unknown-prop placeholder.
- Uses a new component schema so a fresh import does not reuse older cached popper, swinger, or short-target definitions.
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
