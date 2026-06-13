import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:brain_up/src/domain/family_profile.dart';
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

    test('content coverage report locks age, skill, and type balance', () {
      final report = FoundationCatalog.contentCoverageReport();

      expect(report.totalPuzzleCount, FoundationCatalog.allPuzzles.length);
      for (final ageBandId in AgeBandId.values) {
        expect(
          report.countByAgeBand[ageBandId],
          greaterThanOrEqualTo(40),
          reason: ageBandId.name,
        );
      }
      for (final skillTag in SkillTag.values) {
        expect(
          report.countBySkill[skillTag],
          greaterThanOrEqualTo(12),
          reason: skillTag.name,
        );
      }
      for (final difficulty in PuzzleDifficulty.values) {
        expect(
          report.countByDifficulty[difficulty],
          greaterThan(0),
          reason: difficulty.name,
        );
      }

      expect(
        report.countByType.values.where((count) => count > 0).length,
        greaterThanOrEqualTo(10),
      );
      expect(report.skillGaps(minimumPerAgeBand: 4), isEmpty);
    });

    test('content manifest exports JSON-ready coverage and puzzle metadata',
        () {
      final manifest = FoundationCatalog.contentManifest();
      final json = jsonDecode(jsonEncode(manifest)) as Map<String, Object?>;
      final qualityGate = json['qualityGate'] as Map<String, Object?>;
      final coverage = json['coverage'] as Map<String, Object?>;
      final puzzles = json['puzzles'] as List<Object?>;
      final focusTracker = puzzles.cast<Map<String, Object?>>().firstWhere(
            (puzzle) => puzzle['payloadRef'] == 'focus.tracker.easy.001',
          );

      expect(json['schemaVersion'], 1);
      expect(qualityGate['passes'], isTrue);
      expect(coverage['totalPuzzleCount'], FoundationCatalog.allPuzzles.length);
      expect(puzzles.length, FoundationCatalog.allPuzzles.length);
      expect(focusTracker['skillTag'], SkillTag.attention.name);
      expect(focusTracker['difficulty'], PuzzleDifficulty.easy.name);
      expect(focusTracker['ageBandIds'], contains(AgeBandId.age4to5.name));
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
    test('lesson generator uses review signals from recent practice', () {
      final lesson = FoundationCatalog.lessonForId('lesson.010');
      final reviewProfile = PracticeReviewProfile.fromSessions([
        PracticeSession(
          completedAt: DateTime(2026, 6, 12, 18),
          challengeId: 'lesson.009',
          challengeTitle: 'Hard memory lesson',
          skill: 'Working memory',
          minutes: 5,
          correctAnswers: 2,
          totalQuestions: 5,
          wrongAttempts: 2,
          mistakePuzzleIds: ['memory.order.normal.003'],
        ),
      ]);
      final puzzles = FoundationCatalog.puzzlesForLesson(
        lesson: lesson,
        ageBandId: AgeBandId.age6,
        reviewProfile: reviewProfile,
      );

      expect(puzzles.length, 5);
      expect(
        puzzles.map((puzzle) => puzzle.payloadRef),
        contains('memory.order.normal.003'),
      );
      expect(
        puzzles.any((puzzle) => puzzle.skillTag == SkillTag.memory),
        isTrue,
      );
    });

    test('successful adaptive review clears older mistake signals', () {
      final reviewProfile = PracticeReviewProfile.fromSessions([
        PracticeSession(
          completedAt: DateTime(2026, 6, 12, 18),
          challengeId: 'lesson.009',
          challengeTitle: 'Hard memory lesson',
          skill: 'Working memory',
          minutes: 5,
          correctAnswers: 2,
          totalQuestions: 5,
          wrongAttempts: 2,
          mistakePuzzleIds: ['memory.order.normal.003'],
        ),
        PracticeSession(
          completedAt: DateTime(2026, 6, 13, 18),
          challengeId: FoundationCatalog.adaptiveReviewLesson.id,
          challengeTitle: 'Review complete',
          skill: 'Working memory',
          minutes: 3,
          correctAnswers: 5,
          totalQuestions: 5,
          reviewedPuzzleIds: ['memory.order.normal.003'],
        ),
      ]);

      expect(reviewProfile.mistakePuzzleIds, isEmpty);
      expect(reviewProfile.weakSkillTags, isNot(contains(SkillTag.memory)));
      expect(reviewProfile.hasSignals, isFalse);
    });
  });
}
