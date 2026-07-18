# Compatibility Contract

- Verified target: SketchUp Make 2017.2.2555 x64 on Windows.
- Embedded runtime: Ruby 2.2.4.
- Stage source: an existing JSON-based Practisim `.STG` file.
- Supported edits: add, delete, move, vertical rotate, scale, and duplicate tagged catalog components.
- Unsupported edits: arbitrary geometry inference, component explosion, mirroring, shear, pitch/roll, blank-stage authoring, or cloud synchronization.
- Unsupported SketchUp surfaces: Web, iPad, macOS, and newer desktop releases unless a later release explicitly adds them.

SketchUp Make 2017 is unsupported by Trimble. Web services such as Extension Warehouse and 3D Warehouse may be unavailable. Install the RBZ locally through Extension Manager.

Stage models imported under an older transform profile are not export-compatible with beta 2. Re-import the original `.STG` so the corrected yaw and ground-offset metadata are applied.
