# BrainUp Content Worlds

## Purpose

Content worlds make BrainUp puzzles feel like small adventures instead of a
stack of disconnected cards. A world defines the visual language, object set,
character fit, reward style, and preferred puzzle families for a group of
lessons.

The same puzzle family can appear in different worlds, but the scene, objects,
and story wrapper should change so the child feels progression and discovery.

## World Design Rules

Every world should define:

- stable `worldId`;
- child-facing theme;
- primary skills;
- preferred puzzle families;
- visual palette;
- scene backgrounds;
- reusable object set;
- helper character fit;
- reward style;
- boss lesson idea;
- asset requirements.

Worlds should be:

- visually distinct from each other;
- bright and readable on mobile;
- simple enough for ages 4-5;
- expandable for harder ages 7-8;
- reusable across route, review, daily, and boss content.

## World 1. Space Station

- World id: `space_station`
- Theme: rockets, planets, stars, modules, antennas, friendly aliens
- Primary skills: pattern, spatial, memory
- Best puzzle families:
  - `pattern.sequence_complete`
  - `spatial.route_build`
  - `memory.order_recall`
  - `attention.shadow_match`
  - `boss.mixed_challenge`
- Visual palette: deep navy, cyan, mint, bright coral, star yellow
- Core scenes:
  - launch bay;
  - planet map;
  - repair module;
  - star collection path;
  - mission control desk.
- Object set:
  - rockets;
  - planets;
  - stars;
  - satellites;
  - keys/cards;
  - fuel cells;
  - control buttons.
- Character fit: main BrainUp guide, memory guide, logic guide
- Reward style: star badges, rocket stickers, mission patches
- Boss idea: repair the station by solving path, pattern, and memory tasks
- Asset priority: P0

## World 2. Forest Lab

- World id: `forest_lab`
- Theme: treehouse science lab, leaves, mushrooms, jars, friendly experiments
- Primary skills: classification, attention, reasoning
- Best puzzle families:
  - `classification.odd_one_out`
  - `classification.object_sort`
  - `attention.spot_difference`
  - `reasoning.cause_effect`
  - `classification.habitat_match`
- Visual palette: leaf green, warm yellow, soft teal, berry red
- Core scenes:
  - treehouse table;
  - mushroom path;
  - leaf microscope;
  - sorting shelves;
  - garden workbench.
- Object set:
  - leaves;
  - berries;
  - jars;
  - mushrooms;
  - seed packets;
  - magnifying glasses;
  - tiny tools.
- Character fit: attention guide, logic guide
- Reward style: leaf badges, discovery stamps, seed collection
- Boss idea: sort lab samples and find what changed after an experiment
- Asset priority: P0

## World 3. Underwater City

- World id: `underwater_city`
- Theme: bubbles, coral, submarines, glowing sea signs, friendly sea helpers
- Primary skills: attention, memory, spatial
- Best puzzle families:
  - `attention.shadow_match`
  - `memory.what_changed`
  - `spatial.maze`
  - `math.group_compare`
  - `pattern.rule_detect`
- Visual palette: aqua, ocean blue, coral pink, pearl white, soft purple
- Core scenes:
  - coral plaza;
  - submarine dock;
  - bubble tunnel;
  - shell market;
  - glowing reef maze.
- Object set:
  - shells;
  - bubbles;
  - fish signs;
  - submarines;
  - pearls;
  - coral shapes;
  - treasure keys.
- Character fit: memory guide, attention guide
- Reward style: pearl badges, shell stickers, bubble trails
- Boss idea: guide a submarine through a reef using memory and path clues
- Asset priority: P1

## World 4. Robot Town

- World id: `robot_town`
- Theme: friendly robots, gears, circuits, charging stations, code panels
- Primary skills: reasoning, pattern, arithmetic
- Best puzzle families:
  - `reasoning.code_solver`
  - `pattern.rule_detect`
  - `math.logic_scales`
  - `reasoning.rule_arrange`
  - `reasoning.mini_sudoku`
