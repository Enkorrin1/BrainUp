import 'package:brain_up/src/domain/daily_challenge.dart';
import 'package:brain_up/src/domain/family_profile.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';
import 'package:brain_up/src/mini_games/core/mini_game_controller.dart';
import 'package:brain_up/src/mini_games/core/mini_game_definition.dart';
import 'package:brain_up/src/mini_games/core/mini_game_registry.dart';
import 'package:brain_up/src/mini_games/core/mini_game_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registry creates the first three playable mini-game definitions', () {
    final cases = {
      PuzzleType.memoryGrid: MiniGameType.memoryGrid,
      PuzzleType.pathPuzzle: MiniGameType.logicPath,
      PuzzleType.spatialRotation: MiniGameType.shapeBuilder,
    };

    for (final entry in cases.entries) {
      final puzzle = FoundationCatalog.allPuzzles.firstWhere(
        (puzzle) =>
            puzzle.type == entry.key &&
            FoundationCatalog.isMiniGameReadyPuzzle(puzzle),
      );
      final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
      final definition = MiniGameRegistry.definitionForChallenge(challenge);

      expect(definition, isNotNull);
      expect(definition?.type, entry.value);
      expect(definition?.puzzleId, challenge.id);
      expect(definition?.firstRound.correctChoiceId, challenge.correctChoiceId);
      expect(definition?.rounds, hasLength(1));
      expect(definition?.assetKeys, isNotEmpty);
      expect(definition?.toJson(), containsPair('type', entry.value.name));
    }
  });

  test('mini-game controller returns normalized answer and exit results', () {
    final puzzle = FoundationCatalog.allPuzzles.firstWhere(
      FoundationCatalog.isMiniGameReadyPuzzle,
    );
    final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
    final definition = MiniGameRegistry.definitionForChallenge(challenge)!;
    final controller = MiniGameController(definition: definition);

    controller.recordHint();
    final correct = controller.answer(challenge.correctChoiceId);
    final wrong = MiniGameController(definition: definition).answer(
      challenge.choices
          .firstWhere((choice) => choice.id != challenge.correctChoiceId)
          .id,
    );
    final exited = MiniGameController(definition: definition).exit();

    expect(correct.isCorrect, isTrue);
    expect(correct.usedHints, 1);
    expect(correct.stars, 2);
    expect(correct.rewardSignals, contains('mini_game_clear'));
    expect(wrong.isCorrect, isFalse);
    expect(wrong.wrongAttempts, 1);
    expect(wrong.mistakeSignals, contains(challenge.id));
    expect(wrong.difficultySignal, MiniGameDifficultySignal.easier);
    expect(exited.exited, isTrue);
    expect(exited.completionReason, MiniGameCompletionReason.exited);
  });

  test('mini-game controller preserves retry signals after a later success',
      () {
    final puzzle = FoundationCatalog.allPuzzles.firstWhere(
      FoundationCatalog.isMiniGameReadyPuzzle,
    );
    final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
    final definition = MiniGameRegistry.definitionForChallenge(challenge)!;
    final controller = MiniGameController(definition: definition);
    final wrongChoice = challenge.choices
        .firstWhere((choice) => choice.id != challenge.correctChoiceId)
        .id;

    final firstTry = controller.answer(wrongChoice);
    final corrected = controller.answer(challenge.correctChoiceId);

    expect(firstTry.isCorrect, isFalse);
    expect(firstTry.wrongAttempts, 1);
    expect(corrected.isCorrect, isTrue);
    expect(corrected.wrongAttempts, 1);
    expect(corrected.stars, 1);
    expect(corrected.mistakeSignals, contains(challenge.id));
    expect(corrected.difficultySignal, MiniGameDifficultySignal.easier);
  });
}
