import 'family_profile.dart';

import 'learning_foundation.dart';

class DailyChallenge {
  const DailyChallenge({
    required this.id,
    required this.title,
    required this.prompt,
    required this.question,
    required this.skill,
    required this.goal,
    required this.minutes,
    required this.choices,
    required this.correctChoiceId,
    required this.hint,
    required this.explanation,
  });

  final String id;
  final String title;
  final String prompt;
  final String question;
  final String skill;
  final LearningGoal goal;
  final int minutes;
  final List<ChallengeChoice> choices;
  final String correctChoiceId;
  final String hint;
  final String explanation;

  bool isCorrectChoice(String choiceId) {
    return choiceId == correctChoiceId;
  }

  ChallengeChoice get correctChoice {
    return choices.firstWhere((choice) => choice.id == correctChoiceId);
  }
}

class ChallengeChoice {
  const ChallengeChoice({
    required this.id,
    required this.label,
  });

  final String id;
  final String label;
}

DailyChallenge dailyChallengeForDate(
  ChildAge age,
  DateTime date, {
  LearningGoal? goal,
}) {
  final challenges = dailyChallengesForAge(age, goal: goal);
  final day = DateTime.utc(date.year, date.month, date.day);
  final firstContentDay = DateTime.utc(2026, 1, 1);
  final daysSinceStart = day.difference(firstContentDay).inDays;

  return challenges[daysSinceStart % challenges.length];
}

List<DailyChallenge> dailyChallengesForAge(
  ChildAge age, {
  LearningGoal? goal,
}) {
  final challenges = _allChallengesForAge(age);
  if (goal == null) {
    return challenges;
  }

  final focusedChallenges = challenges
      .where((challenge) => challenge.goal == goal)
      .toList(growable: false);
  return focusedChallenges.isEmpty ? challenges : focusedChallenges;
}

DailyChallenge dailyChallengeById(String id, {required ChildAge age}) {
  final match = dailyChallengeByIdOrNull(id, age: age);
  if (match != null) {
    return match;
  }

  return _allChallengesForAge(age).first;
}

DailyChallenge? dailyChallengeByIdOrNull(String id, {required ChildAge age}) {
  final ageChallenges = _allChallengesForAge(age);
  final ageMatch = ageChallenges.where((challenge) => challenge.id == id);
  if (ageMatch.isNotEmpty) {
    return ageMatch.first;
  }

  for (final candidateAge in ChildAge.values) {
    final match = _allChallengesForAge(candidateAge)
        .where((challenge) => challenge.id == id);
    if (match.isNotEmpty) {
      return match.first;
    }
  }

  return null;
}

DailyChallenge dailyChallengeForPuzzle(
  PuzzleDefinition puzzle,
  ChildAge age,
) {
  final manualChallenge = dailyChallengeByIdOrNull(puzzle.payloadRef, age: age);
  if (manualChallenge != null) {
    return manualChallenge;
  }

  final skill = _skillTitleForPuzzle(puzzle.skillTag);
  final typeTitle = _titleForPuzzleType(puzzle.type);
  final difficulty = _difficultyTitle(puzzle.difficulty);
  final correctId = puzzle.correctAnswerKey;

  return DailyChallenge(
    id: puzzle.payloadRef,
    title: '$typeTitle: $difficulty',
    prompt: _promptForPuzzle(puzzle),
    question: _questionForPuzzle(puzzle, skill),
    skill: skill,
    goal: _goalForSkill(puzzle.skillTag),
    minutes: _minutesForDifficulty(puzzle.difficulty),
    correctChoiceId: correctId,
    hint: _hintForPuzzle(puzzle, skill),
    explanation: _explanationForPuzzle(puzzle, skill),
    choices: [
      ChallengeChoice(id: correctId, label: _choiceLabel(correctId)),
      const ChallengeChoice(id: 'almost', label: 'Почти'),
      const ChallengeChoice(id: 'different', label: 'Другое'),
    ],
  );
}

List<DailyChallenge> dailyChallengesByIds(
  List<String> ids, {
  required ChildAge age,
}) {
  return [
    for (final id in ids) dailyChallengeById(id, age: age),
  ];
}

