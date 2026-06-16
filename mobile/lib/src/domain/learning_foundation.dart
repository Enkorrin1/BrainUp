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
  decoration,
}

enum RewardRarity {
  common,
  rare,
  epic,
}

enum MapNodeState {
  completed,
  current,
  locked,
}

enum StoryWorldState {
  locked,
  active,
  repaired,
  completed,
}

enum WeeklyEventState {
  upcoming,
  active,
  completed,
  expired,
}

enum CharacterCoachMoment {
  neutral,
  hint,
  correct,
  retry,
  streak,
  boss,
  celebrate,
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

class StoryWorldDefinition {
  const StoryWorldDefinition({
    required this.id,
    required this.title,
    required this.missionTitle,
    required this.missionSummary,
    required this.completionSummary,
    required this.helperCharacterId,
    required this.lessonIds,
    required this.accentHex,
  });

  final String id;
  final String title;
  final String missionTitle;
  final String missionSummary;
  final String completionSummary;
  final String helperCharacterId;
  final List<String> lessonIds;
  final int accentHex;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'missionTitle': missionTitle,
      'missionSummary': missionSummary,
      'completionSummary': completionSummary,
      'helperCharacterId': helperCharacterId,
      'lessonIds': lessonIds,
      'accentHex': accentHex,
    };
  }
}

class StoryWorldProgress {
  const StoryWorldProgress({
    required this.world,
    required this.state,
    required this.completedLessonCount,
  });

  final StoryWorldDefinition world;
  final StoryWorldState state;
  final int completedLessonCount;

  int get totalLessonCount {
    return world.lessonIds.length;
  }

  double get progress {
    if (totalLessonCount == 0) {
      return 0;
    }
    return completedLessonCount / totalLessonCount;
  }

  Map<String, Object?> toJson() {
    return {
      'worldId': world.id,
      'state': state.name,
      'completedLessonCount': completedLessonCount,
      'totalLessonCount': totalLessonCount,
      'progress': progress,
    };
  }
}

class WeeklyEventDefinition {
  const WeeklyEventDefinition({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.bannerLabel,
    required this.startDateIso8601,
    required this.endDateIso8601,
    required this.rewardId,
    required this.targetLessonCount,
    required this.accentHex,
    this.worldIds = const [],
    this.skillTags = const [],
    this.puzzleTypes = const [],
    this.featuredLessonIds = const [],
  });

  final String id;
  final String title;
  final String subtitle;
  final String bannerLabel;
  final String startDateIso8601;
  final String endDateIso8601;
  final String rewardId;
  final int targetLessonCount;
  final int accentHex;
  final List<String> worldIds;
  final List<SkillTag> skillTags;
  final List<PuzzleType> puzzleTypes;
  final List<String> featuredLessonIds;

  DateTime get startDate {
    return _dateOnly(DateTime.parse(startDateIso8601));
  }

  DateTime get endDate {
    return _dateOnly(DateTime.parse(endDateIso8601));
  }

  bool isActiveOn(DateTime date) {
    final day = _dateOnly(date);
    return !day.isBefore(startDate) && !day.isAfter(endDate);
  }

  WeeklyEventState stateFor({
    required DateTime now,
    required int completedLessonCount,
  }) {
    if (completedLessonCount >= targetLessonCount) {
      return WeeklyEventState.completed;
    }

    final day = _dateOnly(now);
    if (day.isBefore(startDate)) {
      return WeeklyEventState.upcoming;
    }
    if (day.isAfter(endDate)) {
      return WeeklyEventState.expired;
    }
    return WeeklyEventState.active;
  }

  int remainingDays(DateTime now) {
    final day = _dateOnly(now);
    if (day.isAfter(endDate)) {
      return 0;
    }

    return endDate.difference(day).inDays + 1;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'bannerLabel': bannerLabel,
      'startDateIso8601': startDateIso8601,
      'endDateIso8601': endDateIso8601,
      'rewardId': rewardId,
      'targetLessonCount': targetLessonCount,
      'accentHex': accentHex,
      'worldIds': worldIds,
      'skillTags': [
        for (final skillTag in skillTags) skillTag.name,
      ],
      'puzzleTypes': [
        for (final puzzleType in puzzleTypes) puzzleType.name,
      ],
      'featuredLessonIds': featuredLessonIds,
    };
  }
}

class WeeklyEventProgress {
  const WeeklyEventProgress({
    required this.event,
    required this.completedLessonCount,
    required this.matchingPuzzleCount,
    required this.remainingDays,
    required this.state,
  });

  final WeeklyEventDefinition event;
  final int completedLessonCount;
  final int matchingPuzzleCount;
  final int remainingDays;
  final WeeklyEventState state;

  int get targetLessonCount {
    return event.targetLessonCount;
  }

  double get progress {
    if (targetLessonCount <= 0) {
      return 0;
    }

    return completedLessonCount.clamp(0, targetLessonCount) / targetLessonCount;
  }

  bool get completed {
    return state == WeeklyEventState.completed;
  }

  Map<String, Object?> toJson() {
    return {
      'eventId': event.id,
      'state': state.name,
      'completedLessonCount': completedLessonCount,
      'targetLessonCount': targetLessonCount,
      'progress': progress,
      'remainingDays': remainingDays,
      'matchingPuzzleCount': matchingPuzzleCount,
      'rewardId': event.rewardId,
    };
  }
}

class CharacterCoachDefinition {
  const CharacterCoachDefinition({
    required this.id,
    required this.displayName,
    required this.role,
    required this.shortRole,
    required this.skillTags,
    required this.worldIds,
    required this.preferredInteractionTypes,
    required this.accentHex,
    required this.avatarAssetKey,
    required this.neutralLine,
    required this.hintLine,
    required this.correctLine,
    required this.retryLine,
    required this.streakLine,
    required this.bossLine,
    required this.celebrateLine,
  });

