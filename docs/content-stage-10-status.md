# Content Stage 10 Status

## Goal

Run Android emulator smoke and visual QA for the current BrainUp prototype,
with seeded review data that exercises the adaptive review entry point and
parent-facing review mastery panel.

## Emulator

- Device: `emulator-5554`
- App package: `com.brainup.app`
- Build: debug APK from `mobile/build/app/outputs/flutter-apk/app-debug.apk`
- Seed profile: `Mira`, age 6, logic goal, 7 completed tasks, 4-day streak,
  280 XP, 2 open review signals, 1 resolved review signal.

## Checks Completed

- Installed the debug APK on the emulator.
- Seeded the debug SharedPreferences profile through `run-as`.
- Launched BrainUp and confirmed the foreground package is `com.brainup.app`.
- Confirmed the path screen renders the BrainUp route and the adaptive
  "repeat tricky work" card with 2 review tasks.
- Opened the adaptive review lesson from the path card and confirmed the
  lesson screen starts at step 1 of 5 with the expected memory review task.
- Confirmed the parent screen renders review mastery metrics:
  - resolved: 1;
  - needs review: 2;
  - review sessions: 1.
- Captured a logcat tail after QA with no BrainUp fatal exception observed.

## Artifacts

Saved under `mobile/qa-artifacts/stage-10/`:

- `stage10-map-smoke.png`
- `stage10-map-smoke.xml`
- `stage10-review-tap-result.png`
- `stage10-parent-review-progress-2.png`
- `stage10-parent-review-progress-2.xml`
- `stage10-logcat-tail.txt`
- seeded `stage10-FlutterSharedPreferences.xml`

## Note

The emulator also had the old `com.logiclike.logic_like` package installed.
One intermediate foreground check showed that old app on screen, so the QA
flow explicitly refocused `com.brainup.app` and re-ran the review entry check
against BrainUp.