String _skillTitleForPuzzle(SkillTag skillTag) {
  return switch (skillTag) {
    SkillTag.attention => 'Внимание',
    SkillTag.memory => 'Рабочая память',
    SkillTag.pattern => 'Закономерности',
    SkillTag.classification => 'Сравнение',
    SkillTag.arithmetic => 'Математическое мышление',
    SkillTag.spatial => 'Пространственное мышление',
    SkillTag.reasoning => 'Логика и дедукция',
  };
}

String _titleForPuzzleType(PuzzleType type) {
  return switch (type) {
    PuzzleType.oddOneOut => 'Лишний элемент',
    PuzzleType.sequenceComplete => 'Продолжи ряд',
    PuzzleType.pairMatch => 'Найди пару',
    PuzzleType.categorySort => 'Сортировка',
    PuzzleType.pathPuzzle => 'Маршрут',
    PuzzleType.countBridge => 'Числовой мост',
    PuzzleType.visualCompare => 'Сравнение',
    PuzzleType.analogy => 'Аналогия',
    PuzzleType.memoryGrid => 'Память',
    PuzzleType.codeBreaker => 'Код',
    PuzzleType.spatialRotation => 'Поворот',
    PuzzleType.attentionScan => 'Детали',
    PuzzleType.rebus => 'Ребус',
    PuzzleType.mixedBoss => 'Босс-задача',
  };
}

String _difficultyTitle(PuzzleDifficulty difficulty) {
  return switch (difficulty) {
    PuzzleDifficulty.easy => 'разминка',
    PuzzleDifficulty.normal => 'уровень',
    PuzzleDifficulty.hard => 'вызов',
    PuzzleDifficulty.boss => 'финал',
  };
}

LearningGoal _goalForSkill(SkillTag skillTag) {
  return switch (skillTag) {
    SkillTag.arithmetic => LearningGoal.math,
    SkillTag.attention || SkillTag.memory => LearningGoal.attention,
    _ => LearningGoal.logic,
  };
}

int _minutesForDifficulty(PuzzleDifficulty difficulty) {
  return switch (difficulty) {
    PuzzleDifficulty.easy => 3,
    PuzzleDifficulty.normal => 4,
    PuzzleDifficulty.hard => 5,
    PuzzleDifficulty.boss => 6,
  };
}

String _promptForPuzzle(PuzzleDefinition puzzle) {
  return switch (puzzle.type) {
    PuzzleType.sequenceComplete =>
      'Найди правило и продолжи последовательность.',
    PuzzleType.memoryGrid => 'Удержи связь в памяти и выбери правильную пару.',
    PuzzleType.countBridge => 'Собери число из маленьких частей.',
    PuzzleType.attentionScan => 'Посмотри внимательно и сравни детали.',
    PuzzleType.codeBreaker => 'Раскрой правило кода.',
    PuzzleType.spatialRotation => 'Представь, как фигура повернулась.',
    PuzzleType.oddOneOut => 'Найди элемент, который отличается от остальных.',
    PuzzleType.mixedBoss => 'Соедини несколько правил в одном решении.',
    _ => 'Реши короткую головоломку BrainUp.',
  };
}

String _questionForPuzzle(PuzzleDefinition puzzle, String skill) {
  return switch (puzzle.type) {
    PuzzleType.mixedBoss =>
      'Босс-уровень: какой вариант лучше всего завершает задачу на $skill?',
    PuzzleType.memoryGrid => 'Какая карточка образует правильную пару?',
    PuzzleType.codeBreaker => 'Какой ответ подходит к скрытому правилу?',
    PuzzleType.countBridge => 'Какой вариант собирает нужное число?',
    PuzzleType.spatialRotation =>
      'Какой вариант сохраняет форму после поворота?',
    _ => 'Какой вариант подходит для навыка "$skill"?',
  };
}

String _hintForPuzzle(PuzzleDefinition puzzle, String skill) {
  return 'Сначала найди главное правило: это задача на $skill. '
      'Отбрось вариант, который нарушает порядок.';
}

String _explanationForPuzzle(PuzzleDefinition puzzle, String skill) {
  return 'Правильный ответ сохраняет правило задачи на $skill. '
      'Такой формат помогает тренировать навык постепенно.';
}

