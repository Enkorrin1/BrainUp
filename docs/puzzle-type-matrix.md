# BrainUp Puzzle Type Matrix

## Purpose

This matrix turns the BrainUp puzzle content system into concrete puzzle
families. It is the planning source for Stage 18 visual metadata, Stage 19 large
content packs, Stage 20 interactions, and later content QA.

Each family below should become a reusable content template with its own visual
logic, asset set, interaction rules, hints, explanations, and route placement.

## Family Fields

Each puzzle family defines:

- family id;
- primary skill;
- secondary skills;
- age fit;
- interaction;
- visual scene;
- answer rule;
- hint pattern;
- asset needs;
- app placement;
- MVP priority.

## Priority Legend

- P0: must exist in the first rich content pack.
- P1: should exist soon after P0.
- P2: useful for later scale, boss levels, or special events.

## Puzzle Families

### 1. Odd One Out

- Family id: `classification.odd_one_out`
- Primary skill: classification
- Secondary skills: attention
- Age fit: 4-8
- Interaction: tap choice
- Visual scene: 4-6 object cards from one world
- Answer rule: choose the object that does not share the group property
- Hint pattern: "Look for what three objects have in common."
- Asset needs: object cards, selected state, correct/wrong state
- Placement: route warm-up, daily challenge, adaptive review
- MVP priority: P0

### 2. Sequence Completion

- Family id: `pattern.sequence_complete`
- Primary skill: pattern
- Secondary skills: memory
- Age fit: 4-8
- Interaction: tap choice or drag missing card
- Visual scene: object row with one empty slot
- Answer rule: continue the repeating or growing pattern
- Hint pattern: "Say the row out loud and find what repeats."
- Asset needs: row cards, empty slot, answer cards
- Placement: route, review, boss prerequisite
- MVP priority: P0

### 3. Pair Matching

- Family id: `memory.pair_match`
- Primary skill: memory
- Secondary skills: classification
- Age fit: 4-8
- Interaction: tap pair or drag object to partner
- Visual scene: object cards split into two groups
- Answer rule: connect objects that logically belong together
- Hint pattern: "Think what this object is used with."
- Asset needs: object pairs, connection line, match animation
- Placement: route, review, daily challenge
- MVP priority: P0

### 4. Memory Order

- Family id: `memory.order_recall`
- Primary skill: memory
- Secondary skills: attention
- Age fit: 5-8
- Interaction: reveal then tap/reorder
- Visual scene: remember phase with 3-6 objects, then hidden sequence
- Answer rule: restore the shown order
- Hint pattern: "Remember the first and last object first."
- Asset needs: object cards, cover cards, reorder slots
- Placement: route, adaptive review, boss
- MVP priority: P0

### 5. Route Building

- Family id: `spatial.route_build`
- Primary skill: spatial
- Secondary skills: reasoning
- Age fit: 5-8
- Interaction: tap path segments or drag route pieces
- Visual scene: map grid with start, goal, obstacles
- Answer rule: build the path that follows the conditions
- Hint pattern: "Find the path that avoids the blocked tiles."
- Asset needs: grid tiles, start/finish, obstacles, path pieces
- Placement: route, boss lessons
- MVP priority: P0

### 6. Object Counting

- Family id: `math.object_count`
- Primary skill: arithmetic
- Secondary skills: attention
- Age fit: 4-6
- Interaction: tap number choice
- Visual scene: small group of world objects
- Answer rule: count exact target objects
- Hint pattern: "Touch each object once as you count."
- Asset needs: countable objects, number cards, highlight state
- Placement: early route, daily challenge
- MVP priority: P0

### 7. Group Comparison

- Family id: `math.group_compare`
- Primary skill: arithmetic
- Secondary skills: attention
- Age fit: 4-8
- Interaction: tap group or comparison symbol
- Visual scene: two or three object groups
- Answer rule: choose more, less, equal, or biggest group
- Hint pattern: "Count both groups, then compare the numbers."
- Asset needs: group containers, object sets, comparison symbols
- Placement: route, review
- MVP priority: P0

### 8. Shadow Matching

- Family id: `attention.shadow_match`
- Primary skill: attention
- Secondary skills: spatial
- Age fit: 4-7
- Interaction: tap object matching the silhouette
- Visual scene: shadow card plus object choices
- Answer rule: match outline and major details
- Hint pattern: "Look at the whole outline, not only the color."
- Asset needs: silhouettes, object cards, fit animation
- Placement: route, daily challenge, review
- MVP priority: P0

### 9. Shape Rotation

