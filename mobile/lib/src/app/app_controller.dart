import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../data/family_profile_store.dart';
import '../domain/daily_challenge.dart';
import '../domain/family_profile.dart';
import '../domain/learning_foundation.dart';

class AppController extends ChangeNotifier {
  AppController(this._familyProfileStore);

  final FamilyProfileStore _familyProfileStore;

  bool _isLoading = true;
  FamilyProfile? _familyProfile;

  bool get isLoading => _isLoading;
  FamilyProfile? get familyProfile => _familyProfile;

  Future<void> load() async {
    _familyProfile = await _familyProfileStore.load();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> completeOnboarding({
    required String childName,
    required ChildAge childAge,
    required LearningGoal learningGoal,
  }) async {
    final createdAt = DateTime.now();
    final child = ChildProfile(
      id: childProfileId(name: childName, createdAt: createdAt),
      name: childName,
      age: childAge,
      learningGoal: learningGoal,
      createdAt: createdAt,
    );
    final profile = FamilyProfile(
      childName: childName,
      childAge: childAge,
      learningGoal: learningGoal,
      createdAt: createdAt,
      childProfiles: [child],
      activeChildId: child.id,
    );

    await _familyProfileStore.save(profile);
    _familyProfile = profile;
    notifyListeners();
  }

  Future<void> completeDailyChallenge(DailyChallenge challenge) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null) {
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (currentProfile.completedOn(today)) {
      return;
    }

    final activeChild = currentProfile.activeChild;
    final yesterday = today.subtract(const Duration(days: 1));
    final currentStreak =
        activeChild.completedOn(yesterday) ? activeChild.currentStreak + 1 : 1;
    final nextSession = PracticeSession(
      completedAt: now,
      challengeId: challenge.id,
      challengeTitle: challenge.title,
      skill: challenge.skill,
      minutes: challenge.minutes,
      correctAnswers: 1,
      totalQuestions: 1,
    );
    final currentNode = _currentMapNodeFor(activeChild);
    final completedMapNodeIds = [
      ...activeChild.completedMapNodeIds,
      if (currentNode != null &&
          !activeChild.completedMapNodeIds.contains(currentNode.id))
        currentNode.id,
    ];
    final completedLessonIds = [
      ...activeChild.completedLessonIds,
      if (currentNode != null &&
          !activeChild.completedLessonIds.contains(currentNode.lessonId))
        currentNode.lessonId,
    ];
    final nextChild = activeChild.copyWith(
      completedChallenges: activeChild.completedChallenges + 1,
      currentStreak: currentStreak,
      bestStreak: math.max(activeChild.bestStreak, currentStreak),
      totalPracticeMinutes:
          activeChild.totalPracticeMinutes + challenge.minutes,
      lastChallengeDate: today,
      lastChallengeId: challenge.id,
      lastChallengeSkill: challenge.skill,
      practiceSessions: [
        ...activeChild.practiceSessions,
        nextSession,
      ],
      completedMapNodeIds: completedMapNodeIds,
      completedLessonIds: completedLessonIds,
      mapStars: activeChild.mapStars + 1,
      mapXp: activeChild.mapXp +
          (currentNode == null ? 20 : 20 + currentNode.order * 2),
      hearts: math.min(5, activeChild.hearts + 1),
    );

    final nextProfile = currentProfile.withActiveChild(nextChild);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> completeLesson({
    required String lessonId,
    required DailyChallenge challenge,
    int correctAnswers = 1,
    int totalQuestions = 1,
    int usedHints = 0,
    int wrongAttempts = 0,
    List<String> mistakePuzzleIds = const [],
    List<String> reviewedPuzzleIds = const [],
  }) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null) {
      return;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final activeChild = currentProfile.activeChild;
    final currentNode = _nodeForLesson(lessonId);
    final lesson = FoundationCatalog.lessonForId(lessonId);
    final isReviewLesson =
        lessonId == FoundationCatalog.adaptiveReviewLesson.id;
    final wasCompleted = activeChild.completedLessonIds.contains(lessonId);

    final yesterday = today.subtract(const Duration(days: 1));
    final currentStreak =
        activeChild.completedOn(yesterday) ? activeChild.currentStreak + 1 : 1;
    final nextSession = PracticeSession(
      completedAt: now,
      challengeId: lessonId,
      challengeTitle: challenge.title,
      skill: challenge.skill,
      minutes: challenge.minutes,
      correctAnswers: correctAnswers,
      totalQuestions: totalQuestions,
      usedHints: usedHints,
      wrongAttempts: wrongAttempts,
      mistakePuzzleIds: mistakePuzzleIds,
      reviewedPuzzleIds: reviewedPuzzleIds,
    );
    final completedMapNodeIds = [
      ...activeChild.completedMapNodeIds,
      if (!isReviewLesson &&
          currentNode != null &&
          !activeChild.completedMapNodeIds.contains(currentNode.id))
        currentNode.id,
    ];
    final completedLessonIds = [
      ...activeChild.completedLessonIds,
      if (!isReviewLesson) lessonId,
    ];
    final nextChild = activeChild.copyWith(
      completedChallenges: activeChild.completedChallenges + 1,
      currentStreak: currentStreak,
      bestStreak: math.max(activeChild.bestStreak, currentStreak),
      totalPracticeMinutes:
          activeChild.totalPracticeMinutes + challenge.minutes,
      lastChallengeDate: today,
      lastChallengeId: lessonId,
      lastChallengeSkill: challenge.skill,
      practiceSessions: [
        ...activeChild.practiceSessions,
        nextSession,
      ],
      completedMapNodeIds: completedMapNodeIds,
      completedLessonIds: completedLessonIds,
      mapStars: activeChild.mapStars + (isReviewLesson ? 0 : 1),
      mapXp: activeChild.mapXp + (wasCompleted ? 8 : lesson.xpReward),
      hearts: math.min(5, activeChild.hearts + 1),
    );

    final nextProfile = currentProfile.withActiveChild(nextChild);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  MapNode? _currentMapNodeFor(ChildProfile child) {
    for (final node in FoundationCatalog.starterMap.nodes) {
      if (!child.completedMapNodeIds.contains(node.id)) {
        return node;
      }
    }

    return null;
  }

  MapNode? _nodeForLesson(String lessonId) {
    for (final node in FoundationCatalog.starterMap.nodes) {
      if (node.lessonId == lessonId) {
        return node;
      }
    }

    return null;
  }

  Future<void> addChildProfile({
    required String childName,
    required ChildAge childAge,
    required LearningGoal learningGoal,
  }) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null || !currentProfile.canAddChild) {
      return;
    }

