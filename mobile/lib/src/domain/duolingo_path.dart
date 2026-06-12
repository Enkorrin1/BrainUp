import 'learning_foundation.dart';

enum PathNodeType {
  lesson,
  review,
  reward,
  boss,
  practice,
}

enum PathNodeState {
  completed,
  current,
  locked,
}

class LearningPath {
  const LearningPath({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.units,
  });

  final String id;
  final String titleKey;
  final String subtitleKey;
  final List<PathUnit> units;

  List<PathNode> get nodes {
    final allNodes = [
      for (final unit in units) ...unit.nodes,
    ];
    return [...allNodes]
      ..sort((first, second) => first.order.compareTo(second.order));
  }

  PathNode? nextNode(Set<String> completedNodeIds) {
    for (final node in nodes) {
      if (!completedNodeIds.contains(node.id) &&
          node.isUnlocked(completedNodeIds)) {
        return node;
      }
    }
    return null;
  }

  PathNodeState stateForNode({
    required PathNode node,
    required Set<String> completedNodeIds,
  }) {
    if (completedNodeIds.contains(node.id)) {
      return PathNodeState.completed;
    }

    final currentNode = nextNode(completedNodeIds);
    if (currentNode?.id == node.id) {
      return PathNodeState.current;
    }

    return PathNodeState.locked;
  }

  PathNode? nodeForLesson(String lessonId) {
    for (final node in nodes) {
      if (node.lessonId == lessonId) {
        return node;
      }
    }
    return null;
  }
}

