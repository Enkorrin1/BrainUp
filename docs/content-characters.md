# BrainUp Helper Characters

## Purpose

Helper characters make BrainUp feel warm, memorable, and guided. They should not
turn puzzles into long tutorials. Their job is to give short emotional support,
teach a thinking strategy, and make rewards feel personal.

Characters are part of puzzle metadata. A production-ready puzzle can reference
one character by `characterId`, plus an emotion/state for the current moment.

## Character Design Rules

Every helper character should define:

- stable `characterId`;
- primary role;
- target skills;
- visual silhouette;
- personality;
- voice rules;
- emotion states;
- hint style;
- success style;
- wrong-answer style;
- preferred worlds;
- preferred puzzle families;
- reward usage;
- asset requirements.

Characters should be:

- friendly and calm;
- visually readable at small size;
- distinct from each other;
- useful for learning, not decorative noise;
- consistent across route, review, daily, and boss moments.

## Shared Emotion States

All core characters should eventually support:

- `neutral`: default idle portrait;
- `thinking`: used before hints or while a puzzle is active;
- `hint`: points to strategy;
- `happy`: correct answer;
- `encourage`: wrong answer or retry;
- `celebrate`: lesson, streak, or boss completion.

Optional later states:

- `surprised`;
- `focused`;
- `sleepy`;
- `proud`;
- `badge`.

## Voice Rules

### Before A Puzzle

Use short strategy prompts:

- "Look for the rule."
- "Count slowly."
- "Remember the order."
- "Check the shape."

### Hint

Hints should name a strategy:

- "Compare the first two cards."
- "Count the left side first."
- "Try the path without blocked tiles."

### Wrong Answer

Use calm encouragement:

- "Good try. Look at the shape again."
- "Almost. Count one more time."
- "Try checking the first clue."

Avoid:

- harsh failure words;
- long lectures;
- jokes that distract from the task;
- repeated generic praise after every tap.

### Correct Answer

Tie praise to the skill:

- "Yes. You found the repeating rule."
- "Nice counting. Both sides match now."
- "Great memory. That was the third object."

## Character 1. Brainy

- Character id: `brainy`
- Role: main BrainUp guide
- Target skills: all skills
- Visual silhouette: small bright teal mascot with expressive eyes and a simple
  head shape that works as an app icon companion
- Personality: curious, warm, energetic, never pushy
- Voice: short and friendly
- Primary use:
  - onboarding;
  - route intro;
  - daily challenge;
  - mixed boss lessons;
  - reward moments.
- Preferred worlds:
  - `space_station`;
  - `riddle_castle`;
  - `toy_shop`;
  - `shape_garden`.
- Preferred puzzle families:
  - `boss.mixed_challenge`;
  - `pattern.sequence_complete`;
  - `classification.odd_one_out`;
  - `memory.pair_match`.
- Hint style: general strategy cue
- Success style: celebrates progress and names the skill
- Wrong-answer style: invites retry without pressure
- Reward usage: stars, badges, streak milestones, route unlocks
- Asset priority: P0

Sample lines:

- Neutral: "Ready for a short brain quest?"
- Hint: "Start with the easiest clue."
- Correct: "Yes. You found the idea."
- Retry: "Good try. Let's look one step closer."

## Character 2. Lumi

- Character id: `lumi`
- Role: memory guide
- Target skills: memory, attention
- Visual silhouette: soft glowing helper with a small lantern or light trail
- Personality: gentle, patient, observant
- Voice: calm and reassuring
- Primary use:
  - memory reveal;
  - order recall;
  - pair matching;
  - what changed;
  - adaptive review after memory mistakes.
- Preferred worlds:
  - `space_station`;
  - `underwater_city`;
  - `toy_shop`;
  - `train_expedition`.
- Preferred puzzle families:
  - `memory.order_recall`;
  - `memory.pair_match`;
  - `memory.what_changed`;
  - `memory.story_order`.
- Hint style: teaches chunking and anchors
- Success style: names what the child remembered
- Wrong-answer style: suggests remembering first/last or location
- Reward usage: glow trail, memory spark, pair badge
- Asset priority: P0

Sample lines:

- Neutral: "Let's keep the order in mind."
- Hint: "Remember the first and last object first."
- Correct: "Great memory. That was the right order."
- Retry: "Almost. Picture where it was before."

## Character 3. Quadra

- Character id: `quadra`
- Role: shape and space guide
- Target skills: spatial, attention
- Visual silhouette: friendly geometric character made from rounded shapes
- Personality: precise, playful, focused
- Voice: clear and visual
- Primary use:
  - shape rotation;
  - route building;
  - mazes;
  - picture assembly;
  - shadow matching.
- Preferred worlds:
  - `shape_garden`;
  - `space_station`;
  - `dinosaur_island`;
  - `robot_town`.
- Preferred puzzle families:
  - `spatial.shape_rotation`;
  - `spatial.route_build`;
  - `spatial.maze`;
  - `spatial.picture_assembly`;
  - `attention.shadow_match`.
- Hint style: points to outline, direction, or path
- Success style: confirms spatial transformation
- Wrong-answer style: asks child to compare outline or direction again
- Reward usage: shape badge, path sparkle, puzzle piece snap
- Asset priority: P0

Sample lines:

- Neutral: "Shapes can turn, but they stay themselves."
- Hint: "Look at the outline first."
- Correct: "Nice. The shape turned, but it still matches."
- Retry: "Check the direction of the point."

## Character 4. Numba

- Character id: `numba`
- Role: math guide
- Target skills: arithmetic, comparison, counting
- Visual silhouette: cheerful number-themed helper with count beads or blocks
- Personality: practical, upbeat, steady
- Voice: direct and rhythmic
- Primary use:
  - object counting;
  - group comparison;
  - logic scales;
  - number bridges;
  - early arithmetic review.