  final String id;
  final String displayName;
  final String role;
  final String shortRole;
  final List<SkillTag> skillTags;
  final List<String> worldIds;
  final List<PuzzleInteractionType> preferredInteractionTypes;
  final int accentHex;
  final String avatarAssetKey;
  final String neutralLine;
  final String hintLine;
  final String correctLine;
  final String retryLine;
  final String streakLine;
  final String bossLine;
  final String celebrateLine;

  bool supportsSkill(SkillTag skillTag) {
    return skillTags.contains(skillTag);
  }

  bool supportsWorld(String worldId) {
    return worldIds.contains(worldId);
  }

  String lineFor(CharacterCoachMoment moment) {
    return switch (moment) {
      CharacterCoachMoment.neutral => neutralLine,
      CharacterCoachMoment.hint => hintLine,
      CharacterCoachMoment.correct => correctLine,
      CharacterCoachMoment.retry => retryLine,
      CharacterCoachMoment.streak => streakLine,
      CharacterCoachMoment.boss => bossLine,
      CharacterCoachMoment.celebrate => celebrateLine,
    };
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'role': role,
      'shortRole': shortRole,
      'skillTags': [
        for (final skillTag in skillTags) skillTag.name,
      ],
      'worldIds': worldIds,
      'preferredInteractionTypes': [
        for (final interactionType in preferredInteractionTypes)
          interactionType.name,
      ],
      'accentHex': accentHex,
      'avatarAssetKey': avatarAssetKey,
      'lines': {
        'neutral': neutralLine,
        'hint': hintLine,
        'correct': correctLine,
        'retry': retryLine,
        'streak': streakLine,
        'boss': bossLine,
        'celebrate': celebrateLine,
      },
    };
  }
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

class ContentMilestoneMetric {
  const ContentMilestoneMetric({
    required this.id,
    required this.label,
    required this.current,
    required this.target,
    required this.unit,
  });

  final String id;
  final String label;
  final int current;
  final int target;
  final String unit;

  bool get passes {
    return current >= target;
  }

  int get remaining {
    final gap = target - current;
    return gap < 0 ? 0 : gap;
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'label': label,
      'current': current,
      'target': target,
      'unit': unit,
      'passes': passes,
      'remaining': remaining,
    };
  }
}

class ContentMilestoneReport {
  const ContentMilestoneReport({
    required this.metrics,
  });

  final List<ContentMilestoneMetric> metrics;

  bool get passes {
    return metrics.every((metric) => metric.passes);
  }

  List<ContentMilestoneMetric> get gaps {
    return [
      for (final metric in metrics)
        if (!metric.passes) metric,
    ];
  }

  int get passedCount {
    return metrics.where((metric) => metric.passes).length;
  }

  Map<String, Object?> toJson() {
    return {
      'passes': passes,
      'passedCount': passedCount,
      'totalCount': metrics.length,
      'metrics': [
        for (final metric in metrics) metric.toJson(),
      ],
      'gaps': [
        for (final metric in gaps) metric.toJson(),
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
    required this.milestoneReport,
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
  final ContentMilestoneReport milestoneReport;

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
      'largeContentMilestone': milestoneReport.toJson(),
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
    required this.accentHex,
    this.worldId,
    this.characterId,
    this.rarity = RewardRarity.common,
  });

  final String id;
  final RewardType type;
  final String titleKey;
  final String descriptionKey;
  final String visualKey;
  final int xpCost;
  final int unlockedAfterStars;
  final int accentHex;
  final String? worldId;
  final String? characterId;
  final RewardRarity rarity;

  bool isUnlockedForStars(int stars) {
    return stars >= unlockedAfterStars;
  }

  bool get canEquip {
    return switch (type) {
      RewardType.avatarItem ||
      RewardType.decoration ||
      RewardType.badge =>
        true,
      RewardType.sticker || RewardType.booster => false,
    };
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'type': type.name,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'visualKey': visualKey,
      'xpCost': xpCost,
      'unlockedAfterStars': unlockedAfterStars,
      'accentHex': accentHex,
      'rarity': rarity.name,
      if (worldId != null) 'worldId': worldId,
      if (characterId != null) 'characterId': characterId,
      'canEquip': canEquip,
    };
  }
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

