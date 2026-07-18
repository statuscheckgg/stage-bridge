# Manual Beta Test - SketchUp Make 2017

Use a copy of a familiar Practisim stage containing several walls, targets, fault lines, and barrels. Keep the original `.STG` unchanged.

## 1. Install Beta 3

1. Close SketchUp.
2. Open SketchUp Make 2017.
3. Select `Window > Extension Manager`.
4. Select `Install Extension`.
5. Choose `stage-bridge-0.1.0-beta.3.rbz`.
6. Restart SketchUp if requested.
7. Confirm that `Extensions > Stage Bridge` is present.

This development package is unsigned. If SketchUp refuses to load it, temporarily select the `Unrestricted` extension-loading policy for this local test. Restore the stricter policy after testing. The public release will use a signed RBZ.

Do not reuse a SketchUp model imported with beta 1 or beta 2. Start with the original `.STG` file.

## 2. Import a Known Stage

1. Start a new empty SketchUp model.
2. Select `File > Import`.
3. Set the file type to `Practisim Stage (*.STG)`.
4. Select the copied test stage.
5. Wait for SketchUp to zoom to the imported stage.

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

## 5. Validate

1. Select `Extensions > Stage Bridge > Validate Stage`.
2. Read the complete result.

Expected result:

- Normal supported edits pass validation.
- Untagged SketchUp geometry produces a warning and is ignored.
- Mirrored, sheared, pitched, rolled, or exploded tagged props block export.

If validation fails unexpectedly, capture a screenshot and the complete validation message before changing anything else.

## 6. Export to a New STG

1. Select `Extensions > Stage Bridge > Export Practisim Stage`.
2. Save as a new file such as `MyStage-SketchUp-Test.STG`.
3. Do not overwrite the original stage during beta testing.
4. If targets or steel were added, duplicated, or deleted, review the proposed paper, steel, no-shoot, round, and point totals.

## 7. Check the Result in Practisim

Open the exported file in Practisim and confirm:

- The stage opens without an error.
- Moved and rotated props match the SketchUp edit.
- The scaled fault line has the expected length.
- The duplicated barrel exists once at the new position.
- The deleted prop is gone.
- The newly added prop exists.
- Targets and walls are not upside down or below the ground.
- Briefings, stage shape, camera information, activation behavior, and custom properties still exist.
- Paper, steel, no-shoot, round, and point totals are correct.

## 8. Round-Trip Once More

1. Start another new empty SketchUp model.
2. Import the exported test `.STG`.
3. Confirm that the edited layout matches what was exported.
4. Run `Validate Stage` again.

## Report a Problem

Record:

- SketchUp Make build number.
- Stage Bridge version.
- Practisim version or file version if known.
- Prop name that behaved incorrectly.
- Whether the problem appeared during import, editing, validation, export, or Practisim reopening.
- Complete validation message.
- Before-and-after screenshots.

Do not publish a private stage file unless you intentionally want to share it.
