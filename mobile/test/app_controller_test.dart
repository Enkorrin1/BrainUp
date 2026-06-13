import 'package:flutter_test/flutter_test.dart';
import 'package:brain_up/src/app/app_controller.dart';
import 'package:brain_up/src/data/family_profile_store.dart';
import 'package:brain_up/src/domain/daily_challenge.dart';
import 'package:brain_up/src/domain/family_profile.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';

void main() {
  group('AppController', () {
    test('loads existing family profile', () async {
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();

      expect(controller.isLoading, isFalse);
      expect(controller.familyProfile, profile);
    });

    test('creates and saves profile from onboarding', () async {
      final store = _InMemoryFamilyProfileStore();
      final controller = AppController(store);

      await controller.completeOnboarding(
        childName: 'Лев',
        childAge: ChildAge.five,
        learningGoal: LearningGoal.math,
      );

      expect(store.savedProfile?.childName, 'Лев');
      expect(store.savedProfile?.childAge, ChildAge.five);
      expect(store.savedProfile?.learningGoal, LearningGoal.math);
      expect(store.savedProfile?.children, hasLength(1));
      expect(store.savedProfile?.activeChild.name, 'Лев');
      expect(controller.familyProfile, store.savedProfile);
    });

    test('adds and switches child profiles on a family plan', () async {
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        completedChallenges: 2,
        subscriptionPlan: FamilySubscriptionPlan.annual,
      );
      final firstChildId = profile.activeChild.id;
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.addChildProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        learningGoal: LearningGoal.math,
      );

      expect(controller.familyProfile?.children, hasLength(2));
      expect(controller.familyProfile?.childName, 'Лев');
      expect(controller.familyProfile?.completedChallenges, 0);

      await controller.selectChildProfile(firstChildId);

      expect(controller.familyProfile?.childName, 'Мира');
      expect(controller.familyProfile?.completedChallenges, 2);
    });

    test('does not add a second child on the starter plan', () async {
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.addChildProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        learningGoal: LearningGoal.math,
      );

      expect(controller.familyProfile?.children, hasLength(1));
      expect(controller.familyProfile?.childName, 'Мира');
    });

    test('updates and saves family subscription plan', () async {
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.updateSubscriptionPlan(FamilySubscriptionPlan.annual);

      expect(
        controller.familyProfile?.subscriptionPlan,
        FamilySubscriptionPlan.annual,
      );
      expect(controller.familyProfile?.subscriptionUpdatedAt, isNotNull);
      expect(store.savedProfile, controller.familyProfile);
    });

    test('records completion metrics for a daily challenge', () async {
      final yesterday = _today().subtract(const Duration(days: 1));
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        completedChallenges: 2,
        currentStreak: 2,
        bestStreak: 2,
        totalPracticeMinutes: 8,
        lastChallengeDate: yesterday,
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.completeDailyChallenge(_challenge);

      final savedProfile = controller.familyProfile;
      expect(savedProfile?.completedChallenges, 3);
      expect(savedProfile?.currentStreak, 3);
      expect(savedProfile?.bestStreak, 3);
      expect(savedProfile?.totalPracticeMinutes, 9);
      expect(savedProfile?.lastChallengeId, _challenge.id);
      expect(savedProfile?.lastChallengeSkill, _challenge.skill);
      expect(savedProfile?.practiceSessions, hasLength(1));
      expect(savedProfile?.lastSession?.challengeTitle, _challenge.title);
    });

    test('records concrete lesson attempts for long path progress', () async {
      final profile = FamilyProfile(
        childName: 'Leo',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 8),
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.completeLesson(
        lessonId: 'lesson.001',
        challenge: _challenge,
        correctAnswers: 2,
        totalQuestions: 3,
        usedHints: 1,
        wrongAttempts: 2,
        mistakePuzzleIds: ['shape-path', 'toy-count'],
      );
      await controller.completeLesson(
        lessonId: 'lesson.001',
        challenge: _challenge,
      );

      final savedProfile = controller.familyProfile;
      expect(savedProfile?.completedChallenges, 2);
      expect(savedProfile?.activeChild.completedLessonIds, [
        'lesson.001',
        'lesson.001',
      ]);
      expect(savedProfile?.activeChild.completedMapNodeIds, ['node.001']);
      expect(savedProfile?.practiceSessions, hasLength(2));
      expect(savedProfile?.lastChallengeId, 'lesson.001');
      expect(savedProfile?.lastSession?.correctAnswers, 1);
      expect(savedProfile?.practiceSessions.first.correctAnswers, 2);
      expect(savedProfile?.practiceSessions.first.totalQuestions, 3);
      expect(savedProfile?.practiceSessions.first.usedHints, 1);
      expect(savedProfile?.practiceSessions.first.wrongAttempts, 2);
      expect(savedProfile?.practiceSessions.first.mistakePuzzleIds, [
        'shape-path',
        'toy-count',
      ]);
    });

    test('records adaptive review without advancing the main path', () async {
      final profile = FamilyProfile(
        childName: 'Leo',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 8),
        childProfiles: [
          ChildProfile(
            id: 'child-review',
            name: 'Leo',
            age: ChildAge.five,
            createdAt: DateTime(2026, 6, 8),
            completedLessonIds: const ['lesson.001'],
            completedMapNodeIds: const ['node.001'],
            mapStars: 1,
          ),
        ],
        activeChildId: 'child-review',
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.completeLesson(
        lessonId: FoundationCatalog.adaptiveReviewLesson.id,
        challenge: _challenge,
        correctAnswers: 4,
        totalQuestions: 5,
        usedHints: 1,
        wrongAttempts: 1,
        mistakePuzzleIds: ['memory.order.normal.003'],
      );

      final child = controller.familyProfile?.activeChild;
      expect(child?.completedLessonIds, ['lesson.001']);
      expect(child?.completedMapNodeIds, ['node.001']);
      expect(child?.mapStars, 1);
      expect(child?.mapXp, FoundationCatalog.adaptiveReviewLesson.xpReward);
      expect(child?.lastChallengeId, FoundationCatalog.adaptiveReviewLesson.id);
      expect(child?.lastSession?.mistakePuzzleIds, [
        'memory.order.normal.003',
      ]);
    });

    test('starts a new streak when yesterday was missed', () async {
      final twoDaysAgo = _today().subtract(const Duration(days: 2));
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        completedChallenges: 4,
        currentStreak: 4,
        bestStreak: 4,
        lastChallengeDate: twoDaysAgo,
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.completeDailyChallenge(_challenge);

      expect(controller.familyProfile?.currentStreak, 1);
      expect(controller.familyProfile?.bestStreak, 4);
    });

    test('counts only one daily challenge completion per day', () async {
      final today = _today();
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        completedChallenges: 2,
        currentStreak: 2,
        bestStreak: 2,
        totalPracticeMinutes: 8,
        lastChallengeDate: today,
      );
      final store = _InMemoryFamilyProfileStore(profile);
      final controller = AppController(store);

      await controller.load();
      await controller.completeDailyChallenge(_challenge);

      expect(controller.familyProfile?.completedChallenges, 2);
      expect(controller.familyProfile?.currentStreak, 2);
      expect(controller.familyProfile?.totalPracticeMinutes, 8);
      expect(controller.familyProfile?.practiceSessions, isEmpty);
      expect(controller.familyProfile?.lastChallengeDate, today);
    });
  });
}

const _challenge = DailyChallenge(
  id: 'test',
  title: 'Тестовое задание',
  prompt: 'Выберите ответ.',
  question: 'Что подходит?',
  skill: 'Логика',
  goal: LearningGoal.logic,
  minutes: 1,
  correctChoiceId: 'a',
  hint: 'Нужен первый вариант.',
  explanation: 'Первый вариант подходит по правилу.',
  choices: [
    ChallengeChoice(id: 'a', label: 'A'),
    ChallengeChoice(id: 'b', label: 'B'),
  ],
);

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

class _InMemoryFamilyProfileStore implements FamilyProfileStore {
  _InMemoryFamilyProfileStore([this.savedProfile]);

  FamilyProfile? savedProfile;

  @override
  Future<void> clear() async {
    savedProfile = null;
  }

  @override
  Future<FamilyProfile?> load() async {
    return savedProfile;
  }

  @override
  Future<void> save(FamilyProfile profile) async {
    savedProfile = profile;
  }
}
