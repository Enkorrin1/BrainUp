import 'package:intl/intl.dart';

import '../domain/daily_challenge.dart';
import '../domain/family_profile.dart';
import '../domain/learning_foundation.dart';
import 'generated/app_localizations.dart';

extension LocalizedModels on AppLocalizations {
  String labelForAge(ChildAge age) {
    return ageYears(age.years);
  }

  String labelForGoal(LearningGoal goal) {
    return switch (goal) {
      LearningGoal.logic => goalLogicLabel,
      LearningGoal.math => goalMathLabel,
      LearningGoal.attention => goalAttentionLabel,
    };
  }

  String descriptionForGoal(LearningGoal goal) {
    return switch (goal) {
      LearningGoal.logic => goalLogicDescription,
      LearningGoal.math => goalMathDescription,
      LearningGoal.attention => goalAttentionDescription,
    };
  }

  String titleForCourse(CourseDefinition course) {
    return switch (course.track) {
      CourseTrack.logic => courseLogicTitle,
      CourseTrack.math => courseMathTitle,
      CourseTrack.spatial => courseSpatialTitle,
      CourseTrack.attention => courseAttentionTitle,
      CourseTrack.rebus => courseRebusTitle,
      CourseTrack.mixed => courseMixedTitle,
    };
  }

  String subtitleForCourse(CourseDefinition course) {
    return switch (course.track) {
      CourseTrack.logic => courseLogicSubtitle,
      CourseTrack.math => courseMathSubtitle,
      CourseTrack.spatial => courseSpatialSubtitle,
      CourseTrack.attention => courseAttentionSubtitle,
      CourseTrack.rebus => courseRebusSubtitle,
      CourseTrack.mixed => courseMixedSubtitle,
    };
  }

  String labelForPlan(FamilySubscriptionPlan plan) {
    return switch (plan) {
      FamilySubscriptionPlan.starter => planStarterLabel,
      FamilySubscriptionPlan.monthly => planMonthlyLabel,
      FamilySubscriptionPlan.annual => planAnnualLabel,
    };
  }

  String priceForPlan(FamilySubscriptionPlan plan) {
    return switch (plan) {
      FamilySubscriptionPlan.starter => planStarterPrice,
      FamilySubscriptionPlan.monthly => planMonthlyPrice,
      FamilySubscriptionPlan.annual => planAnnualPrice,
    };
  }

  String capacityForPlan(FamilySubscriptionPlan plan) {
    return switch (plan) {
      FamilySubscriptionPlan.starter => planStarterCapacity,
      FamilySubscriptionPlan.monthly => planFamilyCapacity,
      FamilySubscriptionPlan.annual => planFamilyCapacity,
    };
  }

  String descriptionForPlan(FamilySubscriptionPlan plan) {
    return switch (plan) {
      FamilySubscriptionPlan.starter => planStarterDescription,
      FamilySubscriptionPlan.monthly => planMonthlyDescription,
      FamilySubscriptionPlan.annual => planAnnualDescription,
    };
  }

  String statusForPlan(FamilySubscriptionPlan plan) {
    return plan.isPaid ? planActiveStatus : planInactiveStatus;
  }

  String formatShortDate(DateTime date) {
    return DateFormat.yMd(localeName).format(date);
  }

  String weekdayShort(DateTime date) {
    return switch (date.weekday) {
      DateTime.monday => weekdayMondayShort,
      DateTime.tuesday => weekdayTuesdayShort,
      DateTime.wednesday => weekdayWednesdayShort,
      DateTime.thursday => weekdayThursdayShort,
      DateTime.friday => weekdayFridayShort,
      DateTime.saturday => weekdaySaturdayShort,
      DateTime.sunday => weekdaySundayShort,
      _ => weekdaySundayShort,
    };
  }

