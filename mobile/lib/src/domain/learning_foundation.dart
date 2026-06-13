import 'family_profile.dart';

enum AgeBandId {
  age4to5,
  age6,
  age7to8,
}

enum PuzzleType {
  oddOneOut,
  sequenceComplete,
  pairMatch,
  categorySort,
  pathPuzzle,
  countBridge,
  visualCompare,
  analogy,
  memoryGrid,
  codeBreaker,
  spatialRotation,
  attentionScan,
  rebus,
  mixedBoss,
}

enum PuzzleDifficulty {
  easy,
  normal,
  hard,
  boss,
}

enum SkillTag {
  attention,
  memory,
  pattern,
  classification,
  arithmetic,
  spatial,
  reasoning,
}

enum PuzzleInteractionType {
  tapChoice,
  dragToTarget,
  reorderCards,
  matchPairs,
  memoryReveal,
  tracePath,
  rotateObject,
  sortObjects,
  multiStepBoss,
}

enum PuzzleAnimationType {
  none,
  cardBounce,
  hintPulse,
  objectSnap,
  pathTrace,
  revealFlip,
  rotateTurn,
  rewardBurst,
}

enum PuzzleFeedbackStyle {
  standard,
  characterCoach,
  softRetry,
  celebratory,
  bossMilestone,
}

enum ContentPlacement {
  mainRoute,
  dailyChallenge,
  adaptiveReview,
  bossNode,
  mistakeRepeat,
  parentAnalytics,
  rewardCollection,
  ageTrack,
  weakSkillRecommendation,
}

enum ContentQaSeverity {
  blocker,
  warning,
}

enum ContentQaIssueType {
  duplicatePuzzleId,
  duplicatePayloadRef,
  missingCorrectAnswer,
  missingHint,
  missingVisualMetadata,
  invalidVisualWorld,
  invalidVisualCharacter,
  missingChoiceAssets,
  invalidEstimatedSeconds,
  bossAgeMismatch,
  excessiveFamilyRepetition,
}

enum PuzzleCognitiveLoad {
  light,
  medium,
  high,
  boss,
}

enum RewardType {
  sticker,
  badge,
  booster,
  avatarItem,
}

enum MapNodeState {
  completed,
  current,
  locked,
}

enum CourseTrack {
  logic,
  math,
  spatial,
  attention,
  rebus,
  mixed,
}

class CourseDefinition {
  const CourseDefinition({
    required this.id,
    required this.track,
    required this.lessonIds,
    required this.recommendedAgeBandId,
  });

  final String id;
  final CourseTrack track;
  final List<String> lessonIds;
  final AgeBandId recommendedAgeBandId;
}

class AgeBand {
  const AgeBand({
    required this.id,
    required this.minAgeInclusive,
    required this.maxAgeInclusive,
    required this.titleKey,
  });

  final AgeBandId id;
  final int minAgeInclusive;
  final int maxAgeInclusive;
  final String titleKey;

  bool contains(int age) {
    return age >= minAgeInclusive && age <= maxAgeInclusive;
  }
}

class LevelMap {
  const LevelMap({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.nodes,
  });

  final String id;
  final String titleKey;
  final String subtitleKey;
  final List<MapNode> nodes;
}

class MapNode {
  const MapNode({
    required this.id,
    required this.order,
    required this.titleKey,
    required this.subtitleKey,
    required this.lessonId,
    required this.requiredStarsToUnlock,
    required this.ageBandId,
  });

  final String id;
  final int order;
  final String titleKey;
  final String subtitleKey;
  final String lessonId;
  final int requiredStarsToUnlock;
  final AgeBandId ageBandId;

  MapNodeState stateForStars(int stars) {
    if (stars > requiredStarsToUnlock) {
      return MapNodeState.completed;
    }
    if (stars >= requiredStarsToUnlock) {
      return MapNodeState.current;
    }
    return MapNodeState.locked;
  }

  MapNodeState stateForCompletedNodes(List<String> completedNodeIds) {
    if (completedNodeIds.contains(id)) {
      return MapNodeState.completed;
    }
    if (completedNodeIds.length + 1 == order) {
      return MapNodeState.current;
    }
    return MapNodeState.locked;
  }
}

class Lesson {
  const Lesson({
    required this.id,
    required this.titleKey,
    required this.stepIds,
    required this.xpReward,
    required this.maxHearts,
  });

  final String id;
  final String titleKey;
  final List<String> stepIds;
  final int xpReward;
  final int maxHearts;
}

class ContentPlacementRule {
  const ContentPlacementRule({
    required this.placement,
    required this.minPuzzleCount,
    required this.maxPuzzleCount,
    required this.defaultPuzzleCount,
    required this.description,
    this.preferredDifficulties = const [],
    this.preferredTypes = const [],
  });

  final ContentPlacement placement;
  final int minPuzzleCount;
  final int maxPuzzleCount;
  final int defaultPuzzleCount;
  final String description;
  final List<PuzzleDifficulty> preferredDifficulties;
  final List<PuzzleType> preferredTypes;

  Map<String, Object?> toJson() {
    return {
      'placement': placement.name,
      'minPuzzleCount': minPuzzleCount,
      'maxPuzzleCount': maxPuzzleCount,
      'defaultPuzzleCount': defaultPuzzleCount,
      'description': description,
      'preferredDifficulties': [
        for (final difficulty in preferredDifficulties) difficulty.name,
      ],
      'preferredTypes': [
        for (final type in preferredTypes) type.name,
      ],
    };
  }
}

class LessonStep {
  const LessonStep({
    required this.id,
    required this.lessonId,
    required this.order,
    required this.puzzleId,
    required this.internalSkillTag,
  });

  final String id;
  final String lessonId;
  final int order;
  final String puzzleId;
  final SkillTag internalSkillTag;
}

class VisualPuzzleMetadata {
  const VisualPuzzleMetadata({
    required this.familyId,
    required this.worldId,
    required this.characterId,
    required this.sceneAsset,
    required this.choiceAssets,
    required this.interactionType,
    required this.animationType,
    required this.feedbackStyle,
    required this.estimatedSeconds,
    required this.cognitiveLoad,
    this.bossMixTags = const [],
  });

  final String familyId;
  final String worldId;
  final String characterId;
  final String sceneAsset;
  final List<String> choiceAssets;
  final PuzzleInteractionType interactionType;
  final PuzzleAnimationType animationType;
  final PuzzleFeedbackStyle feedbackStyle;
  final int estimatedSeconds;
  final PuzzleCognitiveLoad cognitiveLoad;
  final List<String> bossMixTags;

  Map<String, Object?> toJson() {
    return {
      'familyId': familyId,
      'worldId': worldId,
      'characterId': characterId,
      'sceneAsset': sceneAsset,
      'choiceAssets': choiceAssets,
      'interactionType': interactionType.name,
      'animationType': animationType.name,
      'feedbackStyle': feedbackStyle.name,
      'estimatedSeconds': estimatedSeconds,
      'cognitiveLoad': cognitiveLoad.name,
      'bossMixTags': bossMixTags,
    };
  }
}

class PuzzleDefinition {
  const PuzzleDefinition({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.skillTag,
    required this.payloadRef,
    required this.correctAnswerKey,
    required this.hintKeys,
    this.ageBandIds = const [
      AgeBandId.age4to5,
      AgeBandId.age6,
      AgeBandId.age7to8,
    ],
    this.difficulty = PuzzleDifficulty.easy,
    this.visualMetadata,
  });

  final String id;
  final String lessonId;
  final PuzzleType type;
  final SkillTag skillTag;
  final String payloadRef;
  final String correctAnswerKey;
  final List<String> hintKeys;
  final List<AgeBandId> ageBandIds;
  final PuzzleDifficulty difficulty;
  final VisualPuzzleMetadata? visualMetadata;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'type': type.name,
      'skillTag': skillTag.name,
      'payloadRef': payloadRef,
      'correctAnswerKey': correctAnswerKey,
      'hintKeys': hintKeys,
      'ageBandIds': [
        for (final ageBandId in ageBandIds) ageBandId.name,
      ],
      'difficulty': difficulty.name,
      if (visualMetadata != null) 'visualMetadata': visualMetadata!.toJson(),
    };
  }
}

class ContentCoverageGap {
  const ContentCoverageGap({
    required this.ageBandId,
    required this.skillTag,
    required this.count,
    required this.minimum,
  });

  final AgeBandId ageBandId;
  final SkillTag skillTag;
  final int count;
  final int minimum;

  String get key {
    return '${ageBandId.name}.${skillTag.name}';
  }

  Map<String, Object?> toJson() {
    return {
      'key': key,
      'ageBandId': ageBandId.name,
      'skillTag': skillTag.name,
      'count': count,
      'minimum': minimum,
    };
  }
}

class ContentCoverageReport {
  const ContentCoverageReport({
    required this.totalPuzzleCount,
    required this.countByAgeBand,
    required this.countBySkill,
    required this.countByDifficulty,
    required this.countByType,
    required this.countByAgeBandAndSkill,
  });

  final int totalPuzzleCount;
  final Map<AgeBandId, int> countByAgeBand;
  final Map<SkillTag, int> countBySkill;
  final Map<PuzzleDifficulty, int> countByDifficulty;
  final Map<PuzzleType, int> countByType;
  final Map<AgeBandId, Map<SkillTag, int>> countByAgeBandAndSkill;

  int countFor({
    required AgeBandId ageBandId,
    required SkillTag skillTag,
  }) {
    return countByAgeBandAndSkill[ageBandId]?[skillTag] ?? 0;
  }

  List<ContentCoverageGap> skillGaps({
    required int minimumPerAgeBand,
  }) {
    return [
      for (final ageBandId in AgeBandId.values)
        for (final skillTag in SkillTag.values)
          if (countFor(ageBandId: ageBandId, skillTag: skillTag) <
              minimumPerAgeBand)
            ContentCoverageGap(
              ageBandId: ageBandId,
              skillTag: skillTag,
              count: countFor(ageBandId: ageBandId, skillTag: skillTag),
              minimum: minimumPerAgeBand,
            ),
    ];
  }

  Map<String, Object?> toJson({
    int minimumPerAgeBandSkill = 4,
  }) {
    final gaps = skillGaps(minimumPerAgeBand: minimumPerAgeBandSkill);

    return {
      'totalPuzzleCount': totalPuzzleCount,
      'countByAgeBand': {
        for (final entry in countByAgeBand.entries) entry.key.name: entry.value,
      },
      'countBySkill': {
        for (final entry in countBySkill.entries) entry.key.name: entry.value,
      },
      'countByDifficulty': {
        for (final entry in countByDifficulty.entries)
          entry.key.name: entry.value,
      },
      'countByType': {
        for (final entry in countByType.entries) entry.key.name: entry.value,
      },
      'countByAgeBandAndSkill': {
        for (final ageEntry in countByAgeBandAndSkill.entries)
          ageEntry.key.name: {
            for (final skillEntry in ageEntry.value.entries)
              skillEntry.key.name: skillEntry.value,
          },
      },
      'minimumPerAgeBandSkill': minimumPerAgeBandSkill,
      'skillGaps': [
        for (final gap in gaps) gap.toJson(),
      ],
    };
  }
}

class ContentFamilySummary {
  const ContentFamilySummary({
    required this.familyId,
    required this.count,
    required this.examplePayloadRefs,
  });

  final String familyId;
  final int count;
  final List<String> examplePayloadRefs;

  Map<String, Object?> toJson() {
    return {
      'familyId': familyId,
      'count': count,
      'examplePayloadRefs': examplePayloadRefs,
    };
  }
}

class ContentQaIssue {
  const ContentQaIssue({
    required this.type,
    required this.severity,
    required this.message,
    this.puzzleId,
    this.familyId,
  });

  final ContentQaIssueType type;
  final ContentQaSeverity severity;
  final String message;
  final String? puzzleId;
  final String? familyId;

  Map<String, Object?> toJson() {
    return {
      'type': type.name,
      'severity': severity.name,
      'message': message,
      if (puzzleId != null) 'puzzleId': puzzleId,
      if (familyId != null) 'familyId': familyId,
    };
  }
}

class ContentQaReport {
  const ContentQaReport({
    required this.issues,
  });

  final List<ContentQaIssue> issues;

  List<ContentQaIssue> get blockers {
    return [
      for (final issue in issues)
        if (issue.severity == ContentQaSeverity.blocker) issue,
    ];
  }

