# Stage 27 Status: Character Coach System

Stage 27 turns the documented helper characters into a runtime coaching system.
Children now see a named helper during lessons, hints, retries, correct-answer
feedback, boss-style moments, and lesson completion.

## Implemented

- Added `CharacterCoachMoment`.
- Added `CharacterCoachDefinition`.
- Added 6 coach definitions:
  - Brainy: logic and mixed quest guide.
  - Lumi: memory coach.
  - Quadra: shape and spatial coach.
  - Numba: math coach.
  - Rulo: rule and code coach.
  - Mira: focus and detail coach.
- Added skill-to-coach fallback lookup for every `SkillTag`.
- Added puzzle-to-coach lookup using visual metadata first.
- Exported `characterCoaches` in `content-manifest.json`.
- Added puzzle context fields to `DailyChallenge`.
- Preserved manual challenge copy while adding skill, world, character,
  difficulty, puzzle type, and feedback style context.
- Added coach avatar and speech cards to lesson questions.
- Added coach-specific hint text and retry support.
- Added coach-specific correct-answer feedback while preserving the existing
  localized `Correct!` explanation.
- Added coach celebration card on lesson completion and adaptive review
  completion.

## Verified

- Character catalog covers all known helper ids.
- Every skill has a default coach.
- Coach world ids resolve to known worlds.
- Generated and curated puzzle challenges carry coach context.
- Lesson widget test confirms Brainy appears on the first lesson.

## Next Stage

Stage 28 should upgrade more puzzle templates from choice simulation into true
gesture mechanics: drag, connect, reorder, flip, trace, rotate, and sort.
