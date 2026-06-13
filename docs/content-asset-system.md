# BrainUp Asset System

## Purpose

This document defines how BrainUp stores and names visual assets for rich puzzle
content. It connects the puzzle type matrix, visual worlds, and helper
characters to real files that Flutter can render.

The goal is to make future puzzle content predictable: a puzzle metadata record
should be able to reference world, character, object, reward, and feedback
assets without inventing a new path format every time.

## Asset Roots

Production assets live under:

```text
mobile/assets/images/
```

Current roots:

```text
mobile/assets/images/generated/
mobile/assets/images/puzzles/
mobile/assets/images/characters/
mobile/assets/images/worlds/
mobile/assets/images/rewards/
mobile/assets/images/effects/
```

## Root Responsibilities

### `generated/`

Existing app-level generated images and reward illustrations.

Use for:

- legacy generated app art;
- current reward cards;
- temporary generated visuals before moving them into structured folders.

### `puzzles/`

Reusable puzzle objects and family-specific visual pieces.

Use for:

- object cards;
- shape cards;
- silhouettes;
- countable items;
- draggable items;
- grid pieces;
- path tiles;
- family-specific puzzle props.

### `characters/`

Helper character portraits, states, props, and character-specific rewards.

Use for:

- Brainy;
- Lumi;
- Quadra;
- Numba;
- Rulo;
- Mira.

### `worlds/`

World backgrounds, world objects, scene frames, and world UI states.

Use for:

- space station;
- forest lab;
- underwater city;
- robot town;
- riddle castle;
- dinosaur island;
- toy shop;
- shape garden;
- train expedition;
- detective academy.

### `rewards/`

Reusable reward visuals that are not locked to a single character or world.

Use for:

- badges;
- stickers;
- streak rewards;
- boss completion rewards;
- collectible items.

### `effects/`

Reusable feedback and animation overlays.

Use for:

- sparkle;
- pulse;
- correct highlight;
- soft retry highlight;
- trail;
- snap;
- reveal.

## Naming Rules

File names should be lowercase snake case.

Use:

```text
<scope>_<id>_<state>.<ext>
```

Avoid:

- spaces;
- uppercase letters;
- version names like `final2`;
- unclear names like `image.png`;
- duplicated names across the same folder.

## Supported Formats

Use:

- `.svg` for simple icons, shapes, cards, silhouettes, and scalable objects;
- `.png` for rendered character art, textured scenes, and rich illustration;
- `.webp` later for optimized raster assets if needed.

Avoid:

- large uncompressed PNGs for tiny icons;
- SVGs with embedded raster images;
- one-off assets that duplicate reusable objects.

## Character Asset Paths

Character assets should follow:

```text
mobile/assets/images/characters/<characterId>/<state>.png
mobile/assets/images/characters/<characterId>/icon.png
mobile/assets/images/characters/<characterId>/prop_<propId>.svg
mobile/assets/images/characters/<characterId>/reward_<rewardId>.png
```

Required P0 states:

- `neutral.png`;
- `thinking.png`;
- `hint.png`;
- `happy.png`;
- `encourage.png`;
- `celebrate.png`;
- `icon.png`.

Example metadata ids:

```text
character.brainy.neutral
character.lumi.hint
character.quadra.prop.shape_pointer
```

## World Asset Paths

World assets should follow:

```text
mobile/assets/images/worlds/<worldId>/backgrounds/<sceneId>.png
mobile/assets/images/worlds/<worldId>/objects/<objectId>.svg
mobile/assets/images/worlds/<worldId>/ui/<stateId>.svg
mobile/assets/images/worlds/<worldId>/rewards/<rewardId>.png
```

Example metadata ids:

```text
world.space_station.background.launch_bay
world.toy_shop.object.train_car_red
world.shape_garden.reward.flower_badge
```

## Puzzle Asset Paths

Puzzle family assets should follow:

```text
mobile/assets/images/puzzles/<familyId>/<assetId>.svg
mobile/assets/images/puzzles/<familyId>/<assetId>.png
```

Shared puzzle objects can stay in:

```text
mobile/assets/images/puzzles/shared/<assetId>.svg
```

Family id folders should use the metadata family id without dots:

```text
classification_odd_one_out
pattern_sequence_complete
memory_pair_match
spatial_route_build
```

## Reward Asset Paths

Reusable rewards should follow:

```text
mobile/assets/images/rewards/badges/<badgeId>.png
mobile/assets/images/rewards/stickers/<stickerId>.png
mobile/assets/images/rewards/streaks/<streakId>.png
mobile/assets/images/rewards/boss/<bossRewardId>.png
```

Reward metadata ids:

```text
reward.badge.logic_spark
reward.sticker.rocket_friend
reward.boss.space_station_patch
```

## Effect Asset Paths

Reusable effects should follow:

```text
mobile/assets/images/effects/correct/<effectId>.svg
mobile/assets/images/effects/retry/<effectId>.svg
mobile/assets/images/effects/hint/<effectId>.svg
mobile/assets/images/effects/reward/<effectId>.svg
```

Effect metadata ids:

```text
effect.correct.sparkle_pop
effect.retry.soft_ring
effect.hint.pulse_outline
effect.reward.star_burst
```

## First-Pack Asset Scope

For the first rich content pack, prioritize these worlds:

- `space_station`;
- `forest_lab`;
- `robot_town`;
- `toy_shop`;
- `shape_garden`.

Prioritize these characters:

- `brainy`;
- `lumi`;
- `quadra`;
- `numba`;
- `rulo`;
- `mira`.

Prioritize these puzzle families:

- `classification_odd_one_out`;
- `pattern_sequence_complete`;
- `memory_pair_match`;
- `memory_order_recall`;
- `spatial_route_build`;
- `math_object_count`;
- `math_group_compare`;
- `attention_shadow_match`;
- `spatial_shape_rotation`;
- `pattern_rule_detect`;
- `math_logic_scales`;
- `classification_object_sort`;
- `boss_mixed_challenge`.

## Placeholder Rules

Placeholder assets are allowed only when:

- the puzzle is still in draft or playable readiness;
- the filename clearly marks the placeholder;
- the metadata can later point to the final asset without changing puzzle logic.

Use:

```text
placeholder_<assetId>.svg
placeholder_<assetId>.png
```

Do not ship production puzzles with placeholder visuals.

## QA Rules

Before an asset-backed puzzle becomes production-ready:

- every referenced asset path must exist;
- image dimensions must be appropriate for mobile;
- important objects must remain clear on a small screen;
- text should not be baked into images unless localization is impossible;
- transparent PNGs should be trimmed;
- SVGs should not contain unnecessary hidden layers;
- asset names must match metadata ids;
- duplicate objects should be reused instead of copied.

## Flutter Registration

`mobile/pubspec.yaml` must include every asset root used by puzzle metadata:

```yaml
assets:
  - assets/images/generated/
  - assets/images/puzzles/
  - assets/images/characters/
  - assets/images/worlds/
  - assets/images/rewards/
  - assets/images/effects/
```

When deeper subfolders are introduced, either add the specific folders to
`pubspec.yaml` or verify that the current Flutter version includes the needed
files through the declared root.

## Stage 17 Done Criteria

This stage is complete when:

- `docs/content-asset-system.md` exists;
- core asset roots exist in `mobile/assets/images/`;
- `pubspec.yaml` registers the new roots;
- naming rules for characters, worlds, puzzles, rewards, and effects are clear;
- Stage 18 can add visual metadata using stable asset ids and paths.