class PathUnit {
  const PathUnit({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.order,
    required this.nodes,
    required this.primarySkillTags,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final int order;
  final List<PathNode> nodes;
  final List<SkillTag> primarySkillTags;
}

class PathNode {
  const PathNode({
    required this.id,
    required this.unitId,
    required this.order,
    required this.titleKey,
    required this.lessonId,
    required this.type,
    required this.requiredCompletedNodeIds,
    required this.rewardXp,
    required this.primarySkillTag,
  });

  final String id;
  final String unitId;
  final int order;
  final String titleKey;
  final String lessonId;
  final PathNodeType type;
  final List<String> requiredCompletedNodeIds;
  final int rewardXp;
  final SkillTag primarySkillTag;

  bool isUnlocked(Set<String> completedNodeIds) {
    return requiredCompletedNodeIds.every(completedNodeIds.contains);
  }
}

class LessonResult {
  const LessonResult({
    required this.lessonId,
    required this.nodeId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.usedHints,
    required this.wrongAttempts,
    required this.earnedXp,
    required this.mistakeItems,
  });

  final String lessonId;
  final String nodeId;
  final int correctAnswers;
  final int totalQuestions;
  final int usedHints;
  final int wrongAttempts;
  final int earnedXp;
  final List<MistakeReviewItem> mistakeItems;

  double get accuracy {
    if (totalQuestions <= 0) {
      return 0;
    }
    return correctAnswers / totalQuestions;
  }

  bool get hasMistakes {
    return wrongAttempts > 0 || mistakeItems.isNotEmpty;
  }
}

class MistakeReviewItem {
  const MistakeReviewItem({
    required this.id,
    required this.lessonId,
    required this.puzzleId,
    required this.skillTag,
    required this.createdAtIso8601,
    this.resolvedAtIso8601,
  });

  final String id;
  final String lessonId;
  final String puzzleId;
  final SkillTag skillTag;
  final String createdAtIso8601;
  final String? resolvedAtIso8601;

  bool get isResolved {
    return resolvedAtIso8601 != null;
  }

  MistakeReviewItem resolve(String resolvedAtIso8601) {
    return MistakeReviewItem(
      id: id,
      lessonId: lessonId,
      puzzleId: puzzleId,
      skillTag: skillTag,
      createdAtIso8601: createdAtIso8601,
      resolvedAtIso8601: resolvedAtIso8601,
    );
  }
}

class DailyGoal {
  const DailyGoal({
    required this.targetLessons,
    required this.completedLessons,
  });

  final int targetLessons;
  final int completedLessons;

  bool get isComplete {
    return completedLessons >= targetLessons;
  }

  double get progress {
    if (targetLessons <= 0) {
      return 1;
    }
    return (completedLessons / targetLessons).clamp(0.0, 1.0).toDouble();
  }
}

class HeartState {
  const HeartState({
    required this.current,
    required this.max,
  });

  final int current;
  final int max;

  bool get hasHearts {
    return current > 0;
  }

  HeartState lose({int count = 1}) {
    return HeartState(
      current: (current - count).clamp(0, max).toInt(),
      max: max,
    );
  }

  HeartState restore({int count = 1}) {
    return HeartState(
      current: (current + count).clamp(0, max).toInt(),
      max: max,
    );
  }
}

class StreakState {
  const StreakState({
    required this.current,
    required this.best,
    required this.lastPracticeDate,
  });

  final int current;
  final int best;
  final DateTime? lastPracticeDate;

  StreakState afterPractice(DateTime practicedAt) {
    final practiceDate = _dateOnly(practicedAt);
    final previousDate = lastPracticeDate == null
        ? null
        : _dateOnly(lastPracticeDate!);

    if (previousDate == practiceDate) {
      return this;
    }

    final yesterday = practiceDate.subtract(const Duration(days: 1));
    final nextCurrent = previousDate == yesterday ? current + 1 : 1;

    return StreakState(
      current: nextCurrent,
      best: nextCurrent > best ? nextCurrent : best,
      lastPracticeDate: practiceDate,
    );
  }
}

class PrototypeLearningPathCatalog {
  const PrototypeLearningPathCatalog._();

  static const LearningPath mainPath = LearningPath(
    id: 'path.prototype.main',
    titleKey: 'mapLessonTitle',
    subtitleKey: 'mapLessonSubtitle',
    units: [
      PathUnit(
        id: 'unit.patterns',
        titleKey: 'mapNodePath',
        descriptionKey: 'mapLessonSubtitle',
        order: 1,
        primarySkillTags: [
          SkillTag.pattern,
          SkillTag.classification,
          SkillTag.arithmetic,
        ],
        nodes: [
          PathNode(
            id: 'path.node.001',
            unitId: 'unit.patterns',
            order: 1,
            titleKey: 'mapNodeStart',
            lessonId: 'lesson.001',
            type: PathNodeType.lesson,
            requiredCompletedNodeIds: [],
            rewardXp: 24,
            primarySkillTag: SkillTag.pattern,
          ),
          PathNode(
            id: 'path.node.002',
            unitId: 'unit.patterns',
            order: 2,
            titleKey: 'mapNodeShapes',
            lessonId: 'lesson.002',
            type: PathNodeType.lesson,
            requiredCompletedNodeIds: ['path.node.001'],
            rewardXp: 28,
            primarySkillTag: SkillTag.arithmetic,
          ),
          PathNode(
            id: 'path.node.003',
            unitId: 'unit.patterns',
            order: 3,
            titleKey: 'mapNodePairs',
            lessonId: 'lesson.003',
            type: PathNodeType.lesson,
            requiredCompletedNodeIds: ['path.node.002'],
            rewardXp: 32,
            primarySkillTag: SkillTag.classification,
          ),
          PathNode(
            id: 'path.node.004',
            unitId: 'unit.patterns',
            order: 4,
            titleKey: 'mapNodeCounting',
            lessonId: 'lesson.004',
            type: PathNodeType.review,
            requiredCompletedNodeIds: ['path.node.003'],
            rewardXp: 36,
            primarySkillTag: SkillTag.arithmetic,
          ),
          PathNode(
            id: 'path.node.005',
            unitId: 'unit.patterns',
            order: 5,
            titleKey: 'mapNodeRhythm',
            lessonId: 'lesson.005',
            type: PathNodeType.lesson,
            requiredCompletedNodeIds: ['path.node.004'],
            rewardXp: 40,
            primarySkillTag: SkillTag.pattern,
          ),
          PathNode(
            id: 'path.node.006',
            unitId: 'unit.patterns',
            order: 6,
            titleKey: 'mapNodeFinal',
            lessonId: 'lesson.006',
            type: PathNodeType.boss,
            requiredCompletedNodeIds: ['path.node.005'],
            rewardXp: 44,
            primarySkillTag: SkillTag.reasoning,
          ),
        ],
      ),
    ],
  );

  static Set<String> completedNodeIdsFromLessons(
    Iterable<String> completedLessonIds,
  ) {
    final completedLessons = completedLessonIds.toSet();
    return {
      for (final node in mainPath.nodes)
        if (completedLessons.contains(node.lessonId)) node.id,
    };
  }
}

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}
