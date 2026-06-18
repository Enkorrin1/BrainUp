# Mini-Game Stage 32 Status

## Status

Implemented.

Stage 32 adds the first mini-game runtime foundation for BrainUp. This is not
yet the full content wave. It is a safe vertical slice that proves the app can
open a playable Flame surface from a lesson, return a normalized result, and
keep the existing lesson fallback stable.

## Delivered

- Added `flame` and `flame_audio` to the Flutter app dependencies.
- Added `mobile/lib/src/mini_games/core`.
- Added `MiniGameDefinition`, `MiniGameRoundDefinition`, `MiniGameResult`,
  `MiniGameController`, and `MiniGameRegistry`.
- Added `MiniGameHostScreen` with a Flutter overlay around a Flame `GameWidget`.
- Added a placeholder `MemoryGridPreviewGame` running on Flame.
- Connected memory reveal puzzles to the mini-game launcher.
- Kept the existing lesson interaction widgets as fallback controls.
- Added mini-game readiness data to `FoundationCatalog.contentManifest()`.
- Added tests for registry mapping, result normalization, manifest readiness,
  and widget-level mini-game launch.

## Runtime Flow

```text
LessonScreen
  -> DailyChallenge
  -> MiniGameRegistry.definitionForChallenge
  -> MiniGameHostScreen
  -> Flame GameWidget
  -> MiniGameResult
  -> LessonScreen answer state
  -> AppController lesson completion and adaptive review
```

## Current Mini-Game Coverage

Enabled in this stage:

- `PuzzleInteractionType.memoryReveal`;
- `PuzzleType.memoryGrid`;
- placeholder Flame scene: `MemoryGridPreviewGame`.

Not enabled yet:

- logic path;
- shape builder;
- math bubbles;
- attention scan;
- boss mix as a full Flame game.

## Next Stage

Stage 33 should turn the placeholder layer into the first real playable pack:

- production `MemoryGridGame`;
- first `LogicPathGame`;
- first `ShapeBuilderGame`;
- shared tutorial overlay;
- shared success and retry effects;
- stronger mini-game asset mapping.
