# Модель контента

## Основа

Модель контента должна быть совместима с текущим `D:\Project\LogicLike`, где уже есть `CourseDefinition`, `Lesson`, `LessonStep`, `PuzzleDefinition`, `PuzzleType`, `SkillTag` и возрастные группы.

Новый слой Duolingo-style добавляет поверх этого карту прогресса: path units, path nodes, mastery state, daily goal и mistake review.

## LearningPath

LearningPath - основная карта обучения.

Поля:

- id;
- titleKey;
- subtitleKey;
- ageBandId;
- unitIds;
- dailyGoalPolicy;
- localizationNamespace.

## PathUnit

PathUnit - группа уроков на карте, например “Закономерности 1” или “Счет и сравнение”.

Поля:

- id;
- titleKey;
- descriptionKey;
- order;
- nodeIds;
- primarySkillTags;
- unlockRule;

## PathNode

PathNode - конкретная точка на карте.

Поля:

- id;
- unitId;
- order;
- lessonId;
- nodeType;
- requiredCompletedNodeIds;
- masteryState;
- rewardXp;

Типы:

- lesson;
- review;
- chest;
- boss;
- story;
- practice.

## CourseDefinition

CourseDefinition из исходного проекта можно оставить для группировки контента по трекам:

- logic;
- math;
- spatial;
- attention;
- rebus;
- mixed.

В Duolingo-style версии курсы могут стать источником уроков для карты, но главный child-facing flow должен вести через `LearningPath`.

## Навык

Навык - это аналитическая единица, которую пользователь развивает через серию уроков.

Поля:

- id;
- title;
- description;
- ageRange;
- difficulty;
- prerequisites;
- lessons;
- masteryRules.

Пример:

```json
{
  "id": "patterns-basic",
  "title": "Закономерности",
  "description": "Поиск правила в рядах фигур, чисел и объектов.",
  "ageRange": "6-8",
  "difficulty": 1,
  "prerequisites": [],
  "lessons": ["patterns-basic-1", "patterns-basic-2"],
  "masteryRules": {
    "minAccuracy": 0.8,
    "minCompletedLessons": 2
  }
}
```

## Урок

Урок - короткая завершенная сессия из нескольких задач.

Поля:

- id;
- skillId;
- title;
- description;
- estimatedMinutes;
- difficulty;
- exerciseIds;
- rewardXp;

Пример:

```json
{
  "id": "patterns-basic-1",
  "skillId": "patterns-basic",
  "title": "Первые закономерности",
  "description": "Находим, что меняется в последовательности.",
  "estimatedMinutes": 5,
  "difficulty": 1,
  "exerciseIds": ["ex-001", "ex-002", "ex-003"],
  "rewardXp": 10
}
```

## Задание

Задание - минимальная единица проверки.

Поля:

- id;
- type;
- skillId;
- difficulty;
- prompt;
- media;
- options;
- correctAnswer;
- explanation;
- hints;
- tags.

Пример:

```json
{
  "id": "ex-001",
  "type": "single-choice",
  "skillId": "patterns-basic",
  "difficulty": 1,
  "prompt": "Что должно быть следующим?",
  "media": null,
  "options": [
    { "id": "a", "label": "Круг" },
    { "id": "b", "label": "Квадрат" },
    { "id": "c", "label": "Треугольник" }
  ],
  "correctAnswer": "b",
  "explanation": "Фигуры чередуются: круг, квадрат, круг, квадрат.",
  "hints": ["Посмотри, повторяются ли фигуры по очереди."],
  "tags": ["sequence", "visual-pattern"]
}
```

## Типы заданий MVP

### single-choice

Один правильный ответ из нескольких вариантов.

### multiple-choice

Несколько правильных ответов.

### sequence

Выбор следующего элемента или восстановление порядка.

### classify

Разделение объектов по правилу.

### numeric-input

Короткий числовой ответ.

## Правила качества контента

- У каждой задачи должен быть один проверяемый правильный ответ.
- Объяснение должно быть короче условия.
- Сложность должна расти постепенно.
- Нельзя смешивать несколько новых идей в одном задании.
- Визуальные задачи должны быть понятны без длинного текста.
- Ошибка пользователя должна давать полезный сигнал о слабом навыке.
