import 'package:flutter_test/flutter_test.dart';
import 'package:brain_up/src/data/family_profile_store.dart';
import 'package:brain_up/src/domain/family_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharedPreferencesFamilyProfileStore', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('returns null when profile has not been saved', () async {
      final preferences = await SharedPreferences.getInstance();
      final store = SharedPreferencesFamilyProfileStore(preferences);

      expect(await store.load(), isNull);
    });

    test('saves and loads family profile', () async {
      final preferences = await SharedPreferences.getInstance();
      final store = SharedPreferencesFamilyProfileStore(preferences);
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
        learningGoal: LearningGoal.logic,
        completedChallenges: 3,
        currentStreak: 2,
        bestStreak: 3,
        totalPracticeMinutes: 14,
        subscriptionPlan: FamilySubscriptionPlan.monthly,
        subscriptionUpdatedAt: DateTime(2026, 6, 8, 20),
        lastChallengeDate: DateTime(2026, 6, 8),
        lastChallengeId: 'logic-train',
        lastChallengeSkill: 'Последовательности',
        practiceSessions: [
          PracticeSession(
            completedAt: DateTime(2026, 6, 8, 19),
            challengeId: 'logic-train',
            challengeTitle: 'Логический поезд',
            skill: 'Последовательности',
            minutes: 5,
          ),
        ],
      );

      await store.save(profile);

      expect(await store.load(), profile);
    });

    test('clears saved family profile', () async {
      final preferences = await SharedPreferences.getInstance();
      final store = SharedPreferencesFamilyProfileStore(preferences);
      final profile = FamilyProfile(
        childName: 'Мира',
        childAge: ChildAge.six,
        createdAt: DateTime(2026, 6, 8),
      );

      await store.save(profile);
      await store.clear();

      expect(await store.load(), isNull);
    });
  });
}
