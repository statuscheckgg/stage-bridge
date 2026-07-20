# Changelog

## 0.1.0-beta.7 - 2026-07-20

- Replaced the repeated Stage Bridge toolbar artwork with distinct function-specific icons for Import Stage, Add Prop, Validate Stage, and Export Stage.
- Added a matching information-document icon for the Stage Metadata menu command.
- Kept Validate and Export visibly disabled while preserving recognizable command silhouettes in their grayed-out state.

## 0.1.0-beta.6 - 2026-07-20

- Reversed the internal yaw of the selected full-size popper asset so its mechanism and fall direction match Practisim without changing the preserved STG transform.
- Replaced the simplified procedural swinger with complete Big Prop assembly `Group#167`, including its stand, pivot arms, target, and counterweight.
- Reconfirmed the white-center two-stack mapping on Big Prop `Group#275`, whose visible no-shoot band sits between the target bodies without covering the upper headbox.
- Remapped `uspsa-full-target-short` to the low upright Big Prop assembly `USPSA target and stand#7` instead of the incorrectly oriented `#10` variant; verified at 20 x 18 x 43.693 inches in SketchUp.
- Mapped Practisim `faultline-2ft` to a yellow 24 x 3.5 x 1.5-inch procedural fault line instead of the magenta unknown-prop placeholder.
- Bumped the model component schema so re-imported stages cannot reuse stale beta 5 or earlier beta 6 component definitions.

## 0.1.0-beta.5 - 2026-07-18

- Removed SketchUp's stock template person whenever an STG stage is imported.
- Mapped `uspsa-popper` to the selected leftmost full-size Big Prop popper assembly `Group#180`.
- Mapped white-center vertical stacked targets to Big Prop assembly `Group#275`.
- Derived the `uspsa-two-stack-hc` visual from the same stack with a private white-to-black center recolor.
- Added SketchUp 2017 regressions for person removal, packaged asset dimensions, and white/black stack isolation.
- Added an illustrated, plain-language installation and manual-test guide for GitHub testers.

## 0.1.0-beta.4 - 2026-07-18

- Remembered the most recently successful STG import folder across SketchUp restarts.
- Reused that folder for the Stage Bridge import dialog; the same preference is ready for export when that feature is enabled.
- Added safe fallback to the current stage source folder or the user's home folder when the remembered directory no longer exists.
- Defined the public MVP as an import-and-edit preview.
- Grayed out `Validate Stage` and `Export Practisim Stage` pending mapping refinement and reopen-in-Practisim acceptance testing.
- Replaced the stretched clear-frame 4 x 6 ft and 8 x 6 ft wall visuals with the native-proportion plain supported wall assemblies `Group#286` and `Group#336` from Big Prop.

## 0.1.0-beta.3 - 2026-07-18

- Corrected adjustable fault-line origins so Practisim translations identify the start endpoint instead of the center of the line.
- Preserved imported adjustable fault-line colors, including custom red and green lines.
- Added a dedicated double-X start-position component for `ssi-double-x-start-box`.
- Added a tagged procedural swinger assembly for `uspsa-swinger` and `uspsa-swinger-right` instead of using an unsupported-prop placeholder.
- Added endpoint, color, double-X, and swinger regressions to the SketchUp 2017 smoke test.
- Blocked export from models imported with earlier beta transform profiles so corrected stages are always re-imported from the original `.STG`.

## 0.1.0-beta.2 - 2026-07-18

- Corrected visual yaw after the Practisim-to-SketchUp Y-axis reflection.
- Corrected adjustable fault lines to use Practisim's 0.1-meter base mesh before applying source scale.
- Added reversible display-only ground offsets for props whose source Z places their visual mesh below the SketchUp ground plane.
- Added packaged SketchUp 2017 components for common walls, USPSA targets and no-shoots, barrels, barrel stacks, and start markers.
- Normalized packaged component origins to bottom center while preserving source transforms for export.
- Added visual geometry regression checks and required-component RBZ structure validation.
- Added a component source manifest with size and SHA-256 verification.
- Made root extension metadata read the canonical version constant to prevent release-version drift.
- Blocked export from beta 1 imported models so stages are re-imported under the corrected transform profile.

## 0.1.0-beta.1 - 2026-07-18

- Initial SketchUp Make 2017 extension scaffold.
- Practisim STG import with UTF-8 and UTF-16LE detection.
- Embedded source preservation and reversible calibrated transform mapping.
- Tagged supported-prop catalog with visible unknown placeholders.
- Safe export, duplicate-ID allocation, activation checks, scoring review, atomic writes, and overwrite backups.
- Synthetic core fixture, SketchUp startup smoke harness, RBZ packaging validation, and public-beta documentation.
