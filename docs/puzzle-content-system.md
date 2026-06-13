# BrainUp Puzzle Content System

## Purpose

This document is the quality system for BrainUp puzzle content. It defines what
a strong puzzle must contain before it can be used in the main route, daily
practice, adaptive review, or boss lessons.

BrainUp puzzles should feel like small playable scenes: clear, warm, visual,
age-appropriate, and educational. The goal is not only to increase the number
of tasks, but to make each task feel intentionally designed.

## Puzzle Anatomy

Every production-ready puzzle needs:

- stable puzzle id;
- puzzle family and puzzle type;
- target skill tag;
- age band;
- difficulty;
- learning objective;
- world or scene theme;
- helper character;
- prompt;
- question;
- answer options or interactive objects;
- one correct answer rule;
- hint;
- explanation;
- visual asset references;
- interaction pattern;
- feedback behavior;
- placement rule.

## Core Quality Rules

- The child should understand what to do within 3 seconds.
- The task should have exactly one correct answer.
- The screen should show the thinking problem visually, not only in text.
- The question should use short child-friendly wording.
- The hint should teach the next thinking step, not reveal the answer directly.
- The explanation should name the rule after the child answers.
- Wrong feedback should be calm and useful.
- Correct feedback should feel rewarding but stay quick.
- A puzzle should not depend on reading long paragraphs.
- A puzzle must fit the selected age band and cognitive load.

## Age Bands

### Ages 4-5

Use:

- 2-4 answer choices;
- simple objects;
- concrete visual differences;
- one-step reasoning;
- large touch targets;
- short prompts.

Avoid:

- multi-condition logic;
- tiny details;
- abstract symbols without visual support;
- long memory sequences.

### Age 6

Use:

- 3-5 answer choices;
- simple two-step reasoning;
- early number relationships;
- short memory sequences;
- clear rule patterns.

Add:

- light distractors;
- simple spatial turns;
- category sorting with familiar objects.

### Ages 7-8

Use:

- 4-6 answer choices;
- two-step and three-step reasoning;
- mixed skills;
- simple codes;
- boss puzzles;
- larger visual scenes.

Add:

- conditional clues;
- multiple objects to compare;
- harder memory order tasks;
- early deduction grids.

## Difficulty Rules

### Easy

- One visible rule.
- Minimal distractors.
- Familiar objects.
- Short interaction.
- Hint points directly to the strategy.

### Normal

- One main rule plus mild distraction.
- Requires comparison or short memory.
- May combine text and image.
- Hint narrows the search.

### Hard

- Two-step reasoning.
- More similar distractors.
- Requires holding more than one detail.
- Hint explains the method.

### Boss

- Combines at least two skills.
- Uses a richer scene.
- Has 6-8 steps or objects.
- Gives stronger reward feedback.
- Should feel like a milestone, not a normal repeated card.

## Skill Design Rules

### Logic And Reasoning

Puzzle should ask the child to infer a rule, condition, or relationship.

Good formats:

- code grids;
- cause and effect;
- if-then paths;
- logic scales;
- mini deduction scenes.

Visual requirement:

- show clues as objects, cards, paths, or symbols;
- avoid pure text riddles for younger children.

### Memory

Puzzle should require remembering order, pair, position, or change.

Good formats:

- memory reveal;
- object order;
- pair matching;
- what changed;
- short sequence recall.

Visual requirement:

- use memorable objects;
- show a clear remember phase and answer phase.

### Math

Puzzle should use counting, comparison, balance, number bridges, or simple
operations.

Good formats:

- count objects;
- compare groups;
- make a target number;
- balance scale;
- missing number.

Visual requirement:

- numbers should be supported by objects;
- answer choices should not require mental arithmetic beyond the age band.

### Attention

Puzzle should require noticing detail, difference, target, position, or matching
visual features.

Good formats:

- spot the difference;
- find target object;
- shadow match;
- detail count;
- visual scan.

Visual requirement:

- details must be visible on mobile;
- distractors should be fair, not hidden by poor contrast.

### Spatial Thinking

Puzzle should involve shape, direction, rotation, path, layout, or position.

Good formats:

- rotate shape;
- trace path;
- maze;
- shape stack;
- shadow fit;
- object placement.

Visual requirement:

- shapes and paths must be large enough to inspect;
- orientation changes should be clear.

### Classification

Puzzle should require grouping, sorting, odd-one-out, or shared property.

Good formats:

- sort into baskets;
- find the odd item;
- match habitat;
- choose same category;
- compare object properties.

Visual requirement:

