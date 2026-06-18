import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/mini_game_definition.dart';
import '../core/mini_game_scene_controller.dart';
import '../games/boss_mix_game/boss_mix_game.dart';
import '../games/attention_scan_game/attention_scan_game.dart';
import '../games/drag_drop_game/drag_drop_game.dart';
import '../games/logic_path_game/logic_path_game.dart';
import '../games/memory_grid_game/memory_grid_game.dart';
import '../games/pair_link_game/pair_link_game.dart';
import '../games/pattern_machine_game/pattern_machine_game.dart';
import '../games/shape_builder_game/shape_builder_game.dart';

Color miniGameAccentFor(MiniGameType type) {
  return switch (type) {
    MiniGameType.memoryGrid => const Color(0xFF42F4D2),
    MiniGameType.logicPath => const Color(0xFFFFD15C),
    MiniGameType.mathBubbles => const Color(0xFFFF6F7D),
    MiniGameType.shapeBuilder => const Color(0xFF9C6AF2),
    MiniGameType.attentionScan => const Color(0xFF68D391),
    MiniGameType.patternMachine => const Color(0xFF5C8EF7),
    MiniGameType.pairLink => const Color(0xFFFFD15C),
    MiniGameType.sortLab => const Color(0xFFE9C46A),
    MiniGameType.bossMix => const Color(0xFFFF6F7D),
  };
}

FlameGame miniGameSceneFor(
  MiniGameDefinition definition, {
  required MiniGameSceneController sceneController,
}) {
  return switch (definition.type) {
    MiniGameType.memoryGrid => MemoryGridGame(
        definition: definition,
        sceneController: sceneController,
      ),
    MiniGameType.logicPath => LogicPathGame(
        definition: definition,
        sceneController: sceneController,
      ),
    MiniGameType.shapeBuilder => ShapeBuilderGame(
        definition: definition,
        sceneController: sceneController,
      ),
    MiniGameType.bossMix => BossMixGame(
        definition: definition,
        sceneController: sceneController,
      ),
    MiniGameType.mathBubbles || MiniGameType.sortLab => DragDropGame(
        definition: definition,
        sceneController: sceneController,
      ),
    MiniGameType.attentionScan => AttentionScanGame(
        definition: definition,
        sceneController: sceneController,
      ),
    MiniGameType.patternMachine => PatternMachineGame(
        definition: definition,
        sceneController: sceneController,
      ),
    MiniGameType.pairLink => PairLinkGame(
        definition: definition,
        sceneController: sceneController,
      ),
  };
}
