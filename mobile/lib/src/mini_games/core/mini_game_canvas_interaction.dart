import 'mini_game_definition.dart';

class MiniGameCanvasInteraction {
  const MiniGameCanvasInteraction._();

  static String? choiceIdForHotspot({
    required MiniGameDefinition definition,
    required int hotspotIndex,
  }) {
    final choices = definition.firstRound.choiceIds;
    if (choices.isEmpty || hotspotIndex < 0) {
      return null;
    }
    return choices[hotspotIndex % choices.length];
  }

  static String? dropTargetIdForZone({
    required MiniGameDefinition definition,
    required int zoneIndex,
  }) {
    final targets = definition.firstRound.dropTargets;
    if (targets.isEmpty || zoneIndex < 0) {
      return null;
    }
    return targets[zoneIndex % targets.length].id;
  }

  static bool isKnownDropTarget({
    required MiniGameDefinition definition,
    required String targetId,
  }) {
    return definition.firstRound.dropTargets.any(
      (target) => target.id == targetId,
    );
  }

  static bool isCorrectDrop({
    required MiniGameDefinition definition,
    required String choiceId,
    required String targetId,
  }) {
    final expectedTarget =
        definition.firstRound.correctDropTargetByChoiceId[choiceId];
    if (expectedTarget != null) {
      return expectedTarget == targetId;
    }

    final targets = definition.firstRound.dropTargets;
    return choiceId == definition.firstRound.correctChoiceId &&
        targets.isNotEmpty &&
        targetId == targets.first.id;
  }
}
