import '../../domain/daily_challenge.dart';
import '../../domain/learning_foundation.dart';
import 'mini_game_definition.dart';

class MiniGameRegistry {
  const MiniGameRegistry._();

  static const enabledInteractionTypes = {
    PuzzleInteractionType.memoryReveal,
    PuzzleInteractionType.tracePath,
    PuzzleInteractionType.rotateObject,
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
        !enabledInteractionTypes.contains(interaction.type)) {
      return null;
    }

    final miniGameType = _typeFor(
      interactionType: interaction.type,
      puzzleType: puzzleType,
    );
    if (miniGameType == null) {
      return null;
    }

    return MiniGameDefinition(
      id: 'mini.${miniGameType.name}.${challenge.id}',
      puzzleId: challenge.id,
      type: miniGameType,
      title: _titleFor(miniGameType),
      prompt: challenge.question,
      worldId: challenge.worldId ?? 'space_station',
      characterId: challenge.characterId ?? 'brainy',
      puzzleType: puzzleType,
      skillTag: skillTag,
      difficulty: difficulty,
      sourceInteractionType: interaction.type,
      estimatedSeconds: _estimatedSecondsFor(difficulty),
      assetKeys: [
        for (final item in interaction.items)
          if (item.assetId != null) item.assetId!,
      ],
      rounds: [
        MiniGameRoundDefinition(
          id: '${challenge.id}.round.1',
          title: challenge.title,
          goal: interaction.instruction,
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

  static int _estimatedSecondsFor(PuzzleDifficulty difficulty) {
    return switch (difficulty) {
      PuzzleDifficulty.easy => 25,
      PuzzleDifficulty.normal => 35,
      PuzzleDifficulty.hard => 50,
      PuzzleDifficulty.boss => 75,
    };
  }
}