  String titleForChallenge(DailyChallenge challenge) {
    return switch (challenge.id) {
      'shape-path' => challengeShapePathTitle,
      'fruit-pattern' => challengeFruitPatternTitle,
      'toy-count' => challengeToyCountTitle,
      'odd-card' => challengeOddCardTitle,
      'logic-train' => challengeLogicTrainTitle,
      'sticker-sum' => challengeStickerSumTitle,
      'memory-pairs' => challengeMemoryPairsTitle,
      'lock-key' => challengeLockKeyTitle,
      'shadow-match' => challengeShadowMatchTitle,
      'balance-scale' => challengeBalanceScaleTitle,
      'shape-rotation' => challengeShapeRotationTitle,
      'code-grid' => challengeCodeGridTitle,
      'number-bridge' => challengeNumberBridgeTitle,
      'detail-count' => challengeDetailCountTitle,
      'space-sequence' => challengeSpaceSequenceTitle,
      'shape-stack' => challengeShapeStackTitle,
      _ => _generatedTitleForChallenge(challenge) ?? challenge.title,
    };
  }

  String promptForChallenge(DailyChallenge challenge) {
    return switch (challenge.id) {
      'shape-path' => challengeShapePathPrompt,
      'fruit-pattern' => challengeFruitPatternPrompt,
      'toy-count' => challengeToyCountPrompt,
      'odd-card' => challengeOddCardPrompt,
      'logic-train' => challengeLogicTrainPrompt,
      'sticker-sum' => challengeStickerSumPrompt,
      'memory-pairs' => challengeMemoryPairsPrompt,
      'lock-key' => challengeLockKeyPrompt,
      'shadow-match' => challengeShadowMatchPrompt,
      'balance-scale' => challengeBalanceScalePrompt,
      'shape-rotation' => challengeShapeRotationPrompt,
      'code-grid' => challengeCodeGridPrompt,
      'number-bridge' => challengeNumberBridgePrompt,
      'detail-count' => challengeDetailCountPrompt,
      'space-sequence' => challengeSpaceSequencePrompt,
      'shape-stack' => challengeShapeStackPrompt,
      _ => _generatedPromptForChallenge(challenge) ?? challenge.prompt,
    };
  }

  String questionForChallenge(DailyChallenge challenge) {
    return switch (challenge.id) {
      'shape-path' => challengeShapePathQuestion,
      'fruit-pattern' => challengeFruitPatternQuestion,
      'toy-count' => challengeToyCountQuestion,
      'odd-card' => challengeOddCardQuestion,
      'logic-train' => challengeLogicTrainQuestion,
      'sticker-sum' => challengeStickerSumQuestion,
      'memory-pairs' => challengeMemoryPairsQuestion,
      'lock-key' => challengeLockKeyQuestion,
      'shadow-match' => challengeShadowMatchQuestion,
      'balance-scale' => challengeBalanceScaleQuestion,
      'shape-rotation' => challengeShapeRotationQuestion,
      'code-grid' => challengeCodeGridQuestion,
      'number-bridge' => challengeNumberBridgeQuestion,
      'detail-count' => challengeDetailCountQuestion,
      'space-sequence' => challengeSpaceSequenceQuestion,
      'shape-stack' => challengeShapeStackQuestion,
      _ => _generatedQuestionForChallenge(challenge) ?? challenge.question,
    };
  }

  String skillForChallenge(DailyChallenge challenge) {
    return localizedSkill(challenge.skill);
  }

  String hintForChallenge(DailyChallenge challenge) {
    return switch (challenge.id) {
      'shape-path' => challengeShapePathHint,
      'fruit-pattern' => challengeFruitPatternHint,
      'toy-count' => challengeToyCountHint,
      'odd-card' => challengeOddCardHint,
      'logic-train' => challengeLogicTrainHint,
      'sticker-sum' => challengeStickerSumHint,
      'memory-pairs' => challengeMemoryPairsHint,
      'lock-key' => challengeLockKeyHint,
      'shadow-match' => challengeShadowMatchHint,
      'balance-scale' => challengeBalanceScaleHint,
      'shape-rotation' => challengeShapeRotationHint,
      'code-grid' => challengeCodeGridHint,
      'number-bridge' => challengeNumberBridgeHint,
      'detail-count' => challengeDetailCountHint,
      'space-sequence' => challengeSpaceSequenceHint,
      'shape-stack' => challengeShapeStackHint,
      _ => _generatedHintForChallenge(challenge) ?? challenge.hint,
    };
  }