  static const List<CharacterCoachDefinition> characterCoaches = [
    CharacterCoachDefinition(
      id: 'brainy',
      displayName: 'Brainy',
      role: 'Main BrainUp guide for mixed logic quests and big moments.',
      shortRole: 'Logic guide',
      skillTags: [
        SkillTag.attention,
        SkillTag.memory,
        SkillTag.pattern,
        SkillTag.classification,
        SkillTag.arithmetic,
        SkillTag.spatial,
        SkillTag.reasoning,
      ],
      worldIds: [
        'space_station',
        'riddle_castle',
        'toy_shop',
        'shape_garden',
      ],
      preferredInteractionTypes: [
        PuzzleInteractionType.tapChoice,
        PuzzleInteractionType.matchPairs,
        PuzzleInteractionType.multiStepBoss,
      ],
      accentHex: 0xFF42F4D2,
      avatarAssetKey: 'character.brainy.neutral',
      neutralLine: 'Ready for a short brain quest?',
      hintLine: 'Start with the easiest clue.',
      correctLine: 'Yes. You found the idea.',
      retryLine: 'Good try. Look one step closer.',
      streakLine: 'Your brain route is warming up.',
      bossLine: 'Use every clue. Boss puzzles need teamwork.',
      celebrateLine: 'Mission progress unlocked. Nice thinking.',
    ),
    CharacterCoachDefinition(
      id: 'lumi',
      displayName: 'Lumi',
      role: 'Memory guide for order, pairs, and recall puzzles.',
      shortRole: 'Memory coach',
      skillTags: [
        SkillTag.memory,
        SkillTag.attention,
      ],
      worldIds: [
        'space_station',
        'underwater_city',
        'toy_shop',
        'train_expedition',
      ],
      preferredInteractionTypes: [
        PuzzleInteractionType.matchPairs,
        PuzzleInteractionType.memoryReveal,
        PuzzleInteractionType.reorderCards,
      ],
      accentHex: 0xFF5C8EF7,
      avatarAssetKey: 'character.lumi.neutral',
      neutralLine: 'Let us keep the order in mind.',
      hintLine: 'Remember the first and last object first.',
      correctLine: 'Great memory. That stayed in place.',
      retryLine: 'Almost. Picture where it was before.',
      streakLine: 'Your memory light is getting brighter.',
      bossLine: 'Hold the clues in order before you choose.',
      celebrateLine: 'You remembered the route beautifully.',
    ),
    CharacterCoachDefinition(
      id: 'quadra',
      displayName: 'Quadra',
      role: 'Shape and space guide for turns, paths, and outlines.',
      shortRole: 'Shape coach',
      skillTags: [
        SkillTag.spatial,
        SkillTag.attention,
      ],
      worldIds: [
        'shape_garden',
        'space_station',
        'dinosaur_island',
        'robot_town',
      ],
      preferredInteractionTypes: [
        PuzzleInteractionType.rotateObject,
        PuzzleInteractionType.tracePath,
        PuzzleInteractionType.dragToTarget,
      ],
      accentHex: 0xFF9C6AF2,
      avatarAssetKey: 'character.quadra.neutral',
      neutralLine: 'Shapes can turn, but they stay themselves.',
      hintLine: 'Look at the outline first.',
      correctLine: 'Nice. The shape still matches.',
      retryLine: 'Check the direction of the point.',
      streakLine: 'Your shape sense is getting sharper.',
      bossLine: 'Turn the shape in your mind first.',
      celebrateLine: 'The path fits. Quadra is impressed.',
    ),
    CharacterCoachDefinition(
      id: 'numba',
      displayName: 'Numba',
      role: 'Math guide for counting, comparing, and number bridges.',
      shortRole: 'Math coach',
      skillTags: [
        SkillTag.arithmetic,
      ],
      worldIds: [
        'toy_shop',
        'robot_town',
        'dinosaur_island',
        'underwater_city',
      ],
      preferredInteractionTypes: [
        PuzzleInteractionType.tapChoice,
        PuzzleInteractionType.dragToTarget,
        PuzzleInteractionType.sortObjects,
      ],
      accentHex: 0xFFFFD15C,
      avatarAssetKey: 'character.numba.neutral',
      neutralLine: 'Let us count carefully.',
      hintLine: 'Count the left side, then the right side.',
      correctLine: 'Yes. The numbers balance.',
      retryLine: 'Almost. Touch each object once as you count.',
      streakLine: 'Those numbers are lining up.',
      bossLine: 'Check each number before the final answer.',
      celebrateLine: 'Count badge energy unlocked.',
    ),
    CharacterCoachDefinition(
      id: 'rulo',
      displayName: 'Rulo',
      role: 'Logic guide for rules, codes, patterns, and clues.',
      shortRole: 'Rule coach',
      skillTags: [
        SkillTag.pattern,
        SkillTag.classification,
        SkillTag.reasoning,
      ],
      worldIds: [
        'robot_town',
        'riddle_castle',
        'detective_academy',
        'forest_lab',
      ],
      preferredInteractionTypes: [
        PuzzleInteractionType.tapChoice,
        PuzzleInteractionType.reorderCards,
        PuzzleInteractionType.tracePath,
        PuzzleInteractionType.multiStepBoss,
      ],
      accentHex: 0xFFFF9D2E,
      avatarAssetKey: 'character.rulo.neutral',
      neutralLine: 'Every puzzle has a clue.',
      hintLine: 'Compare what changed from left to right.',
      correctLine: 'Exactly. You found the rule.',
      retryLine: 'Close. Check the first clue again.',
      streakLine: 'Your clue trail is getting longer.',
      bossLine: 'Solve one rule, then the next.',
      celebrateLine: 'Rule found. Gate unlocked.',
    ),
    CharacterCoachDefinition(
      id: 'mira',
      displayName: 'Mira',
      role: 'Attention guide for details, sorting, and visual clues.',
      shortRole: 'Focus coach',
      skillTags: [
        SkillTag.attention,
        SkillTag.classification,
        SkillTag.memory,
      ],
      worldIds: [
        'forest_lab',
        'underwater_city',
        'shape_garden',
        'detective_academy',
      ],
      preferredInteractionTypes: [
        PuzzleInteractionType.tapChoice,
        PuzzleInteractionType.sortObjects,
        PuzzleInteractionType.memoryReveal,
      ],
      accentHex: 0xFFA7F46A,
      avatarAssetKey: 'character.mira.neutral',
      neutralLine: 'Small details can help.',
      hintLine: 'Check color, size, and position.',
      correctLine: 'Great focus. You spotted it.',
      retryLine: 'Almost. Look at the outline again.',
      streakLine: 'Your focus trail is clear.',
      bossLine: 'Scan every detail before the final choice.',
      celebrateLine: 'The details are sorted and shining.',
    ),
  ];