- Visual palette: electric blue, graphite, lime, orange, white panels
- Core scenes:
  - robot workshop;
  - circuit board;
  - gear factory;
  - charging station;
  - code console.
- Object set:
  - gears;
  - batteries;
  - robot parts;
  - code tiles;
  - switches;
  - circuit nodes;
  - tool cards.
- Character fit: logic guide, math guide
- Reward style: robot parts, circuit badges, power cells
- Boss idea: assemble a robot by solving code, scale, and ordering tasks
- Asset priority: P0

## World 5. Castle Of Riddles

- World id: `riddle_castle`
- Theme: bright castle rooms, keys, doors, banners, friendly magical puzzles
- Primary skills: reasoning, classification, memory
- Best puzzle families:
  - `reasoning.conditional_path`
  - `reasoning.picture_rebus`
  - `memory.story_order`
  - `classification.odd_one_out`
  - `boss.mixed_challenge`
- Visual palette: royal purple, gold, sky blue, emerald, warm stone
- Core scenes:
  - gate puzzle;
  - key room;
  - banner hall;
  - magic library;
  - treasure door.
- Object set:
  - keys;
  - doors;
  - crowns;
  - banners;
  - books;
  - gems;
  - shields.
- Character fit: logic guide, main guide
- Reward style: keys, gem badges, castle stamps
- Boss idea: open the treasure door through story order, rebus, and path clues
- Asset priority: P1

## World 6. Dinosaur Island

- World id: `dinosaur_island`
- Theme: gentle dinosaurs, fossils, nests, volcano paths, explorer tools
- Primary skills: classification, counting, spatial
- Best puzzle families:
  - `math.object_count`
  - `classification.habitat_match`
  - `spatial.route_build`
  - `attention.spot_difference`
  - `memory.order_recall`
- Visual palette: jungle green, sand, volcano coral, sky blue, fossil cream
- Core scenes:
  - fossil dig;
  - dinosaur nest;
  - jungle path;
  - volcano bridge;
  - explorer camp.
- Object set:
  - fossils;
  - eggs;
  - footprints;
  - leaves;
  - explorer flags;
  - stones;
  - small dinos.
- Character fit: attention guide, spatial guide
- Reward style: fossil pieces, explorer badges, footprint stickers
- Boss idea: follow footprints, count eggs, and sort fossils to find a safe path
- Asset priority: P1

## World 7. Toy Shop

- World id: `toy_shop`
- Theme: shelves, blocks, balls, trains, plush toys, gift boxes
- Primary skills: arithmetic, classification, memory
- Best puzzle families:
  - `math.object_count`
  - `math.group_compare`
  - `classification.object_sort`
  - `memory.pair_match`
  - `pattern.sequence_complete`
- Visual palette: warm cream, red, teal, yellow, playful blue
- Core scenes:
  - shelf counter;
  - gift wrapping table;
  - train display;
  - block corner;
  - checkout counter.
- Object set:
  - blocks;
  - balls;
  - toy trains;
  - plush toys;
  - gift boxes;
  - price tags;
  - baskets.
- Character fit: math guide, memory guide
- Reward style: toy stickers, gift ribbons, shelf badges
- Boss idea: prepare the right gift order through counting, sorting, and pairs
- Asset priority: P0

## World 8. Garden Of Shapes

- World id: `shape_garden`
- Theme: flowers, paths, shape bushes, color gates, gentle garden puzzles
- Primary skills: spatial, pattern, attention
- Best puzzle families:
  - `spatial.shape_rotation`
  - `spatial.picture_assembly`
  - `pattern.sequence_complete`
  - `attention.shadow_match`
  - `classification.object_sort`
- Visual palette: fresh green, flower pink, sunny yellow, lavender, white
- Core scenes:
  - shape flower bed;
  - color gate;
  - garden path;
  - butterfly board;
  - puzzle fountain.
- Object set:
  - shape flowers;
  - butterflies;
  - stones;
  - watering cans;
  - garden signs;
  - petals;
  - seeds.
