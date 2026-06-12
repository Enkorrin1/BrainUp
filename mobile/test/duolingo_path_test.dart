import 'package:flutter_test/flutter_test.dart';
import 'package:brain_up/src/domain/duolingo_path.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';

void main() {
  group('LearningPath', () {
    test('selects the first unlocked unfinished node as current', () {
      final path = _samplePath();

      expect(path.nextNode(<String>{})?.id, 'node.001');
      expect(
        path.stateForNode(
          node: path.nodes[0],
          completedNodeIds: <String>{},
        ),
        PathNodeState.current,
      );
      expect(
        path.stateForNode(
          node: path.nodes[1],
          completedNodeIds: <String>{},
        ),
        PathNodeState.locked,
      );
    });

    test('unlocks the next node after prerequisites are complete', () {
      final path = _samplePath();
      final completed = <String>{'node.001'};

      expect(path.nextNode(completed)?.id, 'node.002');
      expect(
        path.stateForNode(
          node: path.nodes[0],
          completedNodeIds: completed,
        ),
        PathNodeState.completed,
      );
      expect(
        path.stateForNode(
          node: path.nodes[1],
          completedNodeIds: completed,
        ),
        PathNodeState.current,
      );
    });

    test('returns no current node when the path is complete', () {
      final path = _samplePath();

      expect(path.nextNode(<String>{'node.001', 'node.002'}), isNull);
    });
  });

  group('LessonResult', () {
    test('calculates accuracy and mistake state', () {
      const result = LessonResult(
        lessonId: 'lesson.001',
        nodeId: 'node.001',
        correctAnswers: 3,
        totalQuestions: 4,
        usedHints: 1,
        wrongAttempts: 1,
        earnedXp: 20,
        mistakeItems: [],
      );

      expect(result.accuracy, 0.75);
      expect(result.hasMistakes, isTrue);
    });
  });

  group('MistakeReviewItem', () {
    test('resolves a pending review item', () {
      const item = MistakeReviewItem(
        id: 'mistake.001',
        lessonId: 'lesson.001',
        puzzleId: 'puzzle.shape_path',
        skillTag: SkillTag.pattern,
        createdAtIso8601: '2026-06-12T09:00:00.000',
      );

      final resolved = item.resolve('2026-06-12T09:05:00.000');

      expect(item.isResolved, isFalse);
      expect(resolved.isResolved, isTrue);
      expect(resolved.resolvedAtIso8601, '2026-06-12T09:05:00.000');
    });
  });

  group('DailyGoal', () {
    test('caps progress and reports completion', () {
      const goal = DailyGoal(targetLessons: 2, completedLessons: 3);

      expect(goal.isComplete, isTrue);
      expect(goal.progress, 1);
    });
  });

  group('HeartState', () {
    test('clamps lost and restored hearts', () {
      const hearts = HeartState(current: 1, max: 5);

      expect(hearts.lose(count: 3).current, 0);
      expect(hearts.restore(count: 10).current, 5);
    });
  });

  group('StreakState', () {
    test('starts, keeps, increments, and resets streaks', () {
      const empty = StreakState(
        current: 0,
        best: 0,
        lastPracticeDate: null,
      );

      final first = empty.afterPractice(DateTime(2026, 6, 10, 12));
      final sameDay = first.afterPractice(DateTime(2026, 6, 10, 18));
      final nextDay = sameDay.afterPractice(DateTime(2026, 6, 11, 9));
      final gap = nextDay.afterPractice(DateTime(2026, 6, 13, 9));

      expect(first.current, 1);
      expect(sameDay.current, 1);
      expect(nextDay.current, 2);
      expect(nextDay.best, 2);
      expect(gap.current, 1);
      expect(gap.best, 2);
    });
  });
}

LearningPath _samplePath() {
  return const LearningPath(
    id: 'path.prototype',
    titleKey: 'pathPrototypeTitle',
    subtitleKey: 'pathPrototypeSubtitle',
    units: [
      PathUnit(
        id: 'unit.001',
        titleKey: 'unit001Title',
        descriptionKey: 'unit001Description',
        order: 1,
        primarySkillTags: [SkillTag.pattern],
        nodes: [
          PathNode(
            id: 'node.001',
            unitId: 'unit.001',
            order: 1,
            titleKey: 'node001Title',
            lessonId: 'lesson.001',
            type: PathNodeType.lesson,
            requiredCompletedNodeIds: [],
            rewardXp: 20,
            primarySkillTag: SkillTag.pattern,
          ),
          PathNode(
            id: 'node.002',
            unitId: 'unit.001',
            order: 2,
            titleKey: 'node002Title',
            lessonId: 'lesson.002',
            type: PathNodeType.lesson,
            requiredCompletedNodeIds: ['node.001'],
            rewardXp: 24,
            primarySkillTag: SkillTag.classification,
          ),
        ],
      ),
    ],
  );
}