  List<ContentQaIssue> get warnings {
    return [
      for (final issue in issues)
        if (issue.severity == ContentQaSeverity.warning) issue,
    ];
  }

  bool get passes {
    return blockers.isEmpty;
  }

  Map<String, Object?> toJson() {
    return {
      'passes': passes,
      'blockerCount': blockers.length,
      'warningCount': warnings.length,
      'issues': [
        for (final issue in issues) issue.toJson(),
      ],
    };
  }
}

class ContentDashboardReport {
  const ContentDashboardReport({
    required this.totalPuzzleCount,
    required this.visualPuzzleCount,
    required this.visualCoveragePercent,
    required this.qualityGatePasses,
    required this.coverage,
    required this.placementRules,
    required this.puzzleIdsWithoutAssets,
    required this.puzzleIdsWithoutHints,
    required this.skillGaps,
    required this.lowTypeCoverage,
    required this.repeatedFamilies,
    required this.qaReport,
  });

  final int totalPuzzleCount;
  final int visualPuzzleCount;
  final int visualCoveragePercent;
  final bool qualityGatePasses;
  final ContentCoverageReport coverage;
  final List<ContentPlacementRule> placementRules;
  final List<String> puzzleIdsWithoutAssets;
  final List<String> puzzleIdsWithoutHints;
  final List<ContentCoverageGap> skillGaps;
  final Map<PuzzleType, int> lowTypeCoverage;
  final List<ContentFamilySummary> repeatedFamilies;
  final ContentQaReport qaReport;

  bool get hasBlockingIssues {
    return !qualityGatePasses ||
        skillGaps.isNotEmpty ||
        lowTypeCoverage.isNotEmpty ||
        puzzleIdsWithoutHints.isNotEmpty ||
        !qaReport.passes;
  }

  Map<String, Object?> toJson() {
    return {
      'totalPuzzleCount': totalPuzzleCount,
      'visualPuzzleCount': visualPuzzleCount,
      'visualCoveragePercent': visualCoveragePercent,
      'qualityGatePasses': qualityGatePasses,
      'hasBlockingIssues': hasBlockingIssues,
      'coverage': coverage.toJson(),
      'placementRules': [
        for (final rule in placementRules) rule.toJson(),
      ],
      'issues': {
        'skillGaps': [
          for (final gap in skillGaps) gap.toJson(),
        ],
        'lowTypeCoverage': {
          for (final entry in lowTypeCoverage.entries)
            entry.key.name: entry.value,
        },
        'puzzleIdsWithoutAssets': puzzleIdsWithoutAssets,
        'puzzleIdsWithoutHints': puzzleIdsWithoutHints,
      },
      'repeatedFamilies': [
        for (final family in repeatedFamilies) family.toJson(),
      ],
      'qa': qaReport.toJson(),
    };
  }
}

class PuzzleAttempt {
  const PuzzleAttempt({
    required this.puzzleId,
    required this.childAge,
    required this.startAtIso8601,
    required this.endAtIso8601,
    required this.isCorrect,
    required this.usedHints,
    required this.answerKeyUsed,
    required this.spentSeconds,
  });

  final String puzzleId;
  final int childAge;
  final String startAtIso8601;
  final String endAtIso8601;
  final bool isCorrect;
  final int usedHints;
  final String answerKeyUsed;
  final int spentSeconds;
}

class RewardDefinition {
  const RewardDefinition({
    required this.id,
    required this.type,
    required this.titleKey,
    required this.descriptionKey,
    required this.visualKey,
    required this.xpCost,
    required this.unlockedAfterStars,
  });

  final String id;
  final RewardType type;
  final String titleKey;
  final String descriptionKey;
  final String visualKey;
  final int xpCost;
  final int unlockedAfterStars;
}

class ChildProgress {
  const ChildProgress({
    required this.childId,
    required this.completedLevels,
    required this.stars,
    required this.totalXp,
    required this.completedRewards,
    required this.failedAttempts,
    required this.maxStreak,
    required this.lastPlayedAtIso8601,
  });

  final String childId;
  final List<String> completedLevels;
  final int stars;
  final int totalXp;
  final List<String> completedRewards;
  final int failedAttempts;
  final int maxStreak;
  final String? lastPlayedAtIso8601;

  int get starsForLevelMap => stars;
}

class PracticeReviewProfile {
  const PracticeReviewProfile({
    this.mistakePuzzleIds = const [],
    this.weakSkillTags = const [],
  });

  final List<String> mistakePuzzleIds;
  final List<SkillTag> weakSkillTags;

  bool get hasSignals {
    return mistakePuzzleIds.isNotEmpty || weakSkillTags.isNotEmpty;
  }

  static PracticeReviewProfile fromSessions(
    List<PracticeSession> sessions, {
    int maxSessions = 12,
  }) {
    if (sessions.isEmpty) {
      return const PracticeReviewProfile();
    }

    final recentSessions = [
      ...sessions
    ]..sort((first, second) => second.completedAt.compareTo(first.completedAt));
    final mistakes = <String>[];
    final resolvedMistakes = <String>{};
    final weakSkills = <SkillTag>{};
    final reinforcedSkills = <SkillTag>{};

    for (final session in recentSessions.take(maxSessions)) {
      final accuracy = session.totalQuestions == 0
          ? 1.0
          : session.correctAnswers / session.totalQuestions;
      final isSuccessfulReview = session.reviewedPuzzleIds.isNotEmpty &&
          accuracy >= 0.8 &&
          session.wrongAttempts == 0;
      if (isSuccessfulReview) {
        resolvedMistakes.addAll(session.reviewedPuzzleIds);
        reinforcedSkills
            .addAll(_skillTagsForPuzzleIds(session.reviewedPuzzleIds));
        final sessionSkill = _skillTagForSessionSkill(session.skill);
        if (sessionSkill != null) {
          reinforcedSkills.add(sessionSkill);
        }
      }

      for (final puzzleId in session.mistakePuzzleIds) {
        if (!resolvedMistakes.contains(puzzleId) &&
            !mistakes.contains(puzzleId)) {
          mistakes.add(puzzleId);
        }
      }

      if (accuracy < 0.8 ||
          session.wrongAttempts > 0 ||
          session.usedHints > 1) {
        final skillTag = _skillTagForSessionSkill(session.skill);
        if (skillTag != null && !reinforcedSkills.contains(skillTag)) {
          weakSkills.add(skillTag);
        }
      }
    }

    return PracticeReviewProfile(
      mistakePuzzleIds: mistakes.take(6).toList(growable: false),
      weakSkillTags: weakSkills.toList(growable: false),
    );
  }
}

class FoundationCatalog {
  static const Set<String> knownWorldIds = {
    'space_station',
    'forest_lab',
    'underwater_city',
    'robot_town',
    'riddle_castle',
    'dinosaur_island',
    'toy_shop',
    'shape_garden',
    'train_expedition',
    'detective_academy',
  };

  static const Set<String> knownCharacterIds = {
    'brainy',
    'lumi',
    'quadra',
    'numba',
    'rulo',
    'mira',
  };

  static const List<ContentPlacementRule> placementRules = [
    ContentPlacementRule(
      placement: ContentPlacement.mainRoute,
      minPuzzleCount: 5,
      maxPuzzleCount: 5,
      defaultPuzzleCount: 5,
      description: 'Standard learning path lesson with mixed practice.',
      preferredDifficulties: [
        PuzzleDifficulty.easy,
        PuzzleDifficulty.normal,
        PuzzleDifficulty.hard,
      ],
    ),
    ContentPlacementRule(
      placement: ContentPlacement.dailyChallenge,
      minPuzzleCount: 1,
      maxPuzzleCount: 1,
      defaultPuzzleCount: 1,
      description: 'Short daily puzzle selected for fast streak practice.',
      preferredDifficulties: [
        PuzzleDifficulty.easy,
        PuzzleDifficulty.normal,
      ],
    ),
    ContentPlacementRule(
      placement: ContentPlacement.adaptiveReview,
      minPuzzleCount: 3,
      maxPuzzleCount: 5,
      defaultPuzzleCount: 5,
      description: 'Review set built from recent mistakes and weak skills.',
      preferredDifficulties: [
        PuzzleDifficulty.easy,
        PuzzleDifficulty.normal,
        PuzzleDifficulty.hard,
      ],
    ),
    ContentPlacementRule(
      placement: ContentPlacement.bossNode,
      minPuzzleCount: 6,
      maxPuzzleCount: 8,
      defaultPuzzleCount: 7,
      description: 'Mixed checkpoint lesson with harder multi-skill puzzles.',
      preferredDifficulties: [
        PuzzleDifficulty.hard,
        PuzzleDifficulty.boss,
      ],
      preferredTypes: [
        PuzzleType.mixedBoss,
        PuzzleType.codeBreaker,
        PuzzleType.analogy,
        PuzzleType.pathPuzzle,
      ],
    ),
    ContentPlacementRule(
      placement: ContentPlacement.mistakeRepeat,
      minPuzzleCount: 1,
      maxPuzzleCount: 3,
      defaultPuzzleCount: 2,
      description: 'Small repeat queue for missed puzzle families.',
    ),
    ContentPlacementRule(
      placement: ContentPlacement.parentAnalytics,
      minPuzzleCount: 0,
      maxPuzzleCount: 0,
      defaultPuzzleCount: 0,
      description: 'Reporting placement; puzzles contribute signals only.',
    ),
    ContentPlacementRule(
      placement: ContentPlacement.rewardCollection,
      minPuzzleCount: 1,
      maxPuzzleCount: 1,
      defaultPuzzleCount: 1,
      description: 'Special milestone puzzle that unlocks a reward moment.',
      preferredDifficulties: [
        PuzzleDifficulty.normal,
        PuzzleDifficulty.hard,
      ],
    ),
    ContentPlacementRule(
      placement: ContentPlacement.ageTrack,
      minPuzzleCount: 5,
      maxPuzzleCount: 5,
      defaultPuzzleCount: 5,
      description: 'Age-band scoped content route.',
    ),
    ContentPlacementRule(
      placement: ContentPlacement.weakSkillRecommendation,
      minPuzzleCount: 3,
      maxPuzzleCount: 5,
      defaultPuzzleCount: 4,
      description: 'Recommended practice for the weakest recent skill.',
    ),
  ];

  static const List<AgeBand> ageBands = [
    AgeBand(
      id: AgeBandId.age4to5,
      minAgeInclusive: 4,
      maxAgeInclusive: 5,
      titleKey: 'age_band_4_to_5',
    ),
    AgeBand(
      id: AgeBandId.age6,
      minAgeInclusive: 6,
      maxAgeInclusive: 6,
      titleKey: 'age_band_6',
    ),
    AgeBand(
      id: AgeBandId.age7to8,
      minAgeInclusive: 7,
      maxAgeInclusive: 8,
      titleKey: 'age_band_7_to_8',
    ),
  ];

  static const LevelMap starterMap = LevelMap(
    id: 'map.main',
    titleKey: 'map_main_title',
    subtitleKey: 'map_main_subtitle',
    nodes: [
      MapNode(
        id: 'node.001',
        order: 1,
        titleKey: 'node_001_title',
        subtitleKey: 'node_001_subtitle',
        lessonId: 'lesson.001',
        requiredStarsToUnlock: 0,
        ageBandId: AgeBandId.age4to5,
      ),
      MapNode(
        id: 'node.002',
        order: 2,
        titleKey: 'node_002_title',
        subtitleKey: 'node_002_subtitle',
        lessonId: 'lesson.002',
        requiredStarsToUnlock: 1,
        ageBandId: AgeBandId.age4to5,
      ),
      MapNode(
        id: 'node.003',
        order: 3,
        titleKey: 'node_003_title',
        subtitleKey: 'node_003_subtitle',
        lessonId: 'lesson.003',
        requiredStarsToUnlock: 2,
        ageBandId: AgeBandId.age4to5,
      ),
      MapNode(
        id: 'node.004',
        order: 4,
        titleKey: 'node_004_title',
        subtitleKey: 'node_004_subtitle',
        lessonId: 'lesson.004',
        requiredStarsToUnlock: 3,
        ageBandId: AgeBandId.age6,
      ),
      MapNode(
        id: 'node.005',
        order: 5,
        titleKey: 'node_005_title',
        subtitleKey: 'node_005_subtitle',
        lessonId: 'lesson.005',
        requiredStarsToUnlock: 4,
        ageBandId: AgeBandId.age6,
      ),
      MapNode(
        id: 'node.006',
        order: 6,
        titleKey: 'node_006_title',
        subtitleKey: 'node_006_subtitle',
        lessonId: 'lesson.006',
        requiredStarsToUnlock: 5,
        ageBandId: AgeBandId.age7to8,
      ),
      MapNode(
        id: 'node.007',
        order: 7,
        titleKey: 'node_007_title',
        subtitleKey: 'node_007_subtitle',
        lessonId: 'lesson.007',
        requiredStarsToUnlock: 6,
        ageBandId: AgeBandId.age7to8,
      ),
      MapNode(
        id: 'node.008',
        order: 8,
        titleKey: 'node_008_title',
        subtitleKey: 'node_008_subtitle',
        lessonId: 'lesson.008',
        requiredStarsToUnlock: 7,
        ageBandId: AgeBandId.age7to8,
      ),
    ],
  );

