# Backup and Recovery

The public import-and-edit MVP has STG validation and export disabled. The behavior below documents the in-development export implementation and does not describe an available preview command.

- Export defaults to a new filename ending in `-SketchUp.STG`.
- Stage Bridge never silently overwrites an existing file.
- Confirmed overwrites first create `<file>.backup-YYYYMMDD-HHMMSS` beside the target.
- Writes use a temporary sibling file followed by a rename. If replacement fails after the original is removed, Stage Bridge restores the backup.
- The open SketchUp model embeds the latest exported source JSON, source encoding, path, and hash.

If an exported stage does not open correctly in Practisim:

1. Stop editing the exported file.
2. Restore the timestamped backup if an overwrite was used.
3. Keep the `.skp` model and rejected `.STG` for diagnostics.
4. Run `Validate Stage` and capture the full message.
5. Report the SketchUp build, Stage Bridge version, Practisim file version, and validation message without publishing private stage files unless intentionally shared.
