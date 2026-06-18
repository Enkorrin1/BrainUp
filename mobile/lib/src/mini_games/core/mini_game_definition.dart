import '../../domain/learning_foundation.dart';

enum MiniGameType {
  memoryGrid,
  logicPath,
  mathBubbles,
  shapeBuilder,
  attentionScan,
  patternMachine,
  sortLab,
  bossMix,
}

class MiniGameRoundDefinition {
  const MiniGameRoundDefinition({
    required this.id,
    required this.title,
    required this.goal,
    required this.correctChoiceId,
    required this.choiceIds,
  });

  final String id;
  final String title;
  final String goal;
  final String correctChoiceId;
  final List<String> choiceIds;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'goal': goal,
      'correctChoiceId': correctChoiceId,
      'choiceIds': choiceIds,
    };
  }
}

class MiniGameDefinition {
  const MiniGameDefinition({
    required this.id,
    required this.puzzleId,
    required this.type,
    required this.title,
    required this.prompt,
    required this.worldId,
    required this.characterId,
    required this.puzzleType,
    required this.skillTag,
    required this.difficulty,
    required this.sourceInteractionType,
    required this.rounds,
    required this.estimatedSeconds,
    this.timePressure = false,
    this.assetKeys = const [],
  });

  final String id;
  final String puzzleId;
  final MiniGameType type;
  final String title;
  final String prompt;
  final String worldId;
  final String characterId;
  final PuzzleType puzzleType;
  final SkillTag skillTag;
  final PuzzleDifficulty difficulty;
  final PuzzleInteractionType sourceInteractionType;
  final List<MiniGameRoundDefinition> rounds;
  final int estimatedSeconds;
  final bool timePressure;
  final List<String> assetKeys;

  MiniGameRoundDefinition get firstRound {
    return rounds.first;
  }

  bool get isBoss {
    return type == MiniGameType.bossMix || difficulty == PuzzleDifficulty.boss;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'puzzleId': puzzleId,
      'type': type.name,
      'title': title,
      'prompt': prompt,
      'worldId': worldId,
      'characterId': characterId,
      'puzzleType': puzzleType.name,
      'skillTag': skillTag.name,
      'difficulty': difficulty.name,
      'sourceInteractionType': sourceInteractionType.name,
      'roundCount': rounds.length,
      'estimatedSeconds': estimatedSeconds,
      'timePressure': timePressure,
      'assetKeys': assetKeys,
      'rounds': [
        for (final round in rounds) round.toJson(),
      ],
    };
  }
}