  static const List<StoryWorldDefinition> storyWorlds = [
    StoryWorldDefinition(
      id: 'space_station',
      title: 'Space Station',
      missionTitle: 'Repair the rocket route',
      missionSummary:
          'Help Brainy collect star parts and open the launch path.',
      completionSummary: 'The rocket route is repaired and ready to fly.',
      helperCharacterId: 'brainy',
      lessonIds: ['lesson.001', 'lesson.002', 'lesson.003'],
      accentHex: 0xFF42F4D2,
    ),
    StoryWorldDefinition(
      id: 'forest_lab',
      title: 'Forest Lab',
      missionTitle: 'Sort the living clues',
      missionSummary: 'Help Mira spot details and organize forest samples.',
      completionSummary: 'The forest lab is tidy and full of discoveries.',
      helperCharacterId: 'mira',
      lessonIds: ['lesson.004', 'lesson.005', 'lesson.006'],
      accentHex: 0xFFA7F46A,
    ),
    StoryWorldDefinition(
      id: 'robot_town',
      title: 'Robot Town',
      missionTitle: 'Restart the circuit parade',
      missionSummary: 'Help Rulo decode rules so the robots can march again.',
      completionSummary: 'Robot Town is buzzing with working circuits.',
      helperCharacterId: 'rulo',
      lessonIds: ['lesson.007', 'lesson.008', 'lesson.009'],
      accentHex: 0xFFFFD15C,
    ),
    StoryWorldDefinition(
      id: 'shape_garden',
      title: 'Shape Garden',
      missionTitle: 'Grow the pattern flowers',
      missionSummary: 'Help Quadra turn shapes and complete garden paths.',
      completionSummary: 'The Shape Garden blooms in perfect patterns.',
      helperCharacterId: 'quadra',
      lessonIds: ['lesson.010', 'lesson.011', 'lesson.012'],
      accentHex: 0xFF9C6AF2,
    ),
    StoryWorldDefinition(
      id: 'toy_shop',
      title: 'Toy Shop',
      missionTitle: 'Pack the clever toy orders',
      missionSummary: 'Help Numba count, compare, and match playful objects.',
      completionSummary: 'Every toy order is packed and ready.',
      helperCharacterId: 'numba',
      lessonIds: ['lesson.013', 'lesson.014', 'lesson.015'],
      accentHex: 0xFFFF9D2E,
    ),
    StoryWorldDefinition(
      id: 'underwater_city',
      title: 'Underwater City',
      missionTitle: 'Light the coral signals',
      missionSummary: 'Help Lumi remember signal patterns under the waves.',
      completionSummary: 'The coral signals shine across the city.',
      helperCharacterId: 'lumi',
      lessonIds: ['lesson.016', 'lesson.017', 'lesson.018'],
      accentHex: 0xFF5C8EF7,
    ),
    StoryWorldDefinition(
      id: 'dinosaur_island',
      title: 'Dinosaur Island',
      missionTitle: 'Find the fossil trail',
      missionSummary:
          'Follow clues, compare tracks, and uncover the hidden trail.',
      completionSummary: 'The fossil trail is mapped for the explorers.',
      helperCharacterId: 'mira',
      lessonIds: ['lesson.019', 'lesson.020', 'lesson.021'],
      accentHex: 0xFFFF6F7D,
    ),
    StoryWorldDefinition(
      id: 'riddle_castle',
      title: 'Riddle Castle',
      missionTitle: 'Open the final logic gate',
      missionSummary:
          'Combine memory, math, patterns, and reasoning to unlock the castle.',
      completionSummary: 'The final logic gate opens for the BrainUp team.',
      helperCharacterId: 'brainy',
      lessonIds: ['lesson.022', 'lesson.023', 'lesson.024'],
      accentHex: 0xFFE9C46A,
    ),
  ];

