# BrainUp Child Engagement Roadmap

This roadmap describes the next product stages for making BrainUp genuinely
interesting for children. It builds on the existing 501-puzzle content bank,
content QA, dashboard, interaction specs, and lesson UI.

The goal is not to copy another app. BrainUp should feel like its own playful
logic adventure: bright worlds, helpful characters, meaningful rewards, and
puzzles that feel like actions inside a story.

## Final Goal

BrainUp should feel like an endless brain adventure for children:

- every lesson has a reason inside a world;
- every puzzle feels interactive, not like a worksheet;
- every helper character has a role and personality;
- every session gives a visible reward or progress moment;
- parents can see real thinking-skill growth.

## Stage 26. Story Worlds And Missions

Turn the current content bank into themed adventures.

Status: implemented as the first story-world layer. BrainUp now has 8 mission
worlds assigned to the 24 starter lessons, map mission UI, lesson mission
headers, and completion progress cards.

Scope:

- define 8-10 world arcs;
- assign lessons and puzzle families to worlds;
- add mission titles and short story beats;
- create world progress states: locked, active, repaired, completed;
- add a world intro and completion moment.

Examples:

- Space Station: repair the rocket by solving route, memory, and logic puzzles;
- Forest Lab: help Mira classify plants and spot details;
- Robot Town: restore circuits using code and sequence puzzles;
- Shape Garden: rotate, sort, and complete shape paths.

Definition of done:

- each starter world has a mission summary;
- at least 4 worlds appear in the app UI;
- lesson entry shows the current world mission;
- completion screen references the world progress.

Delivered:

- `StoryWorldDefinition` and `StoryWorldProgress`;
- 8 world arcs with helper characters and lesson assignments;
- world states: locked, active, repairing, completed;
- story worlds exported in `content-manifest.json`;
- mission strip on the path screen;
- mission label in the lesson header;
- mission progress card on lesson completion.

## Stage 27. Character Coach System

Make helper characters feel alive and useful.

Status: implemented as the first in-lesson coach layer. BrainUp now has a
runtime character coach catalog, puzzle-to-coach context, coach speech in
lessons, useful retry hints, and coach celebration cards.

Scope:

- give each helper a skill role;
- add character reactions for correct, wrong, hint, streak, and boss moments;
- create short child-friendly coach lines;
- show character avatar on lesson and feedback screens;
- connect characters to worlds.

Character roles:

- Brainy: logic and boss puzzles;
- Lumi: memory and recall;
- Numba: math thinking;
- Quadra: spatial thinking;
- Mira: attention and classification;
- Rulo: code, rules, and patterns.

Definition of done:

- every skill has a default helper;
- lesson feedback uses helper-specific copy;
- wrong answers give a useful hint, not just a failure state;
- character copy is short and warm.

Delivered:

- `CharacterCoachDefinition` and `CharacterCoachMoment`;
- 6 runtime coaches: Brainy, Lumi, Quadra, Numba, Rulo, Mira;
- default coach lookup for every skill;
- puzzle metadata carried into `DailyChallenge`;
- coach avatar and speech on the lesson question card;
- helper-specific hint, retry, correct, boss, streak, and celebration lines;
- coach celebration card on lesson completion;
- coach catalog exported in `content-manifest.json`.

## Stage 28. True Interactive Puzzle Mechanics

Upgrade tap-simulated interactions into real mechanics.

Priority mechanics:

- drag cards into targets;
- connect matching pairs;
- reorder cards;
- flip memory cards;
- trace routes;
- rotate shapes;
- sort objects into baskets;
- multi-step boss puzzle flow.

Definition of done:

- at least 3 mechanics are true gesture-based interactions;
- every mechanic has success, retry, and hint states;
- mechanics work on mobile screen sizes;
- existing tap-choice fallback remains stable.

## Stage 29. Collection And Customization

Give children a reason to return beyond completing levels.

Scope:

- sticker collection;
- helper character outfits;
- room or world decoration items;
- collectible puzzle badges;
- reward reveal animation;
- collection screen improvements.

Reward rules:

- small reward after normal lessons;
- stronger reward after boss lessons;
- rare reward after streak milestones;
- world-themed rewards for each world arc.

Definition of done:

- children can see what they unlocked;
- rewards have clear visual identity;
- collection progress is persistent;
- rewards do not block learning.

## Stage 30. Weekly Events

Make existing content feel fresh through limited-time themes.

Event examples:

- Robot Week;
- Star Hunt;
- Shape Garden Festival;
- Memory Mission;
- Logic Detective Week.

Scope:

- event definition model;
- event banner on home/path;
- event-specific puzzle selection;
- event rewards;
- event completion state.

Definition of done:

- one event can be configured without code changes;
- event has title, dates, reward, and puzzle filters;
- event progress is visible;
- event does not break normal route progress.

## Stage 31. Boss Mini-Games

Make boss levels feel like special moments.

Scope:

- 3-step boss puzzle flow;
- boss intro screen;
- world-specific boss problem;
- final reward reveal;
- stronger animation and feedback;
- parent summary for boss performance.

Boss structure:

- step 1: solve a core rule;
- step 2: apply a second skill;
- step 3: combine both into the final answer.

Definition of done:

- at least 3 boss templates exist;
- boss levels use mixed skills;
- boss completion feels different from normal lessons;
- boss mistakes feed adaptive review.

## Stage 32. Adaptive Smart Route

Make practice feel personal without making children feel judged.

Scope:

- detect weak skills from recent sessions;
- insert gentle review nodes;
- choose puzzle types by mistake history;
- avoid repeating the same family too soon;
- adapt difficulty after streaks of success or struggle.

Child-facing language:

- "Lumi prepared a memory boost";
- "Brainy found a logic shortcut";
- "Let's warm up this skill together."

Definition of done:

- adaptive review uses real mistake ids;
- weak-skill recommendations appear in the route;
- quick repeats are avoided;
- parents can see why a review was recommended.

## Stage 33. Sound And Microanimations

Add polish that makes the app feel responsive and joyful.

Scope:

- soft correct sound;
- gentle retry sound;
- card flip animation;
- drag snap animation;
- reward sparkle;
- helper character expression changes;
- reduced-motion fallback.

Rules:

- sounds must be optional;
- animations should support understanding;
- feedback should be quick and not distracting.

Definition of done:

- core lesson states have sound and animation hooks;
- settings include sound toggle;
- reduced-motion mode avoids heavy animation;
- tests cover toggles or state persistence.

## Stage 34. Child Creator Mode

Let children create simple puzzles.

Scope:

- build a sequence puzzle;
- choose an odd-one-out set;
- create a pair-match puzzle;
- let a helper character "try" the puzzle;
- save local creations for replay.

Definition of done:

- child can create at least 2 puzzle types;
- creation flow has guardrails;
- created puzzle can be played;
- no online sharing is required for the first version.

## Stage 35. Parent Insight Upgrade

Make parent value obvious and trustworthy.

Scope:

- skill growth over time;
- strongest and weakest skills;
- hint usage trend;
- mistake family trend;
- recommended next practice;
- weekly summary.

Definition of done:

- parent dashboard explains progress in plain language;
- recommendations are tied to actual practice data;
- parent can see learning value without reading raw puzzle logs.

## Success Metrics

Engagement metrics:

- children finish more lessons per session;
- children return on the next day;
- boss lesson completion rate improves;
- collection screen is opened after rewards;
- event participation is visible.

Learning metrics:

- mistake repeat rate decreases after adaptive review;
- hints decrease over repeated practice;
- weak-skill recommendations lead to better accuracy;
- parent dashboard shows understandable progress.

Content metrics:

- 25+ puzzle types;
- 100+ reusable asset references;
- 30+ route lessons;
- 10 boss levels;
- no QA blockers;
- visual metadata coverage approaches 100%.

## Recommended Build Order

1. Stage 26: Story Worlds And Missions.
2. Stage 27: Character Coach System.
3. Stage 29: Collection And Customization.
4. Stage 31: Boss Mini-Games.
5. Stage 28: True Interactive Puzzle Mechanics.
6. Stage 32: Adaptive Smart Route.
7. Stage 30: Weekly Events.
8. Stage 33: Sound And Microanimations.
9. Stage 35: Parent Insight Upgrade.
10. Stage 34: Child Creator Mode.

The first three stages should make BrainUp feel much more alive even before
adding many new puzzle types.