  static const List<Lesson> starterLessons = [
    Lesson(
      id: 'lesson.001',
      titleKey: 'lesson_001_title',
      stepIds: ['step.001.1', 'step.001.2', 'step.001.3'],
      xpReward: 24,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.002',
      titleKey: 'lesson_002_title',
      stepIds: ['step.002.1', 'step.002.2', 'step.002.3'],
      xpReward: 28,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.003',
      titleKey: 'lesson_003_title',
      stepIds: ['step.003.1', 'step.003.2', 'step.003.3', 'step.003.4'],
      xpReward: 32,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.004',
      titleKey: 'lesson_004_title',
      stepIds: ['step.004.1', 'step.004.2', 'step.004.3'],
      xpReward: 36,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.005',
      titleKey: 'lesson_005_title',
      stepIds: ['step.005.1', 'step.005.2', 'step.005.3', 'step.005.4'],
      xpReward: 40,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.006',
      titleKey: 'lesson_006_title',
      stepIds: ['step.006.1', 'step.006.2', 'step.006.3', 'step.006.4'],
      xpReward: 44,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.007',
      titleKey: 'lesson_007_title',
      stepIds: ['step.007.1', 'step.007.2', 'step.007.3', 'step.007.4'],
      xpReward: 48,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.008',
      titleKey: 'lesson_008_title',
      stepIds: ['step.008.1', 'step.008.2', 'step.008.3', 'step.008.4'],
      xpReward: 52,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.009',
      titleKey: 'lesson_009_title',
      stepIds: ['step.009.1', 'step.009.2', 'step.009.3', 'step.009.4'],
      xpReward: 54,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.010',
      titleKey: 'lesson_010_title',
      stepIds: ['step.010.1', 'step.010.2', 'step.010.3', 'step.010.4'],
      xpReward: 56,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.011',
      titleKey: 'lesson_011_title',
      stepIds: ['step.011.1', 'step.011.2', 'step.011.3', 'step.011.4'],
      xpReward: 58,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.012',
      titleKey: 'lesson_012_title',
      stepIds: ['step.012.1', 'step.012.2', 'step.012.3', 'step.012.4'],
      xpReward: 60,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.013',
      titleKey: 'lesson_013_title',
      stepIds: ['step.013.1', 'step.013.2', 'step.013.3', 'step.013.4'],
      xpReward: 62,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.014',
      titleKey: 'lesson_014_title',
      stepIds: ['step.014.1', 'step.014.2', 'step.014.3', 'step.014.4'],
      xpReward: 64,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.015',
      titleKey: 'lesson_015_title',
      stepIds: ['step.015.1', 'step.015.2', 'step.015.3', 'step.015.4'],
      xpReward: 66,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.016',
      titleKey: 'lesson_016_title',
      stepIds: ['step.016.1', 'step.016.2', 'step.016.3', 'step.016.4'],
      xpReward: 68,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.017',
      titleKey: 'lesson_017_title',
      stepIds: ['step.017.1', 'step.017.2', 'step.017.3', 'step.017.4'],
      xpReward: 70,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.018',
      titleKey: 'lesson_018_title',
      stepIds: ['step.018.1', 'step.018.2', 'step.018.3', 'step.018.4'],
      xpReward: 72,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.019',
      titleKey: 'lesson_019_title',
      stepIds: ['step.019.1', 'step.019.2', 'step.019.3', 'step.019.4'],
      xpReward: 74,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.020',
      titleKey: 'lesson_020_title',
      stepIds: ['step.020.1', 'step.020.2', 'step.020.3', 'step.020.4'],
      xpReward: 76,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.021',
      titleKey: 'lesson_021_title',
      stepIds: ['step.021.1', 'step.021.2', 'step.021.3', 'step.021.4'],
      xpReward: 78,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.022',
      titleKey: 'lesson_022_title',
      stepIds: ['step.022.1', 'step.022.2', 'step.022.3', 'step.022.4'],
      xpReward: 80,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.023',
      titleKey: 'lesson_023_title',
      stepIds: ['step.023.1', 'step.023.2', 'step.023.3', 'step.023.4'],
      xpReward: 82,
      maxHearts: 5,
    ),
    Lesson(
      id: 'lesson.024',
      titleKey: 'lesson_024_title',
      stepIds: ['step.024.1', 'step.024.2', 'step.024.3', 'step.024.4'],
      xpReward: 84,
      maxHearts: 5,
    ),
  ];

  static const Lesson adaptiveReviewLesson = Lesson(
    id: 'lesson.review.adaptive',
    titleKey: 'lesson_review_adaptive_title',
    stepIds: [],
    xpReward: 12,
    maxHearts: 5,
  );

  static const List<CourseDefinition> starterCourses = [
    CourseDefinition(
      id: 'course.logic',
      track: CourseTrack.logic,
      lessonIds: [
        'lesson.001',
        'lesson.003',
        'lesson.004',
        'lesson.009',
        'lesson.013',
        'lesson.018',
        'lesson.021',
        'lesson.024',
      ],
      recommendedAgeBandId: AgeBandId.age4to5,
    ),
    CourseDefinition(
      id: 'course.math',
      track: CourseTrack.math,
      lessonIds: [
        'lesson.002',
        'lesson.005',
        'lesson.007',
        'lesson.010',
        'lesson.014',
        'lesson.017',
        'lesson.020',
        'lesson.023',
      ],
      recommendedAgeBandId: AgeBandId.age4to5,
    ),
    CourseDefinition(
      id: 'course.spatial',
      track: CourseTrack.spatial,
      lessonIds: [
        'lesson.001',
        'lesson.005',
        'lesson.008',
        'lesson.011',
        'lesson.015',
        'lesson.018',
        'lesson.022',
        'lesson.024',
      ],
      recommendedAgeBandId: AgeBandId.age6,
    ),
    CourseDefinition(
      id: 'course.attention',
      track: CourseTrack.attention,
      lessonIds: [
        'lesson.003',
        'lesson.006',
        'lesson.008',
        'lesson.012',
        'lesson.016',
        'lesson.019',
        'lesson.021',
        'lesson.023',
      ],
      recommendedAgeBandId: AgeBandId.age6,
    ),
    CourseDefinition(
      id: 'course.rebus',
      track: CourseTrack.rebus,
      lessonIds: [
        'lesson.004',
        'lesson.006',
        'lesson.007',
        'lesson.011',
        'lesson.015',
        'lesson.017',
        'lesson.020',
        'lesson.022',
      ],
      recommendedAgeBandId: AgeBandId.age7to8,
    ),
    CourseDefinition(
      id: 'course.mixed',
      track: CourseTrack.mixed,
      lessonIds: [
        'lesson.001',
        'lesson.002',
        'lesson.003',
        'lesson.004',
        'lesson.013',
        'lesson.014',
        'lesson.015',
        'lesson.016',
      ],
      recommendedAgeBandId: AgeBandId.age4to5,
    ),
  ];