  String explanationForChallenge(DailyChallenge challenge) {
    return switch (challenge.id) {
      'shape-path' => challengeShapePathExplanation,
      'fruit-pattern' => challengeFruitPatternExplanation,
      'toy-count' => challengeToyCountExplanation,
      'odd-card' => challengeOddCardExplanation,
      'logic-train' => challengeLogicTrainExplanation,
      'sticker-sum' => challengeStickerSumExplanation,
      'memory-pairs' => challengeMemoryPairsExplanation,
      'lock-key' => challengeLockKeyExplanation,
      'shadow-match' => challengeShadowMatchExplanation,
      'balance-scale' => challengeBalanceScaleExplanation,
      'shape-rotation' => challengeShapeRotationExplanation,
      'code-grid' => challengeCodeGridExplanation,
      'number-bridge' => challengeNumberBridgeExplanation,
      'detail-count' => challengeDetailCountExplanation,
      'space-sequence' => challengeSpaceSequenceExplanation,
      'shape-stack' => challengeShapeStackExplanation,
      _ =>
        _generatedExplanationForChallenge(challenge) ?? challenge.explanation,
    };
  }

  String choiceLabelFor(DailyChallenge challenge, ChallengeChoice choice) {
    return switch ('${challenge.id}:${choice.id}') {
      'shape-path:triangle' => choiceTriangle,
      'shape-path:circle' => choiceCircle,
      'shape-path:star' => choiceStar,
      'fruit-pattern:apple' => choiceApple,
      'fruit-pattern:banana' => choiceBanana,
      'fruit-pattern:pear' => choicePear,
      'toy-count:2' => '2',
      'toy-count:3' => '3',
      'toy-count:4' => '4',
      'odd-card:apple' => choiceApple,
      'odd-card:ball' => choiceBall,
      'odd-card:banana' => choiceBanana,
      'logic-train:blue' => choiceBlue,
      'logic-train:red' => choiceRed,
      'logic-train:green' => choiceGreen,
      'sticker-sum:4' => '4',
      'sticker-sum:5' => '5',
      'sticker-sum:6' => '6',
      'memory-pairs:lock' => choiceLock,
      'memory-pairs:shoe' => choiceShoe,
      'memory-pairs:cloud' => choiceCloud,
      'lock-key:lock' => choiceLock,
      'lock-key:shoe' => choiceShoe,
      'lock-key:cloud' => choiceCloud,
      'shadow-match:rocket' => choiceRocket,
      'shadow-match:planet' => choicePlanet,
      'shadow-match:star' => choiceStar,
      'balance-scale:apple' => choiceApple,
      'balance-scale:star' => choiceStar,
      'balance-scale:ball' => choiceBall,
      'shape-rotation:same' => choiceSameTriangle,
      'shape-rotation:circle' => choiceCircle,
      'shape-rotation:square' => choiceSquare,
      'code-grid:6' => '6',
      'code-grid:7' => '7',
      'code-grid:8' => '8',
      'number-bridge:4+2+1' => '4 + 2 + 1',
      'number-bridge:4+1' => '4 + 1',
      'number-bridge:2+1' => '2 + 1',
      'detail-count:blue-squares' => choiceBlueSquares,
      'detail-count:red-circles' => choiceRedCircles,
      'detail-count:green-stars' => choiceGreenStars,
      'space-sequence:rocket' => choiceRocket,
      'space-sequence:planet' => choicePlanet,
      'space-sequence:star' => choiceStar,
      'shape-stack:square' => choiceSquare,
      'shape-stack:circle' => choiceCircle,
      'shape-stack:triangle' => choiceTriangle,
      _ => _generatedChoiceLabelFor(challenge, choice) ?? choice.label,
    };
  }

  bool get _isRu => localeName.startsWith('ru');