  static const List<RewardDefinition> collectionRewards = [
    RewardDefinition(
      id: 'reward.sticker.star_helper',
      type: RewardType.sticker,
      titleKey: 'Star helper',
      descriptionKey: 'A first bright sticker for starting the route.',
      visualKey: 'assets/images/generated/astronaut.png',
      xpCost: 0,
      unlockedAfterStars: 0,
      accentHex: 0xFF42F4D2,
      worldId: 'space_station',
      characterId: 'brainy',
    ),
    RewardDefinition(
      id: 'reward.sticker.brave_rocket',
      type: RewardType.sticker,
      titleKey: 'Brave rocket',
      descriptionKey: 'Unlocked after the first completed lesson.',
      visualKey: 'assets/images/generated/rocket.png',
      xpCost: 0,
      unlockedAfterStars: 1,
      accentHex: 0xFFFF6F7D,
      worldId: 'space_station',
      characterId: 'brainy',
    ),
    RewardDefinition(
      id: 'reward.decoration.star_window',
      type: RewardType.decoration,
      titleKey: 'Star window',
      descriptionKey: 'A glowing window for the collection room.',
      visualKey: 'icon.window',
      xpCost: 0,
      unlockedAfterStars: 2,
      accentHex: 0xFF5C8EF7,
      worldId: 'space_station',
      rarity: RewardRarity.rare,
    ),
    RewardDefinition(
      id: 'reward.outfit.brainy_nova',
      type: RewardType.avatarItem,
      titleKey: 'Brainy Nova suit',
      descriptionKey: 'A launch suit for the main guide.',
      visualKey: 'character.brainy.outfit.nova',
      xpCost: 0,
      unlockedAfterStars: 3,
      accentHex: 0xFF42F4D2,
      worldId: 'space_station',
      characterId: 'brainy',
      rarity: RewardRarity.rare,
    ),
    RewardDefinition(
      id: 'reward.badge.memory_spark',
      type: RewardType.badge,
      titleKey: 'Memory spark',
      descriptionKey: 'A badge for keeping clues in mind.',
      visualKey: 'icon.psychology',
      xpCost: 0,
      unlockedAfterStars: 4,
      accentHex: 0xFF5C8EF7,
      characterId: 'lumi',
    ),
    RewardDefinition(
      id: 'reward.sticker.forest_sprout',
      type: RewardType.sticker,
      titleKey: 'Forest sprout',
      descriptionKey: 'A detail-hunting sticker from Forest Lab.',
      visualKey: 'assets/images/generated/planet.png',
      xpCost: 0,
      unlockedAfterStars: 5,
      accentHex: 0xFFA7F46A,
      worldId: 'forest_lab',
      characterId: 'mira',
    ),
    RewardDefinition(
      id: 'reward.decoration.lab_shelf',
      type: RewardType.decoration,
      titleKey: 'Lab shelf',
      descriptionKey: 'A tidy shelf for curious discoveries.',
      visualKey: 'icon.science',
      xpCost: 0,
      unlockedAfterStars: 6,
      accentHex: 0xFFA7F46A,
      worldId: 'forest_lab',
    ),
    RewardDefinition(
      id: 'reward.outfit.mira_explorer',
      type: RewardType.avatarItem,
      titleKey: 'Mira explorer cloak',
      descriptionKey: 'A focus cloak for spotting small details.',
      visualKey: 'character.mira.outfit.explorer',
      xpCost: 0,
      unlockedAfterStars: 8,
      accentHex: 0xFFA7F46A,
      worldId: 'forest_lab',
      characterId: 'mira',
      rarity: RewardRarity.rare,
    ),
    RewardDefinition(
      id: 'reward.badge.focus_lens',
      type: RewardType.badge,
      titleKey: 'Focus lens',
      descriptionKey: 'A badge for careful attention puzzles.',
      visualKey: 'icon.center_focus',
      xpCost: 0,
      unlockedAfterStars: 10,
      accentHex: 0xFFA7F46A,
      worldId: 'forest_lab',
      characterId: 'mira',
    ),
    RewardDefinition(
      id: 'reward.sticker.circuit_bot',
      type: RewardType.sticker,
      titleKey: 'Circuit bot',
      descriptionKey: 'A robot sticker for rule detectives.',
      visualKey: 'assets/images/generated/sticker.png',
      xpCost: 0,
      unlockedAfterStars: 12,
      accentHex: 0xFFFFD15C,
      worldId: 'robot_town',
      characterId: 'rulo',
    ),
    RewardDefinition(
      id: 'reward.outfit.rulo_circuit',
      type: RewardType.avatarItem,
      titleKey: 'Rulo circuit cape',
      descriptionKey: 'A cape for finding hidden rules.',
      visualKey: 'character.rulo.outfit.circuit',
      xpCost: 0,
      unlockedAfterStars: 15,
      accentHex: 0xFFFF9D2E,
      worldId: 'robot_town',
      characterId: 'rulo',
      rarity: RewardRarity.rare,
    ),
    RewardDefinition(
      id: 'reward.decoration.parade_lights',
      type: RewardType.decoration,
      titleKey: 'Parade lights',
      descriptionKey: 'Robot Town lights for the collection room.',
      visualKey: 'icon.lightbulb',
      xpCost: 0,
      unlockedAfterStars: 18,
      accentHex: 0xFFFFD15C,
      worldId: 'robot_town',
      rarity: RewardRarity.rare,
    ),
    RewardDefinition(
      id: 'reward.badge.rule_finder',
      type: RewardType.badge,
      titleKey: 'Rule finder',
      descriptionKey: 'A badge for solving pattern rules.',
      visualKey: 'icon.schema',
      xpCost: 0,
      unlockedAfterStars: 21,
      accentHex: 0xFFFF9D2E,
      worldId: 'robot_town',
      characterId: 'rulo',
    ),
    RewardDefinition(
      id: 'reward.sticker.shape_flower',
      type: RewardType.sticker,
      titleKey: 'Shape flower',
      descriptionKey: 'A garden sticker for spatial thinking.',
      visualKey: 'assets/images/generated/planet.png',
      xpCost: 0,
      unlockedAfterStars: 24,
      accentHex: 0xFF9C6AF2,
      worldId: 'shape_garden',
      characterId: 'quadra',
    ),
    RewardDefinition(
      id: 'reward.outfit.quadra_prism',
      type: RewardType.avatarItem,
      titleKey: 'Quadra prism suit',
      descriptionKey: 'A suit for turning shapes in your mind.',
      visualKey: 'character.quadra.outfit.prism',
      xpCost: 0,
      unlockedAfterStars: 28,
      accentHex: 0xFF9C6AF2,
      worldId: 'shape_garden',
      characterId: 'quadra',
      rarity: RewardRarity.rare,
    ),
    RewardDefinition(
      id: 'reward.decoration.garden_gate',
      type: RewardType.decoration,
      titleKey: 'Garden gate',
      descriptionKey: 'A patterned gate for the collection room.',
      visualKey: 'icon.category',
      xpCost: 0,
      unlockedAfterStars: 32,
      accentHex: 0xFF9C6AF2,
      worldId: 'shape_garden',
    ),
    RewardDefinition(
      id: 'reward.badge.shape_master',
      type: RewardType.badge,
      titleKey: 'Shape master',
      descriptionKey: 'A badge for rotation and path puzzles.',
      visualKey: 'icon.change_circle',
      xpCost: 0,
      unlockedAfterStars: 36,
      accentHex: 0xFF9C6AF2,
      worldId: 'shape_garden',
      characterId: 'quadra',
      rarity: RewardRarity.epic,
    ),
    RewardDefinition(
      id: 'reward.sticker.toy_crate',
      type: RewardType.sticker,
      titleKey: 'Toy crate',
      descriptionKey: 'A sticker for counting playful objects.',
      visualKey: 'assets/images/generated/lion.png',
      xpCost: 0,
      unlockedAfterStars: 40,
      accentHex: 0xFFFF9D2E,
      worldId: 'toy_shop',
      characterId: 'numba',
    ),
    RewardDefinition(
      id: 'reward.outfit.numba_count',
      type: RewardType.avatarItem,
      titleKey: 'Numba count vest',
      descriptionKey: 'A vest for careful number builders.',
      visualKey: 'character.numba.outfit.count',
      xpCost: 0,
      unlockedAfterStars: 45,
      accentHex: 0xFFFFD15C,
      worldId: 'toy_shop',
      characterId: 'numba',
      rarity: RewardRarity.rare,
    ),
    RewardDefinition(
      id: 'reward.decoration.toy_shelf',
      type: RewardType.decoration,
      titleKey: 'Toy shelf',
      descriptionKey: 'A shelf full of sorted toy clues.',
      visualKey: 'icon.toys',
      xpCost: 0,
      unlockedAfterStars: 50,
      accentHex: 0xFFFF9D2E,
      worldId: 'toy_shop',
    ),
    RewardDefinition(
      id: 'reward.badge.number_bridge',
      type: RewardType.badge,
      titleKey: 'Number bridge',
      descriptionKey: 'A badge for building sums and comparisons.',
      visualKey: 'icon.functions',
      xpCost: 0,
      unlockedAfterStars: 56,
      accentHex: 0xFFFFD15C,
      worldId: 'toy_shop',
      characterId: 'numba',
      rarity: RewardRarity.epic,
    ),
    RewardDefinition(
      id: 'reward.sticker.coral_signal',
      type: RewardType.sticker,
      titleKey: 'Coral signal',
      descriptionKey: 'A sticker for remembering hidden signals.',
      visualKey: 'assets/images/generated/planet.png',
      xpCost: 0,
      unlockedAfterStars: 62,
      accentHex: 0xFF5C8EF7,
      worldId: 'underwater_city',
      characterId: 'lumi',
    ),
    RewardDefinition(
      id: 'reward.outfit.lumi_wave',
      type: RewardType.avatarItem,
      titleKey: 'Lumi wave scarf',
      descriptionKey: 'A scarf for memory missions under the waves.',
      visualKey: 'character.lumi.outfit.wave',
      xpCost: 0,
      unlockedAfterStars: 70,
      accentHex: 0xFF5C8EF7,
      worldId: 'underwater_city',
      characterId: 'lumi',
      rarity: RewardRarity.rare,
    ),
    RewardDefinition(
      id: 'reward.decoration.coral_lamp',
      type: RewardType.decoration,
      titleKey: 'Coral lamp',
      descriptionKey: 'A soft memory light for the collection room.',
      visualKey: 'icon.water',
      xpCost: 0,
      unlockedAfterStars: 80,
      accentHex: 0xFF5C8EF7,
      worldId: 'underwater_city',
      rarity: RewardRarity.rare,
    ),
    RewardDefinition(
      id: 'reward.badge.memory_captain',
      type: RewardType.badge,
      titleKey: 'Memory captain',
      descriptionKey: 'A rare badge for long memory streaks.',
      visualKey: 'icon.military_tech',
      xpCost: 0,
      unlockedAfterStars: 90,
      accentHex: 0xFF5C8EF7,
      worldId: 'underwater_city',
      characterId: 'lumi',
      rarity: RewardRarity.epic,
    ),
  ];

