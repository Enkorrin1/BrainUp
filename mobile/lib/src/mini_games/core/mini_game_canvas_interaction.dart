import '../../domain/learning_foundation.dart';
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

  static int normalizedQuarterTurns(int quarterTurns) {
    return ((quarterTurns % 4) + 4) % 4;
  }

  static int targetRotationQuarterTurns({
    required MiniGameDefinition definition,
  }) {
    return switch (definition.difficulty) {
      PuzzleDifficulty.easy => 1,
      PuzzleDifficulty.normal => 2,
      PuzzleDifficulty.hard || PuzzleDifficulty.boss => 3,
    };
  }

  static bool isCorrectRotationAssembly({
    required MiniGameDefinition definition,
    required String choiceId,
    required String targetId,
    required int quarterTurns,
  }) {
    return isCorrectDrop(
          definition: definition,
          choiceId: choiceId,
          targetId: targetId,
        ) &&
        normalizedQuarterTurns(quarterTurns) ==
            targetRotationQuarterTurns(definition: definition);
  }

  static List<int> normalizedHotspotSequence(List<int> hotspotIndices) {
    final normalized = <int>[];
    for (final hotspotIndex in hotspotIndices) {
      if (hotspotIndex < 0) {
        continue;
      }
      if (normalized.isEmpty || normalized.last != hotspotIndex) {
        normalized.add(hotspotIndex);
      }
    }
    return normalized;
  }

  static int? traceEndpointHotspotIndex({
    required MiniGameDefinition definition,
    required int nodeCount,
    int minEndpointIndex = 2,
  }) {
    final choices = definition.firstRound.choiceIds;
    if (choices.isEmpty || nodeCount <= 0) {
      return null;
    }

    final choiceIndex = choices.indexOf(definition.firstRound.correctChoiceId);
    if (choiceIndex < 0) {
      return null;
    }

    final minIndex = minEndpointIndex.clamp(0, nodeCount - 1);
    var endpointIndex = choiceIndex;
    while (endpointIndex < minIndex) {
      endpointIndex += choices.length;
    }
    while (endpointIndex >= nodeCount &&
        endpointIndex - choices.length >= minIndex) {
      endpointIndex -= choices.length;
    }
    if (endpointIndex >= nodeCount) {
      return choiceIndex < nodeCount ? choiceIndex : null;
    }
    return endpointIndex;
  }

  static bool isValidTraceRoute({
    required MiniGameDefinition definition,
    required List<int> hotspotIndices,
    required int nodeCount,
  }) {
    final endpointIndex = traceEndpointHotspotIndex(
      definition: definition,
      nodeCount: nodeCount,
    );
    if (endpointIndex == null) {
      return false;
    }

    final normalized = normalizedHotspotSequence(hotspotIndices);
    if (normalized.length != endpointIndex + 1) {
      return false;
    }
    for (var index = 0; index <= endpointIndex; index += 1) {
      if (normalized[index] != index) {
        return false;
      }
    }
    return true;
  }
}
