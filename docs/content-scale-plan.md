# BrainUp Content Scale Plan

## Goal

BrainUp needs to feel deep from the first prototype: a child should see a long
learning route, meet different puzzle formats, and keep getting new short
challenges across logic, memory, math, attention, spatial thinking, and
reasoning.

Current implementation notes:

- Stage 1: content scale plan and structured catalog direction.
- Stage 2: generated puzzle variants connected to lessons.
- Stage 3: generated puzzle localization and polish
  (`docs/content-stage-3-status.md`).
- Stage 4: content bank expansion and balanced lesson delivery
  (`docs/content-stage-4-status.md`).
- Stage 5: review-aware delivery from practice history
  (`docs/content-stage-5-status.md`).
- Stage 6: visible adaptive review path moment
  (`docs/content-stage-6-status.md`).
- Stage 7: dedicated adaptive review result state
  (`docs/content-stage-7-status.md`).
- Stage 8: adaptive review signal clearing
  (`docs/content-stage-8-status.md`).

## Content Architecture

Each puzzle should carry:

- stable id;
- puzzle type;
- skill tag;
- age band;
- difficulty;
- payload reference;
- correct answer key;
- hint keys;
- lesson/template ownership when needed.

The app can keep seed content in Dart for the prototype. Later, the same shape
can move to JSON or a content editor.

## Puzzle Families

- Patterns and sequences.
- Odd one out and classification.
- Pair matching and memory links.
- Counting and arithmetic bridges.
- Visual comparison.
- Spatial rotation and shape logic.
- Deduction and code grids.
- Attention/detail scanning.
- Rebus and association tasks.
- Mixed review and boss tasks.

## First Content Targets

- 30 puzzles for ages 4-5.
- 50 puzzles for age 6.
- 60 puzzles for ages 7-8.
- 40 mixed review puzzles.
- 20 boss puzzles.
- 20 memory/review puzzles.

First practical milestone: create at least 70 structured puzzle definitions and
make the catalog prove skill and difficulty coverage through tests.

## Lesson Generation Direction

Each lesson should eventually be composed dynamically:

- one warm-up puzzle;
- two puzzles from the current node skill;
- one adjacent-skill puzzle;
- one mistake or review puzzle when available;
- occasional boss puzzle.

For now, existing 24 lesson templates stay compatible while the larger content
bank grows behind them.

## Quality Rules

- Every skill must have easy, normal, and hard content.
- Every age band must have multiple puzzle types.
- Boss content must combine at least two skills.
- No puzzle family should dominate the first route.
- New content must be testable by id, age band, skill, and difficulty.
