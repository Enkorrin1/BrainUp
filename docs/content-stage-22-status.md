# Stage 22 Status: Content Placement Rules

Stage 22 makes content placement explicit. BrainUp now has a catalog-level
contract for where puzzle content can appear and how large each learning moment
should be.

## Implemented

- Added `ContentPlacement` for:
  - main learning route;
  - daily challenge;
  - adaptive review;
  - boss node;
  - mistake repeat;
  - parent analytics;
  - reward collection;
  - age track;
  - weak-skill recommendation.
- Added `ContentPlacementRule` with min, max, and default puzzle counts.
- Added placement rules to `FoundationCatalog.contentManifest()`.
- Added per-lesson placement export to the manifest.
- Routed normal lessons to `mainRoute`.
- Routed the adaptive review lesson to `adaptiveReview`.
- Routed every 12th lesson to `bossNode`.
- Expanded boss lessons to 7 default puzzles.
- Filtered normal and review lessons away from boss-only content.
- Prioritized mixed or boss-difficulty puzzles inside boss lessons.

## Verified

Tests now cover:

- manifest placement rule export;
- placement classification for normal, review, and boss lessons;
- normal lesson size;
- adaptive review size;
- boss lesson size;
- boss lesson inclusion of mixed or boss content.

## Next

Stage 23 should turn the manifest into a content dashboard that shows whether
the catalog is healthy enough to keep scaling.