- Character fit: spatial guide, attention guide
- Reward style: flower badges, garden stickers, butterfly trails
- Boss idea: restore a shape garden by rotating, sorting, and assembling pieces
- Asset priority: P0

## World 9. Train Expedition

- World id: `train_expedition`
- Theme: train cars, routes, tickets, stations, cargo crates, maps
- Primary skills: sequence, memory, reasoning
- Best puzzle families:
  - `memory.story_order`
  - `pattern.rule_detect`
  - `spatial.route_build`
  - `reasoning.rule_arrange`
  - `math.group_compare`
- Visual palette: train red, navy, warm yellow, map beige, teal
- Core scenes:
  - station platform;
  - route map;
  - cargo sorting;
  - train car row;
  - ticket booth.
- Object set:
  - train cars;
  - tickets;
  - suitcases;
  - cargo crates;
  - route signs;
  - station clocks;
  - flags.
- Character fit: memory guide, logic guide
- Reward style: tickets, route stamps, train badges
- Boss idea: arrange train cars and choose the right route to reach a station
- Asset priority: P1

## World 10. Junior Detective Academy

- World id: `detective_academy`
- Theme: clue boards, magnifiers, footprints, cases, friendly mystery scenes
- Primary skills: reasoning, attention, memory
- Best puzzle families:
  - `attention.spot_difference`
  - `memory.what_changed`
  - `reasoning.cause_effect`
  - `reasoning.conditional_path`
  - `reasoning.code_solver`
- Visual palette: teal, warm tan, navy, clue orange, paper white
- Core scenes:
  - clue board;
  - desk with evidence;
  - footprint hallway;
  - secret code note;
  - case map.
- Object set:
  - magnifiers;
  - notes;
  - footprints;
  - envelopes;
  - clue cards;
  - stamps;
  - flashlights.
- Character fit: logic guide, attention guide
- Reward style: case badges, clue stamps, detective cards
- Boss idea: solve a small case by finding changes, ordering clues, and decoding
- Asset priority: P2

## First Pack World Mix

The first rich content pack should focus on five worlds:

- `space_station`
- `forest_lab`
- `robot_town`
- `toy_shop`
- `shape_garden`

This gives strong contrast while covering:

- logic and reasoning;
- memory;
- math;
- attention;
- spatial thinking;
- classification.

Later packs should add:

- `underwater_city`
- `riddle_castle`
- `dinosaur_island`
- `train_expedition`
- `detective_academy`

## World To Puzzle Family Coverage

Each P0 puzzle family should have at least two compatible worlds:

- `classification.odd_one_out`: forest lab, toy shop, shape garden
- `pattern.sequence_complete`: space station, toy shop, shape garden
- `memory.pair_match`: toy shop, forest lab, space station
- `memory.order_recall`: space station, dinosaur island, train expedition
- `spatial.route_build`: space station, dinosaur island, train expedition
- `math.object_count`: toy shop, dinosaur island, forest lab
- `math.group_compare`: toy shop, underwater city, train expedition
- `attention.shadow_match`: space station, underwater city, shape garden
- `spatial.shape_rotation`: shape garden, robot town, space station
- `pattern.rule_detect`: underwater city, robot town, train expedition
- `math.logic_scales`: robot town, toy shop, riddle castle
- `classification.object_sort`: forest lab, toy shop, shape garden
- `boss.mixed_challenge`: space station, robot town, riddle castle

## Asset Naming Direction

World asset names should follow:

```text
world.<worldId>.background.<sceneId>
world.<worldId>.object.<objectId>
world.<worldId>.ui.<stateId>
world.<worldId>.reward.<rewardId>
```

Examples:

```text
world.space_station.background.launch_bay
world.toy_shop.object.train_car_red
world.shape_garden.reward.flower_badge
```

## Stage 15 Done Criteria

This stage is complete when:

- `docs/content-worlds.md` exists;
- 8-10 worlds are defined;
- each world has visual palette, scenes, object sets, rewards, and boss idea;
- each P0 puzzle family maps to at least two worlds;
- Stage 17 can derive asset folders and naming from this document;
- Stage 19 can choose worlds for the first large content pack.
