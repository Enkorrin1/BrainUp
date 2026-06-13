# Content Stage 12 Status

## Goal

Make the content bank exportable so future internal tooling can inspect puzzle
coverage, detect gaps, and preview puzzle metadata without parsing Dart source.

## Delivered

- Added JSON serialization for `PuzzleDefinition`.
- Added JSON serialization for `ContentCoverageReport` and
  `ContentCoverageGap`.
- Added `FoundationCatalog.contentManifest()` as the source of truth for
  exportable content metadata.
- Added `mobile/tool/export_content_manifest.dart`.
- Generated `docs/content-manifest.json` from the current catalog.

## Manifest Shape

The exported manifest contains:

- `schemaVersion`;
- quality gate status;
- coverage counts by age band, skill, difficulty, type, and age/skill pair;
- skill coverage gaps;
- full puzzle metadata for every generated and starter puzzle.

## Command

```powershell
cd mobile
dart run tool/export_content_manifest.dart
```

The command writes `../docs/content-manifest.json` by default.

## Next Step

Stage 13 should turn this manifest into a lightweight internal content dashboard
inside the app or a small local report, so content planning becomes visual.
