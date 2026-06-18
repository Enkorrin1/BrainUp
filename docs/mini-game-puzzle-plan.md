# BrainUp Mini-Game Puzzle Plan

## Goal

Turn BrainUp puzzles into small playable mini-games, not static question cards.
The child should feel that every lesson contains actions: move, build, rotate,
remember, catch, connect, repair, unlock, and defeat a small challenge.

The goal is not to copy Duolingo, LogicLike, or any other app. BrainUp should
have its own identity: colorful brain adventures, living helper characters,
world-specific puzzle scenes, and playful feedback that makes thinking feel
active.

## Final Target

BrainUp should have a mini-game layer where:

- each important puzzle type can run as a real interactive scene;
- simple quiz tasks still stay lightweight when a full game scene is not needed;
- lessons mix several mini-game mechanics so sessions feel varied;
- boss levels combine 2-3 mechanics into a special challenge;
- characters react with animations, hints, and success moments;
- content can be scaled through data definitions, not by hardcoding every screen;
- mistakes and mini-game results feed the adaptive review loop;
- the app remains fast on Android emulators and real mid-range devices.

## Recommended Stack Addition

Add these packages when the implementation stage starts:

- `flame` for game loop, sprites, components, gestures, effects, and collision;
- `flame_audio` for lightweight sound effects and music loops;
- `rive` for animated characters, emotional states, and interactive reactions;
- keep normal Flutter widgets for menus, overlays, lesson flow, rewards, and
  parent-facing screens.

Do not move the whole app into a game engine. The right structure is:

- Flutter owns navigation, lessons, profile, rewards, localization, and storage;
- Flame owns the playable puzzle surface;
- Rive owns character animation states;
- domain models own puzzle content, rules, results, and progression.

## Architecture

Target structure:

```text
mobile/lib/src/
  mini_games/
    core/
      mini_game_definition.dart
      mini_game_result.dart
      mini_game_controller.dart
      mini_game_registry.dart
      mini_game_difficulty.dart
      mini_game_feedback.dart
    host/
      mini_game_host_screen.dart
      mini_game_overlay.dart
      mini_game_pause_sheet.dart
      mini_game_result_bridge.dart
    games/
      memory_grid_game/
      logic_path_game/
      math_bubbles_game/
      shape_builder_game/
      attention_scan_game/
      pattern_machine_game/
      sort_lab_game/
      boss_mix_game/
    assets/
      mini_game_asset_resolver.dart
      mini_game_audio_cues.dart
      character_reaction_mapper.dart
```

Runtime flow:

```text
LessonScreen
  -> DailyChallenge
  -> MiniGameDefinition
  -> MiniGameRegistry
  -> MiniGameHostScreen
  -> Flame GameWidget
  -> MiniGameResult
  -> AppController progress, XP, rewards, mistakes, review
```

## Core Contracts

Every mini-game should produce a normalized result:

- `miniGameId`;
- `puzzleId`;
- `isCorrect`;
- `score`;
- `stars`;
- `durationSeconds`;
- `wrongAttempts`;
- `usedHints`;
- `skillTags`;
- `mistakeSignals`;
- `rewardSignals`;
- `difficultySignal`.

Every mini-game definition should include:

- game type;
- world id;
- character id;
- asset set;
- difficulty;
- target skill;
- round count;
- time pressure mode;
- hint behavior;
- success animation;
- failure animation;
- parent summary label.

## Mini-Game Families

### Memory

Examples:

- flip and remember object positions;
- repeat a glowing sequence;
- remember what changed in a scene;
- restore items in the correct order.

Good for:

- memory lessons;
- daily warmups;
- adaptive review after attention mistakes.

### Logic

Examples:

- connect rule paths;
- choose the only route that satisfies conditions;
- repair a machine by applying if/then rules;
- solve a small code lock.

Good for:

- core lesson progression;
- boss levels;
- older child difficulty.

### Math Thinking

Examples:

- catch number bubbles that match a rule;
- balance scales with objects;
- split treasure into equal groups;
- compare groups visually before answering.

Good for:

- fast, energetic lessons;
- number sense;
- streak challenges.

### Spatial Thinking

Examples:

- rotate shapes into matching shadows;
- build a bridge from pieces;
- assemble a picture from fragments;
- guide a character through a spatial maze.

Good for:

- visual variety;
- tablet-friendly play;
- boss puzzle step 2.

### Attention

Examples:

- spot differences in a lively scene;
- scan for matching symbols under light time pressure;
- sort distractions from target objects;
- find the object that changed after animation.

Good for:

- short sessions;
- weekly events;
- younger age bands.

### Mixed Boss

Examples:

- memory step, logic step, final spatial step;
- math clue, pattern machine, final gate;
- attention scan, code rule, reward unlock.

Good for:

- every 8-12 lessons;
- world finale;
- special rewards and badges.

## Stage 32. Mini-Game Engine Foundation

Create the technical foundation for playable puzzle scenes.

Status: implemented as the first runtime slice. BrainUp now has Flame and
Flame Audio dependencies, a `mini_games` architecture layer, a normalized
mini-game result contract, a registry, a host screen, and a placeholder Flame
memory-grid scene that can return results into the lesson flow.

Scope:

- add Flame and Flame Audio dependencies;
- create `mini_games/core`;
- create `MiniGameDefinition`, `MiniGameResult`, and `MiniGameRegistry`;
- create `MiniGameHostScreen` with Flutter overlay controls;
- connect one existing puzzle type to a placeholder Flame scene;
- keep current lesson flow and fallback widgets stable.

Definition of done:

- app can open a mini-game from a lesson;
- mini-game can return correct, wrong, hint, and exit results;
- lesson completion and mistake review still work;
- `flutter analyze`, `flutter test`, and Android launch pass.