  String? _generatedTitleForChallenge(DailyChallenge challenge) {
    final family = _generatedFamilyFor(challenge.id);
    if (family == null) {
      return null;
    }

    if (_isRu) {
      return switch (family) {
        _GeneratedChallengeFamily.patternTrail => 'Маршрут закономерности',
        _GeneratedChallengeFamily.memoryPairs => 'Пары по памяти',
        _GeneratedChallengeFamily.mathBridge => 'Числовой мост',
        _GeneratedChallengeFamily.focusDetails => 'Охота за деталями',
        _GeneratedChallengeFamily.logicCode => 'Секретный код',
        _GeneratedChallengeFamily.spaceTurn => 'Поворот в уме',
        _GeneratedChallengeFamily.sortOdd => 'Лишний предмет',
        _GeneratedChallengeFamily.mixedBoss => 'Босс-головоломка',
      };
    }

    return switch (family) {
      _GeneratedChallengeFamily.patternTrail => 'Pattern trail',
      _GeneratedChallengeFamily.memoryPairs => 'Memory pairs',
      _GeneratedChallengeFamily.mathBridge => 'Number bridge',
      _GeneratedChallengeFamily.focusDetails => 'Detail hunt',
      _GeneratedChallengeFamily.logicCode => 'Secret code',
      _GeneratedChallengeFamily.spaceTurn => 'Mind turn',
      _GeneratedChallengeFamily.sortOdd => 'Odd one out',
      _GeneratedChallengeFamily.mixedBoss => 'Boss puzzle',
    };
  }

  String? _generatedPromptForChallenge(DailyChallenge challenge) {
    final family = _generatedFamilyFor(challenge.id);
    if (family == null) {
      return null;
    }

    if (_isRu) {
      return switch (family) {
        _GeneratedChallengeFamily.patternTrail =>
          'Найди правило, которое повторяется.',
        _GeneratedChallengeFamily.memoryPairs =>
          'Вспомни, какие предметы подходят друг к другу.',
        _GeneratedChallengeFamily.mathBridge =>
          'Собери нужное число из двух частей.',
        _GeneratedChallengeFamily.focusDetails =>
          'Просканируй картинку и сравни детали.',
        _GeneratedChallengeFamily.logicCode =>
          'Разгадай правило числового кода.',
        _GeneratedChallengeFamily.spaceTurn =>
          'Представь, как предмет поворачивается.',
        _GeneratedChallengeFamily.sortOdd =>
          'Найди предмет, который не подходит к группе.',
        _GeneratedChallengeFamily.mixedBoss =>
          'Соедини два правила в одной задаче.',
      };
    }

    return switch (family) {
      _GeneratedChallengeFamily.patternTrail => 'Find the repeating rule.',
      _GeneratedChallengeFamily.memoryPairs => 'Remember the matching pair.',
      _GeneratedChallengeFamily.mathBridge => 'Build the target number.',
      _GeneratedChallengeFamily.focusDetails => 'Scan the details carefully.',
      _GeneratedChallengeFamily.logicCode => 'Break the number code.',
      _GeneratedChallengeFamily.spaceTurn => 'Imagine the object turning.',
      _GeneratedChallengeFamily.sortOdd => 'Find what does not belong.',
      _GeneratedChallengeFamily.mixedBoss => 'Combine two rules.',
    };
  }

