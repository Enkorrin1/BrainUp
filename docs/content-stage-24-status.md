# Stage 24 Status: Content QA

Stage 24 adds automated content QA so BrainUp can keep scaling without quietly
losing quality. The checks separate blockers from warnings: blockers fail the
content gate, while warnings highlight polish work that should be planned.

## Implemented

- Added `ContentQaSeverity`.
- Added `ContentQaIssueType`.
- Added `ContentQaIssue`.
- Added `ContentQaReport`.
- Added `FoundationCatalog.contentQaReport()`.
- Added QA output to `FoundationCatalog.contentManifest()`.
- Added QA output to `ContentDashboardReport`.
- Added QA rendering to `docs/content-dashboard.md`.

## Automated Checks

- duplicate puzzle ids;
- duplicate payload refs;
- missing correct answer key;
- missing hint keys;
- missing visual metadata;
- unknown visual world;
- unknown helper character;
- missing choice assets;
- invalid estimated seconds;
- boss puzzle age mismatch;
- excessive family repetition.

## Playability Checks

The test suite now verifies that every puzzle definition can produce a playable
daily challenge with:

- non-empty prompt, question, hint, and explanation;
- short prompt and question text;
- exactly one matching correct choice.

## Current QA Result

- blockers: 0;
- warnings: expected polish warnings for older puzzles without visual metadata
  and repeated family saturation.

## Next

Stage 25 should use these QA signals while growing toward the first large
content milestone.