    final createdAt = DateTime.now();
    final child = ChildProfile(
      id: childProfileId(name: childName, createdAt: createdAt),
      name: childName,
      age: childAge,
      learningGoal: learningGoal,
      createdAt: createdAt,
    );
    final nextProfile = currentProfile.withActiveChild(child);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> selectChildProfile(String childId) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null || currentProfile.activeChild.id == childId) {
      return;
    }

    final child = currentProfile.children.firstWhere(
      (profile) => profile.id == childId,
      orElse: () => currentProfile.activeChild,
    );
    if (child.id == currentProfile.activeChild.id) {
      return;
    }

    final nextProfile = currentProfile.withActiveChild(child);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> updateSubscriptionPlan(FamilySubscriptionPlan plan) async {
    final currentProfile = _familyProfile;
    if (currentProfile == null || currentProfile.subscriptionPlan == plan) {
      return;
    }

    final nextProfile = currentProfile.copyWith(
      subscriptionPlan: plan,
      subscriptionUpdatedAt: DateTime.now(),
    );

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> equipCollectionReward(String rewardId) async {
    final currentProfile = _familyProfile;
    final reward = FoundationCatalog.rewardForId(rewardId);
    if (currentProfile == null || reward == null || !reward.canEquip) {
      return;
    }

    final activeChild = currentProfile.activeChild;
    if (!reward.isUnlockedForStars(activeChild.mapStars)) {
      return;
    }

    final nextChild = switch (reward.type) {
      RewardType.avatarItem => activeChild.copyWith(
          selectedCharacterId: reward.characterId,
          selectedOutfitRewardId: reward.id,
        ),
      RewardType.decoration => activeChild.copyWith(
          selectedDecorationRewardId: reward.id,
        ),
      RewardType.badge => activeChild.copyWith(
          selectedBadgeRewardId: reward.id,
        ),
      RewardType.sticker || RewardType.booster => activeChild,
    };

    if (nextChild == activeChild) {
      return;
    }

    final nextProfile = currentProfile.withActiveChild(nextChild);

    await _familyProfileStore.save(nextProfile);
    _familyProfile = nextProfile;
    notifyListeners();
  }

  Future<void> resetFamilyProfile() async {
    await _familyProfileStore.clear();
    _familyProfile = null;
    notifyListeners();
  }
}
