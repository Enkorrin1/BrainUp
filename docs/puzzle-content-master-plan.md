# BrainUp Puzzle Content Master Plan

## Goal

Turn BrainUp into a rich thinking app with many high-quality puzzle scenes, not
just many repeated questions. Each puzzle should feel individual: clear task,
beautiful visual setup, age-appropriate interaction, helpful character feedback,
and a place in the learning route, review loop, daily practice, or boss levels.

## Product Principle

Every puzzle should define:

- puzzle type;
- target skill;
- age band;
- difficulty;
- visual world;
- character or guide;
- scene assets;
- choice or object assets;
- interaction pattern;
- animation and feedback style;
- hint and explanation;
- intended placement in the app.

## Stage 13. Puzzle Content System

Create the quality standard for BrainUp puzzles.

Deliverable: `docs/puzzle-content-system.md`

Status: done in `docs/content-stage-13-status.md`.

Define:

- puzzle anatomy;
- visual requirements by puzzle type;
- easy, normal, hard, and boss rules;
- character feedback rules;
- hint and explanation quality;
- asset requirements;
- animation requirements;
- accessibility and readability rules for children.

## Stage 14. Puzzle Type Matrix

Design a broad set of puzzle families so the app feels varied.

Deliverable: `docs/puzzle-type-matrix.md`

Status: done in `docs/content-stage-14-status.md`.

Target families:

- odd one out;
- sequence completion;
- pair matching;
- memory order;
- route building;
- object counting;
- group comparison;
- shadow matching;
- shape rotation;
- rule arrangement;
- pattern detection;
- code solving;
- spot the difference;
- picture assembly;
- logic scales;
- mini sudoku;
- habitat matching;
- spatial maze;
- picture rebus;
- what changed;
- conditional path;
- object sorting;
- cause and effect;
- story ordering;
- mixed boss puzzle.

## Stage 15. Visual Worlds

Create memorable content worlds for tasks and lessons.

Deliverable: `docs/content-worlds.md`

Status: done in `docs/content-stage-15-status.md`.

Initial worlds:

- space station;
- forest lab;
- underwater city;
- robot town;
- castle of riddles;
- dinosaur island;
- toy shop;
- garden of shapes;
- train expedition;
- junior detective academy.

Each world should define backgrounds, object sets, character fit, rewards, and
preferred puzzle families.

## Stage 16. Helper Characters

Create recurring characters that make feedback warmer and more recognizable.

Deliverable: `docs/content-characters.md`

Status: done in `docs/content-stage-16-status.md`.

Initial roles:

- main BrainUp guide;
- memory guide;
- shape and space guide;
- math guide;
- logic guide;
- attention guide.

Each character needs portrait, emotional states, hint voice, success voice, and
recommended puzzle usage.

## Stage 17. Asset System

Move puzzle content toward real visual scenes.

Deliverable: asset structure and asset rules.

Status: done in `docs/content-stage-17-status.md`.

Target folders:

- `mobile/assets/images/puzzles/`
- `mobile/assets/images/characters/`
- `mobile/assets/images/worlds/`
- `mobile/assets/images/rewards/`

Asset categories:

- puzzle objects;
- cards;
- backgrounds;
- characters;
- skill icons;
- answer feedback effects;
- rewards;
- animated states.

## Stage 18. Visual Puzzle Metadata

Extend puzzle data so every puzzle can describe its scene.

Status: done in `docs/content-stage-18-status.md`.

Target fields:

- `worldId`;
- `characterId`;
- `sceneAsset`;
- `choiceAssets`;
- `animationType`;
- `feedbackStyle`;
- `estimatedSeconds`;
- `cognitiveLoad`;
- `bossMixTags`.

Result: each puzzle becomes a mini-scene that future UI and tooling can render.

## Stage 19. First Large Unique Puzzle Pack

Create the first high-quality content pack beyond generated variants.

Status: done in `docs/content-stage-19-status.md`.

Targets:

- 25 unique puzzle families;
- 6-10 tasks per family;
- 150-250 distinct puzzles;
- every puzzle has visual direction;
- every puzzle has hint and explanation;
- every puzzle maps to age, skill, difficulty, world, and interaction.

Suggested distribution:

- 40 logic puzzles;
- 40 memory puzzles;
- 40 math puzzles;
- 40 attention puzzles;
- 30 spatial puzzles;
- 30 mixed or boss puzzles.

## Stage 20. Interactive Mechanics

Add interaction types beyond tapping a choice.

