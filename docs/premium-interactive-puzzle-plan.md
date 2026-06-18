# BrainUp Premium Interactive Puzzle Plan

## Final Goal

BrainUp must feel like a collection of polished educational mini-games, not a
quiz app with animations. Each important puzzle should have its own child
action, visual scene, feedback, character reaction, and progression moment.

The target experience:

- a child understands what to do in 2-3 seconds;
- the main answer comes from touching, dragging, tracing, rotating, sorting, or
  building objects inside the scene;
- every tap or drag produces immediate feedback;
- every puzzle type feels mechanically different;
- each world has its own objects, sounds, colors, and character reactions;
- wrong answers help the child recover instead of just saying "wrong";
- content can scale to hundreds of levels without rewriting game screens;
- Android performance stays stable on mid-range devices.

## Quality Bar

A puzzle is considered premium only when it has:

- one clear thinking skill;
- one clear primary action;
- interactive objects on the game canvas;
- no answer-only UI as the main mechanic;
- animated feedback for tap, drag, snap, success, hint, and retry;
- character reaction states;
- at least one hint that changes the scene;
- adaptive support after mistakes;
- result mapping into XP, stars, mistakes, and review;
- smoke coverage in tests;
- verified Android launch.

## Core Architecture Target

Flutter remains responsible for:

- navigation;
- lesson flow;
- rewards;
- profile/progress;
- parent screens;
- overlays and accessibility controls.

Flame becomes responsible for:

- object interaction;
- drag/drop;
- tracing;
- collision/hit testing;
- particle/effect timing;
- scene state;
- mini-game-specific gameplay.

Rive becomes responsible for:

- animated helper characters;
- emotional states;
- boss reactions;
- celebration and retry animation.

Content data becomes responsible for:

- level objects;
- scene skin;
- answer rules;
- difficulty knobs;
- hint behavior;
- audio/effect cue ids.

## Puzzle Families

### 1. Memory Mini-Games

Mechanics:

- flip cards and remember positions;
- repeat a glowing sequence;
- restore objects in order;
- spot what changed after a short animation.

Interactions:

- tap card;
- drag remembered item into slot;
- sequence replay;
- reveal timer.

Quality target:

- 20+ levels per world;
- increasing grid size;
- adaptive reveal duration;
- Lumi character reactions.

### 2. Logic Path Mini-Games

Mechanics:

- trace a route through rule nodes;
- connect conditions in order;
- repair a circuit;
- choose a path that satisfies constraints.

Interactions:

- drag finger along path;
- tap nodes;
- connect wires;
- avoid blockers.

Quality target:

- real path validation, not only final choice;
- blocked paths animate softly;
- Rulo/Quadra explain the rule after mistakes.

### 3. Math Action Mini-Games

Mechanics:

- catch number bubbles;
- balance scales;
- split groups;
- build sums from object pieces.

Interactions:

- drag objects onto scales;
- tap moving bubbles;
- group items into baskets;
- combine number tiles.

Quality target:

- math is visual first;
- wrong choices show why the number does not balance;
- Numba gives counting hints.

### 4. Spatial Builder Mini-Games

Mechanics:

- rotate shapes into shadows;
- assemble fragments;
- build bridges;
- guide objects through spatial mazes.

Interactions:

- rotate with tap/drag;
- drag pieces;
- snap into silhouettes;
- mirror/flip controls.

Quality target:

- real piece state;
- snap zones;
- visual preview;
- reduced-motion fallback.

### 5. Attention Scan Mini-Games

Mechanics:

- find changed object;
- spot differences;
- scan target under light time pressure;
- ignore distractors.

Interactions:

- tap hidden object;
- drag magnifier;
- mark matching symbols;
- time-limited scan.

Quality target:

- readable on phone screens;
- no unfair tiny targets;
- Mira gives attention hints.

### 6. Mixed Boss Mini-Games

Mechanics:

- 3-step challenge combining memory, logic, and spatial/math;
- boss gate unlock;
- reward reveal.

Interactions:

- step 1: remember;
- step 2: trace/build;
- step 3: final interactive solve.

Quality target:

- boss feels special;
- unique world skin;
- stronger reward;
- parent summary explains skills used.

## Implementation Stages

## Stage 43. Real Interaction Engine

Goal: move mini-games from visual scenes to real gameplay scenes.

Scope:

- add shared `MiniGameSceneController`;
- add canvas event model for tap, drag, drop, trace, rotate, and snap;
- add scene state machine: intro, playing, hint, retry, success, complete;
- connect Flame interactions directly to `MiniGameResult`;
- keep Flutter answer buttons only as fallback/accessibility.

Definition of done:

- Memory, Logic Path, Shape Builder, and Boss Mix can be solved from the canvas;
- selected objects visibly affect game state;
- host does not need choice chips for primary gameplay.

## Stage 44. Drag And Drop Mechanics

Goal: make object movement feel like real play.

Scope:

- draggable components;
- drop zones;
- snap animation;
- invalid drop feedback;
- drag haptics;
- drag result bridge.

First targets:

- Math balance scale;
- Shape Builder snap puzzle;
- Sort Lab basket puzzle.

Definition of done:

