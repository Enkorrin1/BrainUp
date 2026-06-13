import 'package:flutter_test/flutter_test.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';

void main() {
  group('FoundationCatalog', () {
    test('starter courses expose at least four lessons', () {
      for (final course in FoundationCatalog.starterCourses) {
        expect(course.lessonIds.length, greaterThanOrEqualTo(4));
      }
    });

    test('expanded lessons contain four ordered steps', () {
      for (final lessonId in [
        'lesson.009',
        'lesson.010',
        'lesson.011',
        'lesson.012'
      ]) {
        final lesson = FoundationCatalog.lessonForId(lessonId);
        final steps = FoundationCatalog.stepsForLesson(lesson);

        expect(steps.length, 4);
        expect(steps.map((step) => step.order), [1, 2, 3, 4]);
      }
    });

    test('content bank exposes a large multi-skill puzzle pool', () {
      expect(FoundationCatalog.allPuzzles.length, greaterThanOrEqualTo(140));

      final counts = FoundationCatalog.puzzleCountBySkill();
      for (final skill in SkillTag.values) {
        expect(counts[skill], greaterThanOrEqualTo(3), reason: skill.name);
      }

      for (final familyPrefix in [
        'category.groups.',
        'route.path.',
        'analogy.link.',
        'rebus.picture.',
        'compare.weight.',
        'memory.order.',
      ]) {
        expect(
          FoundationCatalog.allPuzzles.any(
            (puzzle) => puzzle.payloadRef.startsWith(familyPrefix),
          ),
          isTrue,
          reason: familyPrefix,
        );
      }
    });

    test('content bank supports age, skill, and difficulty filtering', () {
      final ageSixMath = FoundationCatalog.puzzlesFor(
        ageBandId: AgeBandId.age6,
        skillTag: SkillTag.arithmetic,
      );
      final hardFocus = FoundationCatalog.puzzlesFor(
        skillTag: SkillTag.attention,
        difficulty: PuzzleDifficulty.hard,
      );
      final bossPuzzles = FoundationCatalog.puzzlesFor(
        difficulty: PuzzleDifficulty.boss,
      );

      expect(ageSixMath, isNotEmpty);
      expect(hardFocus, isNotEmpty);
      expect(bossPuzzles.length, greaterThanOrEqualTo(8));
      expect(
        bossPuzzles.every(
          (puzzle) => puzzle.ageBandIds.contains(AgeBandId.age7to8),
        ),
        isTrue,
      );
    });

    test('lesson generator mixes fixed and generated content bank puzzles', () {
      final lesson = FoundationCatalog.lessonForId('lesson.012');
      final puzzles = FoundationCatalog.puzzlesForLesson(
        lesson: lesson,
        ageBandId: AgeBandId.age7to8,
      );

      expect(puzzles.length, 5);
      expect(
        puzzles.any((puzzle) => puzzle.lessonId == 'lesson.generated'),
        isTrue,
      );
      expect(
        puzzles.map((puzzle) => puzzle.skillTag).toSet().length,
        greaterThanOrEqualTo(2),
      );
    });

    test('lesson generator balances skills and puzzle types', () {
      final lesson = FoundationCatalog.lessonForId('lesson.021');
      final puzzles = FoundationCatalog.puzzlesForLesson(
        lesson: lesson,
        ageBandId: AgeBandId.age7to8,
      );
      final skillCounts = {
        for (final skill in SkillTag.values)
          skill: puzzles.where((puzzle) => puzzle.skillTag == skill).length,
      };

      expect(puzzles.length, 5);
      expect(
        skillCounts.values.where((count) => count > 2),
        isEmpty,
      );
      expect(
        puzzles.map((puzzle) => puzzle.type).toSet().length,
        greaterThanOrEqualTo(4),
      );
    });
  });
}
