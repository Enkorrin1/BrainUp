# Content Stage 8 Status

Date: 2026-06-13.

## Stage

Stage 8: adaptive review signal clearing.

## Goal

Successful adaptive review should reduce or clear the signals that created the
review mission. The child should not be asked to repeat the same solved mistake
forever.

## Completed

Added reviewed puzzle tracking:

```text
mobile/lib/src/domain/family_profile.dart
```

`PracticeSession` now stores `reviewedPuzzleIds` with backward-compatible JSON
defaults.

Updated lesson completion flow:

```text
mobile/lib/src/features/lesson/lesson_screen.dart
mobile/lib/src/app/app_controller.dart
```

Adaptive review sessions now save all puzzle ids that were reviewed during the
recap. Normal lessons keep this list empty.

Updated review signal generation:

```text
mobile/lib/src/domain/learning_foundation.dart
```

`PracticeReviewProfile.fromSessions(...)` now reads newest sessions first. A
successful review session:

- marks reviewed puzzle ids as resolved;
- prevents older matching mistake ids from creating a new review mission;
- reinforces the reviewed skill tags so older weak-skill signals can be cleared.

## Tests

Updated:

```text
mobile/test/family_profile_test.dart
mobile/test/app_controller_test.dart
mobile/test/learning_foundation_test.dart
mobile/test/widget_test.dart
```

Coverage now checks:

- `reviewedPuzzleIds` serialize and restore;
- adaptive review completion stores reviewed puzzle ids;
- successful review clears older mistake and weak-skill signals;
- returning to the map after successful review hides the review mission.

## Verification

Executed:

```powershell
cd mobile
flutter analyze
flutter test
```

Result:

- `flutter analyze` passed with no issues;
- `flutter test` passed: 63 tests passed.

## Next Stage

Content Stage 9: add richer review progress feedback, such as streaks for
review mastery and parent-facing resolved-mistake insights.
