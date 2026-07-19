# Manual Beta Test - SketchUp Make 2017

Use a copy of a familiar Practisim stage containing several walls, targets, fault lines, and barrels. Keep the original `.STG` unchanged.

## 1. Install Beta 4

1. Close SketchUp.
2. Open SketchUp Make 2017.
3. Select `Window > Extension Manager`.
4. Select `Install Extension`.
5. Choose `stage-bridge-0.1.0-beta.4.rbz`.
6. Restart SketchUp if requested.
7. Confirm that `Extensions > Stage Bridge` is present.

This development package is unsigned. If SketchUp refuses to load it, temporarily select the `Unrestricted` extension-loading policy for this local test. Restore the stricter policy after testing. The public release will use a signed RBZ.

Do not reuse a SketchUp model imported with beta 1 or beta 2. Beta 3 models remain compatible with beta 4.

## 2. Import a Known Stage

1. Start a new empty SketchUp model.
2. Select `File > Import`.
3. Set the file type to `Practisim Stage (*.STG)`.
4. Select the copied test stage.
5. Wait for SketchUp to zoom to the imported stage.

After a successful import, close and reopen SketchUp and use the Stage Bridge import command again. Its file dialog should begin in the same folder.

Before editing, confirm:

- Walls are upright and rest on the ground.
- Paper targets and no-shoots are upright unless the Practisim prop is intentionally tilted.
- Barrels rest on the ground.
- Fault lines are normal stage lengths and do not cross the model indefinitely.
- Adjustable fault lines begin at the same Practisim endpoint and retain their custom color.
- A double-X start position appears as two X marks, not a magenta box.
- Swinger targets appear as tagged target/frame assemblies, not magenta boxes.
- Relative prop positions and facing directions match the familiar Practisim stage.
- Unsupported props appear as magenta placeholders instead of disappearing.

## 3. Select the Correct Prop Wrapper

1. Find the outer group named `Stage Bridge - <stage name>`.
2. Double-click that group once to enter it.
3. Single-click a prop to select the whole tagged component.

The blue selection box should surround the entire target, wall, barrel, or fault line. Do not double-click an individual prop, edit its internal faces, or use `Explode`.

## 4. Exercise Normal SketchUp Editing

Perform these edits using the normal SketchUp tools:

- Move one paper target with the Move tool.
- Rotate one target around the blue vertical axis with the Rotate tool.
- Move and rotate one wall.
- Resize one adjustable fault line along its length with the Scale tool.
- Duplicate one barrel using Move plus `Ctrl`.
- Delete one existing prop.
- Select `Extensions > Stage Bridge > Add Practisim Prop`, then add one familiar target, wall, or barrel from the list.

Keep every prop upright. Do not mirror, pitch, roll, shear, explode, or edit the geometry inside a tagged component.

## 5. Confirm Preview Restrictions

Confirm these two commands are present but grayed out:

- `Validate Stage`
- `Export Practisim Stage`

They are intentionally unavailable in the public import-and-edit preview. Do not work around the disabled commands or use this build to produce a match STG.

## 6. Review Prop Coordination

Compare the imported stage with the familiar Practisim layout and record:

- Incorrect SketchUp component choice.
- Missing or placeholder props.
- Incorrect dimensions, origin, orientation, or ground placement.
- Whether a better component exists in the public Big Prop collection.

Use the exact STG `propName` when available. The current mapping audit is recorded in `Docs\Prop-Mapping-Review.md`.

## 7. Save an Optional SKP Review Copy

You may save the SketchUp model for visual review. The `.skp` file is not a replacement for the original STG and cannot be converted back by the public MVP.

## Report a Problem

Record:

- SketchUp Make build number.
- Stage Bridge version.
- Practisim version or file version if known.
- Prop name that behaved incorrectly.
- Whether the problem appeared during import or visual editing.
- Before-and-after screenshots.

Do not publish a private stage file unless you intentionally want to share it.