  static const List<WeeklyEventDefinition> weeklyEvents = [
    WeeklyEventDefinition(
      id: 'event.star_hunt.2026w25',
      title: 'Star Hunt',
      subtitle: 'Collect star clues in Space Station lessons this week.',
      bannerLabel: 'Weekly event',
      startDateIso8601: '2026-06-15',
      endDateIso8601: '2026-06-21',
      rewardId: 'reward.decoration.star_window',
      targetLessonCount: 3,
      accentHex: 0xFF42F4D2,
      worldIds: ['space_station'],
      skillTags: [
        SkillTag.attention,
        SkillTag.memory,
        SkillTag.pattern,
      ],
      puzzleTypes: [
        PuzzleType.sequenceComplete,
        PuzzleType.pairMatch,
        PuzzleType.attentionScan,
      ],
      featuredLessonIds: [
        'lesson.001',
        'lesson.002',
        'lesson.003',
      ],
    ),
    WeeklyEventDefinition(
      id: 'event.robot_week.2026w26',
      title: 'Robot Week',
      subtitle: 'Decode rules and restart the Robot Town parade.',
      bannerLabel: 'Next weekly event',
      startDateIso8601: '2026-06-22',
      endDateIso8601: '2026-06-28',
      rewardId: 'reward.decoration.parade_lights',
      targetLessonCount: 3,
      accentHex: 0xFFFFD15C,
      worldIds: ['robot_town'],
      skillTags: [
        SkillTag.pattern,
        SkillTag.reasoning,
        SkillTag.classification,
      ],
      puzzleTypes: [
        PuzzleType.sequenceComplete,
        PuzzleType.codeBreaker,
        PuzzleType.categorySort,
      ],
      featuredLessonIds: [
        'lesson.007',
        'lesson.008',
        'lesson.009',
      ],
    ),
    WeeklyEventDefinition(
      id: 'event.shape_festival.2026w27',
      title: 'Shape Garden Festival',
      subtitle: 'Turn, trace, and grow pattern flowers.',
      bannerLabel: 'Next weekly event',
      startDateIso8601: '2026-06-29',
      endDateIso8601: '2026-07-05',
      rewardId: 'reward.badge.shape_master',
      targetLessonCount: 3,
      accentHex: 0xFF9C6AF2,
      worldIds: ['shape_garden'],
      skillTags: [
        SkillTag.spatial,
        SkillTag.pattern,
        SkillTag.attention,
      ],
      puzzleTypes: [
        PuzzleType.spatialRotation,
        PuzzleType.pathPuzzle,
        PuzzleType.visualCompare,
      ],
      featuredLessonIds: [
        'lesson.010',
        'lesson.011',
        'lesson.012',
      ],
    ),
    WeeklyEventDefinition(
      id: 'event.memory_mission.2026w28',
      title: 'Memory Mission',
      subtitle: 'Remember signals and pair hidden clues.',
      bannerLabel: 'Next weekly event',
      startDateIso8601: '2026-07-06',
      endDateIso8601: '2026-07-12',
      rewardId: 'reward.badge.memory_captain',
      targetLessonCount: 3,
      accentHex: 0xFF5C8EF7,
      worldIds: ['underwater_city'],
      skillTags: [
        SkillTag.memory,
        SkillTag.attention,
      ],
      puzzleTypes: [
        PuzzleType.pairMatch,
        PuzzleType.memoryGrid,
        PuzzleType.attentionScan,
      ],
      featuredLessonIds: [
        'lesson.016',
        'lesson.017',
        'lesson.018',
      ],
    ),
    WeeklyEventDefinition(
      id: 'event.logic_detective.2026w29',
      title: 'Logic Detective Week',
      subtitle: 'Follow clues, compare rules, and solve the case.',
      bannerLabel: 'Next weekly event',
      startDateIso8601: '2026-07-13',
      endDateIso8601: '2026-07-19',
      rewardId: 'reward.badge.rule_finder',
      targetLessonCount: 3,
      accentHex: 0xFFFF9D2E,
      worldIds: ['detective_academy', 'riddle_castle'],
      skillTags: [
        SkillTag.reasoning,
        SkillTag.classification,
        SkillTag.pattern,
      ],
      puzzleTypes: [
        PuzzleType.oddOneOut,
        PuzzleType.analogy,
        PuzzleType.codeBreaker,
      ],
      featuredLessonIds: [
        'lesson.022',
        'lesson.023',
        'lesson.024',
      ],
    ),
  ];

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

