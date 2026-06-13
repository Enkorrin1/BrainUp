# Content Stage 17 Status

## Goal

Define and create the BrainUp asset system so future rich puzzle scenes can
reference stable character, world, puzzle, reward, and effect assets.

## Delivered

- Added `docs/content-asset-system.md`.
- Created tracked asset roots:
  - `mobile/assets/images/characters/`;
  - `mobile/assets/images/worlds/`;
  - `mobile/assets/images/rewards/`;
  - `mobile/assets/images/effects/`.
- Added first-pack subfolders for P0 characters and worlds.
- Registered new asset roots in `mobile/pubspec.yaml`.
- Defined naming rules and metadata id conventions for:
  - characters;
  - worlds;
  - puzzle family assets;
  - rewards;
  - feedback effects.
- Defined placeholder and QA rules.

## Why It Matters

BrainUp now has a real filesystem target for the visual puzzle system. Stage 18
can add metadata fields like `worldId`, `characterId`, `sceneAsset`, and
`choiceAssets` without inventing paths later.

## Next Step

Stage 18 should extend puzzle data with visual metadata and add tests that make
sure production-ready puzzle metadata references known worlds, characters, and
asset ids.
