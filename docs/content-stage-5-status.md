# Content Stage 5 Status

Date: 2026-06-13.

## Stage

Stage 5: review-aware lesson delivery.

## Goal

BrainUp should start using practice history to make lessons feel adaptive.
Mistakes and weak skills should reappear naturally inside future lessons instead
of staying only in parent analytics.

## Completed

Added review signals to practice history:

```text
mobile/lib/src/domain/family_profile.dart
```

`PracticeSession` now stores `mistakePuzzleIds` and keeps backward-compatible
JSON defaults for old saved profiles.

Added a review profile:

```text
mobile/lib/src/domain/learning_foundation.dart
```

`PracticeReviewProfile.fromSessions(...)` reads recent sessions and extracts:

- concrete missed puzzle ids;
- weak skill tags from low accuracy, wrong attempts, and hint usage.

Updated lesson generation:

```text
mobile/lib/src/domain/learning_foundation.dart
```

`FoundationCatalog.puzzlesForLesson(...)` now accepts `reviewProfile` and
prioritizes:

- recent missed puzzles when they still fit the age band;
- weak-skill practice;
- the existing balanced mix by skill, type, age, and difficulty.

Updated lesson flow:

```text
mobile/lib/src/features/lesson/lesson_screen.dart
mobile/lib/src/app/app_controller.dart
```

The lesson UI records missed challenge ids during a lesson and saves them in
the completed practice session.

## Tests

Updated:

```text
mobile/test/family_profile_test.dart
mobile/test/app_controller_test.dart
mobile/test/learning_foundation_test.dart
```

Coverage now checks:

- `mistakePuzzleIds` serialize and restore;
- old practice sessions still load with empty mistake ids;
- lesson completion persists missed puzzle ids;
- review-aware lesson generation includes a recent missed puzzle.

## Verification

Executed:

```powershell
cd mobile
flutter analyze
flutter test
```

Result:

- `flutter analyze` passed with no issues;
- `flutter test` passed: 59 tests passed.

## Next Stage

Content Stage 6: expose review as a visible child-facing path moment, such as a
mistake-review node or short adaptive recap lesson.