  static const List<LessonStep> starterLessonSteps = [
    LessonStep(
      id: 'step.001.1',
      lessonId: 'lesson.001',
      order: 1,
      puzzleId: 'puzzle.shape_path',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.001.2',
      lessonId: 'lesson.001',
      order: 2,
      puzzleId: 'puzzle.toy_count',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.001.3',
      lessonId: 'lesson.001',
      order: 3,
      puzzleId: 'puzzle.odd_card',
      internalSkillTag: SkillTag.classification,
    ),
    LessonStep(
      id: 'step.002.1',
      lessonId: 'lesson.002',
      order: 1,
      puzzleId: 'puzzle.toy_count',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.002.2',
      lessonId: 'lesson.002',
      order: 2,
      puzzleId: 'puzzle.shape_path',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.002.3',
      lessonId: 'lesson.002',
      order: 3,
      puzzleId: 'puzzle.shadow_match',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.003.1',
      lessonId: 'lesson.003',
      order: 1,
      puzzleId: 'puzzle.odd_card',
      internalSkillTag: SkillTag.classification,
    ),
    LessonStep(
      id: 'step.003.2',
      lessonId: 'lesson.003',
      order: 2,
      puzzleId: 'puzzle.fruit_pattern',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.003.3',
      lessonId: 'lesson.003',
      order: 3,
      puzzleId: 'puzzle.toy_count',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.003.4',
      lessonId: 'lesson.003',
      order: 4,
      puzzleId: 'puzzle.memory_pairs',
      internalSkillTag: SkillTag.memory,
    ),
    LessonStep(
      id: 'step.004.1',
      lessonId: 'lesson.004',
      order: 1,
      puzzleId: 'puzzle.logic_train',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.004.2',
      lessonId: 'lesson.004',
      order: 2,
      puzzleId: 'puzzle.sticker_sum',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.004.3',
      lessonId: 'lesson.004',
      order: 3,
      puzzleId: 'puzzle.balance_scale',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.005.1',
      lessonId: 'lesson.005',
      order: 1,
      puzzleId: 'puzzle.sticker_sum',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.005.2',
      lessonId: 'lesson.005',
      order: 2,
      puzzleId: 'puzzle.logic_train',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.005.3',
      lessonId: 'lesson.005',
      order: 3,
      puzzleId: 'puzzle.shape_path',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.005.4',
      lessonId: 'lesson.005',
      order: 4,
      puzzleId: 'puzzle.odd_card',
      internalSkillTag: SkillTag.classification,
    ),
    LessonStep(
      id: 'step.006.1',
      lessonId: 'lesson.006',
      order: 1,
      puzzleId: 'puzzle.code_grid',
      internalSkillTag: SkillTag.reasoning,
    ),
    LessonStep(
      id: 'step.006.2',
      lessonId: 'lesson.006',
      order: 2,
      puzzleId: 'puzzle.number_bridge',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.006.3',
      lessonId: 'lesson.006',
      order: 3,
      puzzleId: 'puzzle.detail_count',
      internalSkillTag: SkillTag.attention,
    ),
    LessonStep(
      id: 'step.006.4',
      lessonId: 'lesson.006',
      order: 4,
      puzzleId: 'puzzle.memory_pairs',
      internalSkillTag: SkillTag.memory,
    ),
    LessonStep(
      id: 'step.007.1',
      lessonId: 'lesson.007',
      order: 1,
      puzzleId: 'puzzle.number_bridge',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.007.2',
      lessonId: 'lesson.007',
      order: 2,
      puzzleId: 'puzzle.code_grid',
      internalSkillTag: SkillTag.reasoning,
    ),
    LessonStep(
      id: 'step.007.3',
      lessonId: 'lesson.007',
      order: 3,
      puzzleId: 'puzzle.detail_count',
      internalSkillTag: SkillTag.attention,
    ),
    LessonStep(
      id: 'step.007.4',
      lessonId: 'lesson.007',
      order: 4,
      puzzleId: 'puzzle.logic_train',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.008.1',
      lessonId: 'lesson.008',
      order: 1,
      puzzleId: 'puzzle.detail_count',
      internalSkillTag: SkillTag.attention,
    ),
    LessonStep(
      id: 'step.008.2',
      lessonId: 'lesson.008',
      order: 2,
      puzzleId: 'puzzle.number_bridge',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.008.3',
      lessonId: 'lesson.008',
      order: 3,
      puzzleId: 'puzzle.code_grid',
      internalSkillTag: SkillTag.reasoning,
    ),
    LessonStep(
      id: 'step.008.4',
      lessonId: 'lesson.008',
      order: 4,
      puzzleId: 'puzzle.shape_rotation',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.009.1',
      lessonId: 'lesson.009',
      order: 1,
      puzzleId: 'puzzle.shadow_match',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.009.2',
      lessonId: 'lesson.009',
      order: 2,
      puzzleId: 'puzzle.logic_train',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.009.3',
      lessonId: 'lesson.009',
      order: 3,
      puzzleId: 'puzzle.lock_key',
      internalSkillTag: SkillTag.memory,
    ),
    LessonStep(
      id: 'step.009.4',
      lessonId: 'lesson.009',
      order: 4,
      puzzleId: 'puzzle.balance_scale',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.010.1',
      lessonId: 'lesson.010',
      order: 1,
      puzzleId: 'puzzle.sticker_sum',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.010.2',
      lessonId: 'lesson.010',
      order: 2,
      puzzleId: 'puzzle.balance_scale',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.010.3',
      lessonId: 'lesson.010',
      order: 3,
      puzzleId: 'puzzle.number_bridge',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.010.4',
      lessonId: 'lesson.010',
      order: 4,
      puzzleId: 'puzzle.detail_count',
      internalSkillTag: SkillTag.attention,
    ),
    LessonStep(
      id: 'step.011.1',
      lessonId: 'lesson.011',
      order: 1,
      puzzleId: 'puzzle.shape_rotation',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.011.2',
      lessonId: 'lesson.011',
      order: 2,
      puzzleId: 'puzzle.shadow_match',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.011.3',
      lessonId: 'lesson.011',
      order: 3,
      puzzleId: 'puzzle.space_sequence',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.011.4',
      lessonId: 'lesson.011',
      order: 4,
      puzzleId: 'puzzle.code_grid',
      internalSkillTag: SkillTag.reasoning,
    ),
    LessonStep(
      id: 'step.012.1',
      lessonId: 'lesson.012',
      order: 1,
      puzzleId: 'puzzle.memory_pairs',
      internalSkillTag: SkillTag.memory,
    ),
    LessonStep(
      id: 'step.012.2',
      lessonId: 'lesson.012',
      order: 2,
      puzzleId: 'puzzle.shape_stack',
      internalSkillTag: SkillTag.attention,
    ),
    LessonStep(
      id: 'step.012.3',
      lessonId: 'lesson.012',
      order: 3,
      puzzleId: 'puzzle.odd_card',
      internalSkillTag: SkillTag.classification,
    ),
    LessonStep(
      id: 'step.012.4',
      lessonId: 'lesson.012',
      order: 4,
      puzzleId: 'puzzle.balance_scale',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.013.1',
      lessonId: 'lesson.013',
      order: 1,
      puzzleId: 'puzzle.fruit_pattern',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.013.2',
      lessonId: 'lesson.013',
      order: 2,
      puzzleId: 'puzzle.shadow_match',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.013.3',
      lessonId: 'lesson.013',
      order: 3,
      puzzleId: 'puzzle.odd_card',
      internalSkillTag: SkillTag.classification,
    ),
    LessonStep(
      id: 'step.013.4',
      lessonId: 'lesson.013',
      order: 4,
      puzzleId: 'puzzle.shape_stack',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.014.1',
      lessonId: 'lesson.014',
      order: 1,
      puzzleId: 'puzzle.toy_count',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.014.2',
      lessonId: 'lesson.014',
      order: 2,
      puzzleId: 'puzzle.sticker_sum',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.014.3',
      lessonId: 'lesson.014',
      order: 3,
      puzzleId: 'puzzle.balance_scale',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.014.4',
      lessonId: 'lesson.014',
      order: 4,
      puzzleId: 'puzzle.number_bridge',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.015.1',
      lessonId: 'lesson.015',
      order: 1,
      puzzleId: 'puzzle.shape_rotation',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.015.2',
      lessonId: 'lesson.015',
      order: 2,
      puzzleId: 'puzzle.shape_stack',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.015.3',
      lessonId: 'lesson.015',
      order: 3,
      puzzleId: 'puzzle.shadow_match',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.015.4',
      lessonId: 'lesson.015',
      order: 4,
      puzzleId: 'puzzle.detail_count',
      internalSkillTag: SkillTag.attention,
    ),
    LessonStep(
      id: 'step.016.1',
      lessonId: 'lesson.016',
      order: 1,
      puzzleId: 'puzzle.memory_pairs',
      internalSkillTag: SkillTag.memory,
    ),
    LessonStep(
      id: 'step.016.2',
      lessonId: 'lesson.016',
      order: 2,
      puzzleId: 'puzzle.lock_key',
      internalSkillTag: SkillTag.memory,
    ),
    LessonStep(
      id: 'step.016.3',
      lessonId: 'lesson.016',
      order: 3,
      puzzleId: 'puzzle.detail_count',
      internalSkillTag: SkillTag.attention,
    ),
    LessonStep(
      id: 'step.016.4',
      lessonId: 'lesson.016',
      order: 4,
      puzzleId: 'puzzle.odd_card',
      internalSkillTag: SkillTag.classification,
    ),
    LessonStep(
      id: 'step.017.1',
      lessonId: 'lesson.017',
      order: 1,
      puzzleId: 'puzzle.code_grid',
      internalSkillTag: SkillTag.reasoning,
    ),
    LessonStep(
      id: 'step.017.2',
      lessonId: 'lesson.017',
      order: 2,
      puzzleId: 'puzzle.number_bridge',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.017.3',
      lessonId: 'lesson.017',
      order: 3,
      puzzleId: 'puzzle.balance_scale',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.017.4',
      lessonId: 'lesson.017',
      order: 4,
      puzzleId: 'puzzle.space_sequence',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.018.1',
      lessonId: 'lesson.018',
      order: 1,
      puzzleId: 'puzzle.space_sequence',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.018.2',
      lessonId: 'lesson.018',
      order: 2,
      puzzleId: 'puzzle.shape_rotation',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.018.3',
      lessonId: 'lesson.018',
      order: 3,
      puzzleId: 'puzzle.logic_train',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.018.4',
      lessonId: 'lesson.018',
      order: 4,
      puzzleId: 'puzzle.shadow_match',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.019.1',
      lessonId: 'lesson.019',
      order: 1,
      puzzleId: 'puzzle.odd_card',
      internalSkillTag: SkillTag.classification,
    ),
    LessonStep(
      id: 'step.019.2',
      lessonId: 'lesson.019',
      order: 2,
      puzzleId: 'puzzle.detail_count',
      internalSkillTag: SkillTag.attention,
    ),
    LessonStep(
      id: 'step.019.3',
      lessonId: 'lesson.019',
      order: 3,
      puzzleId: 'puzzle.lock_key',
      internalSkillTag: SkillTag.memory,
    ),
    LessonStep(
      id: 'step.019.4',
      lessonId: 'lesson.019',
      order: 4,
      puzzleId: 'puzzle.fruit_pattern',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.020.1',
      lessonId: 'lesson.020',
      order: 1,
      puzzleId: 'puzzle.sticker_sum',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.020.2',
      lessonId: 'lesson.020',
      order: 2,
      puzzleId: 'puzzle.code_grid',
      internalSkillTag: SkillTag.reasoning,
    ),
    LessonStep(
      id: 'step.020.3',
      lessonId: 'lesson.020',
      order: 3,
      puzzleId: 'puzzle.number_bridge',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.020.4',
      lessonId: 'lesson.020',
      order: 4,
      puzzleId: 'puzzle.balance_scale',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.021.1',
      lessonId: 'lesson.021',
      order: 1,
      puzzleId: 'puzzle.logic_train',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.021.2',
      lessonId: 'lesson.021',
      order: 2,
      puzzleId: 'puzzle.shape_path',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.021.3',
      lessonId: 'lesson.021',
      order: 3,
      puzzleId: 'puzzle.fruit_pattern',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.021.4',
      lessonId: 'lesson.021',
      order: 4,
      puzzleId: 'puzzle.space_sequence',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.022.1',
      lessonId: 'lesson.022',
      order: 1,
      puzzleId: 'puzzle.shape_rotation',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.022.2',
      lessonId: 'lesson.022',
      order: 2,
      puzzleId: 'puzzle.shape_stack',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.022.3',
      lessonId: 'lesson.022',
      order: 3,
      puzzleId: 'puzzle.code_grid',
      internalSkillTag: SkillTag.reasoning,
    ),
    LessonStep(
      id: 'step.022.4',
      lessonId: 'lesson.022',
      order: 4,
      puzzleId: 'puzzle.shadow_match',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.023.1',
      lessonId: 'lesson.023',
      order: 1,
      puzzleId: 'puzzle.toy_count',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.023.2',
      lessonId: 'lesson.023',
      order: 2,
      puzzleId: 'puzzle.detail_count',
      internalSkillTag: SkillTag.attention,
    ),
    LessonStep(
      id: 'step.023.3',
      lessonId: 'lesson.023',
      order: 3,
      puzzleId: 'puzzle.memory_pairs',
      internalSkillTag: SkillTag.memory,
    ),
    LessonStep(
      id: 'step.023.4',
      lessonId: 'lesson.023',
      order: 4,
      puzzleId: 'puzzle.number_bridge',
      internalSkillTag: SkillTag.arithmetic,
    ),
    LessonStep(
      id: 'step.024.1',
      lessonId: 'lesson.024',
      order: 1,
      puzzleId: 'puzzle.space_sequence',
      internalSkillTag: SkillTag.pattern,
    ),
    LessonStep(
      id: 'step.024.2',
      lessonId: 'lesson.024',
      order: 2,
      puzzleId: 'puzzle.shape_stack',
      internalSkillTag: SkillTag.spatial,
    ),
    LessonStep(
      id: 'step.024.3',
      lessonId: 'lesson.024',
      order: 3,
      puzzleId: 'puzzle.lock_key',
      internalSkillTag: SkillTag.memory,
    ),
    LessonStep(
      id: 'step.024.4',
      lessonId: 'lesson.024',
      order: 4,
      puzzleId: 'puzzle.code_grid',
      internalSkillTag: SkillTag.reasoning,
    ),
  ];

