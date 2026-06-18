import 'package:brain_up/src/domain/daily_challenge.dart';
import 'package:brain_up/src/domain/family_profile.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';
import 'package:brain_up/src/mini_games/core/mini_game_controller.dart';
import 'package:brain_up/src/mini_games/core/mini_game_canvas_interaction.dart';
import 'package:brain_up/src/mini_games/core/mini_game_definition.dart';
import 'package:brain_up/src/mini_games/core/mini_game_quality.dart';
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
      expect(definition?.contentConfig?.isValid, isTrue);
      expect(definition?.feedbackProfile.effectCues, isNotEmpty);
      expect(definition?.characterReactionProfile.stateLines, isNotEmpty);
      expect(definition?.adaptiveProfile.reviewPriority, greaterThan(0));
      expect(definition?.audioProfile.cueIds, isNotEmpty);
      expect(definition?.toJson(), containsPair('type', entry.value.name));
    }
  });

  test('registry creates a boss mix definition with three playable steps', () {
    final puzzle = FoundationCatalog.allPuzzles.firstWhere(
      (puzzle) =>
          puzzle.type == PuzzleType.mixedBoss &&
          FoundationCatalog.isMiniGameReadyPuzzle(puzzle),
    );
    final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
    final definition = MiniGameRegistry.definitionForChallenge(challenge);

    expect(definition, isNotNull);
    expect(definition?.type, MiniGameType.bossMix);
    expect(definition?.isBoss, isTrue);
    expect(definition?.rounds, hasLength(3));
    expect(definition?.timePressure, isTrue);
    expect(definition?.audioProfile.rewardCueId, 'mini.boss_reward');
    expect(
      definition?.parentSummaryLabel,
      contains('multi-step planning'),
    );
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

  test('adaptive review definitions prioritize recent mistake signals', () {
    final readyPuzzles = FoundationCatalog.allPuzzles
        .where(FoundationCatalog.isMiniGameReadyPuzzle)
        .take(12)
        .toList(growable: false);
    final mistakePuzzle = readyPuzzles.last;
    final reviews = MiniGameRegistry.adaptiveReviewDefinitions(
      puzzles: readyPuzzles,
      age: ChildAge.seven,
      mistakeSignals: [mistakePuzzle.payloadRef],
      limit: 3,
    );

    expect(reviews, hasLength(3));
    expect(reviews.first.puzzleId, mistakePuzzle.payloadRef);
    expect(reviews.first.adaptiveProfile.reviewPriority, greaterThan(0));
  });

  test('canvas hotspot mapper cycles tap targets into challenge choices', () {
    final puzzle = FoundationCatalog.allPuzzles.firstWhere(
      FoundationCatalog.isMiniGameReadyPuzzle,
    );
    final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
    final definition = MiniGameRegistry.definitionForChallenge(challenge)!;
    final choices = definition.firstRound.choiceIds;

    expect(
      MiniGameCanvasInteraction.choiceIdForHotspot(
        definition: definition,
        hotspotIndex: 0,
      ),
      choices.first,
    );
    expect(
      MiniGameCanvasInteraction.choiceIdForHotspot(
        definition: definition,
        hotspotIndex: choices.length,
      ),
      choices.first,
    );
    expect(
      MiniGameCanvasInteraction.choiceIdForHotspot(
        definition: definition,
        hotspotIndex: -1,
      ),
      isNull,
    );
  });

  test('quality audit passes for mini-game-ready content definitions', () {
    final definitions = FoundationCatalog.allPuzzles
        .where(FoundationCatalog.isMiniGameReadyPuzzle)
        .take(40)
        .map((puzzle) {
          final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
          return MiniGameRegistry.definitionForChallenge(challenge);
        })
        .whereType<MiniGameDefinition>()
        .toList(growable: false);
    final report = MiniGameQualityAudit.auditDefinitions(definitions);

    expect(definitions, isNotEmpty);
    expect(report.passes, isTrue);
    expect(report.blockers, isEmpty);
    expect(
        report.toJson(), containsPair('definitionCount', definitions.length));
  });
}
