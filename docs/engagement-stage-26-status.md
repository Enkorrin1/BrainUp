# Stage 26 Status: Story Worlds And Missions

Stage 26 adds the first story layer to BrainUp. The app now frames lessons as
missions inside themed worlds instead of showing only a generic route.

## Implemented

- Added `StoryWorldState`.
- Added `StoryWorldDefinition`.
- Added `StoryWorldProgress`.
- Added 8 story worlds:
  - Space Station;
  - Forest Lab;
  - Robot Town;
  - Shape Garden;
  - Toy Shop;
  - Underwater City;
  - Dinosaur Island;
  - Riddle Castle.
- Assigned all 24 starter lessons to story worlds.
- Added world mission progress calculation.
- Exported story worlds in `docs/content-manifest.json`.
- Added current mission copy to the path launch panel.
- Added a horizontal story world strip to the path screen.
- Added current mission text to the lesson header.
- Added mission progress to the lesson completion screen.

## Verified

- domain tests cover world assignment and progress states;
- widget tests cover map mission copy, lesson mission header, and completion
  mission progress.

## Next

Stage 27 should make the helper characters feel alive: each world already has a
default helper, so the next step is to use those helpers for feedback, hints,
streaks, and boss moments.
