import 'package:flutter_test/flutter_test.dart';
import 'package:brain_up/src/domain/daily_challenge.dart';
import 'package:brain_up/src/domain/family_profile.dart';

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
  });
}