- every item should have a visible category clue;
- categories should be familiar for younger ages.

## Visual Scene Requirements

Every visual puzzle should define:

- background or scene container;
- main objects;
- answer objects;
- optional helper character;
- highlight state;
- correct state;
- wrong state;
- hint state.

Scenes should be:

- bright but not visually noisy;
- high contrast;
- readable on small screens;
- consistent with the selected world;
- distinct enough from neighboring lessons.

Avoid:

- tiny object differences;
- cluttered backgrounds;
- repeated generic cards without story;
- text placed over busy art;
- visuals that imply multiple correct answers.

## Character Feedback Rules

Characters should help the child feel guided, not judged.

### Before Answer

Use short prompt-style support:

- "Look for the rule."
- "Remember the order."
- "Count slowly."
- "Check the shape."

### Hint

The character should teach a strategy:

- "Try comparing the colors first."
- "The objects repeat in pairs."
- "Count the left side, then the right side."

### Wrong Answer

Tone:

- calm;
- specific;
- encouraging.

Avoid:

- "wrong";
- shame;
- long explanations;
- noisy failure animation.

### Correct Answer

Tone:

- warm;
- short;
- tied to the skill.

Example:

- "Yes. The pattern repeats red, blue, blue."

## Hint And Explanation Rules

### Hint

A hint should:

- reduce the search space;
- name the strategy;
- avoid giving the final answer directly;
- be short enough to read quickly.

### Explanation

An explanation should:

- confirm the answer;
- name the rule;
- connect the visual scene to the reasoning;
- be reusable by parents in analytics later.

Bad explanation:

- "Because it is correct."

Good explanation:

- "The row repeats circle, square. After square, the next shape is circle."

## Interaction Patterns

Supported interaction families:

- tap choice;
- drag item to target;
- reorder cards;
- match pairs;
- reveal memory cards;
- trace path;
- rotate object;
- sort objects;
- multi-step boss sequence.

Every interaction should define:

- input method;
- success condition;
- retry behavior;
- accessibility fallback;
- animation timing;
- state reset behavior.

## Animation Requirements

Animations should clarify state.

Use animation for:

- answer selection;
- hint highlight;
- correct feedback;
- gentle wrong feedback;
- progress update;
- reward reveal.

Timing rules:

- answer feedback: under 800 ms;
- hint pulse: subtle and repeatable;
- reward animation: 1-2 seconds;
- no blocking animation before the child can answer.

Avoid:

- excessive screen shake;
- fast flashing;
- animations that hide the correct object;
- long delays between questions.

## Asset Requirements

Every asset-backed puzzle should include:

- scene asset or background;
- object assets;
- choice assets;
- character asset when used;
- fallback icon or color state;
- asset alt/semantic description for future accessibility.

Asset naming should be stable:

```text
world.<worldId>.<sceneId>
character.<characterId>.<emotion>
puzzle.<familyId>.<objectId>
reward.<rewardId>.<state>
```

## Placement Rules

### Main Route

Use balanced skill progression:

- 1 warm-up;
- 2 target-skill puzzles;
- 1 adjacent-skill puzzle;
- 1 review or mixed puzzle.

### Daily Challenge

Use:

- one short puzzle;
- clear visual;
- low friction;
- fast success loop.

### Adaptive Review

Use:

- previous mistakes;
- weak skill tags;
- similar but not identical variants;
- shorter explanations.

### Boss Lessons

Use:

- mixed skills;
- richer scene;
- stronger reward;
- no brand-new interaction without prior practice.

## Content QA Checklist

A puzzle is ready only if:

- id is unique;
- age band is correct;
- skill tag is correct;
- difficulty is justified;
- visual scene is specified;
- interaction is specified;
- prompt is short;
- answer rule is unambiguous;
- hint teaches strategy;
- explanation teaches the rule;
- assets are available or marked as needed;
- feedback state is defined;
- placement is defined;
- puzzle passes automated catalog checks.

## Production Readiness Levels

### Draft

Puzzle idea exists with type, skill, age, and rough prompt.

### Playable

Puzzle can be answered in the app with text or placeholder visuals.

### Visual

Puzzle has scene metadata and asset references.

### Polished

Puzzle has final visuals, feedback, hint, explanation, and mobile QA.

### Production

Puzzle is tested, localized, visually verified, and approved for route/review
placement.

## Stage 13 Done Criteria

This stage is complete when:

- this quality system exists in `docs/puzzle-content-system.md`;
- future puzzle stages reference it;
- content QA can use it as a checklist;
- Stage 14 can build the puzzle type matrix from these rules.
