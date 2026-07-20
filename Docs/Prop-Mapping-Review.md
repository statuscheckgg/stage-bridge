# Prop Mapping Review

This is the review surface for coordinating Practisim STG `propName` values with Stage Bridge catalog entries and the selected SketchUp 2017 geometry. It records the current choices without treating them as final approvals.

## Mapping Chain

`STG propName` -> catalog alias -> catalog key -> packaged `.skp` asset or procedural builder -> normalized Stage Bridge component -> preserved STG transform on export

The packaged component controls only the SketchUp appearance. The original STG prop name, unique ID, transform, activation data, and original JSON remain attached to the component instance.

## Props Observed in the Three Reference Stages

| STG `propName` | Catalog key | Current SketchUp selection | Big Prop source definition | Review state |
|---|---|---|---|---|
| `barrel-plastic` | `barrel` | `barrel.skp` | `ske245` | Selected asset |
| `barrel-plastic-stack` | `barrel_stack` | `barrel_stack.skp` | `Stacked_Barrels` | Selected asset |
| `faultline-4ft` | `faultline_4ft` | Local fixed-length box | — | Procedural |
| `faultline-8ft` | `faultline_8ft` | Local fixed-length box | — | Procedural |
| `faultline-adjustable` | `faultline_adjustable` | Local endpoint-based adjustable line | — | Procedural; custom color retained |
| `ssi-double-x-start-box` | `double_x_start` | Local double-X marker | — | Procedural |
| `start-position` | `start_position` | `start_position.skp` | `USPSA Shooting Box- 3X3` | Selected asset |
| `uspsa-full-short-tilted` | `uspsa_target_short_tilted` | `uspsa_target_short_tilted.skp` | `USPSA target and stand#8` | Selected asset |
| `uspsa-full-target` | `uspsa_target` | `uspsa_target_high.skp` | `Uspsa target and stand high#1` | Selected asset |
| `uspsa-noshoot-onstand` | `uspsa_no_shoot` | `uspsa_no_shoot_high.skp` | `USPSA No shoot High` | Selected asset |
| `uspsa-popper` | `uspsa_popper` | `uspsa_popper.skp`, internal yaw 180 degrees | `Group#180` | Approved leftmost full-size popper; fall direction corrected |
| `uspsa-swinger` | `uspsa_swinger` | `uspsa_swinger.skp` | `Group#167` | Selected complete swinger and counterweight assembly |
| `uspsa-two-noshoot-vert` | `two_stack_no_shoot` | `uspsa_two_stack_noshoot.skp` | `Group#275` | Approved white-center vertical stack |
| `uspsa-two-stack-hc` | `two_stack_hc` | Derived black-center copy of `uspsa_two_stack_noshoot.skp` | `Group#275` | Approved beta derivation |
| `uspsa-two-stack-noshoot` | `two_stack_no_shoot` | `uspsa_two_stack_noshoot.skp` | `Group#275` | Approved white-center vertical stack |
| `wall-targetsusa-4ft-frame` | `wall_4ft` | `wall_plain_4ft.skp` | `Group#286` | Approved plain wall with both supports |
| `wall-targetsusa-8ft-frame` | `wall_8ft` | `wall_plain_8ft.skp` | `Group#336` | Approved plain wall with both supports |

## Previous Wall Behavior

The current `wall_base.skp` comes from `Clear wall`, whose native definition bounds are approximately 52 inches wide, 96 inches tall, and 4.24 inches deep.

Before the plain-wall change, Stage Bridge applied these visual scales:

| STG wall | Current source | Scale applied | Resulting outside size |
|---|---|---|---|
| 4 x 6 ft | `Clear wall` | X `0.9231`, Z `0.75` | 48 x 72 in |
| 8 x 6 ft | `Clear wall` | X `1.8462`, Z `0.75` | 96 x 72 in |
| 1 x 2 m | `Clear wall` | X `0.7571`, Z `0.8202` | 39.37 x 78.74 in |
| 2 x 2 m | `Clear wall` | X `1.5142`, Z `0.8202` | 78.74 x 78.74 in |
| 3 x 2 m | `Clear wall` | X `2.2714`, Z `0.8202` | 118.11 x 78.74 in |

This made the outside bounds correct but stretched the component's frame members and panel details. The 4 x 6 ft and 8 x 6 ft mappings no longer use this approach. Metric walls still use `Clear wall` pending their own review.

## Wall Candidates Found in Big Prop File

The inventory contains several plausible alternatives. Names alone are not sufficient for final selection, so these should be reviewed as rendered SketchUp thumbnails.