  static List<RewardDefinition> collectionRewardsForStars(int stars) {
    return [
      for (final reward in collectionRewards)
        if (reward.isUnlockedForStars(stars)) reward,
    ];
  }

  static RewardDefinition? nextCollectionRewardForStars(int stars) {
    for (final reward in collectionRewards) {
      if (!reward.isUnlockedForStars(stars)) {
        return reward;
      }
    }

    return null;
  }

  static RewardDefinition? rewardForId(String rewardId) {
    for (final reward in collectionRewards) {
      if (reward.id == rewardId) {
        return reward;
      }
    }

    return null;
  }

  static WeeklyEventDefinition? activeWeeklyEventFor(DateTime now) {
    for (final event in weeklyEvents) {
      if (event.isActiveOn(now)) {
        return event;
      }
    }

    return null;
  }

  static WeeklyEventProgress? activeWeeklyEventProgress({
    required DateTime now,
    required List<String> completedLessonIds,
    AgeBandId? ageBandId,
  }) {
    final event = activeWeeklyEventFor(now);
    if (event == null) {
      return null;
    }

    return weeklyEventProgressFor(
      event: event,
      now: now,
      completedLessonIds: completedLessonIds,
      ageBandId: ageBandId,
    );
  }

  static WeeklyEventProgress weeklyEventProgressFor({
    required WeeklyEventDefinition event,
    required DateTime now,
    required List<String> completedLessonIds,
    AgeBandId? ageBandId,
  }) {
    final completedLessonSet = completedLessonIds.toSet();
    final completedLessonCount = event.featuredLessonIds
        .where(completedLessonSet.contains)
        .length
        .clamp(0, event.targetLessonCount);
    final matchingPuzzleCount = puzzlesForWeeklyEvent(
      event,
      ageBandId: ageBandId,
    ).length;

    return WeeklyEventProgress(
      event: event,
      completedLessonCount: completedLessonCount,
      matchingPuzzleCount: matchingPuzzleCount,
      remainingDays: event.remainingDays(now),
      state: event.stateFor(
        now: now,
        completedLessonCount: completedLessonCount,
      ),
    );
  }

  static List<PuzzleDefinition> puzzlesForWeeklyEvent(
    WeeklyEventDefinition event, {
    AgeBandId? ageBandId,
  }) {
    return [
      for (final puzzle in allPuzzles)
        if (_puzzleMatchesWeeklyEvent(
          puzzle,
          event,
          ageBandId: ageBandId,
        ))
          puzzle,
    ];
  }

