import 'package:flutter_test/flutter_test.dart';
import 'package:brain_up/src/domain/family_profile.dart';

void main() {
  group('FamilyProfile', () {
    test('serializes to json and restores from json', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 8, 9),
        learningGoal: LearningGoal.attention,
        completedChallenges: 2,
        currentStreak: 2,
        bestStreak: 3,
        totalPracticeMinutes: 9,
        subscriptionPlan: FamilySubscriptionPlan.annual,
        subscriptionUpdatedAt: DateTime(2026, 6, 8, 20),
        lastChallengeDate: DateTime(2026, 6, 8),
        lastChallengeId: 'shape-path',
        lastChallengeSkill: 'Внимание и закономерности',
        practiceSessions: [
          PracticeSession(
            completedAt: DateTime(2026, 6, 8, 18, 30),
            challengeId: 'shape-path',
            challengeTitle: 'Дорожка фигур',
            skill: 'Внимание и закономерности',
            minutes: 4,
            correctAnswers: 3,
            totalQuestions: 4,
            usedHints: 1,
            wrongAttempts: 2,
          ),
        ],
      );

      final restored = FamilyProfile.fromJson(profile.toJson());

      expect(restored, profile);
      expect(restored.children, hasLength(1));
      expect(restored.activeChild.name, profile.childName);
      expect(restored.lastSession?.correctAnswers, 3);
      expect(restored.lastSession?.totalQuestions, 4);
      expect(restored.lastSession?.usedHints, 1);
      expect(restored.lastSession?.wrongAttempts, 2);
    });

    test('restores old saved profile with default progress fields', () {
      final restored = FamilyProfile.fromJson({
        'childName': 'Мира',
        'childAge': 'six',
        'createdAt': DateTime(2026, 6, 8).toIso8601String(),
        'completedChallenges': 1,
      });

      expect(restored.learningGoal, LearningGoal.logic);
      expect(restored.currentStreak, 0);
      expect(restored.bestStreak, 0);
      expect(restored.totalPracticeMinutes, 0);
      expect(restored.practiceSessions, isEmpty);
      expect(restored.children, hasLength(1));
      expect(restored.activeChild.name, 'Мира');
      expect(restored.subscriptionPlan, FamilySubscriptionPlan.starter);
      expect(restored.subscriptionUpdatedAt, isNull);
    });

    test('restores old practice session with default quality metrics', () {
      final session = PracticeSession.fromJson({
        'completedAt': DateTime(2026, 6, 8, 18).toIso8601String(),
        'challengeId': 'legacy',
        'challengeTitle': 'Legacy lesson',
        'skill': 'Logic',
        'minutes': 4,
      });

      expect(session.correctAnswers, 1);
      expect(session.totalQuestions, 1);
      expect(session.usedHints, 0);
      expect(session.wrongAttempts, 0);
    });

    test('migrates legacy map nodes into completed lesson ids', () {
      final restored = FamilyProfile.fromJson({
        'childName': 'Leo',
        'childAge': 'five',
        'createdAt': DateTime(2026, 6, 8).toIso8601String(),
        'completedMapNodeIds': ['node.001', 'node.002'],
      });

      expect(restored.activeChild.completedLessonIds, [
        'lesson.001',
        'lesson.002',
      ]);
    });

    test('switches active child without carrying previous progress', () {
      final firstChild = ChildProfile(
        id: 'first',
        name: 'Мира',
        age: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        completedChallenges: 2,
        currentStreak: 2,
        lastChallengeDate: DateTime(2026, 6, 8),
      );
      final secondChild = ChildProfile(
        id: 'second',
        name: 'Лев',
        age: ChildAge.five,
        createdAt: DateTime(2026, 6, 9),
        learningGoal: LearningGoal.math,
      );
      final profile = FamilyProfile(
        childName: firstChild.name,
        childAge: firstChild.age,
        createdAt: firstChild.createdAt,
        completedChallenges: firstChild.completedChallenges,
        currentStreak: firstChild.currentStreak,
        lastChallengeDate: firstChild.lastChallengeDate,
        childProfiles: [firstChild, secondChild],
        activeChildId: firstChild.id,
      );

      final switchedProfile = profile.withActiveChild(secondChild);

      expect(switchedProfile.childName, 'Лев');
      expect(switchedProfile.learningGoal, LearningGoal.math);
      expect(switchedProfile.completedChallenges, 0);
      expect(switchedProfile.currentStreak, 0);
      expect(switchedProfile.lastChallengeDate, isNull);
    });

    test('detects challenge completion by calendar date', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 8),
        lastChallengeDate: DateTime(2026, 6, 8, 18, 30),
      );

      expect(profile.completedOn(DateTime(2026, 6, 8, 7)), isTrue);
      expect(profile.completedOn(DateTime(2026, 6, 9)), isFalse);
    });

    test('returns practice sessions inside the requested day window', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 1),
        practiceSessions: [
          PracticeSession(
            completedAt: DateTime(2026, 6, 1, 17),
            challengeId: 'old',
            challengeTitle: 'Старое задание',
            skill: 'Логика',
            minutes: 3,
          ),
          PracticeSession(
            completedAt: DateTime(2026, 6, 7, 17),
            challengeId: 'recent',
            challengeTitle: 'Новое задание',
            skill: 'Внимание',
            minutes: 4,
          ),
        ],
      );

      final sessions = profile.sessionsInLastDays(
        days: 7,
        now: DateTime(2026, 6, 8),
      );

      expect(sessions.map((session) => session.challengeId), ['recent']);
    });

    test('builds ordered practice day summaries', () {
      final profile = FamilyProfile(
        childName: 'Лев',
        childAge: ChildAge.five,
        createdAt: DateTime(2026, 6, 1),
        lastChallengeDate: DateTime(2026, 6, 8),
        practiceSessions: [
          PracticeSession(
            completedAt: DateTime(2026, 6, 7, 17),
            challengeId: 'first',
            challengeTitle: 'Первое задание',
            skill: 'Логика',
            minutes: 3,
          ),
          PracticeSession(
            completedAt: DateTime(2026, 6, 8, 17),
            challengeId: 'second',
            challengeTitle: 'Второе задание',
            skill: 'Внимание',
            minutes: 4,
          ),
        ],
      );

      final days = profile.practiceDays(
        days: 3,
        now: DateTime(2026, 6, 8),
      );

      expect(days.map((day) => day.date), [
        DateTime(2026, 6, 6),
        DateTime(2026, 6, 7),
        DateTime(2026, 6, 8),
      ]);
      expect(days.map((day) => day.completed), [false, true, true]);
      expect(days.map((day) => day.minutes), [0, 3, 4]);
      expect(profile.practicedOn(DateTime(2026, 6, 7)), isTrue);
      expect(profile.practiceMinutesOn(DateTime(2026, 6, 8)), 4);
    });
  });
}