## Stage 33. First Playable Mini-Game Pack

Build the first three real mini-games.

Status: implemented as the first playable pack. BrainUp now has three distinct
Flame mini-game scenes, shared tutorial guidance, success/retry feedback, and
registry routing for memory, logic path, and shape builder puzzle families.

Scope:

- `MemoryGridGame`;
- `LogicPathGame`;
- `ShapeBuilderGame`;
- shared success and retry effects;
- shared child-friendly tutorial overlay;
- tests for result mapping and lesson integration.

Definition of done:

- three puzzle families feel meaningfully different;
- each mini-game has touch interaction, animation, and feedback;
- each mini-game can be configured from puzzle data;
- no hardcoded lesson-only behavior.

## Stage 34. Visual Feedback And Game Feel

Make every action feel responsive and rewarding.

Scope:

- tap, drag, snap, bounce, sparkle, and shake effects;
- correct answer celebration;
- wrong answer soft retry feedback;
- hint highlight effect;
- progress meter inside the game overlay;
- haptic feedback where supported.

Definition of done:

- children get immediate visual feedback for every action;
- wrong answers feel helpful, not punishing;
- mini-games are readable on small Android screens;
- animations do not block gameplay.

## Stage 35. Character Animation Layer

Make helper characters feel alive inside mini-games.

Scope:

- add Rive character state mapping;
- define states: idle, thinking, hint, correct, retry, streak, boss, celebration;
- show character reactions inside the mini-game overlay;
- connect character role to puzzle skill;
- add fallback static avatar if animation asset is missing.

Definition of done:

- every mini-game can trigger character reactions;
- character copy and animation match the puzzle type;
- missing animation assets do not crash the lesson.

## Stage 36. Content-Driven Mini-Game Definitions

Make mini-games scalable through content data.

Scope:

- extend puzzle metadata with mini-game config;
- define asset slots for objects, background, character, effects, and sounds;
- add validation rules for mini-game-ready puzzles;
- export mini-game data into `docs/content-manifest.json`;
- add QA tests for missing assets and invalid game configs.

Definition of done:

- content can add new playable levels without new screen code;
- invalid mini-game data is caught by tests;
- manifest shows which puzzles are mini-game ready.

## Stage 37. Boss Mini-Game Upgrade

Turn boss lessons into special multi-step mini-games.

Scope:

- build `BossMixGame`;
- combine 2-3 mini-game mechanics in one flow;
- add intro, tension build-up, final unlock, and reward reveal;
- make boss mistakes feed adaptive review;
- add parent summary for boss performance.

Definition of done:

- boss levels clearly feel different from normal lessons;
- boss flow has at least three steps;
- boss reward is stronger than normal lesson reward;
- parent summary explains the thinking skills used.

## Stage 38. Adaptive Difficulty For Mini-Games

Make mini-games adjust to the child.

Scope:

- use attempts, hints, time, and streak to calculate difficulty signals;
- reduce clutter after repeated mistakes;
- increase challenge after strong performance;
- select review mini-games based on mistake type;
- add safe limits so difficulty never jumps too far.

Definition of done:

- mini-games can become easier or harder between attempts;
- adaptive review chooses meaningful practice;
- children are not trapped in repeated failure.

## Stage 39. Sound, Music, And Reward Moments

Add audio polish without overwhelming the child.

Scope:

- short sound effects for tap, drag, snap, correct, retry, reward;
- optional world ambience;
- mute setting;
- volume-safe defaults;
- unique reward reveal cues for boss and collection moments.

Definition of done:

- sound improves clarity and emotion;
- mute works globally;
- audio does not overlap badly between screens.

## Stage 40. Mini-Game QA And Performance Pass

Make the system stable before scaling content.

Scope:

- emulator QA on a separate BrainUp emulator;
- frame stability checks on heavy scenes;
- asset size review;
- accessibility review for color, text, and touch targets;
- widget/unit tests for every mini-game result bridge;
- smoke test for each mini-game type.

Definition of done:

- app launches and plays mini-games on Android emulator;
- no obvious frame drops in basic scenes;
- no text overlap in overlays;
- all mini-game result paths are tested.

## Stage 41. Large Mini-Game Content Wave

Scale from first playable games to a rich content library.

Scope:

- create 10-15 levels per mini-game family;
- add world-specific skins for each family;
- create unique scene objects and character lines;
- add event variants for weekly events;
- add boss variants for at least 4 worlds.

Definition of done:

- BrainUp has enough playable variety for repeated sessions;
- children see different scenes, not only different numbers;
- content QA validates every mini-game level.

## Stage 42. Mini-Game Editor Workflow

Prepare for faster content production.

Scope:

- define a JSON/YAML authoring format for mini-game levels;
- add a validation script;
- add preview fixtures for game configs;
- generate documentation for each mini-game family;
- create content templates for writers/designers.

Definition of done:

- a new mini-game level can be authored without touching Dart code;
- invalid configs fail validation before runtime;
- each family has a documented template.

## Quality Bar

A mini-game is ready only when it has:

- one clear child action;
- one clear thinking skill;
- readable visual hierarchy;
- meaningful animation;
- helpful wrong-answer response;
- at least one hint;
- completion result;
- mistake signal;
- reward or progress moment;
- tests for result mapping;
- Android emulator smoke test.

## First Implementation Recommendation

Start with Stage 32, then Stage 33.

The best first playable slice:

1. add the mini-game host and registry;
2. build `MemoryGridGame`;
3. connect it to existing memory puzzles;
4. return results into the current lesson system;
5. add one character reaction;
6. verify on Android emulator.

This gives a real vertical slice before building many games. After that, the
same host can support logic, math, spatial, attention, and boss mini-games.
