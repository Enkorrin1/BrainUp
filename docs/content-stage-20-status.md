# Stage 20 Status: Interactive Mechanics

Stage 20 adds the first playable interaction layer for BrainUp puzzle content.
The app no longer treats rich puzzles as plain multiple-choice data only:
visual puzzle metadata can now be converted into structured interaction specs
for future lesson renderers.

## Implemented

- Added `ChallengeInteractionSpec` to `DailyChallenge`.
- Added interaction items with labels and optional asset ids.
- Added interaction targets for drag, trace, and sort mechanics.
- Added correctness helpers for ordered card flows and pair/target matching.
- Mapped non-tap `PuzzleInteractionType` values into daily challenge specs:
  - drag to target;
  - reorder cards;
  - match pairs;
  - memory reveal;
  - trace path;
  - rotate object;
  - sort objects;
  - multi-step boss.
- Preserved the existing single-choice lesson fallback.

## Verified

The test suite now checks that curated content exposes concrete interaction
specs for:

- match pairs;
- drag-to-target;
- memory reveal.

## Next

Stage 21 should start rendering these specs in the lesson UI with lightweight
animations and feedback states. The safest first UI targets are:

- match-pair connector cards;
- drag-to-target answer drop zone;
- memory reveal flip cards.