  String? _generatedQuestionForChallenge(DailyChallenge challenge) {
    final family = _generatedFamilyFor(challenge.id);
    if (family == null) {
      return null;
    }

    final variant = _generatedVariantIndex(challenge.id);
    final questions = _isRu
        ? switch (family) {
            _GeneratedChallengeFamily.patternTrail => const [
                'Луна, звезда, луна, звезда, ? Что дальше?',
                'Красный, синий, красный, синий, ? Что дальше?',
                '2, 4, 2, 4, ? Что дальше?',
              ],
            _GeneratedChallengeFamily.memoryPairs => const [
                'Ключ подходит к...',
                'Дождь связан с...',
                'Стопа подходит к...',
              ],
            _GeneratedChallengeFamily.mathBridge => const [
                'Собери 8 из двух частей.',
                'Собери 9 из двух частей.',
                'Собери 10 из двух частей.',
              ],
            _GeneratedChallengeFamily.focusDetails => const [
                '3 красных круга, 2 синих квадрата, 1 зеленая звезда. Чего больше?',
                '2 ракеты, 4 планеты, 3 звезды. Чего больше?',
                '5 маленьких точек, 3 большие точки, 4 линии. Чего больше?',
              ],
            _GeneratedChallengeFamily.logicCode => const [
                '2 -> 4, 3 -> 6, 5 -> ?',
                '1 -> 3, 2 -> 4, 6 -> ?',
                '9 -> 6, 7 -> 4, 5 -> ?',
              ],
            _GeneratedChallengeFamily.spaceTurn => const [
                'Треугольник повернулся вправо. Что осталось тем же?',
                'Ракета перевернулась. Чем она остается?',
                'Квадрат сделал поворот. Что изменилось?',
              ],
            _GeneratedChallengeFamily.sortOdd => const [
                'Яблоко, груша, банан, ракета. Что лишнее?',
                'Круг, квадрат, треугольник, ботинок. Что лишнее?',
                'Замок, ключ, дверь, банан. Что лишнее?',
              ],
            _GeneratedChallengeFamily.mixedBoss => const [
                'Закономерность и математика: 2, 4, 6, ? Число должно быть четным.',
                'Память и логика: ключ подходит к замку, ботинок подходит к ?',
                'Внимание и сортировка: 4 звезды, 2 звезды, 3 круга. Где больше звезд?',
              ],
          }
        : switch (family) {
            _GeneratedChallengeFamily.patternTrail => const [
                'Moon, star, moon, star, ? What comes next?',
                'Red, blue, red, blue, ? What comes next?',
                '2, 4, 2, 4, ? What comes next?',
              ],
            _GeneratedChallengeFamily.memoryPairs => const [
                'Key goes with...',
                'Rain goes with...',
                'Foot goes with...',
              ],
            _GeneratedChallengeFamily.mathBridge => const [
                'Make 8 using two parts.',
                'Make 9 using two parts.',
                'Make 10 using two parts.',
              ],
            _GeneratedChallengeFamily.focusDetails => const [
                '3 red circles, 2 blue squares, 1 green star. Most?',
                '2 rockets, 4 planets, 3 stars. Most?',
                '5 small dots, 3 big dots, 4 lines. Most?',
              ],
            _GeneratedChallengeFamily.logicCode => const [
                '2 -> 4, 3 -> 6, 5 -> ?',
                '1 -> 3, 2 -> 4, 6 -> ?',
                '9 -> 6, 7 -> 4, 5 -> ?',
              ],
            _GeneratedChallengeFamily.spaceTurn => const [
                'A triangle turns right. What stays true?',
                'A rocket turns upside down. What is it still?',
                'A square spins once. What changes?',
              ],
            _GeneratedChallengeFamily.sortOdd => const [
                'Apple, pear, banana, rocket. What does not belong?',
                'Circle, square, triangle, shoe. What does not belong?',
                'Lock, key, door, banana. What does not belong?',
              ],
            _GeneratedChallengeFamily.mixedBoss => const [
                'Pattern + math: 2, 4, 6, ? The number must be even.',
                'Memory + logic: key pairs with lock, shoe pairs with ?',
                'Focus + sorting: 4 stars, 2 stars, 3 circles. Choose most stars.',
              ],
          };
    return questions[variant];
  }