| Candidate definition | Native approximate size | Why it is worth reviewing |
|---|---:|---|
| `Clear wall` | 52 x 96 x 4.24 in | Current choice; known appearance |
| `Clear wall#6` | 52 x 72 x 4 in | Native six-foot height; less vertical distortion |
| `Clear wall#9` | 48 x 72 x 4 in | Native 4 x 6 ft bounds; likely strongest 4-foot candidate |
| `Clear wall#11` | 48 x 72 x 4 in | Native 4 x 6 ft bounds with a different internal variant |
| `Clear wall#12` | 48 x 72 x 4 in | Native 4 x 6 ft bounds and higher geometry detail |
| `HalfWallWOPort` | 52.31 x 72 x 0.81 in | Six-foot wall without a port; may represent a solid panel rather than a frame |
| `HalfWallWPort` | 52.31 x 72 x 0.81 in | Port-wall candidate for future STG aliases |
| `Rifle Barricade` | 48 x 72 x 0.75 in | Exact 4 x 6 ft bounds but likely the wrong construction style |

### Solid Green Wall Family

The green panel walls shown together in the source collection are a different family from the currently packaged `Clear wall` frame:

| Source definition | Approximate bounds | Identification confidence |
|---|---:|---|
| `HalfWallWOPort` | 52.31 x 72 x 0.81 in | Confirmed solid green panel without port |
| `HalfWallWPort` | 52.31 x 72 x 0.81 in | Confirmed solid green panel with small port |
| `Group#284` | 98.49 x 77.17 x 18.01 in including supports | Likely wide solid/no-port assembly; generic source name requires thumbnail confirmation |
| `Group#295` | 98.49 x 80.79 x 18.01 in including supports | Likely wide ported assembly; generic source name requires thumbnail confirmation |

The half-wall definitions contain the green panel itself; the support sticks and feet visible in the collection may be adjacent/grouped geometry rather than part of those two definitions. These solid walls are not the `Clear wall` definition currently packaged by Stage Bridge.

Rendered inspection established the useful complete assemblies:

- `Group#286`: plain approximately 4-foot-wide green wall with both yellow supports and black feet.
- `Group#336`: plain approximately 8-foot-wide wall with both supports and feet; its unpainted panel receives the Stage Bridge green instance material.
- `Group#284`: wide wall with a port, not the plain wall.
- `Group#295`: doorway wall, not the plain wall.

The 4-foot and 8-foot STG wall mappings now use `Group#286` and `Group#336` at their native proportions. The component bounds include support feet, so they are slightly wider, deeper, and taller than the nominal panel dimensions.

For an 8 x 6 ft wall, the review should compare:

1. One 4 x 6 ft component scaled only along X.
2. Two unscaled 4 x 6 ft panels placed side-by-side, preserving member thickness and adding a center seam/post.
3. A dedicated 8 x 6 ft definition if a visually correct one is identified elsewhere in the collection.

## Current Packaged Target Choices

| Stage Bridge asset | Big Prop definition | Intended STG props |
|---|---|---|
| `uspsa_target_high.skp` | `Uspsa target and stand high#1` | `uspsa-full-target`, `uspsa-target` |
| `uspsa_target_short.skp` | `USPSA target and stand#10` | `uspsa-full-target-short` |
| `uspsa_target_short_tilted.skp` | `USPSA target and stand#8` | `uspsa-full-short-tilted` |
| `uspsa_no_shoot_high.skp` | `USPSA No shoot High` | `uspsa-noshoot`, `uspsa-noshoot-onstand` |
| `uspsa_popper.skp` | `Group#180` | `uspsa-popper` and full-popper aliases |
| `uspsa_swinger.skp` | `Group#167` | `uspsa-swinger`, `uspsa-swinger-right` |
| `uspsa_two_stack_noshoot.skp` | `Group#275` | white-center and derived black-center vertical stacks |

The Big Prop collection contains many similarly named target definitions with different heights, hard-cover/no-shoot arrangements, and nearby target combinations. These should not all alias to a single asset without reviewing the corresponding STG prop semantics.

## Proposed Approval Workflow

1. Render a numbered contact sheet for the wall candidates above.
2. Choose one definition for 4 x 6 ft walls and one construction method for 8 x 6 ft walls.
3. Render numbered sheets for paper/no-shoot/stacked/mechanical candidates.
4. Approve mappings by STG `propName`, not by approximate appearance alone.
5. Extract only the approved definitions into the RBZ and record their source names and hashes in `components/manifest.json`.
6. Re-run Garage, CrabLegs, and Bay 7 visual and round-trip tests.

Future asset selections should be changed in code only after the corresponding review choice is approved.
