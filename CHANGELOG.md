# Changelog

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
