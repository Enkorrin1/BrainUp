# Анализ исходного LogicLike

## Источник

Референс-проект: `D:\Project\LogicLike`.

Это уже не пустая идея, а рабочая Flutter-мобильная база с доменными моделями, экранами, локализацией, тестами, ассетами и дорожной картой.

## Что есть в исходном проекте

### Платформа

- Flutter/Dart;
- Android и iOS;
- проект расположен в `mobile`;
- локальное хранилище через `SharedPreferences`;
- локализация EN/RU через ARB;
- `flutter_svg` для визуальных задач;
- `flutter_test` и `flutter_lints`.

### Продукт

В текущем `LogicLike` есть:

- onboarding ребенка;
- выбор возраста 4-8;
- family profile;
- learning goal;
- home learning hub;
- daily mission;
- course catalog;
- lesson flow;
- hints;
- answer feedback;
- lesson completion;
- rewards and sticker collection;
- parent analytics;
- practice history;
- adaptive recommendations;
- localization switch.

### Доменные сущности

Уже есть или явно используются:

- `AgeBandId`;
- `PuzzleType`;
- `SkillTag`;
- `RewardType`;
- `MapNodeState`;
- `CourseTrack`;
- `CourseDefinition`;
- `AgeBand`;
- `LevelMap`;
- `MapNode`;
- `Lesson`;
- `LessonStep`;
- `PuzzleDefinition`;
- `PuzzleAttempt`;
- `RewardDefinition`;
- `ChildProgress`;
- `ChildProfile`;
- `FamilyProfile`;
- `PracticeSession`.

### Типы задач

Существующая база поддерживает оригинальные логические задачи:

- odd one out;
- sequence complete;
- pair match;
- category sort;
- path puzzle;
- count bridge;
- visual compare;
- analogy.

В контенте уже встречаются:

- shape path;
- fruit pattern;
- toy count;
- odd card;
- memory pairs;
- lock key;
- shadow match;
- logic train;
- sticker sum;
- balance scale;
- code grid;
- number bridge;
- detail count;
- shape rotation;
- space sequence;
- shape stack.

## Что переносим в новый проект

Переносить нужно не визуальную копию, а архитектурную и продуктовую основу:

- Flutter app structure;
- доменный слой;
- локализацию;
- возрастные группы;
- типы пазлов;
- уроки и шаги;
- профиль ребенка;
- прогресс;
- родительскую аналитику;
- тестовый подход.

## Что меняем

Главное отличие нового проекта: форма обучения должна быть как в Duolingo.

Значит, вместо текущего акцента на learning hub нужно сделать:

- главный экран как вертикальную или островную карту прогресса;
- один очевидный следующий урок;
- последовательность узлов;
- locked/current/completed/mastered состояния;
- streak как центральную привычку;
- hearts как ограничитель ошибок;
- XP как ежедневный прогресс;
- mistake review после урока;
- daily goal;
- end-of-lesson reward moment;
- повторение старых навыков, когда они ослабевают.

## Что нельзя делать

- Нельзя копировать бренд Duolingo или LogicLike.
- Нельзя использовать чужие exact UI, тексты задач, ассеты или персонажей.
- Нельзя превращать проект в веб-стек, если цель - продолжать текущую мобильную базу.
- Нельзя ломать iOS-совместимость ради Android-only решений.
- Нельзя добавлять новые user-visible строки без l10n.

## Вывод

Новый проект должен быть не “похожий сайт”, а Flutter mobile app, построенный на базе `LogicLike`, где оригинальный логический контент упакован в Duolingo-подобную учебную механику.
