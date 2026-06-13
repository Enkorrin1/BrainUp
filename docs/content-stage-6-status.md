# Content Stage 6 Status

Date: 2026-06-13.

## Stage

Stage 6: visible adaptive review moment.

## Goal

Review should be visible to the child as a clear mission on the learning path,
not only hidden inside lesson generation.

## Completed

Added an adaptive review lesson:

```text
mobile/lib/src/domain/learning_foundation.dart
```

`FoundationCatalog.adaptiveReviewLesson` is a short recap lesson that uses the
same review-aware puzzle picker from Stage 5.

Updated path UI:

```text
mobile/lib/src/features/path/path_screen.dart
```

When practice history contains mistakes or weak-skill signals, the map shows a
dedicated review panel with a review button. Tapping it launches the adaptive
review lesson.

Updated lesson completion:

```text
mobile/lib/src/app/app_controller.dart
```

Adaptive review completion saves practice, XP, hints, wrong attempts, and
missed puzzle ids, but does not advance the main path or mark a map lesson as
complete.

Updated localized UI copy:

```text
mobile/lib/src/l10n/localized_models.dart
```

Added EN/RU adapter strings for the review panel.

## Tests

Updated:

```text
mobile/test/app_controller_test.dart
mobile/test/widget_test.dart
```

Coverage now checks:

- adaptive review completion does not advance the main path;
- the path screen shows the review panel when practice history has signals;
- tapping review opens a review lesson.

## Verification

Executed:

```powershell
cd mobile
flutter analyze
flutter test
```

Result:

- `flutter analyze` passed with no issues;
- `flutter test` passed: 61 tests passed.

## Next Stage

Content Stage 7: make adaptive review feel more complete with a dedicated
review result state and clearer reward/recap messaging.