  static String? nextWeeklyEventLessonId({
    required WeeklyEventDefinition event,
    required List<String> completedLessonIds,
  }) {
    for (final lessonId in event.featuredLessonIds) {
      if (!completedLessonIds.contains(lessonId)) {
        return lessonId;
      }
    }

    return null;
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
      'characterCoaches': [
        for (final coach in characterCoaches) coach.toJson(),
      ],
      'storyWorlds': [
        for (final world in storyWorlds) world.toJson(),
      ],
      'collectionRewards': [
        for (final reward in collectionRewards) reward.toJson(),
      ],
      'weeklyEvents': [
        for (final event in weeklyEvents) event.toJson(),
      ],
      'placementRules': [
        for (final rule in placementRules) rule.toJson(),
      ],
      'qa': contentQaReport().toJson(),
      'largeContentMilestone': largeContentMilestoneReport().toJson(),
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
    final milestoneReport = largeContentMilestoneReport();

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
      milestoneReport: milestoneReport,
    );
  }

  static ContentMilestoneReport largeContentMilestoneReport() {
    final coverage = contentCoverageReport();
    final activePuzzleTypes =
        coverage.countByType.values.where((count) => count > 0).length;
    final starterBossLessons = starterLessons
        .where(
            (lesson) => placementForLesson(lesson) == ContentPlacement.bossNode)
        .length;

    return ContentMilestoneReport(
      metrics: [
        ContentMilestoneMetric(
          id: 'puzzles',
          label: 'Puzzle bank',
          current: allPuzzles.length,
          target: 500,
          unit: 'puzzles',
        ),
        ContentMilestoneMetric(
          id: 'puzzleTypes',
          label: 'Puzzle type variety',
          current: activePuzzleTypes,
          target: 25,
          unit: 'types',
        ),
        ContentMilestoneMetric(
          id: 'visualWorlds',
          label: 'Visual worlds',
          current: knownWorldIds.length,
          target: 8,
          unit: 'worlds',
        ),
        ContentMilestoneMetric(
          id: 'helperCharacters',
          label: 'Helper characters',
          current: knownCharacterIds.length,
          target: 5,
          unit: 'characters',
        ),
        ContentMilestoneMetric(
          id: 'reusableAssets',
          label: 'Reusable asset references',
          current: _catalogAssetReferences().length,
          target: 100,
          unit: 'assets',
        ),
        ContentMilestoneMetric(
          id: 'routeLessons',
          label: 'Route lessons',
          current: starterLessons.length,
          target: 30,
          unit: 'lessons',
        ),
        ContentMilestoneMetric(
          id: 'bossLevels',
          label: 'Boss levels',
          current: starterBossLessons,
          target: 10,
          unit: 'levels',
        ),
        const ContentMilestoneMetric(
          id: 'adaptiveReview',
          label: 'Review works on real mistakes',
          current: 1,
          target: 1,
          unit: 'feature',
        ),
        const ContentMilestoneMetric(
          id: 'dailyChallengeRotation',
          label: 'Daily challenge avoids quick repeats',
          current: 1,
          target: 1,
          unit: 'feature',
        ),
      ],
    );
  }

  static StoryWorldDefinition? storyWorldForLessonId(String lessonId) {
    for (final world in storyWorlds) {
      if (world.lessonIds.contains(lessonId)) {
        return world;
      }
    }
    return null;
  }

  static List<StoryWorldProgress> storyWorldProgressFor(
    List<String> completedLessonIds,
  ) {
    final completed = completedLessonIds.toSet();
    var previousWorldCompleted = true;
    final progress = <StoryWorldProgress>[];

    for (final world in storyWorlds) {
      final completedCount = world.lessonIds
          .where((lessonId) => completed.contains(lessonId))
          .length;
      final worldCompleted = completedCount >= world.lessonIds.length;
      final state = worldCompleted
          ? StoryWorldState.completed
          : completedCount > 0
              ? StoryWorldState.repaired
              : previousWorldCompleted
                  ? StoryWorldState.active
                  : StoryWorldState.locked;

      progress.add(
        StoryWorldProgress(
          world: world,
          state: state,
          completedLessonCount: completedCount,
        ),
      );
      previousWorldCompleted = worldCompleted;
    }

    return progress;
  }

  static StoryWorldProgress currentStoryWorldProgress(
    List<String> completedLessonIds,
  ) {
    final progress = storyWorldProgressFor(completedLessonIds);
    return progress.firstWhere(
      (item) =>
          item.state == StoryWorldState.active ||
          item.state == StoryWorldState.repaired,
      orElse: () => progress.last,
    );
  }

  static CharacterCoachDefinition coachForCharacterId(String? characterId) {
    return characterCoaches.firstWhere(
      (coach) => coach.id == characterId,
      orElse: () => characterCoaches.first,
    );
  }

  static CharacterCoachDefinition coachForSkill(SkillTag skillTag) {
    final coachId = switch (skillTag) {
      SkillTag.attention => 'mira',
      SkillTag.memory => 'lumi',
      SkillTag.pattern => 'rulo',
      SkillTag.classification => 'mira',
      SkillTag.arithmetic => 'numba',
      SkillTag.spatial => 'quadra',
      SkillTag.reasoning => 'rulo',
    };
    return coachForCharacterId(coachId);
  }

  static CharacterCoachDefinition coachForPuzzle(PuzzleDefinition puzzle) {
    final metadata = puzzle.visualMetadata;
    if (metadata != null) {
      return coachForCharacterId(metadata.characterId);
    }
    return coachForSkill(puzzle.skillTag);
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

  static Set<String> _catalogAssetReferences() {
    final assetRefs = <String>{};
    for (final puzzle in allPuzzles) {
      final metadata = puzzle.visualMetadata;
      if (metadata == null) {
        continue;
      }
      assetRefs.add(metadata.sceneAsset);
      assetRefs.addAll(metadata.choiceAssets);
    }
    return assetRefs;
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
      for (var index = 1; index <= 28; index += 1) {
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

DateTime _dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

bool _puzzleMatchesWeeklyEvent(
  PuzzleDefinition puzzle,
  WeeklyEventDefinition event, {
  AgeBandId? ageBandId,
}) {
  if (ageBandId != null && !puzzle.ageBandIds.contains(ageBandId)) {
    return false;
  }

  if (event.skillTags.isNotEmpty &&
      !event.skillTags.contains(puzzle.skillTag)) {
    return false;
  }

  if (event.puzzleTypes.isNotEmpty &&
      !event.puzzleTypes.contains(puzzle.type)) {
    return false;
  }

  final metadata = puzzle.visualMetadata;
  if (event.worldIds.isNotEmpty &&
      (metadata == null || !event.worldIds.contains(metadata.worldId))) {
    return false;
  }

  return true;
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
