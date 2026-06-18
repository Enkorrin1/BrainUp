import '../../domain/learning_foundation.dart';
import 'mini_game_adaptive.dart';
import 'mini_game_audio.dart';
import 'mini_game_character_reaction.dart';
import 'mini_game_feedback.dart';

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

class MiniGameDropTargetDefinition {
  const MiniGameDropTargetDefinition({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'label': label,
    };
  }
}

class MiniGameRoundDefinition {
  const MiniGameRoundDefinition({
    required this.id,
    required this.title,
    required this.goal,
    required this.correctChoiceId,
    required this.choiceIds,
    this.choiceLabelsById = const {},
    this.dropTargets = const [],
    this.correctDropTargetByChoiceId = const {},
  });

  final String id;
  final String title;
  final String goal;
  final String correctChoiceId;
  final List<String> choiceIds;
  final Map<String, String> choiceLabelsById;
  final List<MiniGameDropTargetDefinition> dropTargets;
  final Map<String, String> correctDropTargetByChoiceId;

  String labelForChoice(String choiceId) {
    return choiceLabelsById[choiceId] ?? choiceId;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'goal': goal,
      'correctChoiceId': correctChoiceId,
      'choiceIds': choiceIds,
      'choiceLabelsById': choiceLabelsById,
      'dropTargets': [
        for (final target in dropTargets) target.toJson(),
      ],
      'correctDropTargetByChoiceId': correctDropTargetByChoiceId,
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
    required this.feedbackProfile,
    required this.characterReactionProfile,
    required this.adaptiveProfile,
    required this.audioProfile,
    required this.parentSummaryLabel,
    this.contentConfig,
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
  final MiniGameContentConfig? contentConfig;
  final MiniGameFeedbackProfile feedbackProfile;
  final MiniGameCharacterReactionProfile characterReactionProfile;
  final MiniGameAdaptiveProfile adaptiveProfile;
  final MiniGameAudioProfile audioProfile;
  final String parentSummaryLabel;
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
      if (contentConfig != null) 'contentConfig': contentConfig!.toJson(),
      'feedbackProfile': feedbackProfile.toJson(),
      'characterReactionProfile': characterReactionProfile.toJson(),
      'adaptiveProfile': adaptiveProfile.toJson(),
      'audioProfile': audioProfile.toJson(),
      'parentSummaryLabel': parentSummaryLabel,
      'timePressure': timePressure,
      'assetKeys': assetKeys,
      'rounds': [
        for (final round in rounds) round.toJson(),
      ],
    };
  }
}