- Preferred worlds:
  - `toy_shop`;
  - `robot_town`;
  - `dinosaur_island`;
  - `underwater_city`.
- Preferred puzzle families:
  - `math.object_count`;
  - `math.group_compare`;
  - `math.logic_scales`;
  - `math.number_bridge`;
  - `reasoning.rule_arrange`.
- Hint style: suggests counting order or comparing sides
- Success style: names the number relationship
- Wrong-answer style: prompts one more count without shame
- Reward usage: count badge, balance sparkle, number stamp
- Asset priority: P0

Sample lines:

- Neutral: "Let's count carefully."
- Hint: "Count the left side, then the right side."
- Correct: "Yes. Both sides have the same amount."
- Retry: "Almost. Touch each object once as you count."

## Character 5. Rulo

- Character id: `rulo`
- Role: logic guide
- Target skills: reasoning, pattern, classification
- Visual silhouette: compact guide with a clue board, badge, or small rule card
- Personality: thoughtful, curious, quietly confident
- Voice: asks useful questions
- Primary use:
  - code solving;
  - rule detection;
  - cause and effect;
  - conditional paths;
  - boss puzzle clues.
- Preferred worlds:
  - `robot_town`;
  - `riddle_castle`;
  - `detective_academy`;
  - `forest_lab`.
- Preferred puzzle families:
  - `reasoning.code_solver`;
  - `pattern.rule_detect`;
  - `reasoning.cause_effect`;
  - `reasoning.conditional_path`;
  - `boss.mixed_challenge`.
- Hint style: points to the first clue or repeated rule
- Success style: names the discovered rule
- Wrong-answer style: suggests checking one clue at a time
- Reward usage: clue stamp, rule badge, unlocked door
- Asset priority: P0

Sample lines:

- Neutral: "Every puzzle has a clue."
- Hint: "Compare what changed from left to right."
- Correct: "Exactly. You found the rule."
- Retry: "Close. Check the first clue again."

## Character 6. Mira

- Character id: `mira`
- Role: attention guide
- Target skills: attention, classification, memory
- Visual silhouette: focused helper with a magnifier or bright eye motif
- Personality: observant, kind, quietly excited by details
- Voice: short and precise
- Primary use:
  - spot the difference;
  - shadow matching;
  - detail count;
  - odd one out;
  - visual scan tasks.
- Preferred worlds:
  - `forest_lab`;
  - `underwater_city`;
  - `shape_garden`;
  - `detective_academy`.
- Preferred puzzle families:
  - `attention.spot_difference`;
  - `attention.shadow_match`;
  - `attention.detail_scan`;
  - `classification.odd_one_out`;
  - `memory.what_changed`.
- Hint style: tells the child which visual property to inspect
- Success style: praises careful looking
- Wrong-answer style: narrows attention to a visible detail
- Reward usage: magnifier badge, detail sparkle, focus stamp
- Asset priority: P0

Sample lines:

- Neutral: "Small details can help."
- Hint: "Check color, size, and position."
- Correct: "Great focus. You spotted it."
- Retry: "Almost. Look at the outline again."

## Character To World Fit

First-pack worlds should use:

- `space_station`: Brainy, Lumi, Quadra, Rulo
- `forest_lab`: Mira, Rulo, Brainy
- `robot_town`: Rulo, Numba, Quadra
- `toy_shop`: Numba, Lumi, Brainy
- `shape_garden`: Quadra, Mira, Brainy

Later worlds should use:

- `underwater_city`: Lumi, Mira, Numba
- `riddle_castle`: Rulo, Brainy
- `dinosaur_island`: Quadra, Numba, Mira
- `train_expedition`: Lumi, Rulo, Numba
- `detective_academy`: Rulo, Mira, Lumi

## Character To Skill Fit

- `brainy`: all skills, mixed lessons, onboarding, rewards
- `lumi`: memory, attention
- `quadra`: spatial, attention
- `numba`: arithmetic, comparison
- `rulo`: reasoning, pattern, classification
- `mira`: attention, classification, memory

## Character To Interaction Fit

- Tap choice: any character
- Drag to target: Quadra, Numba, Mira
- Reorder cards: Lumi, Rulo
- Match pairs: Lumi, Brainy
- Memory reveal: Lumi, Mira
- Trace path: Quadra, Rulo
- Rotate object: Quadra
- Multi-step boss flow: Brainy, Rulo, world-specific guide

## Asset Naming Direction

Character asset names should follow:

```text
character.<characterId>.<state>
character.<characterId>.prop.<propId>
character.<characterId>.reward.<rewardId>
```

Examples:

```text
character.brainy.happy
character.lumi.hint
character.quadra.prop.shape_pointer
character.numba.reward.count_badge
```

## Minimum Asset Set

For each P0 character:

- neutral portrait;
- thinking portrait;
- hint portrait;
- happy portrait;
- encourage portrait;
- celebrate portrait;
- small icon;
- simple reward badge.

Stage 17 should create folders and placeholders for these states.

## Usage Rules

- Use one primary helper per puzzle.
- Use Brainy for global app moments and mixed boss transitions.
- Use skill guides for hints and skill-specific feedback.
- Do not show multiple character speeches on the same puzzle state.
- Keep character text short enough for the child to return to the puzzle fast.
- Avoid making characters explain UI controls; they should teach thinking.

## Stage 16 Done Criteria

This stage is complete when:

- `docs/content-characters.md` exists;
- at least 5 helper characters are defined;
- each character maps to skills, worlds, interactions, and feedback style;
- character asset states are defined;
- Stage 17 can derive asset folders and naming from this document;
- Stage 18 can reference `characterId` in puzzle metadata.
