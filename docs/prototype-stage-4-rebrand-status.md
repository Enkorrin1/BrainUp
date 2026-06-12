# Prototype Stage 4: BrainUp Rebrand And Visual Separation

Date: 2026-06-12

## Goal

Move the prototype away from the source-project identity and make the app read as
BrainUp: a separate product with its own naming, package ids, storage keys, and
first-run visual direction.

## Completed

- Renamed the Flutter package to `brain_up`.
- Renamed the app entry class to `BrainUpApp`.
- Updated Android label, namespace, and application id to `com.brainup.app`.
- Updated iOS display name and bundle identifiers to BrainUp naming.
- Replaced local storage keys with `brain_up.*` keys.
- Updated EN/RU visible app copy to BrainUp.
- Rebuilt generated l10n files.
- Reworked onboarding into a BrainUp-specific visual direction:
  - neural-route hero;
  - no legacy mascot/space illustration dependency;
  - new setup panel, goal cards, age tiles, and CTA treatment.
- Removed old empty Android package folders.
- Renamed IDE module files from `logic_like` naming to `brain_up` naming.
- Updated `mobile/README.md` to describe the current BrainUp prototype.

## Verification

Commands run from `D:\Project\DualingoLogicLike\mobile`:

```powershell
& 'D:\Program Files\flutter\bin\flutter.bat' pub get
& 'D:\Program Files\flutter\bin\flutter.bat' gen-l10n
& 'D:\Program Files\flutter\bin\flutter.bat' analyze
$env:TEMP='D:\Project\DualingoLogicLike\.tmp\flutter-test-temp'
$env:TMP='D:\Project\DualingoLogicLike\.tmp\flutter-test-temp'
& 'D:\Program Files\flutter\bin\flutter.bat' test
& 'D:\Program Files\flutter\bin\flutter.bat' build apk --debug
```

Results:

- `flutter analyze`: no issues found.
- `flutter test`: 48 tests passed.
- Debug APK built successfully.
- Android emulator detected: `emulator-5554`, Android 16 API 36.
- Debug APK installed and launched as `com.brainup.app/.MainActivity`.

## Screenshots

- `mobile/brainup-onboarding.png`
- `mobile/brainup-onboarding-bottom.png`
- `mobile/brainup-path.png`

## Remaining Design Work

The prototype is now rebranded and visually separated on onboarding and the main
path. The next stage should redesign the lesson, result, parent, and course
surfaces so the whole app consistently feels like BrainUp rather than a renamed
source app.
