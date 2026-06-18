import 'package:flutter_test/flutter_test.dart';
import 'package:brain_up/src/domain/daily_challenge.dart';
import 'package:brain_up/src/domain/family_profile.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';

void main() {
  group('DailyChallenge', () {
    test('checks answer by selected choice id', () {
      final challenge = dailyChallengesForAge(ChildAge.six).first;

      expect(challenge.isCorrectChoice(challenge.correctChoiceId), isTrue);
      expect(challenge.isCorrectChoice('wrong'), isFalse);
      expect(challenge.correctChoice.id, challenge.correctChoiceId);
    });

    test('selects one stable daily challenge for age and date', () {
      final firstDate = DateTime(2026, 6, 8);
      final sameDateLater = DateTime(2026, 6, 8, 18, 30);

      final firstChallenge = dailyChallengeForDate(
        ChildAge.six,
        firstDate,
        goal: LearningGoal.math,
      );
      final sameDayChallenge = dailyChallengeForDate(
        ChildAge.six,
        sameDateLater,
        goal: LearningGoal.math,
      );

      expect(sameDayChallenge.id, firstChallenge.id);
    });

    test('rotates challenge content across days', () {
      final firstChallenge = dailyChallengeForDate(
        ChildAge.seven,
        DateTime(2026, 6, 8),
      );
      final nextChallenge = dailyChallengeForDate(
        ChildAge.seven,
        DateTime(2026, 6, 9),
      );

      expect(nextChallenge.id, isNot(firstChallenge.id));
    });

    test('filters challenge content by selected learning goal', () {
      for (final age in ChildAge.values) {
        for (final goal in LearningGoal.values) {
          final challenge = dailyChallengeForDate(
            age,
            DateTime(2026, 6, 8),
            goal: goal,
          );

          expect(challenge.goal, goal);
        }
      }
    });

    test('exposes the full age bank when goal is not specified', () {
      final allChallenges = dailyChallengesForAge(ChildAge.seven);

      expect(allChallenges.map((challenge) => challenge.goal).toSet(), {
        LearningGoal.logic,
        LearningGoal.math,
        LearningGoal.attention,
      });
    });

    test('contains expanded catalog challenge ids', () {
      expect(
        dailyChallengeById('shadow-match', age: ChildAge.five).id,
        'shadow-match',
      );
      expect(
        dailyChallengeById('balance-scale', age: ChildAge.five).id,
        'balance-scale',
      );
      expect(
        dailyChallengeById('shape-rotation', age: ChildAge.five).id,
        'shape-rotation',
      );
    });

    test('turns generated puzzle definitions into concrete challenges', () {
      final puzzle = FoundationCatalog.puzzlesFor(
        skillTag: SkillTag.reasoning,
        difficulty: PuzzleDifficulty.boss,
      ).first;
      final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);

      expect(challenge.id, puzzle.payloadRef);
      expect(
        challenge.choices.map((choice) => choice.id),
        contains(challenge.correctChoiceId),
      );
      expect(challenge.question, isNot(contains('Which option fits')));
      expect(challenge.choices.map((choice) => choice.label).toSet().length, 3);
    });

    test('carries character coach context from puzzle metadata', () {
      final puzzle = FoundationCatalog.allPuzzles.firstWhere(
        (puzzle) => puzzle.visualMetadata?.characterId == 'lumi',
      );
      final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);

      expect(challenge.skillTag, puzzle.skillTag);
      expect(challenge.puzzleType, puzzle.type);
      expect(challenge.difficulty, puzzle.difficulty);
      expect(challenge.worldId, puzzle.visualMetadata?.worldId);
      expect(challenge.characterId, 'lumi');
      expect(challenge.feedbackStyle, puzzle.visualMetadata?.feedbackStyle);
      expect(challenge.miniGameConfig, puzzle.visualMetadata?.miniGameConfig);
    });

    test('generated variants produce different questions in one family', () {
      final variants = FoundationCatalog.puzzlesFor(
        skillTag: SkillTag.pattern,
      )
          .where((puzzle) => puzzle.payloadRef.startsWith('pattern.trail.'))
          .take(3)
          .map((puzzle) => dailyChallengeForPuzzle(puzzle, ChildAge.six))
          .toList();

      expect(variants.map((challenge) => challenge.question).toSet().length, 3);
    });

    test('new generated puzzle families expose concrete challenge copy', () {
      final puzzle = FoundationCatalog.allPuzzles.firstWhere(
        (puzzle) => puzzle.payloadRef.startsWith('rebus.picture.'),
      );
      final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);

      expect(challenge.prompt, 'Combine two picture clues into one word.');
      expect(challenge.question, isNot(contains('Choose the best answer')));
      expect(
          challenge.choices.map((choice) => choice.id), contains('sunflower'));
    });

    test('all puzzle definitions produce QA-ready playable challenges', () {
      for (final puzzle in FoundationCatalog.allPuzzles) {
        final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);

        expect(challenge.prompt.trim(), isNotEmpty, reason: puzzle.id);
        expect(challenge.question.trim(), isNotEmpty, reason: puzzle.id);
        expect(challenge.hint.trim(), isNotEmpty, reason: puzzle.id);
        expect(challenge.explanation.trim(), isNotEmpty, reason: puzzle.id);
        expect(challenge.prompt.length, lessThanOrEqualTo(140),
            reason: puzzle.id);
        expect(challenge.question.length, lessThanOrEqualTo(180),
            reason: puzzle.id);
        expect(
          challenge.choices
              .where((choice) => choice.id == challenge.correctChoiceId)
              .length,
          1,
          reason: puzzle.id,
        );
      }
    });

    test('curated pair puzzles expose match pair interaction specs', () {
      final puzzle = CuratedRichPuzzlePack.puzzles.firstWhere(
        (puzzle) =>
            puzzle.visualMetadata?.interactionType ==
            PuzzleInteractionType.matchPairs,
      );
      final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
      final interaction = challenge.interaction;

      expect(interaction, isNotNull);
      expect(interaction!.type, PuzzleInteractionType.matchPairs);
      expect(interaction.items.length, greaterThan(challenge.choices.length));
      expect(interaction.correctMatches, isNotEmpty);
      expect(interaction.isCorrectMatches(interaction.correctMatches), isTrue);

      final wrongMatches = Map<String, String>.from(interaction.correctMatches);
      wrongMatches[wrongMatches.keys.first] = 'wrong';

      expect(interaction.isCorrectMatches(wrongMatches), isFalse);
    });

    test('curated drag puzzles expose drop targets and answer mapping', () {
      final puzzle = CuratedRichPuzzlePack.puzzles.firstWhere(
        (puzzle) =>
            puzzle.visualMetadata?.interactionType ==
            PuzzleInteractionType.dragToTarget,
      );
      final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
      final interaction = challenge.interaction;

      expect(interaction, isNotNull);
      expect(interaction!.type, PuzzleInteractionType.dragToTarget);
      expect(interaction.targets.map((target) => target.id), [
        'target.answer',
      ]);
      expect(
        interaction.correctMatches[challenge.correctChoiceId],
        'target.answer',
      );
    });

    test('curated puzzles cover true gesture interaction types', () {
      final interactionTypes = {
        for (final puzzle in CuratedRichPuzzlePack.puzzles)
          if (puzzle.visualMetadata != null)
            puzzle.visualMetadata!.interactionType,
      };

      expect(
        interactionTypes,
        containsAll({
          PuzzleInteractionType.dragToTarget,
          PuzzleInteractionType.matchPairs,
          PuzzleInteractionType.memoryReveal,
          PuzzleInteractionType.rotateObject,
          PuzzleInteractionType.sortObjects,
        }),
      );
    });

    test('curated memory puzzles expose reveal order checks', () {
      final puzzle = CuratedRichPuzzlePack.puzzles.firstWhere(
        (puzzle) =>
            puzzle.visualMetadata?.interactionType ==
            PuzzleInteractionType.memoryReveal,
      );
      final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
      final interaction = challenge.interaction;

      expect(interaction, isNotNull);
      expect(interaction!.type, PuzzleInteractionType.memoryReveal);
      expect(interaction.correctOrder, isNotEmpty);
      expect(interaction.isCorrectOrder(interaction.correctOrder), isTrue);
      expect(
        interaction.isCorrectOrder(interaction.correctOrder.reversed.toList()),
        isFalse,
      );
      expect(interaction.correctMatches['memory.answer'],
          challenge.correctChoiceId);
    });
  });
}