- child drags objects into meaningful places;
- wrong drops explain why they do not fit;
- tests cover drop result mapping.

## Stage 45. Trace And Path Validation

Goal: make Logic Path a real tracing game.

Scope:

- gesture path tracking;
- node sequence validation;
- route blockers;
- animated path glow;
- retry path rewind.

Definition of done:

- child must trace a valid route;
- route order matters;
- mistakes feed adaptive review.

## Stage 46. Rotation And Spatial Assembly

Goal: make spatial puzzles physically interactive.

Scope:

- rotate objects by dragging or tapping;
- snap to target angle;
- assemble 2-4 pieces;
- silhouette matching;
- progressive difficulty.

Definition of done:

- rotation state is part of answer validation;
- scene shows why a piece fits or does not fit.

## Stage 47. Math Game Pack

Goal: add energetic math mini-games.

Scope:

- `MathBubblesGame`;
- `BalanceScaleGame`;
- `GroupSplitGame`;
- animated numbers and objects;
- data configs for math levels.

Definition of done:

- at least 30 math mini-game levels;
- math levels are solved through object actions;
- visual explanation appears after success/retry.

## Stage 48. Attention Game Pack

Goal: add fast visual scanning mini-games.

Scope:

- `AttentionScanGame`;
- magnifier interaction;
- target/distractor generation;
- time-safe challenge mode;
- accessibility-safe target sizing.

Definition of done:

- at least 30 attention levels;
- no tiny unfair objects;
- hints reveal strategy, not just answer.

## Stage 49. Rive Character Integration

Goal: replace static fallback avatars with real animated characters.

Scope:

- add Rive assets for Brainy, Lumi, Quadra, Numba, Mira, Rulo;
- state machine inputs: idle, thinking, hint, retry, correct, boss,
  celebration;
- animation fallback if asset missing;
- character-specific scene entrances.

Definition of done:

- every mini-game has animated helper reactions;
- missing Rive asset never crashes app.

## Stage 50. Audio And Reward Polish

Goal: make feedback feel satisfying but safe.

Scope:

- tap/drag/snap/correct/retry/reward sounds;
- world ambience loops;
- global mute setting;
- no overlapping sound spam;
- boss reward cue.

Definition of done:

- audio improves clarity;
- mute persists;
- reward moments feel distinct.

## Stage 51. Premium Content Wave

Goal: create enough variety that the app feels rich.

Scope:

- 50 memory levels;
- 50 logic/path levels;
- 50 math levels;
- 50 spatial levels;
- 50 attention levels;
- 20 boss levels;
- world-specific skins and objects.

Definition of done:

- at least 270 premium interactive levels;
- all levels pass config validation;
- each world has multiple mechanics.

## Stage 52. Puzzle Authoring Tooling

Goal: make content production fast and safe.

Scope:

- JSON authoring schema;
- validator for every puzzle type;
- preview fixtures;
- generated content manifest;
- content QA dashboard.

Definition of done:

- new levels can be authored without Dart edits;
- invalid configs fail before runtime;
- designers/writers have templates for every mechanic.

## Stage 53. Android Playtest Pass

Goal: prove the games feel good on device.

Scope:

- emulator smoke for each mini-game type;
- screenshot capture;
- frame timing check;
- touch target review;
- small-screen review;
- accessibility pass.

Definition of done:

- each mini-game launches on Android;
- no obvious frame drops;
- no overlapping text;
- touch targets are comfortable.

## Stage 54. Final Lesson Integration

Goal: make interactive puzzles feel native to the learning path.

Scope:

- lessons mix game types intentionally;
- boss nodes use special game flow;
- adaptive review chooses mini-games by mistake type;
- rewards unlock after game completions;
- parent report explains skills practiced.

Definition of done:

- the learning path feels like a sequence of playful challenges;
- repeated sessions show meaningful variety;
- parents can understand progress.

## Immediate Next Step

Start with Stage 43.

The first implementation slice should:

1. create a shared scene controller;
2. make Memory Grid fully canvas-solvable;
3. make Logic Path require tracing or node sequence;
4. make Shape Builder validate tapped/rotated pieces;
5. remove dependency on answer chips as the main mechanic;
6. add tests and Android screenshots.

This is the point where BrainUp starts moving from "animated quiz" to "real
interactive learning games".

## Progress Log

### 2026-06-18 - Stage 43, Slice 1

Implemented:

- shared `MiniGameSceneController` with scene states, event snapshots, hint,
  retry, success, complete, and exit flow;
- canvas hotspot auto-submit bridge from Flame scenes into `MiniGameResult`;
- Memory Grid, Logic Path, Shape Builder, and Boss Mix now solve from canvas
  taps while keeping answer chips as fallback/accessibility UI;
- host screen now owns one stable Flame game instance per mini-game run;
- regression coverage for canvas hotspot auto-submit result states.

Verified:

- `flutter analyze`;
- `flutter test`;
- `flutter build apk --debug`.

Android emulator note:

- separate AVD launch was attempted with `logiclike_pixel` and
  `brainup_pixel_2`;
- both AVDs appeared in ADB only as `offline`, so APK install/screenshot was
  not completed in this pass;
- the offline emulator processes were closed after the failed launch attempt.
