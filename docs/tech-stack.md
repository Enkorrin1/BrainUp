# Технический стек

## Базовый стек

Новый проект должен наследовать стек существующего проекта `D:\Project\LogicLike`, а не начинаться как отдельный веб-продукт.

Основной стек:

- Flutter;
- Dart;
- один код для Android и iOS;
- Material UI / кастомные Flutter widgets;
- `flutter_svg` для SVG-ассетов задач;
- `flutter_localizations` и `intl` для локализации;
- ARB-файлы для английского и русского языков;
- `SharedPreferences` для локального MVP-хранилища;
- `flutter_test` для unit/widget тестов;
- `flutter_lints` для статического анализа.

## Текущая база LogicLike

Исходный проект находится в `D:\Project\LogicLike`.

Ключевая структура:

```text
mobile/
  lib/
    main.dart
    l10n/
      app_en.arb
      app_ru.arb
    src/
      app/
      data/
      domain/
      features/
      l10n/
      theme/
  test/
  pubspec.yaml
```

Существующие зависимости:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  flutter_svg: ^2.0.10+1
  intl: any
  shared_preferences: ^2.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

## Что сохраняем из LogicLike

- Flutter/Dart как основной технологический фундамент.
- Мобильный фокус: Android и iOS.
- Разделение `app`, `data`, `domain`, `features`, `l10n`, `theme`.
- Локальное хранение профиля через `SharedPreferences` на MVP.
- Доменные модели курсов, уроков, шагов, пазлов, прогресса и семейного профиля.
- Локализацию EN/RU через ARB.
- Тестовый подход через `flutter test`.
- Проверки через `flutter analyze`.

## Что меняем под Duolingo-style

Текущий `LogicLike` уже содержит learning hub, курсы, ежедневные задания, коллекции и родительскую аналитику. Новый продукт должен сместить главный UX:

- вместо hub-first главного экрана сделать карту обучения как основной экран;
- усилить линейную прогрессию по узлам;
- сделать один главный урок дня;
- развить механику серий, XP, сердец и повторения ошибок;
- добавить состояние заблокированных, текущих, завершенных и gold/mastered уроков;
- сделать end-of-lesson экран более похожим на Duolingo: XP, accuracy, streak, mistakes review, next lesson.

## Рекомендуемая архитектура

```text
lib/src/
  app/
    app_controller.dart
    duolingo_logic_app.dart
  data/
    family_profile_store.dart
    learning_progress_store.dart
  domain/
    family_profile.dart
    learning_foundation.dart
    duolingo_path.dart
    mistake_review.dart
    streak_policy.dart
  features/
    onboarding/
    path/
    lesson/
    review/
    rewards/
    parent/
    settings/
  l10n/
  theme/
```

## Domain model

Использовать текущие модели как основу:

- `AgeBandId`;
- `PuzzleType`;
- `SkillTag`;
- `RewardType`;
- `MapNodeState`;
- `CourseTrack`;
- `CourseDefinition`;
- `Lesson`;
- `LessonStep`;
- `PuzzleDefinition`;
- `PuzzleAttempt`;
- `RewardDefinition`;
- `ChildProfile`;
- `FamilyProfile`;
- `PracticeSession`.

Добавить или расширить:

- `LearningPath`;
- `PathUnit`;
- `PathNode`;
- `NodeMasteryState`;
- `MistakeReviewItem`;
- `DailyGoal`;
- `StreakState`;
- `HeartState`;
- `XpLedger`;
- `LessonResult`.

## Storage

### MVP

Оставить локальное хранение:

- `SharedPreferences`;
- JSON-сериализация профиля;
- миграции старых полей профиля;
- сохранение завершенных уроков, XP, серий, сердец, ошибок и истории занятий.

### После MVP

Когда появится аккаунт и синхронизация:

- Supabase или Firebase как backend;
- PostgreSQL, если выбираем Supabase;
- server-side user profile;
- cloud sync прогресса между устройствами;
- родительский аккаунт;
- платежи и подписка.

## Testing

Команды из исходного проекта:

```powershell
cd mobile
flutter pub get
flutter analyze
flutter test
```

Покрыть тестами:

- расчет состояния узлов карты;
- открытие следующего урока;
- начисление XP;
- обновление streak;
- списание и восстановление hearts;
- сохранение и миграцию профиля;
- mistake review queue;
- прохождение урока;
- локализацию ключевых экранов.

## Platform

- Основная локальная проверка: Android emulator на Windows.
- iOS должен оставаться build-compatible.
- Финальная проверка iOS выполняется на macOS через Xcode/CocoaPods.
- Платформенный код добавлять только за изолированными границами.

## AI-функции

AI не нужен для MVP.

Позже можно добавить:

- генерацию черновиков новых пазлов;
- генерацию вариантов подсказок;
- адаптацию объяснения под ошибку ребенка;
- анализ слабых навыков;
- проверку качества контента.

Но проверка ответов в уроках должна оставаться детерминированной.

## Итоговая рекомендация

Делать новый продукт как Flutter mobile app на базе архитектуры `LogicLike`:

- скопировать или перенести структуру `mobile`;
- сохранить доменный слой и l10n-подход;
- заменить главный сценарий с learning hub на Duolingo-style карту;
- оставить оригинальные логические типы задач и родительскую аналитику;
- развивать прогресс, streak, hearts, XP и mistake review как ядро продукта.
