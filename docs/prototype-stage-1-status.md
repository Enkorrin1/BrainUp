# Prototype Stage 1 Status

Date: 2026-06-12.

## Stage

Stage 1: подготовка Flutter-основы.

## Что сделано

- В `D:\Project\BrainUp` создана папка `mobile`.
- Основа скопирована из `D:\Project\LogicLike\mobile`.
- Исходный проект `D:\Project\LogicLike` не изменялся.
- При копировании исключены кэш/сборочные папки:
  - `.dart_tool`;
  - `build`;
  - `.idea`.
- После копирования из целевой папки удалены локальные Android-артефакты:
  - `mobile/android/.gradle`;
  - `mobile/android/.kotlin`;
  - `mobile/android/local.properties`.
- Сохранены:
  - Android runner;
  - iOS runner;
  - `lib`;
  - `test`;
  - `assets`;
  - `l10n.yaml`;
  - `pubspec.yaml`;
  - `pubspec.lock`;
  - Flutter l10n setup.

## Осознанные ограничения

- Dart package пока называется `logic_like`.
- Часть классов пока содержит `LogicLike` в названии, например `LogicLikeApp`.
- В ARB и generated l10n пока есть видимое название `LogicLike`.
- Bundle/application naming еще не переименован.
- UI пока является перенесенной основой, а не уникальным BrainUp-дизайном.

Эти пункты не считаются финальным состоянием. Они должны быть устранены в следующих этапах прототипа.

## Следующий этап

Stage 2: добавить Duolingo-style доменную модель поверх существующей основы:

- `LearningPath`;
- `PathUnit`;
- `PathNode`;
- `PathNodeState`;
- `LessonResult`;
- `MistakeReviewItem`;
- `DailyGoal`;
- `HeartState`;
- `StreakState`.

## Проверки

Структура `mobile` создана и ссылки в `README.md` проверены.

Flutter-команды пока не выполнены, потому что `flutter` не найден в текущем PATH на этой машине:

```text
flutter : The term 'flutter' is not recognized as the name of a cmdlet, function, script file, or operable program.
```

Когда Flutter SDK будет доступен в PATH, нужно выполнить:

```powershell
cd mobile
flutter pub get
flutter analyze
flutter test
```