Status: implemented as the first domain-level interaction spec layer in
`DailyChallenge`. Curated and generated visual puzzle metadata can now produce
playable specs for drag targets, pair matching, memory reveal, route tracing,
rotation, sorting, reorder cards, and boss interactions while keeping the
single-choice lesson fallback intact.

Initial mechanics:

- tap choice;
- drag and drop;
- reorder cards;
- match pairs;
- trace path;
- memory reveal;
- sort into baskets;
- rotate shape;
- build sequence;
- multi-step boss puzzle.

First implementation priority:

- drag reorder;
- match pairs.

Stage 20 delivered:

- `ChallengeInteractionSpec` model for non-tap mechanics;
- interaction items and drop targets with optional visual asset ids;
- correct-order and correct-match validation helpers;
- curated content tests for match pairs, drag-to-target, and memory reveal.

## Stage 21. Animations And Feedback

Make puzzle reactions pleasant and educational.

Status: first lesson UI layer implemented. Rich puzzle interaction specs now
render as lightweight in-lesson stages with visible mechanics, selectable
chips, animated memory reveal tokens, animated answer feedback, and state colors
for correct and retry outcomes.

Feedback examples:

- correct answer: card bounce, character celebration, reward sparkle;
- wrong answer: soft highlight, character encouragement, targeted hint;
- hint opened: relevant objects pulse;
- series complete: reward animation;
- boss complete: portal, chest, badge, or star reveal.

Animations should support learning clarity rather than distract from the task.

Stage 21 delivered:

- in-lesson interaction stage for rich puzzle specs;
- visible badges for match, drag, reveal, order, trace, rotate, sort, and boss;
- memory reveal card entrance animations;
- animated answer feedback with scale and fade transitions;
- widget coverage for the adaptive review reveal mechanic.

## Stage 22. Content Placement Rules

Define where each puzzle type is used.

Status: implemented in `FoundationCatalog` as explicit placement rules and
lesson placement routing. Normal lessons, adaptive review lessons, and boss
nodes now use different default puzzle counts and candidate filters.

Placements:

- main learning route;
- daily challenge;
- adaptive review;
- boss nodes;
- mistake repeat;
- parent analytics;
- reward collection;
- age tracks;
- weak-skill recommendations.

Rules:

- normal lesson: 5 puzzles;
- review lesson: 3-5 puzzles from mistakes or weak skills;
- boss lesson: 6-8 mixed puzzles;
- daily challenge: 1 short puzzle;
- streak milestone: special reward puzzle.

Stage 22 delivered:

- `ContentPlacement` enum for route, review, boss, daily, reward, analytics,
  age track, mistake repeat, and weak-skill recommendation placements;
- `ContentPlacementRule` model with min/max/default puzzle counts;
- manifest export for placement rules and per-lesson placement;
- normal lessons fixed at 5 puzzles;
- adaptive review lessons kept within 3-5 puzzles;
- boss lessons expanded to 6-8 puzzles with priority for mixed or boss content.

## Stage 23. Content Dashboard

Use the Stage 12 manifest to make content quality visible.

Dashboard should show:

- total puzzle count;
- coverage by age;
- coverage by skill;
- coverage by type;
- missing coverage;
- puzzles without assets;
- puzzles without explanations;
- repeated or too-similar puzzle families.

## Stage 24. Content QA

Add quality checks for every puzzle.

Checklist:

- task is clear for the target age;
- exactly one correct answer;
- age difficulty fits;
- wording is short and child-friendly;
- visual scene is attractive;
- hint teaches the next step;
- explanation teaches the rule;
- no excessive repetition.

Automated tests:

- puzzle ids are unique;
- asset references exist;
- hints and explanations exist;
- each type has a minimum count;
- each age band has balanced coverage;
- visual metadata is complete for production-ready puzzles.

## Stage 25. Large Content Milestone

Target for the first strong content version:

- 500+ puzzles;
- 25+ puzzle types;
- 8-10 visual worlds;
- 5-6 helper characters;
- 100+ reusable assets;
- 30+ route lessons;
- 10 boss levels;
- review works on real mistakes;
- daily challenge avoids quick repeats.

## Recommended Start

Start in this order:

1. Stage 13: write the puzzle content system.
2. Stage 14: write the puzzle type matrix.
3. Stage 18: extend `PuzzleDefinition` with visual metadata.
4. Stage 19: add the first large unique puzzle pack.
5. Stage 20: implement drag reorder and match pairs.
