import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import 'mini_game_adaptive.dart';
import 'mini_game_audio.dart';
import 'mini_game_character_reaction.dart';
import 'mini_game_definition.dart';
import 'mini_game_feedback.dart';

class MiniGameRegistry {
  const MiniGameRegistry._();

  static const enabledInteractionTypes = {
    PuzzleInteractionType.memoryReveal,
    PuzzleInteractionType.tracePath,
    PuzzleInteractionType.rotateObject,
    PuzzleInteractionType.multiStepBoss,
  };

  static MiniGameDefinition? definitionForChallenge(DailyChallenge challenge) {
    final interaction = challenge.interaction;
    final puzzleType = challenge.puzzleType;
    final skillTag = challenge.skillTag;
    final difficulty = challenge.difficulty;

    if (interaction == null ||
        puzzleType == null ||
        skillTag == null ||
        difficulty == null ||
        !enabledInteractionTypes.contains(interaction.type) ||
        challenge.miniGameConfig?.isValid != true) {
      return null;
    }

    final contentConfig = challenge.miniGameConfig!;
    final miniGameType = _typeFor(
      interactionType: interaction.type,
      puzzleType: puzzleType,
    );
    if (miniGameType == null) {
      return null;
    }

    final worldId = challenge.worldId ?? 'space_station';
    final characterId = challenge.characterId ?? 'brainy';
    final isBoss = miniGameType == MiniGameType.bossMix ||
        difficulty == PuzzleDifficulty.boss;
    final adaptiveProfile = MiniGameAdaptiveProfile.fromContent(
      puzzleDifficulty: difficulty,
      isBoss: isBoss,
      contentConfig: contentConfig,
    );
    final roundCount =
        contentConfig.minRounds < 1 ? 1 : contentConfig.minRounds;
    final assetKeys = <String>{
      ...contentConfig.assetSlots.values,
      for (final item in interaction.items)
        if (item.assetId != null) item.assetId!,
    }.toList(growable: false);

    return MiniGameDefinition(
      id: 'mini.${miniGameType.name}.${challenge.id}',
      puzzleId: challenge.id,
      type: miniGameType,
      title: _titleFor(miniGameType),
      prompt: challenge.question,
      worldId: worldId,
      characterId: characterId,
      puzzleType: puzzleType,
      skillTag: skillTag,
      difficulty: difficulty,
      sourceInteractionType: interaction.type,
      estimatedSeconds: _estimatedSecondsFor(difficulty, roundCount),
      contentConfig: contentConfig,
      feedbackProfile: MiniGameFeedbackProfile.forContent(contentConfig),
      characterReactionProfile: MiniGameCharacterReactionProfile.forCharacter(
        characterId: characterId,
        skillTag: skillTag,
        isBoss: isBoss,
      ),
      adaptiveProfile: adaptiveProfile,
      audioProfile: MiniGameAudioProfile.forContent(
        worldId: worldId,
        isBoss: isBoss,
        contentConfig: contentConfig,
      ),
      parentSummaryLabel: _parentSummaryFor(
        skillTag: skillTag,
        isBoss: isBoss,
      ),
      timePressure: adaptiveProfile.timePressure,
      assetKeys: assetKeys,
      rounds: [
        for (var index = 0; index < roundCount; index += 1)
          MiniGameRoundDefinition(
            id: '${challenge.id}.round.${index + 1}',
            title: roundCount == 1
                ? challenge.title
                : '${challenge.title} ${index + 1}/$roundCount',
            goal: _goalForRound(
              instruction: interaction.instruction,
              type: miniGameType,
              roundIndex: index,
              roundCount: roundCount,
            ),
            correctChoiceId: challenge.correctChoiceId,
            choiceIds: [
              for (final choice in challenge.choices) choice.id,
            ],
          ),
      ],
    );
  }

  static bool isMiniGameReady(DailyChallenge challenge) {
    return definitionForChallenge(challenge) != null;
  }