  String? _generatedHintForChallenge(DailyChallenge challenge) {
    final family = _generatedFamilyFor(challenge.id);
    if (family == null) {
      return null;
    }

    if (_isRu) {
      return switch (family) {
        _GeneratedChallengeFamily.patternTrail =>
          'Ищи самый маленький кусочек ряда, который повторяется.',
        _GeneratedChallengeFamily.memoryPairs =>
          'Подумай, какие два предмета обычно используются вместе.',
        _GeneratedChallengeFamily.mathBridge =>
          'Сложи обе части и сравни с нужным числом.',
        _GeneratedChallengeFamily.focusDetails =>
          'Сравни количества по одной группе за раз.',
        _GeneratedChallengeFamily.logicCode =>
          'Посмотри, что меняется слева направо.',
        _GeneratedChallengeFamily.spaceTurn =>
          'Поворот меняет направление, но не сам предмет.',
        _GeneratedChallengeFamily.sortOdd =>
          'У трех предметов есть общая идея, а один выбивается.',
        _GeneratedChallengeFamily.mixedBoss =>
          'Сначала реши первое правило, потом проверь вторую подсказку.',
      };
    }

    return switch (family) {
      _GeneratedChallengeFamily.patternTrail =>
        'Look for the smallest group that repeats.',
      _GeneratedChallengeFamily.memoryPairs =>
        'Think about which two objects are used together.',
      _GeneratedChallengeFamily.mathBridge =>
        'Add both parts and compare with the target.',
      _GeneratedChallengeFamily.focusDetails =>
        'Compare the counts one group at a time.',
      _GeneratedChallengeFamily.logicCode =>
        'Find what changes from left to right.',
      _GeneratedChallengeFamily.spaceTurn =>
        'A turn changes direction, not the object identity.',
      _GeneratedChallengeFamily.sortOdd =>
        'Three items share one idea. One does not.',
      _GeneratedChallengeFamily.mixedBoss =>
        'Solve the first rule, then check the second clue.',
    };
  }

  String? _generatedExplanationForChallenge(DailyChallenge challenge) {
    final family = _generatedFamilyFor(challenge.id);
    if (family == null) {
      return null;
    }

    if (_isRu) {
      return switch (family) {
        _GeneratedChallengeFamily.patternTrail =>
          'Ответ продолжает то же повторяющееся правило.',
        _GeneratedChallengeFamily.memoryPairs =>
          'Правильная пара связана по смыслу.',
        _GeneratedChallengeFamily.mathBridge =>
          'Только правильная пара дает нужное число.',
        _GeneratedChallengeFamily.focusDetails =>
          'В правильной группе самое большое количество предметов.',
        _GeneratedChallengeFamily.logicCode =>
          'Одно и то же правило применяется к каждому числу.',
        _GeneratedChallengeFamily.spaceTurn =>
          'После поворота предмет сохраняет свою форму.',
        _GeneratedChallengeFamily.sortOdd =>
          'Лишний предмет нарушает правило группы.',
        _GeneratedChallengeFamily.mixedBoss =>
          'В босс-задаче нужно объединить навыки, а не угадывать.',
      };
    }

    return switch (family) {
      _GeneratedChallengeFamily.patternTrail =>
        'The answer keeps the same repeating pattern.',
      _GeneratedChallengeFamily.memoryPairs =>
        'The correct pair has a real connection.',
      _GeneratedChallengeFamily.mathBridge =>
        'Only the correct pair reaches the target number.',
      _GeneratedChallengeFamily.focusDetails =>
        'The correct group has the largest count.',
      _GeneratedChallengeFamily.logicCode =>
        'The same rule is applied to every number.',
      _GeneratedChallengeFamily.spaceTurn =>
        'The object keeps its shape after rotation.',
      _GeneratedChallengeFamily.sortOdd =>
        'The odd item breaks the group rule.',
      _GeneratedChallengeFamily.mixedBoss =>
        'Boss puzzles ask you to combine skills, not guess.',
    };
  }

