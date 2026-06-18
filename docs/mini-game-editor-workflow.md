# BrainUp Mini-Game Editor Workflow

## Goal

Create playable mini-game levels from content data instead of screen code.
Writers and designers should be able to author a level config, validate it,
preview the generated definition, and then connect it to a puzzle family.

## Authoring Format

Each playable puzzle uses `MiniGameContentConfig` in Dart and mirrors one JSON
template in `docs/mini-game-editor-templates/`.

Required fields:

- `gameKey`: runtime family such as `memoryGrid`, `logicPath`,
  `shapeBuilder`, or `bossMix`;
- `templateId`: visual/gameplay template id;
- `tutorialKey`: child-facing tutorial copy key;
- `assetSlots.background`: scene background asset id;
- `assetSlots.primaryObject`: main object asset id;
- `effectCueIds`: visual feedback ids;
- `audioCueIds`: safe sound cue ids;
- `limits.minRounds`: number of playable rounds;
- `limits.reducedMotionSafe`: must be `true` before release.

## Validation

Run from `mobile/`:

```powershell
dart run tool/validate_mini_game_content.dart
```

Optional preview fixture export:

```powershell
dart run tool/validate_mini_game_content.dart --write-preview
```

The validator checks:

- content QA blockers;
- mini-game-ready configs;
- registry conversion into `MiniGameDefinition`;
- quality audit for rounds, assets, character reactions, audio, and duration;
- Stage 41 content wave targets.

## Production Flow

1. Pick the closest template from `docs/mini-game-editor-templates/`.
2. Fill world, character, asset slots, effect cues, and audio cues.
3. Connect the config to a puzzle's `VisualPuzzleMetadata`.
4. Run the validator.
5. Regenerate `docs/content-manifest.json`.
6. Smoke test the level in the Android emulator.

## Current Runtime Families

- `memoryGrid`: reveal and remember card order.
- `logicPath`: trace a route to a valid endpoint.
- `shapeBuilder`: rotate and match spatial shapes.
- `bossMix`: three-step mixed-skill boss gate.