- Family id: `spatial.shape_rotation`
- Primary skill: spatial
- Secondary skills: reasoning
- Age fit: 6-8
- Interaction: tap rotated match or rotate object
- Visual scene: reference shape and rotated options
- Answer rule: choose same shape after rotation
- Hint pattern: "Turning changes direction, but not the shape."
- Asset needs: shape cards, rotation animation, orientation markers
- Placement: route, boss, review
- MVP priority: P0

### 10. Rule Arrangement

- Family id: `reasoning.rule_arrange`
- Primary skill: reasoning
- Secondary skills: pattern
- Age fit: 6-8
- Interaction: drag objects into slots
- Visual scene: ordered slots with a visible rule
- Answer rule: arrange objects so the rule stays true
- Hint pattern: "Place the object that starts the rule first."
- Asset needs: draggable cards, slots, rule marker
- Placement: route, boss lessons
- MVP priority: P1

### 11. Pattern Detection

- Family id: `pattern.rule_detect`
- Primary skill: pattern
- Secondary skills: reasoning
- Age fit: 5-8
- Interaction: tap the rule or missing piece
- Visual scene: two rows where one row shows the rule
- Answer rule: infer the rule and apply it
- Hint pattern: "Compare what changes from left to right."
- Asset needs: row cards, rule badges, answer cards
- Placement: route, review, boss
- MVP priority: P0

### 12. Code Solving

- Family id: `reasoning.code_solver`
- Primary skill: reasoning
- Secondary skills: pattern
- Age fit: 7-8
- Interaction: tap symbol/number answer
- Visual scene: small code grid or symbol machine
- Answer rule: solve the hidden mapping or sequence rule
- Hint pattern: "Find how the first row changes."
- Asset needs: code symbols, grid cells, answer cards
- Placement: later route, boss
- MVP priority: P1

### 13. Spot The Difference

- Family id: `attention.spot_difference`
- Primary skill: attention
- Secondary skills: memory
- Age fit: 4-8
- Interaction: tap changed object/detail
- Visual scene: two similar scenes side by side or before/after reveal
- Answer rule: identify the changed or missing detail
- Hint pattern: "Check color, size, and position."
- Asset needs: paired scene variants, highlight ring
- Placement: route, daily challenge, review
- MVP priority: P1

### 14. Picture Assembly

- Family id: `spatial.picture_assembly`
- Primary skill: spatial
- Secondary skills: attention
- Age fit: 5-8
- Interaction: drag pieces into frame
- Visual scene: simple broken image or object silhouette
- Answer rule: assemble pieces into the target shape
- Hint pattern: "Start with the corner or edge piece."
- Asset needs: puzzle pieces, target frame, snap animation
- Placement: route, reward moments, boss
- MVP priority: P1

### 15. Logic Scales

- Family id: `math.logic_scales`
- Primary skill: arithmetic
- Secondary skills: reasoning
- Age fit: 6-8
- Interaction: tap missing object or drag object to scale
- Visual scene: balance scale with objects on both sides
- Answer rule: make both sides equal
- Hint pattern: "Count what is already on each side."
- Asset needs: scale, weighted objects, balance animation
- Placement: route, review, boss
- MVP priority: P0

### 16. Mini Sudoku

- Family id: `reasoning.mini_sudoku`
- Primary skill: reasoning
- Secondary skills: classification
- Age fit: 7-8
- Interaction: drag/tap item into grid
- Visual scene: 2x2 or 3x3 grid with symbols or objects
- Answer rule: each row/column needs unique items
- Hint pattern: "Look for the row that has only one missing item."
- Asset needs: grid, symbol tiles, error highlight
- Placement: later route, boss
- MVP priority: P2

### 17. Habitat Matching

- Family id: `classification.habitat_match`
- Primary skill: classification
- Secondary skills: reasoning
- Age fit: 4-8
- Interaction: drag character/object to correct place
- Visual scene: animals or objects and matching habitats/rooms
- Answer rule: place item where it belongs
- Hint pattern: "Think where this object is usually found."
- Asset needs: item cards, habitat scenes, drop zones
- Placement: route, daily challenge
- MVP priority: P1

### 18. Spatial Maze

- Family id: `spatial.maze`
- Primary skill: spatial
- Secondary skills: reasoning
- Age fit: 5-8
- Interaction: trace path or tap next step
- Visual scene: maze with collectible or goal
- Answer rule: reach goal without blocked paths
- Hint pattern: "Look one step ahead before moving."
- Asset needs: maze tiles, character token, blocked paths
- Placement: route, boss lessons
- MVP priority: P1

### 19. Picture Rebus

