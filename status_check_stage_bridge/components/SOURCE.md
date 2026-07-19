# Legacy Stage-Building Component Pack

These SketchUp 2017 component files are extracted from the user-supplied `Big Prop File.skp` collection, described by the user as publicly available and free to distribute specifically for stage building.

The Stage Bridge wrapper normalizes each component to a bottom-center origin. Practisim coordinate, yaw, scale, and round-trip metadata remain controlled by the extension rather than by the component's original placement in the collection model.

The source collection itself is not packaged in the RBZ. Only mapped component definitions are included.

The plain 4 x 6 ft and 8 x 6 ft wall assets use the complete supported assemblies `Group#286` and `Group#336`, respectively. The older `Clear wall` asset remains packaged only for metric-wall mappings pending their separate review.

The full-size steel popper uses `Group#180`, the leftmost full-size popper in the source collection's four-popper row. The vertical white-center stacked-target assembly uses `Group#275`. The hard-cover stacked-target mapping uses a private copy of that same assembly and replaces only its white center material with black when the component is built; the packaged source asset is not modified.

`manifest.json` records the source collection fingerprint, source definition names, extracted asset sizes, and extracted asset fingerprints. The source collection's original local path is intentionally not stored in the distributable package.
