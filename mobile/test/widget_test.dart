import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brain_up/src/app/brain_up_app.dart';
import 'package:brain_up/src/data/app_locale_store.dart';
import 'package:brain_up/src/data/family_profile_store.dart';
import 'package:brain_up/src/domain/daily_challenge.dart';
import 'package:brain_up/src/domain/family_profile.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';
import 'package:brain_up/src/features/course/course_screen.dart';
import 'package:brain_up/src/features/parent/parent_screen.dart';
import 'package:brain_up/src/features/path/path_screen.dart';
import 'package:brain_up/src/l10n/l10n.dart';
import 'package:brain_up/src/mini_games/core/mini_game_definition.dart';
import 'package:brain_up/src/mini_games/core/mini_game_registry.dart';
import 'package:brain_up/src/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows onboarding when family profile is empty', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: SharedPreferencesFamilyProfileStore(preferences),
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Build your BrainUp route'), findsOneWidget);
    expect(find.text('Age'), findsOneWidget);
    expect(find.text('Learning goal'), findsOneWidget);
  });

  testWidgets('shows path-first map after profile load', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Space Station: Repair the rocket route'), findsOneWidget);
    expect(
      find.text('Help Brainy collect star parts and open the launch path.'),
      findsOneWidget,
    );
    expect(find.text('Forest Lab'), findsOneWidget);
    expect(find.text('locked'), findsAtLeastNWidgets(1));
    expect(find.text('Courses and puzzles'), findsNothing);
  });

  testWidgets('opens current lesson from path cta', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 5'), findsOneWidget);
    expect(find.text('Space Station: Repair the rocket route'), findsOneWidget);
    expect(find.text('Rulo - Rule coach'), findsOneWidget);
    expect(find.text('Every puzzle has a clue.'), findsOneWidget);
  });

  testWidgets('opens current lesson from path node', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    final listView = find.byType(ListView).first;
    for (var attempt = 0; attempt < 4; attempt += 1) {
      if (tester.any(find.text('Start'))) {
        break;
      }
      await tester.drag(listView, const Offset(0, -260));
      await tester.pumpAndSettle();
    }

    final startFinder = find.text('Start').last;
    expect(startFinder, findsOneWidget);

    await tester.tap(startFinder);
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 5'), findsOneWidget);
  });

  testWidgets('opens collection tab and equips an unlocked outfit',
      (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfileWithStars(8));

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('My collection'));
    await tester.pumpAndSettle();

    expect(find.text('Collection room'), findsOneWidget);
    final collectionScroll = find.descendant(
      of: find.byKey(const ValueKey('collection-scroll')),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.text('Outfits'),
      260,
      scrollable: collectionScroll.first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Outfits'), findsOneWidget);
    expect(find.text('Mira explorer cloak'), findsOneWidget);

    await tester.tap(find.text('Mira explorer cloak').first);
    await tester.pumpAndSettle();

    expect(store.profile?.activeChild.selectedCharacterId, 'mira');
    expect(
      store.profile?.activeChild.selectedOutfitRewardId,
      'reward.outfit.mira_explorer',
    );
    expect(find.text('Equipped'), findsAtLeastNWidgets(1));
  });

  testWidgets('shows weekly event progress on the path', (tester) async {
    String? selectedLessonId;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildAppTheme(),
        home: PathScreen(
          profile: _testProfileWithCompletedLessons(['lesson.001']),
          now: DateTime(2026, 6, 16),
          onLessonSelected: (lessonId) {
            selectedLessonId = lessonId;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Star Hunt'), findsOneWidget);
    expect(find.text('1/3 lessons'), findsOneWidget);
    expect(find.text('Play event lesson'), findsOneWidget);

    await tester.ensureVisible(find.text('Play event lesson'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Play event lesson'));
    await tester.pumpAndSettle();

    expect(selectedLessonId, 'lesson.002');
  });

  testWidgets('shows adaptive review entry from practice history',
      (tester) async {
    final store = _MemoryFamilyProfileStore(
      _testProfileWithPracticeSessions([
        PracticeSession(
          completedAt: DateTime(2026, 6, 12, 18),
          challengeId: 'lesson.009',
          challengeTitle: 'Memory lesson',
          skill: 'Working memory',
          minutes: 5,
          correctAnswers: 2,
          totalQuestions: 5,
          wrongAttempts: 2,
          mistakePuzzleIds: ['memory.order.normal.003'],
        ),
      ]),
    );

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Practice tricky bits'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);

    await tester.tap(find.text('Review'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Step 1 of 5'), findsOneWidget);
    expect(find.textContaining('Remember:'), findsOneWidget);
    expect(find.text('Memory Grid'), findsOneWidget);
    expect(find.text('Play directly in this puzzle'), findsOneWidget);
    expect(find.text('Play mini-game'), findsNothing);
    expect(_gameWidgetFinder(), findsOneWidget);
  });

  testWidgets('shows adaptive review result without map reward',
      (tester) async {
    final profile = _testProfileWithPracticeSessions([
      PracticeSession(
        completedAt: DateTime(2026, 6, 12, 18),
        challengeId: 'lesson.009',
        challengeTitle: 'Memory lesson',
        skill: 'Working memory',
        minutes: 5,
        correctAnswers: 2,
        totalQuestions: 5,
        wrongAttempts: 2,
        mistakePuzzleIds: ['memory.order.normal.003'],
      ),
    ]);
    final challenges = _adaptiveReviewChallenges(profile);
    final store = _MemoryFamilyProfileStore(profile);

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Review'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    for (var index = 0; index < challenges.length; index += 1) {
      final challenge = challenges[index];
      final definition = MiniGameRegistry.definitionForChallenge(challenge);
      if (definition == null) {
        await _answerClassicChallenge(tester, challenge);
      } else {
        await _tapInlineMemoryCorrectTile(tester, definition);
      }

      final nextLabel =
          index == challenges.length - 1 ? 'Finish lesson' : 'Next';
      await tester.ensureVisible(find.text(nextLabel));
      await tester.pump();
      await tester.tap(find.text(nextLabel));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    expect(find.text('Review complete!'), findsOneWidget);
    expect(find.text('Skill reinforced'), findsOneWidget);
    expect(find.text('Mistakes reviewed'), findsOneWidget);
    expect(find.text('New sticker!'), findsNothing);
    expect(find.text('Next lesson'), findsNothing);

    await tester.ensureVisible(find.text('Back home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back home'));
    await tester.pumpAndSettle();

    expect(find.text('Practice tricky bits'), findsNothing);
  });

  testWidgets('plays memory puzzle inline and returns result', (tester) async {
    final profile = _testProfileWithPracticeSessions([
      PracticeSession(
        completedAt: DateTime(2026, 6, 12, 18),
        challengeId: 'lesson.009',
        challengeTitle: 'Memory lesson',
        skill: 'Working memory',
        minutes: 5,
        correctAnswers: 2,
        totalQuestions: 5,
        wrongAttempts: 2,
        mistakePuzzleIds: ['memory.order.normal.003'],
      ),
    ]);
    final challenge = _firstAdaptiveReviewChallenge(profile);
    final definition = MiniGameRegistry.definitionForChallenge(challenge)!;
    final store = _MemoryFamilyProfileStore(profile);

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Review'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Memory Grid'), findsOneWidget);
    expect(find.text('Play directly in this puzzle'), findsOneWidget);
    expect(find.text('Play mini-game'), findsNothing);

    await _tapInlineMemoryCorrectTile(tester, definition);

    expect(find.textContaining('Correct!'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('shows a lesson hint before checking an answer', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Hint'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hint'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('The shapes alternate'),
      findsOneWidget,
    );
  });

  testWidgets('opens a retry hint after a wrong lesson answer', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Triangle').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Triangle').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Think step by step'), findsOneWidget);
    expect(
      find.text('Good try. Read the hint, then choose again.'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(find.text('Try again'), 300);

    expect(find.text('Try again'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Circle').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check'));
    await tester.pumpAndSettle();

    expect(find.text('Correct!'), findsNothing);
    expect(find.textContaining('Correct!'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('shows reward moment after completing a lesson', (tester) async {
    final store = _MemoryFamilyProfileStore(_testProfile());

    await tester.pumpWidget(
      BrainUpApp(
        familyProfileStore: store,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    final answers = ['Circle', '3', 'Ball', 'Lock', 'Lock'];
    for (var index = 0; index < answers.length; index += 1) {
      final answer = answers[index];
      final answerFinder = find.text(answer).last;
      await tester.ensureVisible(answerFinder);
      await tester.pumpAndSettle();
      await tester.tap(answerFinder);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Check'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Check'));
      await tester.pumpAndSettle();
      final nextLabel = index == answers.length - 1 ? 'Finish lesson' : 'Next';
      await tester.ensureVisible(find.text(nextLabel));
      await tester.pumpAndSettle();
      await tester.tap(find.text(nextLabel));
      await tester.pumpAndSettle();
    }

    expect(find.text('New sticker!'), findsOneWidget);
    expect(find.text('Space Station mission'), findsOneWidget);
    expect(find.text('1/3 lessons repaired'), findsOneWidget);
    expect(find.text('Lesson summary'), findsOneWidget);
    expect(find.text('Questions'), findsOneWidget);
    expect(find.text('+1 sticker'), findsOneWidget);

    await tester.ensureVisible(find.text('Next lesson'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next lesson'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Step 1 of'), findsOneWidget);
  });

  testWidgets('shows concrete course lesson progress states', (tester) async {
    final profile = _testProfileWithCompletedLessons(['lesson.001']);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildAppTheme(),
        home: CourseScreen(
          profile: profile,
          course: FoundationCatalog.starterCourses.first,
          onStartLesson: (_) {},
          onBackHome: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 of 8 lessons complete'), findsOneWidget);
    expect(find.text('Stars'), findsOneWidget);
    expect(find.text('+1 star'), findsNothing);
    expect(find.text('done'), findsOneWidget);
    expect(find.text('open'), findsAtLeastNWidgets(1));
    expect(find.text('locked'), findsAtLeastNWidgets(1));
  });

  testWidgets('shows parent skill insights panel', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: buildAppTheme(),
        home: ParentScreen(
          profile: _testProfile(),
          currentLocale: const Locale('en'),
          onChildSelected: (_) async {},
          onChildAdded: ({
            required childAge,
            required childName,
            required learningGoal,
          }) async {},
          onLocaleChanged: (_) async {},
          onSubscriptionPlanChanged: (_) async {},
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.dragFrom(const Offset(400, 520), const Offset(0, -1200));
    await tester.pumpAndSettle();

    expect(find.text('Skills and recommendations'), findsOneWidget);
    expect(find.text('Strong area'), findsOneWidget);
    expect(find.text('Practice next'), findsOneWidget);
  });

  testWidgets('shows accuracy-based parent recommendation', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: ParentScreen(
          profile: _testProfileWithPracticeSessions([
            PracticeSession(
              completedAt: DateTime.now(),
              challengeId: 'lesson.low-accuracy',
              challengeTitle: 'Low accuracy lesson',
              skill: 'Math thinking',
              minutes: 4,
              correctAnswers: 1,
              totalQuestions: 4,
              usedHints: 0,
              wrongAttempts: 3,
            ),
          ]),
          currentLocale: const Locale('en'),
          onChildSelected: (_) async {},
          onChildAdded: ({
            required childAge,
            required childName,
            required learningGoal,
          }) async {},
          onLocaleChanged: (_) async {},
          onSubscriptionPlanChanged: (_) async {},
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.dragFrom(const Offset(400, 520), const Offset(0, -1200));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('accuracy is the main signal'),
      findsOneWidget,
    );
  });

  testWidgets('shows parent review mastery insights', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: ParentScreen(
          profile: _testProfileWithPracticeSessions([
            PracticeSession(
              completedAt: DateTime(2026, 6, 12, 18),
              challengeId: 'lesson.memory',
              challengeTitle: 'Memory lesson',
              skill: 'Working memory',
              minutes: 5,
              correctAnswers: 2,
              totalQuestions: 5,
              wrongAttempts: 2,
              mistakePuzzleIds: ['memory.order.normal.003'],
            ),
            PracticeSession(
              completedAt: DateTime(2026, 6, 13, 18),
              challengeId: 'lesson.review.adaptive',
              challengeTitle: 'Review complete',
              skill: 'Working memory',
              minutes: 3,
              correctAnswers: 5,
              totalQuestions: 5,
              reviewedPuzzleIds: ['memory.order.normal.003'],
            ),
          ]),
          currentLocale: const Locale('en'),
          onChildSelected: (_) async {},
          onChildAdded: ({
            required childAge,
            required childName,
            required learningGoal,
          }) async {},
          onLocaleChanged: (_) async {},
          onSubscriptionPlanChanged: (_) async {},
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.dragFrom(const Offset(400, 520), const Offset(0, -1400));
    await tester.pumpAndSettle();

    expect(find.text('Review progress'), findsOneWidget);
    expect(find.text('Resolved'), findsOneWidget);
    expect(find.text('Needs review'), findsOneWidget);
    expect(find.text('Review sessions'), findsOneWidget);
    expect(
      find.textContaining('mistakes are resolved'),
      findsOneWidget,
    );
  });

  testWidgets('shows recent practice history for parents', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildAppTheme(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: ParentScreen(
          profile: _testProfileWithPracticeSessions([
            PracticeSession(
              completedAt: DateTime(2026, 6, 10, 18),
              challengeId: 'lesson.old',
              challengeTitle: 'Old lesson',
              skill: 'Logic',
              minutes: 3,
              correctAnswers: 2,
              totalQuestions: 4,
              usedHints: 1,
              wrongAttempts: 2,
            ),
            PracticeSession(
              completedAt: DateTime(2026, 6, 11, 18),
              challengeId: 'lesson.recent',
              challengeTitle: 'Recent lesson',
              skill: 'Math thinking',
              minutes: 5,
              correctAnswers: 4,
              totalQuestions: 4,
              usedHints: 0,
              wrongAttempts: 0,
            ),
          ]),
          currentLocale: const Locale('en'),
          onChildSelected: (_) async {},
          onChildAdded: ({
            required childAge,
            required childName,
            required learningGoal,
          }) async {},
          onLocaleChanged: (_) async {},
          onSubscriptionPlanChanged: (_) async {},
          onResetProfile: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.dragFrom(const Offset(400, 520), const Offset(0, -1700));
    await tester.pumpAndSettle();

    expect(find.text('Practice history'), findsOneWidget);
    expect(find.text('Accuracy 100%'), findsOneWidget);
    expect(find.text('Mistakes 0'), findsOneWidget);
  });

  testWidgets('switches and saves app language from parent settings',
      (tester) async {
    final profileStore = _MemoryFamilyProfileStore(_testProfile());
    final localeStore = _MemoryAppLocaleStore();

    await tester.pumpWidget(
      BrainUpApp(
        appLocaleStore: localeStore,
        familyProfileStore: profileStore,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Родителю'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Язык приложения'), 700);
    await tester.dragFrom(const Offset(400, 520), const Offset(0, -260));
    await tester.pumpAndSettle();

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(localeStore.locale, const Locale('en'));
    expect(find.text('App language'), findsOneWidget);
    expect(find.text('Parent'), findsOneWidget);

    await tester.tap(find.text('Russian'));
    await tester.pumpAndSettle();

    expect(localeStore.locale, const Locale('ru'));
    expect(find.text('Язык приложения'), findsOneWidget);
    expect(find.text('Родителю'), findsOneWidget);
  });
}

FamilyProfile _testProfile() {
  return FamilyProfile(
    childName: 'Leo',
    childAge: ChildAge.five,
    createdAt: DateTime(2026, 6, 8),
  );
}

FamilyProfile _testProfileWithPracticeSessions(List<PracticeSession> sessions) {
  return FamilyProfile(
    childName: 'Leo',
    childAge: ChildAge.five,
    createdAt: DateTime(2026, 6, 8),
    practiceSessions: sessions,
  );
}

FamilyProfile _testProfileWithCompletedLessons(List<String> lessonIds) {
  final createdAt = DateTime(2026, 6, 8);
  final child = ChildProfile(
    id: 'child-lesson-progress',
    name: 'Leo',
    age: ChildAge.five,
    createdAt: createdAt,
    completedLessonIds: lessonIds,
    completedMapNodeIds: const ['node.001'],
    mapStars: lessonIds.length,
  );

  return FamilyProfile(
    childName: child.name,
    childAge: child.age,
    createdAt: createdAt,
    childProfiles: [child],
    activeChildId: child.id,
  );
}

FamilyProfile _testProfileWithStars(int stars) {
  final createdAt = DateTime(2026, 6, 8);
  final child = ChildProfile(
    id: 'child-collector',
    name: 'Leo',
    age: ChildAge.five,
    createdAt: createdAt,
    mapStars: stars,
  );

  return FamilyProfile(
    childName: child.name,
    childAge: child.age,
    createdAt: createdAt,
    childProfiles: [child],
    activeChildId: child.id,
  );
}

DailyChallenge _firstAdaptiveReviewChallenge(FamilyProfile profile) {
  return _adaptiveReviewChallenges(profile).first;
}

List<DailyChallenge> _adaptiveReviewChallenges(FamilyProfile profile) {
  final child = profile.activeChild;
  final puzzles = FoundationCatalog.puzzlesForLesson(
    lesson: FoundationCatalog.adaptiveReviewLesson,
    ageBandId: _ageBandIdForChild(child),
    reviewProfile: PracticeReviewProfile.fromSessions(child.practiceSessions),
  );
  return [
    for (final puzzle in puzzles) dailyChallengeForPuzzle(puzzle, child.age),
  ];
}

AgeBandId _ageBandIdForChild(ChildProfile child) {
  return switch (child.age) {
    ChildAge.four || ChildAge.five => AgeBandId.age4to5,
    ChildAge.six => AgeBandId.age6,
    ChildAge.seven || ChildAge.eight => AgeBandId.age7to8,
  };
}

Finder _gameWidgetFinder() {
  return find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString().startsWith('GameWidget'),
  );
}

Future<void> _tapInlineMemoryCorrectTile(
  WidgetTester tester,
  MiniGameDefinition definition,
) async {
  final correctIndex = definition.firstRound.choiceIds.indexOf(
    definition.firstRound.correctChoiceId,
  );
  expect(correctIndex, greaterThanOrEqualTo(0));

  final gameFinder = _gameWidgetFinder().first;
  await tester.ensureVisible(gameFinder);
  await tester.pump();

  final gameRect = tester.getRect(gameFinder);
  await tester.tapAt(
    _memoryTileCenter(
      gameRect: gameRect,
      choiceCount: definition.firstRound.choiceIds.length,
      correctIndex: correctIndex,
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 700));
}

Future<void> _answerClassicChallenge(
  WidgetTester tester,
  DailyChallenge challenge,
) async {
  final correctChoice = challenge.choices.firstWhere(
    (choice) => challenge.isCorrectChoice(choice.id),
  );
  final l10n = lookupAppLocalizations(const Locale('en'));
  final answerFinder = find
      .text(
        l10n.choiceLabelFor(challenge, correctChoice),
      )
      .last;
  await tester.ensureVisible(answerFinder);
  await tester.pump();
  await tester.tap(answerFinder);
  await tester.pump();
  await tester.ensureVisible(find.text('Check'));
  await tester.pump();
  await tester.tap(find.text('Check'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Offset _memoryTileCenter({
  required Rect gameRect,
  required int choiceCount,
  required int correctIndex,
}) {
  if (choiceCount <= 3) {
    final tileWidth = math.min(
      118.0,
      (gameRect.width - 56 - (choiceCount - 1) * 12) / choiceCount,
    );
    const tileHeight = 106.0;
    final totalWidth = tileWidth * choiceCount + (choiceCount - 1) * 12;
    final topLeft = Offset(
      (gameRect.width - totalWidth) / 2,
      gameRect.height * 0.43 - tileHeight / 2,
    );
    return gameRect.topLeft +
        topLeft +
        Offset(
          correctIndex * (tileWidth + 12) + tileWidth / 2,
          tileHeight / 2,
        );
  }

  if (choiceCount == 4) {
    final tileSize = math.min(100.0, gameRect.size.shortestSide / 3.2);
    final gap = tileSize * 0.18;
    final gridWidth = tileSize * 2 + gap;
    final topLeft = Offset(
      (gameRect.width - gridWidth) / 2,
      (gameRect.height - gridWidth) / 2 - 12,
    );
    final row = correctIndex ~/ 2;
    final column = correctIndex % 2;
    return gameRect.topLeft +
        topLeft +
        Offset(
          column * (tileSize + gap) + tileSize / 2,
          row * (tileSize + gap) + tileSize / 2,
        );
  }

  final tileSize = math.min(86.0, gameRect.size.shortestSide / 4.2);
  final gap = tileSize * 0.16;
  final gridWidth = tileSize * 3 + gap * 2;
  final topLeft = Offset(
    (gameRect.width - gridWidth) / 2,
    (gameRect.height - gridWidth) / 2 - 12,
  );
  final row = correctIndex ~/ 3;
  final column = correctIndex % 3;
  return gameRect.topLeft +
      topLeft +
      Offset(
        column * (tileSize + gap) + tileSize / 2,
        row * (tileSize + gap) + tileSize / 2,
      );
}

class _MemoryFamilyProfileStore implements FamilyProfileStore {
  _MemoryFamilyProfileStore(this.profile);

  FamilyProfile? profile;

  @override
  Future<void> clear() async {
    profile = null;
  }

  @override
  Future<FamilyProfile?> load() async {
    return profile;
  }

  @override
  Future<void> save(FamilyProfile profile) async {
    this.profile = profile;
  }
}

class _MemoryAppLocaleStore implements AppLocaleStore {
  Locale? locale;

  @override
  Future<Locale?> load() async {
    return locale;
  }

  @override
  Future<void> save(Locale locale) async {
    this.locale = locale;
  }
}