- Family id: `reasoning.picture_rebus`
- Primary skill: reasoning
- Secondary skills: classification
- Age fit: 6-8
- Interaction: tap answer word/object
- Visual scene: combination of pictures that imply a word or idea
- Answer rule: infer meaning from visual clues
- Hint pattern: "Say the picture names together."
- Asset needs: clue images, answer cards, helper character
- Placement: later route, special daily
- MVP priority: P2

### 20. What Changed

- Family id: `memory.what_changed`
- Primary skill: memory
- Secondary skills: attention
- Age fit: 5-8
- Interaction: reveal scene, then tap changed item
- Visual scene: before scene and after scene
- Answer rule: identify object that moved, vanished, or changed
- Hint pattern: "Remember where each object was."
- Asset needs: scene variants, object highlight, reveal animation
- Placement: route, adaptive review
- MVP priority: P1

### 21. Conditional Path

- Family id: `reasoning.conditional_path`
- Primary skill: reasoning
- Secondary skills: spatial
- Age fit: 7-8
- Interaction: choose route with conditions
- Visual scene: path map with rule signs
- Answer rule: follow if/then constraints to choose correct route
- Hint pattern: "Check each sign before choosing the path."
- Asset needs: path map, rule signs, route markers
- Placement: boss, advanced route
- MVP priority: P2

### 22. Object Sorting

- Family id: `classification.object_sort`
- Primary skill: classification
- Secondary skills: attention
- Age fit: 4-8
- Interaction: drag objects into baskets
- Visual scene: baskets/categories and object cards
- Answer rule: group by shared property
- Hint pattern: "Look for color, shape, use, or place."
- Asset needs: baskets, draggable objects, category icons
- Placement: route, review, daily
- MVP priority: P0

### 23. Cause And Effect

- Family id: `reasoning.cause_effect`
- Primary skill: reasoning
- Secondary skills: sequence
- Age fit: 6-8
- Interaction: tap result card or order story cards
- Visual scene: small story moment with before/after cards
- Answer rule: choose what happens because of the first event
- Hint pattern: "Ask what would happen next."
- Asset needs: story cards, arrow connector, result cards
- Placement: route, parent-friendly learning reports
- MVP priority: P1

### 24. Story Ordering

- Family id: `memory.story_order`
- Primary skill: memory
- Secondary skills: reasoning
- Age fit: 5-8
- Interaction: reorder cards
- Visual scene: 3-5 story cards from one world
- Answer rule: place events in logical or remembered order
- Hint pattern: "Find the first thing that must happen."
- Asset needs: story panels, reorder slots, snap animation
- Placement: route, boss prerequisite, review
- MVP priority: P1

### 25. Mixed Boss Puzzle

- Family id: `boss.mixed_challenge`
- Primary skill: reasoning
- Secondary skills: any two or more skills
- Age fit: 6-8
- Interaction: multi-step sequence
- Visual scene: large world scene with 3-4 connected puzzle beats
- Answer rule: solve all beats to complete the scene
- Hint pattern: "Solve one part at a time."
- Asset needs: boss background, multi-step objects, reward reveal
- Placement: boss nodes, milestone lessons
- MVP priority: P0

## MVP Pack Recommendation

The first rich content pack should include these P0 families:

- `classification.odd_one_out`
- `pattern.sequence_complete`
- `memory.pair_match`
- `memory.order_recall`
- `spatial.route_build`
- `math.object_count`
- `math.group_compare`
- `attention.shadow_match`
- `spatial.shape_rotation`
- `pattern.rule_detect`
- `math.logic_scales`
- `classification.object_sort`
- `boss.mixed_challenge`

Target count for the first pass:

- 8 tasks per P0 family;
- 4 tasks per P1 family;
- 1-2 design prototypes for P2 families;
- at least 150 production-shaped puzzle definitions after metadata support.

## Interaction Implementation Order

1. Tap choice.
2. Drag to target.
3. Reorder cards.
4. Match pairs.
5. Memory reveal.
6. Trace path.
7. Rotate object.
8. Multi-step boss flow.

This order keeps the first expansion achievable while still moving beyond
single-tap quizzes.

## Asset Planning Buckets

Each family should be mapped to one of these asset buckets:

- object cards;
- scene backgrounds;
- grid or path tiles;
- draggable pieces;
- character feedback;
- reward effects;
- animated state overlays.

Stage 17 should use these buckets to create the first reusable asset directory
structure.

## Stage 14 Done Criteria

This stage is complete when:

- `docs/puzzle-type-matrix.md` exists;
- at least 25 puzzle families are defined;
- each family has skill, interaction, visual, asset, and placement guidance;
- P0 families are identified for the first rich content pack;
- Stage 18 can map these families into visual puzzle metadata.