String _choiceLabel(String choiceId) {
  return switch (choiceId) {
    'next' => 'Следующий',
    'pair' => 'Пара',
    'sum' => 'Сумма',
    'detail' => 'Деталь',
    'rule' => 'Правило',
    'same' => 'Та же форма',
    'odd' => 'Лишний',
    'boss' => 'Решение',
    _ => choiceId,
  };
}

List<DailyChallenge> _allChallengesForAge(ChildAge age) {
  switch (age) {
    case ChildAge.four:
    case ChildAge.five:
      return const [
        DailyChallenge(
          id: 'shape-path',
          title: 'Дорожка фигур',
          prompt: 'Посмотри на ряд и найди, что должно идти дальше.',
          question: 'Круг, квадрат, круг, квадрат. Что дальше?',
          skill: 'Закономерности',
          goal: LearningGoal.logic,
          minutes: 4,
          correctChoiceId: 'circle',
          hint: 'Фигуры чередуются: одна, потом другая, потом снова первая.',
          explanation:
              'После квадрата снова идет круг, потому что ряд повторяется через одну фигуру.',
          choices: [
            ChallengeChoice(id: 'triangle', label: 'Треугольник'),
            ChallengeChoice(id: 'circle', label: 'Круг'),
            ChallengeChoice(id: 'star', label: 'Звезда'),
          ],
        ),
        DailyChallenge(
          id: 'toy-count',
          title: 'Сколько игрушек',
          prompt: 'Посчитай предметы и выбери точный ответ.',
          question: 'На полке 2 кубика и 1 мяч. Сколько игрушек всего?',
          skill: 'Счет до пяти',
          goal: LearningGoal.math,
          minutes: 3,
          correctChoiceId: '3',
          hint: 'Сначала посчитай кубики, потом добавь мяч.',
          explanation: '2 кубика и 1 мяч дают 3 игрушки всего.',
          choices: [
            ChallengeChoice(id: '2', label: '2'),
            ChallengeChoice(id: '3', label: '3'),
            ChallengeChoice(id: '4', label: '4'),
          ],
        ),
        DailyChallenge(
          id: 'odd-card',
          title: 'Лишняя карточка',
          prompt: 'Найди предмет, который отличается от остальных.',
          question: 'Яблоко, груша, мяч, банан. Что лишнее?',
          skill: 'Сравнение',
          goal: LearningGoal.attention,
          minutes: 3,
          correctChoiceId: 'ball',
          hint: 'Три предмета можно съесть, а один нужен для игры.',
          explanation: 'Мяч лишний: яблоко, груша и банан - это фрукты.',
          choices: [
            ChallengeChoice(id: 'apple', label: 'Яблоко'),
            ChallengeChoice(id: 'ball', label: 'Мяч'),
            ChallengeChoice(id: 'banana', label: 'Банан'),
          ],
        ),
        DailyChallenge(
          id: 'fruit-pattern',
          title: 'Fruit row',
          prompt: 'Continue the fruit pattern.',
          question: 'Apple, banana, apple, banana. What comes next?',
          skill: 'Р—Р°РєРѕРЅРѕРјРµСЂРЅРѕСЃС‚Рё',
          goal: LearningGoal.logic,
          minutes: 4,
          correctChoiceId: 'apple',
          hint: 'The fruits repeat one by one: apple, then banana.',
          explanation:
              'After banana comes apple again, because the pattern repeats.',
          choices: [
            ChallengeChoice(id: 'apple', label: 'Apple'),
            ChallengeChoice(id: 'banana', label: 'Banana'),
            ChallengeChoice(id: 'pear', label: 'Pear'),
          ],
        ),
        DailyChallenge(
          id: 'shadow-match',
          title: 'Подбери тень',
          prompt: 'Найди предмет, который подходит к тени.',
          question: 'У тени высокий корпус и два маленьких крыла. Что это?',
          skill: 'Пространственное мышление',
          goal: LearningGoal.logic,
          minutes: 4,
          correctChoiceId: 'rocket',
          hint: 'Смотри на общий контур предмета.',
          explanation:
              'Ракета подходит к тени: у нее высокий корпус и два боковых крыла.',
          choices: [
            ChallengeChoice(id: 'rocket', label: 'Ракета'),
            ChallengeChoice(id: 'planet', label: 'Планета'),
            ChallengeChoice(id: 'star', label: 'Звезда'),
          ],
        ),
      ];
    case ChildAge.six:
      return const [
        DailyChallenge(
          id: 'logic-train',
          title: 'Логический поезд',
          prompt: 'Расставь вагоны по правилу.',
          question:
              'Красный, синий, синий, красный, синий, синий. Какой следующий?',
          skill: 'Последовательности',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'red',
          hint: 'Правило повторяется тройками: один красный и два синих.',
          explanation:
              'Следующий вагон красный: после двух синих начинается новая тройка.',
          choices: [
            ChallengeChoice(id: 'blue', label: 'Синий'),
            ChallengeChoice(id: 'red', label: 'Красный'),
            ChallengeChoice(id: 'green', label: 'Зеленый'),
          ],
        ),
        DailyChallenge(
          id: 'sticker-sum',
          title: 'Наклейки в альбоме',
          prompt: 'Сложи две маленькие группы предметов.',
          question: 'У Ники было 3 наклейки, потом дали еще 2. Сколько стало?',
          skill: 'Сложение до десяти',
          goal: LearningGoal.math,
          minutes: 4,
          correctChoiceId: '5',
          hint: 'Начни с трех и досчитай еще два шага.',
          explanation: '3 + 2 = 5, значит стало пять наклеек.',
          choices: [
            ChallengeChoice(id: '4', label: '4'),
            ChallengeChoice(id: '5', label: '5'),
            ChallengeChoice(id: '6', label: '6'),
          ],
        ),
        DailyChallenge(
          id: 'memory-pairs',
          title: 'Пары по памяти',
          prompt: 'Вспомни пару для каждого предмета.',
          question: 'Что подходит к ключу?',
          skill: 'Рабочая память',
          goal: LearningGoal.attention,
          minutes: 4,
          correctChoiceId: 'lock',
          hint: 'Ключ нужен, чтобы что-то открыть.',
          explanation:
              'К ключу подходит замок: вместе они образуют смысловую пару.',
          choices: [
            ChallengeChoice(id: 'lock', label: 'Замок'),
            ChallengeChoice(id: 'shoe', label: 'Ботинок'),
            ChallengeChoice(id: 'cloud', label: 'Облако'),
          ],
        ),
        DailyChallenge(
          id: 'lock-key',
          title: 'Magic pair',
          prompt: 'Choose the object that makes a pair.',
          question: 'A key opens something. What does it go with?',
          skill: 'Р Р°Р±РѕС‡Р°СЏ РїР°РјСЏС‚СЊ',
          goal: LearningGoal.attention,
          minutes: 4,
          correctChoiceId: 'lock',
          hint: 'Think about what a key is used for.',
          explanation: 'A key and a lock work together, so they form the pair.',
          choices: [
            ChallengeChoice(id: 'lock', label: 'Lock'),
            ChallengeChoice(id: 'shoe', label: 'Shoe'),
            ChallengeChoice(id: 'cloud', label: 'Cloud'),
          ],
        ),
        DailyChallenge(
          id: 'balance-scale',
          title: 'Весы',
          prompt: 'Сравни стороны и выбери, чего не хватает.',
          question: 'Слева 2 яблока. Справа 1 яблоко и ?. Что добавить?',
          skill: 'Сравнение',
          goal: LearningGoal.math,
          minutes: 5,
          correctChoiceId: 'apple',
          hint: 'На обеих сторонах должно быть одинаковое количество яблок.',
          explanation:
              'Еще одно яблоко делает правую сторону равной левой: 2 и 2.',
          choices: [
            ChallengeChoice(id: 'apple', label: 'Яблоко'),
            ChallengeChoice(id: 'star', label: 'Звезда'),
            ChallengeChoice(id: 'ball', label: 'Мяч'),
          ],
        ),
      ];
    case ChildAge.seven:
    case ChildAge.eight:
      return const [
        DailyChallenge(
          id: 'code-grid',
          title: 'Кодовая сетка',
          prompt: 'Разгадай правило и выбери правильную клетку.',
          question:
              'В первой строке 2, 4, 6. Во второй 3, 5, ?. Какое число пропущено?',
          skill: 'Логика и дедукция',
          goal: LearningGoal.logic,
          minutes: 6,
          correctChoiceId: '7',
          hint: 'Во второй строке числа тоже растут на 2.',
          explanation:
              'После 3 и 5 идет 7: каждый шаг увеличивает число на два.',
          choices: [
            ChallengeChoice(id: '6', label: '6'),
            ChallengeChoice(id: '7', label: '7'),
            ChallengeChoice(id: '8', label: '8'),
          ],
        ),
        DailyChallenge(
          id: 'number-bridge',
          title: 'Числовой мост',
          prompt: 'Соедини числа так, чтобы получить нужный маршрут.',
          question: 'У тебя есть 4, 2 и 1. Как получить 7?',
          skill: 'Математическое мышление',
          goal: LearningGoal.math,
          minutes: 5,
          correctChoiceId: '4+2+1',
          hint: 'Попробуй использовать все числа один раз.',
          explanation:
              '4 + 2 + 1 = 7, значит все три числа вместе дают нужный результат.',
          choices: [
            ChallengeChoice(id: '4+2+1', label: '4 + 2 + 1'),
            ChallengeChoice(id: '4+1', label: '4 + 1'),
            ChallengeChoice(id: '2+1', label: '2 + 1'),
          ],
        ),
        DailyChallenge(
          id: 'detail-count',
          title: 'Карта деталей',
          prompt: 'Удержи в голове несколько деталей и сравни их.',
          question:
              'Есть 3 красных круга, 2 синих квадрата и 1 зеленая звезда. Чего больше всего?',
          skill: 'Сравнение деталей',
          goal: LearningGoal.attention,
          minutes: 5,
          correctChoiceId: 'red-circles',
          hint: 'Сравни количества: 3, 2 и 1.',
          explanation: 'Больше всего красных кругов: их три.',
          choices: [
            ChallengeChoice(id: 'blue-squares', label: 'Синих квадратов'),
            ChallengeChoice(id: 'red-circles', label: 'Красных кругов'),
            ChallengeChoice(id: 'green-stars', label: 'Зеленых звезд'),
          ],
        ),
        DailyChallenge(
          id: 'shape-rotation',
          title: 'Поворот фигуры',
          prompt: 'Представь, как фигура поворачивается.',
          question:
              'Треугольник повернули вправо. Какая карточка показывает ту же фигуру?',
          skill: 'Пространственное мышление',
          goal: LearningGoal.logic,
          minutes: 6,
          correctChoiceId: 'same',
          hint: 'Поворот меняет направление, но не саму фигуру.',
          explanation:
              'Это тот же треугольник: он повернулся, но не стал другой фигурой.',
          choices: [
            ChallengeChoice(id: 'same', label: 'Тот же треугольник'),
            ChallengeChoice(id: 'circle', label: 'Круг'),
            ChallengeChoice(id: 'square', label: 'Квадрат'),
          ],
        ),
        DailyChallenge(
          id: 'space-sequence',
          title: 'Space route',
          prompt: 'Find the next space object.',
          question: 'Rocket, planet, rocket, planet. What comes next?',
          skill: 'РџРѕСЃР»РµРґРѕРІР°С‚РµР»СЊРЅРѕСЃС‚Рё',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'rocket',
          hint: 'The route repeats: rocket, then planet.',
          explanation: 'After the planet comes a rocket again.',
          choices: [
            ChallengeChoice(id: 'rocket', label: 'Rocket'),
            ChallengeChoice(id: 'planet', label: 'Planet'),
            ChallengeChoice(id: 'star', label: 'Star'),
          ],
        ),
        DailyChallenge(
          id: 'shape-stack',
          title: 'Shape tower',
          prompt: 'Continue the tower rule.',
          question: 'Square, circle, square, circle. Which shape is next?',
          skill: 'РџСЂРѕСЃС‚СЂР°РЅСЃС‚РІРµРЅРЅРѕРµ РјС‹С€Р»РµРЅРёРµ',
          goal: LearningGoal.logic,
          minutes: 5,
          correctChoiceId: 'square',
          hint: 'The tower alternates between two shapes.',
          explanation: 'After a circle comes a square again.',
          choices: [
            ChallengeChoice(id: 'square', label: 'Square'),
            ChallengeChoice(id: 'circle', label: 'Circle'),
            ChallengeChoice(id: 'triangle', label: 'Triangle'),
          ],
        ),
      ];
  }
}
