# Prototype Stage 3 Status

Date: 2026-06-12.

## Stage

Stage 3: главный Duolingo-style `PathScreen`.

## Что сделано

Добавлен новый экран:

```text
mobile/lib/src/features/path/path_screen.dart
```

Обновлена навигация:

```text
mobile/lib/src/features/home/family_shell.dart
```

Первый таб после onboarding теперь открывает `PathScreen`, а не старый hub-first `HomeScreen`.

## UX

Новый экран содержит:

- top bar с hearts, streak и XP;
- текущий lesson CTA;
- карту из path nodes;
- состояния `completed`, `current`, `locked`;
- запуск урока по текущему узлу;
- запуск урока по открытому path node;
- возврат из урока обратно на карту.

## Design

Экран сделан в новом визуальном направлении: космический маршрут знаний.

Это намеренно отличается от текущего `LogicLike` hub:

- темный space backdrop;
- orbit connectors;
- planet/star visuals;
- pill-shaped path nodes;
- top metrics в стеклянных chips;
- карта как главный объект первого экрана.

## Domain

`PrototypeLearningPathCatalog` добавлен в:

```text
mobile/lib/src/domain/duolingo_path.dart
```

Он содержит первый prototype path:

- 1 unit;
- 6 nodes;
- lesson/review/boss node types;
- prerequisites между узлами;
- связь с существующими `lesson.001` - `lesson.006`.

## Tests

Обновлен:

```text
mobile/test/widget_test.dart
```

Что изменено:

- старые проверки home mission CTA заменены на path CTA;
- добавлена проверка path-first карты после загрузки профиля;
- добавлена проверка запуска урока из current path node;
- lesson tests теперь стартуют через `Continue`;
- проверки старого home catalog/collection flow убраны из app-level сценария;
- direct `CourseScreen` test оставлен, так как экран еще существует в кодовой базе.

## Localization

Новые user-visible строки не добавлялись как hard-coded copy. Экран использует существующие l10n-ключи:

- `homeGreeting`;
- `homeRecommendedLessonButton`;
- `homeRecommendedLessonCompleted`;
- `mapLessonSubtitle`;
- `mapNodeStart`;
- `mapNodeShapes`;
- `mapNodePairs`;
- `mapNodeCounting`;
- `mapNodeRhythm`;
- `mapNodeFinal`;
- `mapNodeCompleted`;
- `mapNodeCurrent`;
- `mapNodeLocked`;
- `mapPreviewReward`;
- `courseXpMetricLabel`.

## Осознанные ограничения

- Bottom navigation labels пока старые: `Home`, `Quest`, `Parent`.
- App/package naming пока `logic_like`.
- Onboarding title пока содержит `LogicLike`.
- `PathScreen` пока не сохраняет отдельные path node ids, а выводит completed node state из `completedLessonIds`.
- Android emulator smoke выполнен на `emulator-5554`.
- Visual polish нужно будет продолжать проверять на реальном viewport при следующих UI-итерациях.

## Проверки

Flutter SDK найден по абсолютному пути:

```text
D:\Program Files\flutter\bin\flutter.bat
```

Android SDK найден через Flutter Doctor:

```text
D:\AndroidSDK
```

Подключенный emulator:

```text
sdk gphone64 x86 64 • emulator-5554 • Android 16 (API 36)
```

Выполнено:

```powershell
cd mobile
flutter pub get
flutter analyze
flutter test
```

Результат:

- `flutter pub get` прошел;
- `flutter analyze` прошел без замечаний;
- `flutter test` прошел: 48 tests passed;
- `flutter build apk --debug` прошел;
- `flutter install --debug -d emulator-5554` прошел;
- приложение запущено через `adb shell am start`;
- onboarding открыт на emulator;
- после ввода тестового профиля открыт новый `PathScreen`;
- переход `Continue` с карты в урок работает.

Для обхода нехватки места в `C:\Users\egorc\AppData\Local\Temp` полный тест запускался с `TEMP`/`TMP` на диске `D:`.

Android smoke команды:

```powershell
adb devices
flutter build apk --debug
flutter install --debug -d emulator-5554
adb -s emulator-5554 shell am start -n com.logiclike.logic_like/.MainActivity
```

Smoke-сценарий выполнен:

1. Открыть приложение.
2. Пройти onboarding или загрузить профиль.
3. Убедиться, что первым экраном открывается карта.
4. Нажать `Continue`.
5. Пройти первый шаг урока.
6. Убедиться, что урок открывается с карты.

Скриншоты:

- `mobile/stage3-emulator.png` - onboarding на emulator;
- `mobile/stage3-path-screen.png` - новый path-first экран;
- `mobile/stage3-lesson-from-path.png` - урок, открытый с карты.

## Следующий этап

Stage 4: связать path progress с сохранением и lesson result глубже:

- обновлять path state после завершения урока;
- явно сохранять completed path nodes;
- подготовить mistake review entry points;
- начать переименование user-visible LogicLike branding.
