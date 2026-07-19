# Compatibility Contract

- Verified target: SketchUp Make 2017.2.2555 x64 on Windows.
- Embedded runtime: Ruby 2.2.4.
- Stage source: an existing JSON-based Practisim `.STG` file.
- Public MVP surface: import existing stages; add, delete, move, vertical rotate, scale, and duplicate tagged catalog components for visual design evaluation.
- Public MVP restrictions: `Validate Stage` and `Export Practisim Stage` are disabled until prop mapping and reopen-in-Practisim testing are complete.
- Unsupported edits: arbitrary geometry inference, component explosion, mirroring, shear, pitch/roll, blank-stage authoring, or cloud synchronization.
- Unsupported SketchUp surfaces: Web, iPad, macOS, and newer desktop releases unless a later release explicitly adds them.

SketchUp Make 2017 is unsupported by Trimble. Web services such as Extension Warehouse and 3D Warehouse may be unavailable. Install the RBZ locally through Extension Manager.

The preview must not be represented as a production STG conversion tool. Stage models imported under older transform profiles will need to be re-imported before future export testing.
