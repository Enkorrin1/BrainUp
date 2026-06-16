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

    test('story worlds assign every starter lesson to a mission arc', () {
      final assignedLessonIds = {
        for (final world in FoundationCatalog.storyWorlds) ...world.lessonIds,
      };
      final starterLessonIds = {
        for (final lesson in FoundationCatalog.starterLessons) lesson.id,
      };

      expect(FoundationCatalog.storyWorlds.length, greaterThanOrEqualTo(8));
      expect(assignedLessonIds, starterLessonIds);
      for (final world in FoundationCatalog.storyWorlds) {
        expect(
          FoundationCatalog.knownWorldIds.contains(world.id),
          isTrue,
          reason: world.id,
        );
        expect(
          FoundationCatalog.knownCharacterIds.contains(world.helperCharacterId),
          isTrue,
          reason: world.id,
        );
        expect(world.missionTitle, isNotEmpty);
        expect(world.missionSummary, isNotEmpty);
      }
    });

    test('story world progress reports active repaired and completed states',
        () {
      final initialProgress = FoundationCatalog.storyWorldProgressFor(const []);
      final afterFirstWorld = FoundationCatalog.storyWorldProgressFor(
        const ['lesson.001', 'lesson.002', 'lesson.003'],
      );
      final partialSecondWorld = FoundationCatalog.storyWorldProgressFor(
        const ['lesson.001', 'lesson.002', 'lesson.003', 'lesson.004'],
      );

      expect(initialProgress.first.state, StoryWorldState.active);
      expect(initialProgress[1].state, StoryWorldState.locked);
      expect(afterFirstWorld.first.state, StoryWorldState.completed);
      expect(afterFirstWorld[1].state, StoryWorldState.active);
      expect(partialSecondWorld[1].state, StoryWorldState.repaired);
      expect(
        FoundationCatalog.storyWorldForLessonId('lesson.001')?.title,
        'Space Station',
      );
    });

    test('character coaches cover skills worlds and feedback lines', () {
      expect(FoundationCatalog.characterCoaches.length, 6);
      expect(
        FoundationCatalog.characterCoaches.map((coach) => coach.id).toSet(),
        FoundationCatalog.knownCharacterIds,
      );

      for (final coach in FoundationCatalog.characterCoaches) {
        expect(coach.displayName, isNotEmpty);
        expect(coach.shortRole, isNotEmpty);
        expect(coach.avatarAssetKey, startsWith('character.${coach.id}.'));
        expect(coach.skillTags, isNotEmpty, reason: coach.id);
        expect(coach.worldIds, isNotEmpty, reason: coach.id);
        expect(coach.neutralLine, isNotEmpty, reason: coach.id);
        expect(coach.hintLine, isNotEmpty, reason: coach.id);
        expect(coach.correctLine, isNotEmpty, reason: coach.id);
        expect(coach.retryLine, isNotEmpty, reason: coach.id);

        for (final worldId in coach.worldIds) {
          expect(
            FoundationCatalog.knownWorldIds.contains(worldId),
            isTrue,
            reason: '${coach.id} -> $worldId',
          );
        }
      }

      for (final skillTag in SkillTag.values) {
        final coach = FoundationCatalog.coachForSkill(skillTag);
        expect(coach.supportsSkill(skillTag), isTrue, reason: skillTag.name);
      }
    });

    test('content bank exposes a large multi-skill puzzle pool', () {
      expect(FoundationCatalog.allPuzzles.length, greaterThanOrEqualTo(500));

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
      final visualMetadata = json['visualMetadata'] as Map<String, Object?>;
      final puzzles = json['puzzles'] as List<Object?>;
      final focusTracker = puzzles.cast<Map<String, Object?>>().firstWhere(
            (puzzle) => puzzle['payloadRef'] == 'focus.tracker.easy.001',
          );
      final focusTrackerVisual =
          focusTracker['visualMetadata'] as Map<String, Object?>;

      expect(json['schemaVersion'], 1);
      expect(qualityGate['passes'], isTrue);
      expect(coverage['totalPuzzleCount'], FoundationCatalog.allPuzzles.length);
      expect(
        visualMetadata['visualPuzzleCount'],
        greaterThanOrEqualTo(200),
      );
      expect(puzzles.length, FoundationCatalog.allPuzzles.length);
      expect(focusTracker['skillTag'], SkillTag.attention.name);
      expect(focusTracker['difficulty'], PuzzleDifficulty.easy.name);
      expect(focusTracker['ageBandIds'], contains(AgeBandId.age4to5.name));
      expect(focusTrackerVisual['worldId'], 'forest_lab');
      expect(focusTrackerVisual['characterId'], 'mira');
      expect(focusTrackerVisual['interactionType'], 'tapChoice');
    });

    test('collection rewards expose unlock progress and manifest metadata', () {
      const rewards = FoundationCatalog.collectionRewards;
      final unlocked = FoundationCatalog.collectionRewardsForStars(8);
      final nextReward = FoundationCatalog.nextCollectionRewardForStars(8);
      final manifest = FoundationCatalog.contentManifest();
      final manifestRewards = manifest['collectionRewards'] as List<Object?>;

      expect(rewards.length, greaterThanOrEqualTo(20));
      expect(
        rewards.map((reward) => reward.type).toSet(),
        containsAll([
          RewardType.sticker,
          RewardType.avatarItem,
          RewardType.decoration,
          RewardType.badge,
        ]),
      );
      expect(
        unlocked.map((reward) => reward.id),
        contains('reward.outfit.mira_explorer'),
      );
      expect(nextReward?.id, 'reward.badge.focus_lens');
      expect(
        manifestRewards.cast<Map<String, Object?>>().first,
        containsPair('canEquip', isA<bool>()),
      );
    });

    test('content dashboard report exposes quality and saturation signals', () {
      final dashboard = FoundationCatalog.contentDashboardReport();
      final json =
          jsonDecode(jsonEncode(dashboard.toJson())) as Map<String, Object?>;
      final issues = json['issues'] as Map<String, Object?>;
      final repeatedFamilies = json['repeatedFamilies'] as List<Object?>;

      expect(dashboard.totalPuzzleCount, FoundationCatalog.allPuzzles.length);
      expect(dashboard.visualPuzzleCount, greaterThanOrEqualTo(200));
      expect(dashboard.visualCoveragePercent, greaterThanOrEqualTo(90));
      expect(dashboard.qualityGatePasses, isTrue);
      expect(
        dashboard.milestoneReport.metrics
            .firstWhere((metric) => metric.id == 'puzzles')
            .passes,
        isTrue,
      );
      expect(dashboard.milestoneReport.gaps, isNotEmpty);
      expect(dashboard.skillGaps, isEmpty);
      expect(dashboard.lowTypeCoverage, isEmpty);
      expect(dashboard.qaReport.passes, isTrue);
      expect(dashboard.qaReport.blockers, isEmpty);
      expect(dashboard.qaReport.warnings, isNotEmpty);
      expect(issues['puzzleIdsWithoutHints'], isEmpty);
      expect(repeatedFamilies, isNotEmpty);
      expect(
        repeatedFamilies.cast<Map<String, Object?>>().first,
        containsPair('familyId', isA<String>()),
      );
    });

    test('content QA report blocks structural errors and warns on polish gaps',
        () {
      final report = FoundationCatalog.contentQaReport();
      final json =
          jsonDecode(jsonEncode(report.toJson())) as Map<String, Object?>;
      final issues = json['issues'] as List<Object?>;

      expect(report.passes, isTrue);
      expect(report.blockers, isEmpty);
      expect(
        report.warnings.map((issue) => issue.type),
        contains(ContentQaIssueType.missingVisualMetadata),
      );
      expect(
        report.warnings.map((issue) => issue.type),
        contains(ContentQaIssueType.excessiveFamilyRepetition),
      );
      expect(json['blockerCount'], 0);
      expect(json['warningCount'], report.warnings.length);
      expect(issues, isNotEmpty);
    });

    test('large content milestone tracks achieved goals and remaining gaps',
        () {
      final report = FoundationCatalog.largeContentMilestoneReport();
      final json =
          jsonDecode(jsonEncode(report.toJson())) as Map<String, Object?>;
      final metrics = json['metrics'] as List<Object?>;

      expect(report.passes, isFalse);
      expect(report.passedCount, greaterThanOrEqualTo(4));
      expect(
        report.metrics.firstWhere((metric) => metric.id == 'puzzles').current,
        greaterThanOrEqualTo(500),
      );
      expect(
        report.metrics
            .firstWhere((metric) => metric.id == 'puzzleTypes')
            .passes,
        isFalse,
      );
      expect(metrics.length, report.metrics.length);
    });

    test('curated rich puzzle pack covers first-pack P0 families', () {
      final curatedPuzzles = CuratedRichPuzzlePack.puzzles;
      final countsByFamily = <String, int>{};
      final firstPackWorldIds = {
        'space_station',
        'forest_lab',
        'robot_town',
        'toy_shop',
        'shape_garden',
      };

      for (final puzzle in curatedPuzzles) {
        final metadata = puzzle.visualMetadata;

        expect(metadata, isNotNull, reason: puzzle.id);
        expect(
          FoundationCatalog.knownWorldIds.contains(metadata!.worldId),
          isTrue,
          reason: puzzle.id,
        );
        expect(firstPackWorldIds.contains(metadata.worldId), isTrue);
        expect(
          FoundationCatalog.knownCharacterIds.contains(metadata.characterId),
          isTrue,
          reason: puzzle.id,
        );
        countsByFamily.update(
          metadata.familyId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }

      expect(curatedPuzzles.length, 65);
      for (final familyId in [
        'classification.odd_one_out',
        'pattern.sequence_complete',
        'memory.pair_match',
        'memory.order_recall',
        'spatial.route_build',
        'math.object_count',
        'math.group_compare',
        'attention.shadow_match',
        'spatial.shape_rotation',
        'pattern.rule_detect',
        'math.logic_scales',
        'classification.object_sort',
        'boss.mixed_challenge',
      ]) {
        expect(countsByFamily[familyId], 5, reason: familyId);
      }
      expect(
        curatedPuzzles
            .map((puzzle) => puzzle.visualMetadata!.interactionType)
            .toSet()
            .length,
        greaterThanOrEqualTo(7),
      );
    });

    test('generated visual metadata references known worlds and characters',
        () {
      final generatedPuzzles = FoundationCatalog.allPuzzles
          .where((puzzle) => puzzle.lessonId == 'lesson.generated')
          .toList();

      expect(generatedPuzzles.length, greaterThanOrEqualTo(100));
      for (final puzzle in generatedPuzzles) {
        final metadata = puzzle.visualMetadata;

        expect(metadata, isNotNull, reason: puzzle.id);
        expect(
          FoundationCatalog.knownWorldIds.contains(metadata!.worldId),
          isTrue,
          reason: puzzle.id,
        );
        expect(
          FoundationCatalog.knownCharacterIds.contains(metadata.characterId),
          isTrue,
          reason: puzzle.id,
        );
        expect(metadata.familyId, isNotEmpty, reason: puzzle.id);
        expect(metadata.sceneAsset, startsWith('world.'), reason: puzzle.id);
        expect(metadata.choiceAssets, isNotEmpty, reason: puzzle.id);
        expect(metadata.estimatedSeconds, greaterThan(0), reason: puzzle.id);
      }
    });

    test('lesson generator mixes fixed and generated content bank puzzles', () {
      final lesson = FoundationCatalog.lessonForId('lesson.012');
      final puzzles = FoundationCatalog.puzzlesForLesson(
        lesson: lesson,
        ageBandId: AgeBandId.age7to8,
      );

      expect(puzzles.length, 7);
      expect(
        puzzles.any((puzzle) => puzzle.lessonId == 'lesson.generated'),
        isTrue,
      );
      expect(
        puzzles.map((puzzle) => puzzle.skillTag).toSet().length,
        greaterThanOrEqualTo(2),
      );
    });

    test('content manifest exports placement rules for production routing', () {
      final manifest = FoundationCatalog.contentManifest();
      final placementRules = manifest['placementRules'] as List<Object?>;
      final lessonPlacements = manifest['lessonPlacements'] as List<Object?>;

      expect(
        placementRules
            .cast<Map<String, Object?>>()
            .map((rule) => rule['placement']),
        containsAll([
          ContentPlacement.mainRoute.name,
          ContentPlacement.adaptiveReview.name,
          ContentPlacement.bossNode.name,
          ContentPlacement.dailyChallenge.name,
        ]),
      );
      expect(
        lessonPlacements.cast<Map<String, Object?>>(),
        contains(
          containsPair('lessonId', FoundationCatalog.adaptiveReviewLesson.id),
        ),
      );
    });

    test('lesson placement rules size normal, review, and boss lessons', () {
      final normalLesson = FoundationCatalog.lessonForId('lesson.011');
      final bossLesson = FoundationCatalog.lessonForId('lesson.012');
      const reviewLesson = FoundationCatalog.adaptiveReviewLesson;

      expect(
        FoundationCatalog.placementForLesson(normalLesson),
        ContentPlacement.mainRoute,
      );
      expect(
        FoundationCatalog.placementForLesson(bossLesson),
        ContentPlacement.bossNode,
      );
      expect(
        FoundationCatalog.placementForLesson(reviewLesson),
        ContentPlacement.adaptiveReview,
      );
      expect(
        FoundationCatalog.puzzlesForLesson(
          lesson: normalLesson,
          ageBandId: AgeBandId.age7to8,
        ).length,
        5,
      );
      expect(
        FoundationCatalog.puzzlesForLesson(
          lesson: bossLesson,
          ageBandId: AgeBandId.age7to8,
        ).length,
        inInclusiveRange(6, 8),
      );
      expect(
        FoundationCatalog.puzzlesForLesson(
          lesson: reviewLesson,
          ageBandId: AgeBandId.age6,
          reviewProfile: PracticeReviewProfile.fromSessions([
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
          ]),
        ).length,
        inInclusiveRange(3, 5),
      );
    });

    test('boss placement prioritizes mixed or boss difficulty content', () {
      final puzzles = FoundationCatalog.puzzlesForLesson(
        lesson: FoundationCatalog.lessonForId('lesson.024'),
        ageBandId: AgeBandId.age7to8,
      );

      expect(puzzles.length, inInclusiveRange(6, 8));
      expect(
        puzzles.any(
          (puzzle) =>
              puzzle.type == PuzzleType.mixedBoss ||
              puzzle.difficulty == PuzzleDifficulty.boss,
        ),
        isTrue,
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