  String? _generatedChoiceLabelFor(
    DailyChallenge challenge,
    ChallengeChoice choice,
  ) {
    if (_generatedFamilyFor(challenge.id) == null) {
      return null;
    }

    final id = choice.id;
    if (!_isRu) {
      return _formatGeneratedEnglishChoice(id);
    }

    return switch (id) {
      'moon' => 'Луна',
      'star' => 'Звезда',
      'rocket' => 'Ракета',
      'red' => 'Красный',
      'blue' => 'Синий',
      'green' => 'Зеленый',
      'lock' => 'Замок',
      'cloud' => 'Облако',
      'shoe' => 'Ботинок',
      'key' => 'Ключ',
      'rain' => 'Дождь',
      'foot' => 'Стопа',
      'planet' => 'Планета',
      'planets' => 'Планеты',
      'rockets' => 'Ракеты',
      'stars' => 'Звезды',
      'apple' => 'Яблоко',
      'pear' => 'Груша',
      'banana' => 'Банан',
      'circle' => 'Круг',
      'square' => 'Квадрат',
      'triangle' => 'Треугольник',
      'door' => 'Дверь',
      'same shape' => 'Та же фигура',
      'direction only' => 'Только направление',
      'shape type' => 'Вид фигуры',
      'size' => 'Размер',
      'red circles' => 'Красные круги',
      'blue squares' => 'Синие квадраты',
      'green star' => 'Зеленая звезда',
      'small dots' => 'Маленькие точки',
      'big dots' => 'Большие точки',
      'lines' => 'Линии',
      '2 stars' => '2 звезды',
      '3 circles' => '3 круга',
      '4 stars' => '4 звезды',
      _ => _formatGeneratedEnglishChoice(id),
    };
  }

  _GeneratedChallengeFamily? _generatedFamilyFor(String id) {
    if (id.startsWith('pattern.trail.')) {
      return _GeneratedChallengeFamily.patternTrail;
    }
    if (id.startsWith('memory.pairs.')) {
      return _GeneratedChallengeFamily.memoryPairs;
    }
    if (id.startsWith('math.bridge.')) {
      return _GeneratedChallengeFamily.mathBridge;
    }
    if (id.startsWith('focus.details.')) {
      return _GeneratedChallengeFamily.focusDetails;
    }
    if (id.startsWith('logic.code.')) {
      return _GeneratedChallengeFamily.logicCode;
    }
    if (id.startsWith('space.turn.')) {
      return _GeneratedChallengeFamily.spaceTurn;
    }
    if (id.startsWith('sort.odd.')) {
      return _GeneratedChallengeFamily.sortOdd;
    }
    if (id.startsWith('mixed.boss.')) {
      return _GeneratedChallengeFamily.mixedBoss;
    }
    return null;
  }

  int _generatedVariantIndex(String id) {
    final variant = int.tryParse(id.split('.').last) ?? 1;
    return (variant - 1) % 3;
  }

  String _formatGeneratedEnglishChoice(String id) {
    if (id.contains('+')) {
      return id.replaceAll('+', ' + ');
    }

    return id.split(RegExp(r'[-_ ]')).map((part) {
      if (part.isEmpty) {
        return part;
      }
      return '${part[0].toUpperCase()}${part.substring(1)}';
    }).join(' ');
  }

  String localizedSkill(String skill) {
    return switch (skill) {
      'Focus' => _isRu ? 'Внимание' : goalAttentionLabel,
      'Working memory' => _isRu ? 'Рабочая память' : skillWorkingMemory,
      'Patterns' => _isRu ? 'Закономерности' : skillPatterns,
      'Classification' => _isRu ? 'Классификация' : skillComparison,
      'Math thinking' => _isRu ? 'Математическое мышление' : skillMathThinking,
      'Spatial thinking' =>
        _isRu ? 'Пространственное мышление' : courseSpatialTitle,
      'Logic and deduction' =>
        _isRu ? 'Логика и дедукция' : skillLogicDeduction,
      'Закономерности' => skillPatterns,
      'Счет до пяти' => skillCountingToFive,
      'Сравнение' => skillComparison,
      'Последовательности' => skillSequences,
      'Сложение до десяти' => skillAdditionToTen,
      'Рабочая память' => skillWorkingMemory,
      'Логика и дедукция' => skillLogicDeduction,
      'Математическое мышление' => skillMathThinking,
      'Сравнение деталей' => skillDetailComparison,
      'Логика' => goalLogicLabel,
      'Внимание' => goalAttentionLabel,
      _ => skill,
    };
  }
}

enum _GeneratedChallengeFamily {
  patternTrail,
  memoryPairs,
  mathBridge,
  focusDetails,
  logicCode,
  spaceTurn,
  sortOdd,
  mixedBoss,
}