  static const List<PuzzleDefinition> starterPuzzles = [
    PuzzleDefinition(
      id: 'puzzle.shape_path',
      lessonId: 'lesson.shared',
      type: PuzzleType.sequenceComplete,
      skillTag: SkillTag.pattern,
      payloadRef: 'shape-path',
      correctAnswerKey: 'circle',
      hintKeys: ['challengeShapePathHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.fruit_pattern',
      lessonId: 'lesson.shared',
      type: PuzzleType.sequenceComplete,
      skillTag: SkillTag.pattern,
      payloadRef: 'fruit-pattern',
      correctAnswerKey: 'apple',
      hintKeys: ['challengeFruitPatternHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.toy_count',
      lessonId: 'lesson.shared',
      type: PuzzleType.countBridge,
      skillTag: SkillTag.arithmetic,
      payloadRef: 'toy-count',
      correctAnswerKey: '3',
      hintKeys: ['challengeToyCountHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.odd_card',
      lessonId: 'lesson.shared',
      type: PuzzleType.oddOneOut,
      skillTag: SkillTag.classification,
      payloadRef: 'odd-card',
      correctAnswerKey: 'ball',
      hintKeys: ['challengeOddCardHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.memory_pairs',
      lessonId: 'lesson.shared',
      type: PuzzleType.pairMatch,
      skillTag: SkillTag.memory,
      payloadRef: 'memory-pairs',
      correctAnswerKey: 'lock',
      hintKeys: ['challengeMemoryPairsHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.lock_key',
      lessonId: 'lesson.shared',
      type: PuzzleType.pairMatch,
      skillTag: SkillTag.memory,
      payloadRef: 'lock-key',
      correctAnswerKey: 'lock',
      hintKeys: ['challengeLockKeyHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.shadow_match',
      lessonId: 'lesson.shared',
      type: PuzzleType.visualCompare,
      skillTag: SkillTag.spatial,
      payloadRef: 'shadow-match',
      correctAnswerKey: 'rocket',
      hintKeys: ['challengeShadowMatchHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.logic_train',
      lessonId: 'lesson.shared',
      type: PuzzleType.sequenceComplete,
      skillTag: SkillTag.pattern,
      payloadRef: 'logic-train',
      correctAnswerKey: 'red',
      hintKeys: ['challengeLogicTrainHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.sticker_sum',
      lessonId: 'lesson.shared',
      type: PuzzleType.countBridge,
      skillTag: SkillTag.arithmetic,
      payloadRef: 'sticker-sum',
      correctAnswerKey: '5',
      hintKeys: ['challengeStickerSumHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.balance_scale',
      lessonId: 'lesson.shared',
      type: PuzzleType.visualCompare,
      skillTag: SkillTag.arithmetic,
      payloadRef: 'balance-scale',
      correctAnswerKey: 'apple',
      hintKeys: ['challengeBalanceScaleHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.code_grid',
      lessonId: 'lesson.shared',
      type: PuzzleType.visualCompare,
      skillTag: SkillTag.reasoning,
      payloadRef: 'code-grid',
      correctAnswerKey: '7',
      hintKeys: ['challengeCodeGridHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.number_bridge',
      lessonId: 'lesson.shared',
      type: PuzzleType.countBridge,
      skillTag: SkillTag.arithmetic,
      payloadRef: 'number-bridge',
      correctAnswerKey: '4+2+1',
      hintKeys: ['challengeNumberBridgeHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.detail_count',
      lessonId: 'lesson.shared',
      type: PuzzleType.visualCompare,
      skillTag: SkillTag.attention,
      payloadRef: 'detail-count',
      correctAnswerKey: 'red-circles',
      hintKeys: ['challengeDetailCountHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.shape_rotation',
      lessonId: 'lesson.shared',
      type: PuzzleType.visualCompare,
      skillTag: SkillTag.spatial,
      payloadRef: 'shape-rotation',
      correctAnswerKey: 'same',
      hintKeys: ['challengeShapeRotationHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.space_sequence',
      lessonId: 'lesson.shared',
      type: PuzzleType.sequenceComplete,
      skillTag: SkillTag.pattern,
      payloadRef: 'space-sequence',
      correctAnswerKey: 'rocket',
      hintKeys: ['challengeSpaceSequenceHint'],
    ),
    PuzzleDefinition(
      id: 'puzzle.shape_stack',
      lessonId: 'lesson.shared',
      type: PuzzleType.sequenceComplete,
      skillTag: SkillTag.spatial,
      payloadRef: 'shape-stack',
      correctAnswerKey: 'square',
      hintKeys: ['challengeShapeStackHint'],
    ),
  ];

  static final List<PuzzleDefinition> allPuzzles = [
    ...starterPuzzles,
    ...ContentBank.seedPuzzles,
    ...CuratedRichPuzzlePack.puzzles,
  ];

  static List<PuzzleDefinition> puzzlesFor({
    AgeBandId? ageBandId,
    SkillTag? skillTag,
    PuzzleDifficulty? difficulty,
  }) {
    return [
      for (final puzzle in allPuzzles)
        if ((ageBandId == null || puzzle.ageBandIds.contains(ageBandId)) &&
            (skillTag == null || puzzle.skillTag == skillTag) &&
            (difficulty == null || puzzle.difficulty == difficulty))
          puzzle,
    ];
  }

  static Map<SkillTag, int> puzzleCountBySkill() {
    return {
      for (final skill in SkillTag.values)
        skill: allPuzzles.where((puzzle) => puzzle.skillTag == skill).length,
    };
  }

  static ContentCoverageReport contentCoverageReport() {
    return ContentCoverageReport(
      totalPuzzleCount: allPuzzles.length,
      countByAgeBand: {
        for (final ageBandId in AgeBandId.values)
          ageBandId: puzzlesFor(ageBandId: ageBandId).length,
      },
      countBySkill: puzzleCountBySkill(),
      countByDifficulty: {
        for (final difficulty in PuzzleDifficulty.values)
          difficulty: puzzlesFor(difficulty: difficulty).length,
      },
      countByType: {
        for (final type in PuzzleType.values)
          type: allPuzzles.where((puzzle) => puzzle.type == type).length,
      },
      countByAgeBandAndSkill: {
        for (final ageBandId in AgeBandId.values)
          ageBandId: {
            for (final skillTag in SkillTag.values)
              skillTag: puzzlesFor(
                ageBandId: ageBandId,
                skillTag: skillTag,
              ).length,
          },
      },
    );
  }

  static Map<String, Object?> contentManifest({
    int minimumPerAgeBandSkill = 4,
  }) {
    final report = contentCoverageReport();

    return {
      'schemaVersion': 1,
      'generatedBy': 'FoundationCatalog.contentManifest',
      'qualityGate': {
        'minimumPerAgeBandSkill': minimumPerAgeBandSkill,
        'passes': report
            .skillGaps(
              minimumPerAgeBand: minimumPerAgeBandSkill,
            )
            .isEmpty,
      },
      'coverage': report.toJson(
        minimumPerAgeBandSkill: minimumPerAgeBandSkill,
      ),
      'visualMetadata': {
        'knownWorldIds': knownWorldIds.toList(growable: false),
        'knownCharacterIds': knownCharacterIds.toList(growable: false),
        'visualPuzzleCount':
            allPuzzles.where((puzzle) => puzzle.visualMetadata != null).length,
      },
      'placementRules': [
        for (final rule in placementRules) rule.toJson(),
      ],
      'qa': contentQaReport().toJson(),
      'lessonPlacements': [
        for (final lesson in starterLessons)
          {
            'lessonId': lesson.id,
            'placement': placementForLesson(lesson).name,
            'defaultPuzzleCount':
                placementRuleFor(placementForLesson(lesson)).defaultPuzzleCount,
          },
        {
          'lessonId': adaptiveReviewLesson.id,
          'placement': ContentPlacement.adaptiveReview.name,
          'defaultPuzzleCount':
              placementRuleFor(ContentPlacement.adaptiveReview)
                  .defaultPuzzleCount,
        },
      ],
      'puzzles': [
        for (final puzzle in allPuzzles) puzzle.toJson(),
      ],
    };
  }

  static ContentDashboardReport contentDashboardReport({
    int minimumPerAgeBandSkill = 4,
    int minimumPerType = 2,
    int repeatedFamilyThreshold = 5,
  }) {
    final report = contentCoverageReport();
    final visualPuzzleCount =
        allPuzzles.where((puzzle) => puzzle.visualMetadata != null).length;
    final visualCoveragePercent =
        (visualPuzzleCount * 100 / report.totalPuzzleCount).round();
    final skillGaps = report.skillGaps(
      minimumPerAgeBand: minimumPerAgeBandSkill,
    );
    final lowTypeCoverage = {
      for (final entry in report.countByType.entries)
        if (entry.value < minimumPerType) entry.key: entry.value,
    };
    final qaReport = contentQaReport(
      repeatedFamilyWarningThreshold: repeatedFamilyThreshold,
    );

    return ContentDashboardReport(
      totalPuzzleCount: report.totalPuzzleCount,
      visualPuzzleCount: visualPuzzleCount,
      visualCoveragePercent: visualCoveragePercent,
      qualityGatePasses: skillGaps.isEmpty,
      coverage: report,
      placementRules: placementRules,
      puzzleIdsWithoutAssets: [
        for (final puzzle in allPuzzles)
          if (puzzle.visualMetadata == null) puzzle.id,
      ],
      puzzleIdsWithoutHints: [
        for (final puzzle in allPuzzles)
          if (puzzle.hintKeys.isEmpty) puzzle.id,
      ],
      skillGaps: skillGaps,
      lowTypeCoverage: lowTypeCoverage,
      repeatedFamilies: _repeatedFamilySummaries(
        threshold: repeatedFamilyThreshold,
      ),
      qaReport: qaReport,
    );
  }

  static ContentQaReport contentQaReport({
    int repeatedFamilyWarningThreshold = 5,
  }) {
    final issues = <ContentQaIssue>[];
    final ids = <String, int>{};
    final payloadRefs = <String, int>{};

    for (final puzzle in allPuzzles) {
      ids.update(puzzle.id, (count) => count + 1, ifAbsent: () => 1);
      payloadRefs.update(
        puzzle.payloadRef,
        (count) => count + 1,
        ifAbsent: () => 1,
      );

      if (puzzle.correctAnswerKey.trim().isEmpty) {
        issues.add(
          ContentQaIssue(
            type: ContentQaIssueType.missingCorrectAnswer,
            severity: ContentQaSeverity.blocker,
            puzzleId: puzzle.id,
            message: 'Puzzle has an empty correct answer key.',
          ),
        );
      }

      if (puzzle.hintKeys.isEmpty) {
        issues.add(
          ContentQaIssue(
            type: ContentQaIssueType.missingHint,
            severity: ContentQaSeverity.blocker,
            puzzleId: puzzle.id,
            message: 'Puzzle has no hint key.',
          ),
        );
      }

      final metadata = puzzle.visualMetadata;
      if (metadata == null) {
        issues.add(
          ContentQaIssue(
            type: ContentQaIssueType.missingVisualMetadata,
            severity: ContentQaSeverity.warning,
            puzzleId: puzzle.id,
            message: 'Puzzle has no visual metadata yet.',
          ),
        );
      } else {
        if (!knownWorldIds.contains(metadata.worldId)) {
          issues.add(
            ContentQaIssue(
              type: ContentQaIssueType.invalidVisualWorld,
              severity: ContentQaSeverity.blocker,
              puzzleId: puzzle.id,
              message: 'Puzzle references an unknown visual world.',
            ),
          );
        }
        if (!knownCharacterIds.contains(metadata.characterId)) {
          issues.add(
            ContentQaIssue(
              type: ContentQaIssueType.invalidVisualCharacter,
              severity: ContentQaSeverity.blocker,
              puzzleId: puzzle.id,
              message: 'Puzzle references an unknown helper character.',
            ),
          );
        }
        if (metadata.choiceAssets.isEmpty) {
          issues.add(
            ContentQaIssue(
              type: ContentQaIssueType.missingChoiceAssets,
              severity: ContentQaSeverity.blocker,
              puzzleId: puzzle.id,
              message: 'Puzzle visual metadata has no choice assets.',
            ),
          );
        }
        if (metadata.estimatedSeconds <= 0) {
          issues.add(
            ContentQaIssue(
              type: ContentQaIssueType.invalidEstimatedSeconds,
              severity: ContentQaSeverity.blocker,
              puzzleId: puzzle.id,
              message: 'Puzzle estimated seconds must be positive.',
            ),
          );
        }
      }

      if (puzzle.difficulty == PuzzleDifficulty.boss &&
          !puzzle.ageBandIds.contains(AgeBandId.age7to8)) {
        issues.add(
          ContentQaIssue(
            type: ContentQaIssueType.bossAgeMismatch,
            severity: ContentQaSeverity.blocker,
            puzzleId: puzzle.id,
            message: 'Boss puzzle must be available for age7to8.',
          ),
        );
      }
    }

    for (final entry in ids.entries) {
      if (entry.value > 1) {
        issues.add(
          ContentQaIssue(
            type: ContentQaIssueType.duplicatePuzzleId,
            severity: ContentQaSeverity.blocker,
            puzzleId: entry.key,
            message: 'Puzzle id appears ${entry.value} times.',
          ),
        );
      }
    }

    for (final entry in payloadRefs.entries) {
      if (entry.value > 1) {
        issues.add(
          ContentQaIssue(
            type: ContentQaIssueType.duplicatePayloadRef,
            severity: ContentQaSeverity.blocker,
            puzzleId: entry.key,
            message: 'Puzzle payloadRef appears ${entry.value} times.',
          ),
        );
      }
    }

    for (final family in _repeatedFamilySummaries(
      threshold: repeatedFamilyWarningThreshold,
    )) {
      issues.add(
        ContentQaIssue(
          type: ContentQaIssueType.excessiveFamilyRepetition,
          severity: ContentQaSeverity.warning,
          familyId: family.familyId,
          message: 'Family has ${family.count} variants; review saturation.',
        ),
      );
    }

    return ContentQaReport(issues: issues);
  }

  static List<PuzzleDefinition> puzzlesForLesson({
    required Lesson lesson,
    required AgeBandId ageBandId,
    int? targetCount,
    PracticeReviewProfile reviewProfile = const PracticeReviewProfile(),
  }) {
    final placement = placementForLesson(lesson);
    final rule = placementRuleFor(placement);
    final effectiveTargetCount = targetCount ?? rule.defaultPuzzleCount;
    final fixedPuzzles = [
      for (final step in stepsForLesson(lesson)) puzzleForStep(step),
    ];
    final primarySkill = fixedPuzzles.isEmpty
        ? (reviewProfile.weakSkillTags.isEmpty
            ? SkillTag.pattern
            : reviewProfile.weakSkillTags.first)
        : fixedPuzzles.first.skillTag;
    final lessonNumber = _lessonNumber(lesson.id);
    final targetDifficulty = _difficultyForLessonNumber(lessonNumber);
    final selected = <PuzzleDefinition>[];
    final seenIds = <String>{};

    void addCandidates(
      Iterable<PuzzleDefinition> candidates, {
      required bool balanced,
      required bool enforcePlacement,
    }) {
      for (final puzzle in candidates) {
        if (selected.length >= effectiveTargetCount) {
          return;
        }
        if (seenIds.contains(puzzle.id)) {
          continue;
        }
        if (enforcePlacement &&
            !_fitsPlacement(
              puzzle: puzzle,
              placement: placement,
            )) {
          continue;
        }
        if (balanced &&
            !_fitsLessonBalance(
              puzzle: puzzle,
              selected: selected,
              targetCount: effectiveTargetCount,
            )) {
          continue;
        }
        if (seenIds.add(puzzle.id)) {
          selected.add(puzzle);
        }
      }
    }

    final primaryDifficulty = _rotated(
      puzzlesFor(
        ageBandId: ageBandId,
        skillTag: primarySkill,
        difficulty: targetDifficulty,
      ),
      lessonNumber,
    );
    final primarySkillPool = _rotated(
      puzzlesFor(ageBandId: ageBandId, skillTag: primarySkill),
      lessonNumber * 2,
    );
    final difficultyMatch = _rotated(
      puzzlesFor(ageBandId: ageBandId, difficulty: targetDifficulty),
      lessonNumber * 3,
    );
    final reviewMistakes = _rotated(
      _reviewMistakePuzzles(
        ageBandId: ageBandId,
        reviewProfile: reviewProfile,
      ),
      lessonNumber * 4,
    );
    final weakSkillReview = _rotated(
      _weakSkillPuzzles(
        ageBandId: ageBandId,
        reviewProfile: reviewProfile,
      ),
      lessonNumber * 5,
    );
    final bossMix = _rotated(
      puzzlesFor(ageBandId: ageBandId)
          .where(
            (puzzle) =>
                puzzle.type == PuzzleType.mixedBoss ||
                puzzle.difficulty == PuzzleDifficulty.boss,
          )
          .toList(growable: false),
      lessonNumber * 6,
    );
    final adjacent = _rotated(
      puzzlesFor(ageBandId: ageBandId)
          .where((puzzle) => puzzle.skillTag != primarySkill)
          .toList(growable: false),
      lessonNumber * 7,
    );
    final ageBandPool = _rotated(
      puzzlesFor(ageBandId: ageBandId),
      lessonNumber * 8,
    );

    final fixedTakeCount = placement == ContentPlacement.bossNode
        ? fixedPuzzles.length
        : fixedPuzzles.take(reviewProfile.hasSignals ? 1 : 2).length;
    final fixedPool = fixedPuzzles.take(fixedTakeCount).toList(growable: false);
    final pools = placement == ContentPlacement.bossNode
        ? [
            fixedPool,
            bossMix,
            difficultyMatch,
            primaryDifficulty,
            adjacent,
            ageBandPool,
          ]
        : [
            fixedPool,
            reviewMistakes,
            weakSkillReview,
            primaryDifficulty,
            primarySkillPool,
            difficultyMatch,
            adjacent,
            ageBandPool,
          ];

    for (final pool in pools) {
      addCandidates(
        pool,
        balanced: true,
        enforcePlacement: !identical(pool, fixedPool),
      );
    }
    for (final pool in pools) {
      addCandidates(
        pool,
        balanced: false,
        enforcePlacement: !identical(pool, fixedPool),
      );
    }

    return selected;
  }

  static ContentPlacement placementForLesson(Lesson lesson) {
    if (lesson.id == adaptiveReviewLesson.id) {
      return ContentPlacement.adaptiveReview;
    }

    final lessonNumber = _lessonNumber(lesson.id);
    if (lessonNumber % 12 == 0) {
      return ContentPlacement.bossNode;
    }

    return ContentPlacement.mainRoute;
  }

  static ContentPlacementRule placementRuleFor(ContentPlacement placement) {
    return placementRules.firstWhere((rule) => rule.placement == placement);
  }

  static List<ContentFamilySummary> _repeatedFamilySummaries({
    required int threshold,
  }) {
    final families = <String, List<PuzzleDefinition>>{};
    for (final puzzle in allPuzzles) {
      final familyId = _payloadFamilyId(puzzle.payloadRef);
      families.putIfAbsent(familyId, () => []).add(puzzle);
    }

    final summaries = [
      for (final entry in families.entries)
        if (entry.value.length >= threshold)
          ContentFamilySummary(
            familyId: entry.key,
            count: entry.value.length,
            examplePayloadRefs: [
              for (final puzzle in entry.value.take(4)) puzzle.payloadRef,
            ],
          ),
    ];
    return summaries
      ..sort((first, second) {
        final byCount = second.count.compareTo(first.count);
        if (byCount != 0) {
          return byCount;
        }
        return first.familyId.compareTo(second.familyId);
      });
  }

  static String _payloadFamilyId(String payloadRef) {
    final parts = payloadRef.split('.');
    if (parts.length < 2) {
      return payloadRef;
    }
    return '${parts[0]}.${parts[1]}';
  }

  static Lesson lessonForNode(MapNode node) {
    return lessonForId(node.lessonId);
  }

  static Lesson lessonForId(String lessonId) {
    if (lessonId == adaptiveReviewLesson.id) {
      return adaptiveReviewLesson;
    }

    return starterLessons.firstWhere(
      (lesson) => lesson.id == lessonId,
      orElse: () => starterLessons.first,
    );
  }

  static List<LessonStep> stepsForLesson(Lesson lesson) {
    final steps = [
      for (final step in starterLessonSteps)
        if (step.lessonId == lesson.id) step,
    ];
    return [...steps]
      ..sort((first, second) => first.order.compareTo(second.order));
  }

  static PuzzleDefinition puzzleForStep(LessonStep step) {
    return allPuzzles.firstWhere(
      (puzzle) => puzzle.id == step.puzzleId,
      orElse: () => allPuzzles.first,
    );
  }

  static int _lessonNumber(String lessonId) {
    final numberText = lessonId.split('.').last;
    return int.tryParse(numberText) ?? 1;
  }

  static PuzzleDifficulty _difficultyForLessonNumber(int lessonNumber) {
    if (lessonNumber % 12 == 0) {
      return PuzzleDifficulty.boss;
    }
    if (lessonNumber >= 17) {
      return PuzzleDifficulty.hard;
    }
    if (lessonNumber >= 7) {
      return PuzzleDifficulty.normal;
    }
    return PuzzleDifficulty.easy;
  }

  static List<PuzzleDefinition> _rotated(
    List<PuzzleDefinition> puzzles,
    int seed,
  ) {
    if (puzzles.isEmpty) {
      return const [];
    }
    final offset = seed % puzzles.length;
    return [
      ...puzzles.skip(offset),
      ...puzzles.take(offset),
    ];
  }

  static bool _fitsLessonBalance({
    required PuzzleDefinition puzzle,
    required List<PuzzleDefinition> selected,
    required int targetCount,
  }) {
    if (selected.isEmpty) {
      return true;
    }

    final skillCount = selected
        .where((candidate) => candidate.skillTag == puzzle.skillTag)
        .length;
    if (skillCount >= 2) {
      return false;
    }

    final typeCount =
        selected.where((candidate) => candidate.type == puzzle.type).length;
    if (typeCount >= 1 && selected.length < targetCount - 1) {
      return false;
    }

    return true;
  }

  static bool _fitsPlacement({
    required PuzzleDefinition puzzle,
    required ContentPlacement placement,
  }) {
    return switch (placement) {
      ContentPlacement.mainRoute ||
      ContentPlacement.ageTrack ||
      ContentPlacement.adaptiveReview ||
      ContentPlacement.mistakeRepeat ||
      ContentPlacement.weakSkillRecommendation =>
        puzzle.difficulty != PuzzleDifficulty.boss &&
            puzzle.type != PuzzleType.mixedBoss,
      ContentPlacement.dailyChallenge =>
        puzzle.difficulty == PuzzleDifficulty.easy ||
            puzzle.difficulty == PuzzleDifficulty.normal,
      ContentPlacement.bossNode => true,
      ContentPlacement.rewardCollection =>
        puzzle.difficulty == PuzzleDifficulty.normal ||
            puzzle.difficulty == PuzzleDifficulty.hard,
      ContentPlacement.parentAnalytics => true,
    };
  }

  static List<PuzzleDefinition> _reviewMistakePuzzles({
    required AgeBandId ageBandId,
    required PracticeReviewProfile reviewProfile,
  }) {
    if (reviewProfile.mistakePuzzleIds.isEmpty) {
      return const [];
    }

    return [
      for (final puzzleId in reviewProfile.mistakePuzzleIds)
        ...allPuzzles.where(
          (puzzle) =>
              puzzle.ageBandIds.contains(ageBandId) &&
              (puzzle.id == puzzleId || puzzle.payloadRef == puzzleId),
        ),
    ];
  }

  static List<PuzzleDefinition> _weakSkillPuzzles({
    required AgeBandId ageBandId,
    required PracticeReviewProfile reviewProfile,
  }) {
    if (reviewProfile.weakSkillTags.isEmpty) {
      return const [];
    }

    return [
      for (final puzzle in puzzlesFor(ageBandId: ageBandId))
        if (reviewProfile.weakSkillTags.contains(puzzle.skillTag)) puzzle,
    ];
  }
}

SkillTag? _skillTagForSessionSkill(String skill) {
  final normalized = skill.toLowerCase();
  if (normalized.contains('focus') ||
      normalized.contains('attention') ||
      normalized.contains('detail')) {
    return SkillTag.attention;
  }
  if (normalized.contains('memory')) {
    return SkillTag.memory;
  }
  if (normalized.contains('pattern') || normalized.contains('sequence')) {
    return SkillTag.pattern;
  }
  if (normalized.contains('classification') ||
      normalized.contains('sort') ||
      normalized.contains('comparison')) {
    return SkillTag.classification;
  }
  if (normalized.contains('math') ||
      normalized.contains('count') ||
      normalized.contains('addition')) {
    return SkillTag.arithmetic;
  }
  if (normalized.contains('spatial') ||
      normalized.contains('space') ||
      normalized.contains('rotation')) {
    return SkillTag.spatial;
  }
  if (normalized.contains('logic') ||
      normalized.contains('deduction') ||
      normalized.contains('reason')) {
    return SkillTag.reasoning;
  }
  return null;
}

Set<SkillTag> _skillTagsForPuzzleIds(Iterable<String> puzzleIds) {
  final tags = <SkillTag>{};
  for (final puzzleId in puzzleIds) {
    for (final puzzle in FoundationCatalog.allPuzzles) {
      if (puzzle.id == puzzleId || puzzle.payloadRef == puzzleId) {
        tags.add(puzzle.skillTag);
      }
    }
  }
  return tags;
}

class ContentBank {
  const ContentBank._();

  static final List<PuzzleDefinition> seedPuzzles = _buildSeedPuzzles();

  static List<PuzzleDefinition> _buildSeedPuzzles() {
    const families = [
      _PuzzleFamilySeed(
        slug: 'pattern.trail',
        type: PuzzleType.sequenceComplete,
        skillTag: SkillTag.pattern,
        answer: 'next',
        hintKey: 'challengeShapePathHint',
      ),
      _PuzzleFamilySeed(
        slug: 'memory.pairs',
        type: PuzzleType.memoryGrid,
        skillTag: SkillTag.memory,
        answer: 'pair',
        hintKey: 'challengeMemoryPairsHint',
      ),
      _PuzzleFamilySeed(
        slug: 'math.bridge',
        type: PuzzleType.countBridge,
        skillTag: SkillTag.arithmetic,
        answer: 'sum',
        hintKey: 'challengeNumberBridgeHint',
      ),
      _PuzzleFamilySeed(
        slug: 'focus.details',
        type: PuzzleType.attentionScan,
        skillTag: SkillTag.attention,
        answer: 'detail',
        hintKey: 'challengeDetailCountHint',
      ),
      _PuzzleFamilySeed(
        slug: 'focus.tracker',
        type: PuzzleType.attentionScan,
        skillTag: SkillTag.attention,
        answer: 'target',
        hintKey: 'challengeDetailCountHint',
      ),
      _PuzzleFamilySeed(
        slug: 'logic.code',
        type: PuzzleType.codeBreaker,
        skillTag: SkillTag.reasoning,
        answer: 'rule',
        hintKey: 'challengeCodeGridHint',
      ),
      _PuzzleFamilySeed(
        slug: 'space.turn',
        type: PuzzleType.spatialRotation,
        skillTag: SkillTag.spatial,
        answer: 'same',
        hintKey: 'challengeShapeRotationHint',
      ),
      _PuzzleFamilySeed(
        slug: 'sort.odd',
        type: PuzzleType.oddOneOut,
        skillTag: SkillTag.classification,
        answer: 'odd',
        hintKey: 'challengeOddCardHint',
      ),
      _PuzzleFamilySeed(
        slug: 'category.groups',
        type: PuzzleType.categorySort,
        skillTag: SkillTag.classification,
        answer: 'group',
        hintKey: 'challengeOddCardHint',
      ),
      _PuzzleFamilySeed(
        slug: 'route.path',
        type: PuzzleType.pathPuzzle,
        skillTag: SkillTag.spatial,
        answer: 'route',
        hintKey: 'challengeShapeRotationHint',
      ),
      _PuzzleFamilySeed(
        slug: 'analogy.link',
        type: PuzzleType.analogy,
        skillTag: SkillTag.reasoning,
        answer: 'match',
        hintKey: 'challengeCodeGridHint',
      ),
      _PuzzleFamilySeed(
        slug: 'rebus.picture',
        type: PuzzleType.rebus,
        skillTag: SkillTag.reasoning,
        answer: 'word',
        hintKey: 'challengeCodeGridHint',
      ),
      _PuzzleFamilySeed(
        slug: 'compare.weight',
        type: PuzzleType.visualCompare,
        skillTag: SkillTag.arithmetic,
        answer: 'balance',
        hintKey: 'challengeBalanceScaleHint',
      ),
      _PuzzleFamilySeed(
        slug: 'memory.order',
        type: PuzzleType.memoryGrid,
        skillTag: SkillTag.memory,
        answer: 'order',
        hintKey: 'challengeMemoryPairsHint',
      ),
      _PuzzleFamilySeed(
        slug: 'mixed.boss',
        type: PuzzleType.mixedBoss,
        skillTag: SkillTag.reasoning,
        answer: 'boss',
        hintKey: 'challengeCodeGridHint',
      ),
    ];

    final puzzles = <PuzzleDefinition>[];
    for (final family in families) {
      for (var index = 1; index <= 9; index += 1) {
        final difficulty = _difficultyFor(index);
        puzzles.add(
          PuzzleDefinition(
            id: 'puzzle.${family.slug}.${index.toString().padLeft(3, '0')}',
            lessonId: 'lesson.generated',
            type: family.type,
            skillTag: family.skillTag,
            payloadRef:
                '${family.slug}.${difficulty.name}.${index.toString().padLeft(3, '0')}',
            correctAnswerKey: family.answer,
            hintKeys: [family.hintKey],
            ageBandIds: _ageBandsFor(index, difficulty),
            difficulty: difficulty,
            visualMetadata: _visualMetadataFor(
              family: family,
              difficulty: difficulty,
            ),
          ),
        );
      }
    }

    return puzzles;
  }

  static PuzzleDifficulty _difficultyFor(int index) {
    if (index == 9) {
      return PuzzleDifficulty.boss;
    }
    if (index >= 6) {
      return PuzzleDifficulty.hard;
    }
    if (index >= 3) {
      return PuzzleDifficulty.normal;
    }
    return PuzzleDifficulty.easy;
  }

  static List<AgeBandId> _ageBandsFor(
    int index,
    PuzzleDifficulty difficulty,
  ) {
    if (difficulty == PuzzleDifficulty.boss) {
      return const [AgeBandId.age7to8];
    }
    return switch (index % 3) {
      1 => const [AgeBandId.age4to5, AgeBandId.age6],
      2 => const [AgeBandId.age6, AgeBandId.age7to8],
      _ => const [AgeBandId.age4to5, AgeBandId.age6, AgeBandId.age7to8],
    };
  }

  static VisualPuzzleMetadata _visualMetadataFor({
    required _PuzzleFamilySeed family,
    required PuzzleDifficulty difficulty,
  }) {
    final load = switch (difficulty) {
      PuzzleDifficulty.easy => PuzzleCognitiveLoad.light,
      PuzzleDifficulty.normal => PuzzleCognitiveLoad.medium,
      PuzzleDifficulty.hard => PuzzleCognitiveLoad.high,
      PuzzleDifficulty.boss => PuzzleCognitiveLoad.boss,
    };
    final seconds = switch (difficulty) {
      PuzzleDifficulty.easy => 20,
      PuzzleDifficulty.normal => 30,
      PuzzleDifficulty.hard => 45,
      PuzzleDifficulty.boss => 70,
    };
    final bossTags = difficulty == PuzzleDifficulty.boss
        ? [family.skillTag.name, 'boss']
        : const <String>[];

    return switch (family.slug) {
      'pattern.trail' => VisualPuzzleMetadata(
          familyId: 'pattern.sequence_complete',
          worldId: 'space_station',
          characterId: 'brainy',
          sceneAsset: 'world.space_station.background.star_collection_path',
          choiceAssets: const [
            'world.space_station.object.rocket',
            'world.space_station.object.planet',
            'world.space_station.object.star',
          ],
          interactionType: PuzzleInteractionType.tapChoice,
          animationType: PuzzleAnimationType.cardBounce,
          feedbackStyle: PuzzleFeedbackStyle.characterCoach,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'memory.pairs' => VisualPuzzleMetadata(
          familyId: 'memory.pair_match',
          worldId: 'toy_shop',
          characterId: 'lumi',
          sceneAsset: 'world.toy_shop.background.shelf_counter',
          choiceAssets: const [
            'world.toy_shop.object.gift_box',
            'world.toy_shop.object.train_car',
            'world.toy_shop.object.block',
          ],
          interactionType: PuzzleInteractionType.matchPairs,
          animationType: PuzzleAnimationType.objectSnap,
          feedbackStyle: PuzzleFeedbackStyle.characterCoach,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'math.bridge' => VisualPuzzleMetadata(
          familyId: 'math.object_count',
          worldId: 'toy_shop',
          characterId: 'numba',
          sceneAsset: 'world.toy_shop.background.checkout_counter',
          choiceAssets: const [
            'world.toy_shop.object.block',
            'world.toy_shop.object.ball',
            'world.toy_shop.object.price_tag',
          ],
          interactionType: PuzzleInteractionType.tapChoice,
          animationType: PuzzleAnimationType.hintPulse,
          feedbackStyle: PuzzleFeedbackStyle.characterCoach,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'focus.details' || 'focus.tracker' => VisualPuzzleMetadata(
          familyId: 'attention.spot_difference',
          worldId: 'forest_lab',
          characterId: 'mira',
          sceneAsset: 'world.forest_lab.background.leaf_microscope',
          choiceAssets: const [
            'world.forest_lab.object.leaf',
            'world.forest_lab.object.jar',
            'world.forest_lab.object.magnifier',
          ],
          interactionType: PuzzleInteractionType.tapChoice,
          animationType: PuzzleAnimationType.hintPulse,
          feedbackStyle: PuzzleFeedbackStyle.softRetry,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'logic.code' || 'analogy.link' || 'rebus.picture' => VisualPuzzleMetadata(
          familyId: 'reasoning.code_solver',
          worldId: 'robot_town',
          characterId: 'rulo',
          sceneAsset: 'world.robot_town.background.code_console',
          choiceAssets: const [
            'world.robot_town.object.code_tile',
            'world.robot_town.object.switch',
            'world.robot_town.object.circuit_node',
          ],
          interactionType: PuzzleInteractionType.tapChoice,
          animationType: PuzzleAnimationType.cardBounce,
          feedbackStyle: PuzzleFeedbackStyle.characterCoach,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'space.turn' => VisualPuzzleMetadata(
          familyId: 'spatial.shape_rotation',
          worldId: 'shape_garden',
          characterId: 'quadra',
          sceneAsset: 'world.shape_garden.background.shape_flower_bed',
          choiceAssets: const [
            'world.shape_garden.object.shape_flower',
            'world.shape_garden.object.butterfly',
            'world.shape_garden.object.garden_sign',
          ],
          interactionType: PuzzleInteractionType.rotateObject,
          animationType: PuzzleAnimationType.rotateTurn,
          feedbackStyle: PuzzleFeedbackStyle.characterCoach,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'sort.odd' || 'category.groups' => VisualPuzzleMetadata(
          familyId: 'classification.object_sort',
          worldId: 'forest_lab',
          characterId: 'mira',
          sceneAsset: 'world.forest_lab.background.sorting_shelves',
          choiceAssets: const [
            'world.forest_lab.object.seed_packet',
            'world.forest_lab.object.mushroom',
            'world.forest_lab.object.berry',
          ],
          interactionType: PuzzleInteractionType.sortObjects,
          animationType: PuzzleAnimationType.objectSnap,
          feedbackStyle: PuzzleFeedbackStyle.characterCoach,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'route.path' => VisualPuzzleMetadata(
          familyId: 'spatial.route_build',
          worldId: 'space_station',
          characterId: 'quadra',
          sceneAsset: 'world.space_station.background.planet_map',
          choiceAssets: const [
            'world.space_station.object.path_tile',
            'world.space_station.object.fuel_cell',
            'world.space_station.object.control_button',
          ],
          interactionType: PuzzleInteractionType.tracePath,
          animationType: PuzzleAnimationType.pathTrace,
          feedbackStyle: PuzzleFeedbackStyle.characterCoach,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'compare.weight' => VisualPuzzleMetadata(
          familyId: 'math.logic_scales',
          worldId: 'robot_town',
          characterId: 'numba',
          sceneAsset: 'world.robot_town.background.gear_factory',
          choiceAssets: const [
            'world.robot_town.object.gear',
            'world.robot_town.object.battery',
            'world.robot_town.object.robot_part',
          ],
          interactionType: PuzzleInteractionType.dragToTarget,
          animationType: PuzzleAnimationType.objectSnap,
          feedbackStyle: PuzzleFeedbackStyle.characterCoach,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'memory.order' => VisualPuzzleMetadata(
          familyId: 'memory.order_recall',
          worldId: 'space_station',
          characterId: 'lumi',
          sceneAsset: 'world.space_station.background.mission_control_desk',
          choiceAssets: const [
            'world.space_station.object.key_card',
            'world.space_station.object.satellite',
            'world.space_station.object.star',
          ],
          interactionType: PuzzleInteractionType.memoryReveal,
          animationType: PuzzleAnimationType.revealFlip,
          feedbackStyle: PuzzleFeedbackStyle.characterCoach,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
      'mixed.boss' => VisualPuzzleMetadata(
          familyId: 'boss.mixed_challenge',
          worldId: 'space_station',
          characterId: 'brainy',
          sceneAsset: 'world.space_station.background.repair_module',
          choiceAssets: const [
            'world.space_station.object.rocket',
            'world.space_station.object.fuel_cell',
            'world.space_station.object.control_button',
          ],
          interactionType: PuzzleInteractionType.multiStepBoss,
          animationType: PuzzleAnimationType.rewardBurst,
          feedbackStyle: PuzzleFeedbackStyle.bossMilestone,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags.isEmpty ? const ['mixed', 'boss'] : bossTags,
        ),
      _ => VisualPuzzleMetadata(
          familyId: family.slug.replaceAll('.', '_'),
          worldId: 'space_station',
          characterId: 'brainy',
          sceneAsset: 'world.space_station.background.mission_control_desk',
          choiceAssets: const ['world.space_station.object.star'],
          interactionType: PuzzleInteractionType.tapChoice,
          animationType: PuzzleAnimationType.cardBounce,
          feedbackStyle: PuzzleFeedbackStyle.standard,
          estimatedSeconds: seconds,
          cognitiveLoad: load,
          bossMixTags: bossTags,
        ),
    };
  }
}

class CuratedRichPuzzlePack {
  const CuratedRichPuzzlePack._();

  static const String lessonId = 'lesson.curated.rich.001';

  static final List<PuzzleDefinition> puzzles = _buildPuzzles();

  static List<PuzzleDefinition> _buildPuzzles() {
    const seeds = [
      _CuratedPuzzleFamilySeed(
        slug: 'odd.one.out',
        familyId: 'classification.odd_one_out',
        type: PuzzleType.oddOneOut,
        skillTag: SkillTag.classification,
        answer: 'odd',
        hintKey: 'challengeOddCardHint',
        worldId: 'forest_lab',
        characterId: 'mira',
        sceneAsset: 'world.forest_lab.background.sorting_shelves',
        choiceAssets: [
          'world.forest_lab.object.leaf',
          'world.forest_lab.object.jar',
          'world.forest_lab.object.mushroom',
        ],
        interactionType: PuzzleInteractionType.tapChoice,
        animationType: PuzzleAnimationType.cardBounce,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'sequence.complete',
        familyId: 'pattern.sequence_complete',
        type: PuzzleType.sequenceComplete,
        skillTag: SkillTag.pattern,
        answer: 'next',
        hintKey: 'challengeShapePathHint',
        worldId: 'space_station',
        characterId: 'brainy',
        sceneAsset: 'world.space_station.background.star_collection_path',
        choiceAssets: [
          'world.space_station.object.rocket',
          'world.space_station.object.planet',
          'world.space_station.object.star',
        ],
        interactionType: PuzzleInteractionType.tapChoice,
        animationType: PuzzleAnimationType.cardBounce,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'pair.match',
        familyId: 'memory.pair_match',
        type: PuzzleType.memoryGrid,
        skillTag: SkillTag.memory,
        answer: 'pair',
        hintKey: 'challengeMemoryPairsHint',
        worldId: 'toy_shop',
        characterId: 'lumi',
        sceneAsset: 'world.toy_shop.background.shelf_counter',
        choiceAssets: [
          'world.toy_shop.object.gift_box',
          'world.toy_shop.object.train_car',
          'world.toy_shop.object.block',
        ],
        interactionType: PuzzleInteractionType.matchPairs,
        animationType: PuzzleAnimationType.objectSnap,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'memory.order',
        familyId: 'memory.order_recall',
        type: PuzzleType.memoryGrid,
        skillTag: SkillTag.memory,
        answer: 'order',
        hintKey: 'challengeMemoryPairsHint',
        worldId: 'space_station',
        characterId: 'lumi',
        sceneAsset: 'world.space_station.background.mission_control_desk',
        choiceAssets: [
          'world.space_station.object.key_card',
          'world.space_station.object.satellite',
          'world.space_station.object.star',
        ],
        interactionType: PuzzleInteractionType.memoryReveal,
        animationType: PuzzleAnimationType.revealFlip,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'route.build',
        familyId: 'spatial.route_build',
        type: PuzzleType.pathPuzzle,
        skillTag: SkillTag.spatial,
        answer: 'route',
        hintKey: 'challengeShapeRotationHint',
        worldId: 'space_station',
        characterId: 'quadra',
        sceneAsset: 'world.space_station.background.planet_map',
        choiceAssets: [
          'world.space_station.object.path_tile',
          'world.space_station.object.fuel_cell',
          'world.space_station.object.control_button',
        ],
        interactionType: PuzzleInteractionType.tracePath,
        animationType: PuzzleAnimationType.pathTrace,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'object.count',
        familyId: 'math.object_count',
        type: PuzzleType.countBridge,
        skillTag: SkillTag.arithmetic,
        answer: 'count',
        hintKey: 'challengeToyCountHint',
        worldId: 'toy_shop',
        characterId: 'numba',
        sceneAsset: 'world.toy_shop.background.checkout_counter',
        choiceAssets: [
          'world.toy_shop.object.block',
          'world.toy_shop.object.ball',
          'world.toy_shop.object.price_tag',
        ],
        interactionType: PuzzleInteractionType.tapChoice,
        animationType: PuzzleAnimationType.hintPulse,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'group.compare',
        familyId: 'math.group_compare',
        type: PuzzleType.visualCompare,
        skillTag: SkillTag.arithmetic,
        answer: 'compare',
        hintKey: 'challengeDetailCountHint',
        worldId: 'toy_shop',
        characterId: 'numba',
        sceneAsset: 'world.toy_shop.background.block_corner',
        choiceAssets: [
          'world.toy_shop.object.block',
          'world.toy_shop.object.ball',
          'world.toy_shop.object.basket',
        ],
        interactionType: PuzzleInteractionType.tapChoice,
        animationType: PuzzleAnimationType.hintPulse,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'shadow.match',
        familyId: 'attention.shadow_match',
        type: PuzzleType.attentionScan,
        skillTag: SkillTag.attention,
        answer: 'shadow',
        hintKey: 'challengeShadowMatchHint',
        worldId: 'shape_garden',
        characterId: 'mira',
        sceneAsset: 'world.shape_garden.background.butterfly_board',
        choiceAssets: [
          'world.shape_garden.object.butterfly',
          'world.shape_garden.object.shape_flower',
          'world.shape_garden.object.garden_sign',
        ],
        interactionType: PuzzleInteractionType.tapChoice,
        animationType: PuzzleAnimationType.hintPulse,
        feedbackStyle: PuzzleFeedbackStyle.softRetry,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'shape.rotation',
        familyId: 'spatial.shape_rotation',
        type: PuzzleType.spatialRotation,
        skillTag: SkillTag.spatial,
        answer: 'same',
        hintKey: 'challengeShapeRotationHint',
        worldId: 'shape_garden',
        characterId: 'quadra',
        sceneAsset: 'world.shape_garden.background.shape_flower_bed',
        choiceAssets: [
          'world.shape_garden.object.shape_flower',
          'world.shape_garden.object.stone',
          'world.shape_garden.object.petal',
        ],
        interactionType: PuzzleInteractionType.rotateObject,
        animationType: PuzzleAnimationType.rotateTurn,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'rule.detect',
        familyId: 'pattern.rule_detect',
        type: PuzzleType.sequenceComplete,
        skillTag: SkillTag.pattern,
        answer: 'rule',
        hintKey: 'challengeCodeGridHint',
        worldId: 'robot_town',
        characterId: 'rulo',
        sceneAsset: 'world.robot_town.background.circuit_board',
        choiceAssets: [
          'world.robot_town.object.code_tile',
          'world.robot_town.object.switch',
          'world.robot_town.object.circuit_node',
        ],
        interactionType: PuzzleInteractionType.tapChoice,
        animationType: PuzzleAnimationType.cardBounce,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'logic.scales',
        familyId: 'math.logic_scales',
        type: PuzzleType.visualCompare,
        skillTag: SkillTag.arithmetic,
        answer: 'balance',
        hintKey: 'challengeBalanceScaleHint',
        worldId: 'robot_town',
        characterId: 'numba',
        sceneAsset: 'world.robot_town.background.gear_factory',
        choiceAssets: [
          'world.robot_town.object.gear',
          'world.robot_town.object.battery',
          'world.robot_town.object.robot_part',
        ],
        interactionType: PuzzleInteractionType.dragToTarget,
        animationType: PuzzleAnimationType.objectSnap,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'object.sort',
        familyId: 'classification.object_sort',
        type: PuzzleType.categorySort,
        skillTag: SkillTag.classification,
        answer: 'group',
        hintKey: 'challengeOddCardHint',
        worldId: 'forest_lab',
        characterId: 'mira',
        sceneAsset: 'world.forest_lab.background.garden_workbench',
        choiceAssets: [
          'world.forest_lab.object.seed_packet',
          'world.forest_lab.object.jar',
          'world.forest_lab.object.leaf',
        ],
        interactionType: PuzzleInteractionType.sortObjects,
        animationType: PuzzleAnimationType.objectSnap,
        feedbackStyle: PuzzleFeedbackStyle.characterCoach,
      ),
      _CuratedPuzzleFamilySeed(
        slug: 'mixed.boss',
        familyId: 'boss.mixed_challenge',
        type: PuzzleType.mixedBoss,
        skillTag: SkillTag.reasoning,
        answer: 'boss',
        hintKey: 'challengeCodeGridHint',
        worldId: 'space_station',
        characterId: 'brainy',
        sceneAsset: 'world.space_station.background.repair_module',
        choiceAssets: [
          'world.space_station.object.rocket',
          'world.space_station.object.fuel_cell',
          'world.space_station.object.control_button',
        ],
        interactionType: PuzzleInteractionType.multiStepBoss,
        animationType: PuzzleAnimationType.rewardBurst,
        feedbackStyle: PuzzleFeedbackStyle.bossMilestone,
      ),
    ];

    return [
      for (final seed in seeds)
        for (var index = 1; index <= 5; index += 1)
          _puzzleFor(seed: seed, index: index),
    ];
  }

  static PuzzleDefinition _puzzleFor({
    required _CuratedPuzzleFamilySeed seed,
    required int index,
  }) {
    final difficulty = _difficultyFor(index);
    final paddedIndex = index.toString().padLeft(3, '0');
    final payloadSlug = seed.slug.replaceAll('.', '-');

    return PuzzleDefinition(
      id: 'puzzle.curated.${seed.slug}.$paddedIndex',
      lessonId: lessonId,
      type: seed.type,
      skillTag: seed.skillTag,
      payloadRef: 'curated.$payloadSlug.$paddedIndex',
      correctAnswerKey: seed.answer,
      hintKeys: [seed.hintKey],
      ageBandIds: _ageBandsFor(index, difficulty),
      difficulty: difficulty,
      visualMetadata: VisualPuzzleMetadata(
        familyId: seed.familyId,
        worldId: seed.worldId,
        characterId: seed.characterId,
        sceneAsset: seed.sceneAsset,
        choiceAssets: seed.choiceAssets,
        interactionType: seed.interactionType,
        animationType: seed.animationType,
        feedbackStyle: seed.feedbackStyle,
        estimatedSeconds: _estimatedSecondsFor(difficulty),
        cognitiveLoad: _cognitiveLoadFor(difficulty),
        bossMixTags: seed.type == PuzzleType.mixedBoss
            ? const ['mixed', 'boss', 'first_pack']
            : const [],
      ),
    );
  }

  static PuzzleDifficulty _difficultyFor(int index) {
    return switch (index) {
      1 || 2 => PuzzleDifficulty.easy,
      3 || 4 => PuzzleDifficulty.normal,
      _ => PuzzleDifficulty.hard,
    };
  }

  static List<AgeBandId> _ageBandsFor(
    int index,
    PuzzleDifficulty difficulty,
  ) {
    if (difficulty == PuzzleDifficulty.hard) {
      return const [AgeBandId.age6, AgeBandId.age7to8];
    }
    return switch (index) {
      1 => const [AgeBandId.age4to5, AgeBandId.age6],
      2 => const [AgeBandId.age4to5, AgeBandId.age6, AgeBandId.age7to8],
      3 => const [AgeBandId.age6, AgeBandId.age7to8],
      4 => const [AgeBandId.age4to5, AgeBandId.age6, AgeBandId.age7to8],
      _ => const [AgeBandId.age7to8],
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

  static PuzzleCognitiveLoad _cognitiveLoadFor(PuzzleDifficulty difficulty) {
    return switch (difficulty) {
      PuzzleDifficulty.easy => PuzzleCognitiveLoad.light,
      PuzzleDifficulty.normal => PuzzleCognitiveLoad.medium,
      PuzzleDifficulty.hard => PuzzleCognitiveLoad.high,
      PuzzleDifficulty.boss => PuzzleCognitiveLoad.boss,
    };
  }
}

class _PuzzleFamilySeed {
  const _PuzzleFamilySeed({
    required this.slug,
    required this.type,
    required this.skillTag,
    required this.answer,
    required this.hintKey,
  });

  final String slug;
  final PuzzleType type;
  final SkillTag skillTag;
  final String answer;
  final String hintKey;
}

class _CuratedPuzzleFamilySeed {
  const _CuratedPuzzleFamilySeed({
    required this.slug,
    required this.familyId,
    required this.type,
    required this.skillTag,
    required this.answer,
    required this.hintKey,
    required this.worldId,
    required this.characterId,
    required this.sceneAsset,
    required this.choiceAssets,
    required this.interactionType,
    required this.animationType,
    required this.feedbackStyle,
  });

  final String slug;
  final String familyId;
  final PuzzleType type;
  final SkillTag skillTag;
  final String answer;
  final String hintKey;
  final String worldId;
  final String characterId;
  final String sceneAsset;
  final List<String> choiceAssets;
  final PuzzleInteractionType interactionType;
  final PuzzleAnimationType animationType;
  final PuzzleFeedbackStyle feedbackStyle;
}