  static List<MiniGameDefinition> adaptiveReviewDefinitions({
    required Iterable<PuzzleDefinition> puzzles,
    required ChildAge age,
    Iterable<String> mistakeSignals = const [],
    int limit = 5,
  }) {
    final mistakeSet = mistakeSignals.toSet();
    final definitions = [
      for (final puzzle in puzzles)
        if (FoundationCatalog.isMiniGameReadyPuzzle(puzzle))
          definitionForChallenge(dailyChallengeForPuzzle(puzzle, age)),
    ].whereType<MiniGameDefinition>().toList(growable: false);

    definitions.sort((left, right) {
      final leftMistake = mistakeSet.contains(left.puzzleId) ? 1 : 0;
      final rightMistake = mistakeSet.contains(right.puzzleId) ? 1 : 0;
      final mistakeCompare = rightMistake.compareTo(leftMistake);
      if (mistakeCompare != 0) {
        return mistakeCompare;
      }
      return right.adaptiveProfile.reviewPriority.compareTo(
        left.adaptiveProfile.reviewPriority,
      );
    });

    return definitions.take(limit).toList(growable: false);
  }

  static MiniGameType? _typeFor({
    required PuzzleInteractionType interactionType,
    required PuzzleType puzzleType,
  }) {
    if (interactionType == PuzzleInteractionType.memoryReveal &&
        puzzleType == PuzzleType.memoryGrid) {
      return MiniGameType.memoryGrid;
    }
    if (interactionType == PuzzleInteractionType.tracePath &&
        puzzleType == PuzzleType.pathPuzzle) {
      return MiniGameType.logicPath;
    }
    if (interactionType == PuzzleInteractionType.rotateObject &&
        puzzleType == PuzzleType.spatialRotation) {
      return MiniGameType.shapeBuilder;
    }
    if (interactionType == PuzzleInteractionType.multiStepBoss &&
        puzzleType == PuzzleType.mixedBoss) {
      return MiniGameType.bossMix;
    }

    return null;
  }

  static String _titleFor(MiniGameType type) {
    return switch (type) {
      MiniGameType.memoryGrid => 'Memory Grid',
      MiniGameType.logicPath => 'Logic Path',
      MiniGameType.mathBubbles => 'Math Bubbles',
      MiniGameType.shapeBuilder => 'Shape Builder',
      MiniGameType.attentionScan => 'Attention Scan',
      MiniGameType.patternMachine => 'Pattern Machine',
      MiniGameType.sortLab => 'Sort Lab',
      MiniGameType.bossMix => 'Boss Mix',
    };
  }

  static int _estimatedSecondsFor(PuzzleDifficulty difficulty, int roundCount) {
    final baseSeconds = switch (difficulty) {
      PuzzleDifficulty.easy => 25,
      PuzzleDifficulty.normal => 35,
      PuzzleDifficulty.hard => 50,
      PuzzleDifficulty.boss => 75,
    };
    return baseSeconds + (roundCount - 1) * 18;
  }

  static String _goalForRound({
    required String instruction,
    required MiniGameType type,
    required int roundIndex,
    required int roundCount,
  }) {
    if (roundCount == 1) {
      return instruction;
    }
    final stepGoal = switch (type) {
      MiniGameType.bossMix => switch (roundIndex) {
          0 => 'Step 1: remember the clue and prepare the boss gate.',
          1 => 'Step 2: trace the logic path without losing the rule.',
          _ => 'Final step: choose the answer and unlock the reward.',
        },
      _ => 'Round ${roundIndex + 1}: $instruction',
    };
    return stepGoal;
  }

  static String _parentSummaryFor({
    required SkillTag skillTag,
    required bool isBoss,
  }) {
    final skillLabel = switch (skillTag) {
      SkillTag.attention => 'attention control',
      SkillTag.memory => 'working memory',
      SkillTag.pattern => 'pattern reasoning',
      SkillTag.classification => 'classification',
      SkillTag.arithmetic => 'math thinking',
      SkillTag.spatial => 'spatial reasoning',
      SkillTag.reasoning => 'logic and deduction',
    };
    return isBoss
        ? 'Boss mini-game combined $skillLabel with multi-step planning.'
        : 'Mini-game practiced $skillLabel through active play.';
  }
}
