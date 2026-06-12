# Prototype Stage 2 Status

Date: 2026-06-12.

## Stage

Stage 2: Duolingo-style доменная модель.

## Что сделано

Добавлен доменный файл:

```text
mobile/lib/src/domain/duolingo_path.dart
```

Добавлены модели:

- `LearningPath`;
- `PathUnit`;
- `PathNode`;
- `PathNodeType`;
- `PathNodeState`;
- `LessonResult`;
- `MistakeReviewItem`;
- `DailyGoal`;
- `HeartState`;
- `StreakState`.

## Что умеет модель

- Выбирать первый доступный незавершенный узел как текущий.
- Определять состояние узла: `completed`, `current`, `locked`.
- Проверять prerequisites через `requiredCompletedNodeIds`.
- Находить узел по `lessonId`.
- Считать accuracy урока.
- Определять, были ли ошибки в уроке.
- Создавать и закрывать элементы mistake review.
- Считать прогресс daily goal.
- Списывать и восстанавливать hearts с clamp.
- Обновлять streak: первый день, тот же день, следующий день, разрыв.

## Тесты

Добавлен тестовый файл:

```text
mobile/test/duolingo_path_test.dart
```

Покрыто:

- current node на пустом прогрессе;
- unlocking следующего узла;
- complete path без следующего узла;
- accuracy и mistakes в `LessonResult`;
- resolve для `MistakeReviewItem`;
- progress для `DailyGoal`;
- clamp для `HeartState`;
- start/keep/increment/reset для `StreakState`.

## Осознанные ограничения

- Модели пока не подключены к `AppController`.
- Прогресс `LearningPath` пока не сохраняется в `FamilyProfile`.
- `PathScreen` еще не создан.
- Старые `LogicLike` названия в package/app/l10n пока не переименованы.
- Android emulator smoke пока рано запускать: на этом этапе нет нового UI.

## Проверки

Flutter SDK найден по абсолютному пути:

```text
D:\Program Files\flutter\bin\flutter.bat
```

Выполнено:

```powershell
cd mobile
flutter pub get
flutter analyze
flutter test test\duolingo_path_test.dart
```

Результат:

- `flutter pub get` прошел;
- `flutter analyze` прошел без замечаний;
- `flutter test test\duolingo_path_test.dart` прошел: 8 tests passed.

Полный `flutter test` сначала падал из-за нехватки места в системной temp-папке `C:\Users\egorc\AppData\Local\Temp`. После переноса `TEMP`/`TMP` на диск `D:` полный suite прошел на Stage 3.

Для Android smoke на UI-этапах:

```powershell
adb devices
flutter run -d <device-id>
```

## Следующий этап

Stage 3: создать уникальный Duolingo-style `PathScreen` как главный экран после onboarding:

- top bar: hearts, streak, XP;
- вертикальная или островная карта;
- completed/current/locked узлы;
- старт текущего урока;
- уникальный визуальный стиль, не копия текущего `LogicLike`.
