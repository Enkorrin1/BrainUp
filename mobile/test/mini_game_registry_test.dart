import 'package:brain_up/src/domain/daily_challenge.dart';
import 'package:brain_up/src/domain/family_profile.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';
import 'package:brain_up/src/mini_games/core/mini_game_controller.dart';
import 'package:brain_up/src/mini_games/core/mini_game_definition.dart';
import 'package:brain_up/src/mini_games/core/mini_game_registry.dart';
import 'package:brain_up/src/mini_games/core/mini_game_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registry creates a playable memory mini-game definition', () {
    final puzzle = FoundationCatalog.allPuzzles.firstWhere(
      FoundationCatalog.isMiniGameReadyPuzzle,
    );
    final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
    final definition = MiniGameRegistry.definitionForChallenge(challenge);

    expect(definition, isNotNull);
    expect(definition?.type, MiniGameType.memoryGrid);
    expect(definition?.puzzleId, challenge.id);
    expect(definition?.firstRound.correctChoiceId, challenge.correctChoiceId);
    expect(definition?.rounds, hasLength(1));
    expect(definition?.assetKeys, isNotEmpty);
    expect(definition?.toJson(), containsPair('type', 'memoryGrid'));
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
}
