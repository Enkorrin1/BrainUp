# Stage 30 Status: Weekly Events

Stage 30 makes the existing route feel fresh with configurable weekly themes
that sit on top of normal progress instead of replacing it.

## Delivered

- Added `WeeklyEventDefinition` and `WeeklyEventProgress`.
- Added `FoundationCatalog.weeklyEvents` with configured event windows:
  - Star Hunt;
  - Robot Week;
  - Shape Garden Festival;
  - Memory Mission;
  - Logic Detective Week.
- Added active-event lookup by date.
- Added event progress computed from already completed featured lessons.
- Added event puzzle filtering by world, skill, type, and age band.
- Added event reward references to the Stage 29 reward catalog.
- Exported `weeklyEvents` in `docs/content-manifest.json`.
- Added a path-screen event banner with:
  - event title and subtitle;
  - remaining days;
  - lesson progress;
  - themed puzzle count;
  - reward preview;
  - CTA to the next event lesson.

## Verification Coverage

- Domain tests cover active event lookup, completion state, next event lesson,
  puzzle filters, and manifest export.
- Widget tests cover visible event progress on the path and CTA routing.

## Next Recommended Stage

Stage 31 should make boss levels feel special with boss mini-games, checkpoint
feedback, and larger reward moments.
