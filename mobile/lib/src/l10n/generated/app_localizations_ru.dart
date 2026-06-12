// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'BrainUp';

  @override
  String get homeTab => 'Карта';

  @override
  String get challengeTab => 'Урок';

  @override
  String get parentTab => 'Родителю';

  @override
  String homeGreeting(Object childName) {
    return 'Привет,\n$childName';
  }

  @override
  String get dailyStreakTitle => 'Серия дня';

  @override
  String get streakStart => 'Начни!';

  @override
  String dayCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня',
      many: '$count дней',
      few: '$count дня',
      one: '$count день',
    );
    return '$_temp0';
  }

  @override
  String dayCountShort(Object count) {
    return '$count дн.';
  }

  @override
  String get missionOpenButton => 'Открыть';

  @override
  String get missionStartShortButton => 'Начать';

  @override
  String get missionStartButton => 'Начать миссию';

  @override
  String get homeMissionCompletedTitle => 'Миссия\nвыполнена!';

  @override
  String get homeMissionHelpTitle => 'Помоги космонавту\nсобрать звезды!';

  @override
  String get dailyChallengeTag => 'Задание дня';

  @override
  String get myProgressTitle => 'Мой прогресс';

  @override
  String levelLabel(Object level) {
    return 'Уровень $level';
  }

  @override
  String get myCollectionTitle => 'Моя коллекция';

  @override
  String stickerCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'наклейки',
      many: 'наклеек',
      few: 'наклейки',
      one: 'наклейка',
    );
    return '$_temp0';
  }

  @override
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes мин за неделю',
      many: '$minutes мин за неделю',
      few: '$minutes мин за неделю',
      one: '$minutes мин за неделю',
    );
    return '$ageLabel • $goalLabel • $_temp0';
  }

  @override
  String ageYears(num years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years года',
      many: '$years лет',
      few: '$years года',
      one: '$years год',
    );
    return '$_temp0';
  }

  @override
  String get goalLogicLabel => 'Логика';

  @override
  String get goalLogicDescription =>
      'Закономерности, рассуждение и поиск правил.';

  @override
  String get goalMathLabel => 'Математика';

  @override
  String get goalMathDescription => 'Числа, счет и аккуратные решения.';

  @override
  String get goalAttentionLabel => 'Внимание';

  @override
  String get goalAttentionDescription => 'Фокус, память и сравнение деталей.';

  @override
  String get onboardingTitle => 'Соберем маршрут BrainUp';

  @override
  String get onboardingSubtitle =>
      'Создайте профиль ученика и начните короткий путь мышления с логикой, вниманием и числами.';

  @override
  String get childNameLabel => 'Имя ребенка';

  @override
  String get childNameError => 'Введите имя';

  @override
  String get ageSectionTitle => 'Возраст';

  @override
  String get learningGoalSectionTitle => 'Цель занятий';

  @override
  String get learningGoalShortTitle => 'Цель';

  @override
  String get startButton => 'Начать';

  @override
  String get savingButton => 'Сохраняем';

  @override
  String get onboardingHeroTitle => 'Маршрут мышления готов';

  @override
  String get parentTag => 'Родителю';

  @override
  String get parentDashboardTitle => 'Сводка семьи';

  @override
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel) {
    return '$childName • $ageLabel • $goalLabel';
  }

  @override
  String get currentStreakMetric => 'серия';

  @override
  String get sessionsMetric => 'сессий';

  @override
  String get minutesMetric => 'минут';

  @override
  String get childrenProfilesTitle => 'Детские профили';

  @override
  String get addChildButton => 'Добавить ребенка';

  @override
  String childProgressChallengeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задания',
      many: '$count заданий',
      few: '$count задания',
      one: '$count задание',
    );
    return '$_temp0';
  }

  @override
  String ageGoalSummary(Object ageLabel, Object goalLabel) {
    return '$ageLabel • $goalLabel';
  }

  @override
  String get newChildTitle => 'Новый ребенок';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get addButton => 'Добавить';

  @override
  String get analyticsTitle => 'Аналитика занятий';

  @override
  String get streakMetricLabel => 'Серия';

  @override
  String get bestStreakLabel => 'Лучшее';

  @override
  String get last7DaysLabel => 'За 7 дней';

  @override
  String get weeklyMinutesLabel => 'Минуты';

  @override
  String sessionsCountShort(Object count) {
    return '$count сесс.';
  }

  @override
  String minutesShort(Object count) {
    return '$count мин';
  }

  @override
  String minutesNarrow(Object count) {
    return '$count м';
  }

  @override
  String get lastSkillLabel => 'Последний навык';

  @override
  String get lastSessionLabel => 'Последняя сессия';

  @override
  String get notAvailable => 'Пока нет';

  @override
  String get weeklyRhythmTitle => 'Ритм недели';

  @override
  String get weeklyRhythmSubtitle => 'Дни с практикой и минуты по каждому дню.';

  @override
  String get subscriptionTitle => 'Семейная подписка';

  @override
  String get currentPlanLabel => 'Текущий план';

  @override
  String get familySeatsLabel => 'Семейные места';

  @override
  String get updatedLabel => 'Обновлен';

  @override
  String get recommendedLabel => 'Выгодно';

  @override
  String get currentPlanButton => 'Текущий план';

  @override
  String get chooseButton => 'Выбрать';

  @override
  String get resetProfilePanel =>
      'Сбросить локальный профиль и пройти настройку заново';

  @override
  String get resetButton => 'Сброс';

  @override
  String get resetDialogTitle => 'Сбросить профиль?';

  @override
  String get resetDialogBody =>
      'Настройка откроется заново, а локальный прогресс BrainUp будет очищен.';

  @override
  String get resetConfirmButton => 'Сбросить';

  @override
  String get limitPaidMessage => 'Все семейные места уже заняты.';

  @override
  String get limitStarterMessage => 'Еще профили доступны на семейном плане.';

  @override
  String get planStarterLabel => 'Стартовый';

  @override
  String get planStarterPrice => '0 ₽';

  @override
  String get planStarterCapacity => '1 детский профиль';

  @override
  String get planStarterDescription =>
      'Короткий daily loop и локальный прогресс.';

  @override
  String get planMonthlyLabel => 'Семейный месяц';

  @override
  String get planMonthlyPrice => '399 ₽/мес';

  @override
  String get planFamilyCapacity => 'до 3 детских профилей';

  @override
  String get planMonthlyDescription =>
      'Полный доступ, семейные профили и родительская аналитика.';

  @override
  String get planAnnualLabel => 'Семейный год';

  @override
  String get planAnnualPrice => '2990 ₽/год';

  @override
  String get planAnnualDescription => 'То же, но выгоднее при оплате за год.';

  @override
  String get planActiveStatus => 'Активна';

  @override
  String get planInactiveStatus => 'Не оформлена';

  @override
  String get missionCompletedTitle => 'Миссия выполнена!';

  @override
  String childGoCta(Object childName) {
    return '$childName, вперед!';
  }

  @override
  String get chooseAnswerTitle => 'Выбери ответ';

  @override
  String get checkingButton => 'Засчитываем';

  @override
  String get checkAnswerButton => 'Проверить';

  @override
  String answerCorrect(Object explanation) {
    return 'Верно! $explanation';
  }

  @override
  String answerAlmost(Object hint) {
    return 'Почти. $hint';
  }

  @override
  String get challengeCompletedToday => 'Сегодняшнее задание выполнено';

  @override
  String get weekdayMondayShort => 'Пн';

  @override
  String get weekdayTuesdayShort => 'Вт';

  @override
  String get weekdayWednesdayShort => 'Ср';

  @override
  String get weekdayThursdayShort => 'Чт';

  @override
  String get weekdayFridayShort => 'Пт';

  @override
  String get weekdaySaturdayShort => 'Сб';

  @override
  String get weekdaySundayShort => 'Вс';

  @override
  String get skillPatterns => 'Закономерности';

  @override
  String get skillCountingToFive => 'Счет до пяти';

  @override
  String get skillComparison => 'Сравнение';

  @override
  String get skillSequences => 'Последовательности';

  @override
  String get skillAdditionToTen => 'Сложение до десяти';

  @override
  String get skillWorkingMemory => 'Рабочая память';

  @override
  String get skillLogicDeduction => 'Логика и дедукция';

  @override
  String get skillMathThinking => 'Математическое мышление';

  @override
  String get skillDetailComparison => 'Сравнение деталей';

  @override
  String get challengeShapePathTitle => 'Дорожка фигур';

  @override
  String get challengeShapePathPrompt =>
      'Посмотри на ряд и найди, что должно идти дальше.';

  @override
  String get challengeShapePathQuestion =>
      'Круг, квадрат, круг, квадрат. Что дальше?';

  @override
  String get challengeShapePathHint =>
      'Фигуры чередуются: одна, потом другая, потом снова первая.';

  @override
  String get challengeShapePathExplanation =>
      'После квадрата снова идет круг, потому что ряд повторяется через одну фигуру.';

  @override
  String get challengeToyCountTitle => 'Сколько игрушек';

  @override
  String get challengeToyCountPrompt =>
      'Посчитай предметы и выбери точный ответ.';

  @override
  String get challengeToyCountQuestion =>
      'На полке 2 кубика и 1 мяч. Сколько игрушек всего?';

  @override
  String get challengeToyCountHint =>
      'Сначала посчитай кубики, потом добавь мяч.';

  @override
  String get challengeToyCountExplanation =>
      '2 кубика и 1 мяч дают 3 игрушки всего.';

  @override
  String get challengeOddCardTitle => 'Лишняя карточка';

  @override
  String get challengeOddCardPrompt =>
      'Найди предмет, который отличается от остальных.';

  @override
  String get challengeOddCardQuestion =>
      'Яблоко, груша, мяч, банан. Что лишнее?';

  @override
  String get challengeOddCardHint =>
      'Три предмета можно съесть, а один нужен для игры.';

  @override
  String get challengeOddCardExplanation =>
      'Мяч лишний: яблоко, груша и банан - это фрукты.';

  @override
  String get challengeLogicTrainTitle => 'Логический поезд';

  @override
  String get challengeLogicTrainPrompt => 'Расставь вагоны по правилу.';

  @override
  String get challengeLogicTrainQuestion =>
      'Красный, синий, синий, красный, синий, синий. Какой следующий?';

  @override
  String get challengeLogicTrainHint =>
      'Правило повторяется тройками: один красный и два синих.';

  @override
  String get challengeLogicTrainExplanation =>
      'Следующий вагон красный: после двух синих начинается новая тройка.';

  @override
  String get challengeStickerSumTitle => 'Наклейки в альбоме';

  @override
  String get challengeStickerSumPrompt =>
      'Сложи две маленькие группы предметов.';

  @override
  String get challengeStickerSumQuestion =>
      'У Ники было 3 наклейки, потом дали еще 2. Сколько стало?';

  @override
  String get challengeStickerSumHint => 'Начни с трех и досчитай еще два шага.';

  @override
  String get challengeStickerSumExplanation =>
      '3 + 2 = 5, значит стало пять наклеек.';

  @override
  String get challengeMemoryPairsTitle => 'Пары по памяти';

  @override
  String get challengeMemoryPairsPrompt => 'Вспомни пару для каждого предмета.';

  @override
  String get challengeMemoryPairsQuestion => 'Что подходит к ключу?';

  @override
  String get challengeMemoryPairsHint => 'Ключ нужен, чтобы что-то открыть.';

  @override
  String get challengeMemoryPairsExplanation =>
      'К ключу подходит замок: вместе они образуют смысловую пару.';

  @override
  String get challengeCodeGridTitle => 'Кодовая сетка';

  @override
  String get challengeCodeGridPrompt =>
      'Разгадай правило и выбери правильную клетку.';

  @override
  String get challengeCodeGridQuestion =>
      'В первой строке 2, 4, 6. Во второй 3, 5, ?. Какое число пропущено?';

  @override
  String get challengeCodeGridHint =>
      'Во второй строке числа тоже растут на 2.';

  @override
  String get challengeCodeGridExplanation =>
      'После 3 и 5 идет 7: каждый шаг увеличивает число на два.';

  @override
  String get challengeNumberBridgeTitle => 'Числовой мост';

  @override
  String get challengeNumberBridgePrompt =>
      'Соедини числа так, чтобы получить нужный маршрут.';

  @override
  String get challengeNumberBridgeQuestion =>
      'У тебя есть 4, 2 и 1. Как получить 7?';

  @override
  String get challengeNumberBridgeHint =>
      'Попробуй использовать все числа один раз.';

  @override
  String get challengeNumberBridgeExplanation =>
      '4 + 2 + 1 = 7, значит все три числа вместе дают нужный результат.';

  @override
  String get challengeDetailCountTitle => 'Карта деталей';

  @override
  String get challengeDetailCountPrompt =>
      'Удержи в голове несколько деталей и сравни их.';

  @override
  String get challengeDetailCountQuestion =>
      'Есть 3 красных круга, 2 синих квадрата и 1 зеленая звезда. Чего больше всего?';

  @override
  String get challengeDetailCountHint => 'Сравни количества: 3, 2 и 1.';

  @override
  String get challengeDetailCountExplanation =>
      'Больше всего красных кругов: их три.';

  @override
  String get choiceTriangle => 'Треугольник';

  @override
  String get choiceCircle => 'Круг';

  @override
  String get choiceStar => 'Звезда';

  @override
  String get choiceApple => 'Яблоко';

  @override
  String get choiceBall => 'Мяч';

  @override
  String get choiceBanana => 'Банан';

  @override
  String get choiceBlue => 'Синий';

  @override
  String get choiceRed => 'Красный';

  @override
  String get choiceGreen => 'Зеленый';

  @override
  String get choiceLock => 'Замок';

  @override
  String get choiceShoe => 'Ботинок';

  @override
  String get choiceCloud => 'Облако';

  @override
  String get choiceBlueSquares => 'Синих квадратов';

  @override
  String get choiceRedCircles => 'Красных кругов';

  @override
  String get choiceGreenStars => 'Зеленых звезд';

  @override
  String mapLessonTitle(Object lesson) {
    return 'Урок $lesson';
  }

  @override
  String get mapLessonSubtitle =>
      'Логика, счёт и внимание в одном коротком уроке';

  @override
  String get mapStartButton => 'Начать';

  @override
  String get mapNodeStart => 'Старт';

  @override
  String get mapNodeShapes => 'Фигуры';

  @override
  String get mapNodePairs => 'Пары';

  @override
  String get mapNodeCounting => 'Счёт';

  @override
  String get mapNodePath => 'Путь';

  @override
  String get mapNodeRhythm => 'Ритм';

  @override
  String get mapNodeCompare => 'Сравни';

  @override
  String get mapNodeFinal => 'Финал';

  @override
  String get mapNodeCompleted => 'пройдено';

  @override
  String get mapNodeCurrent => 'доступно';

  @override
  String get mapNodeLocked => 'закрыто';

  @override
  String mapPreviewTitle(Object lesson) {
    return 'Урок $lesson';
  }

  @override
  String mapPreviewSteps(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count шага',
      many: '$count шагов',
      few: '$count шага',
      one: '$count шаг',
    );
    return '$_temp0';
  }

  @override
  String mapPreviewReward(Object xp) {
    return '+$xp XP';
  }

  @override
  String mapPreviewHearts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сердца',
      many: '$count сердец',
      few: '$count сердца',
      one: '$count сердце',
    );
    return '$_temp0';
  }

  @override
  String get mapPreviewBody =>
      'Короткий урок со смешанными задачками: логика, счёт, сравнение и внимание.';

  @override
  String get mapPreviewStart => 'Начать урок';

  @override
  String get mapPreviewClose => 'Позже';

  @override
  String lessonProgress(Object current, Object total) {
    return 'Шаг $current из $total';
  }

  @override
  String get lessonNextButton => 'Дальше';

  @override
  String get lessonFinishButton => 'Завершить урок';

  @override
  String get lessonCompleteTitle => 'Урок пройден!';

  @override
  String get lessonCompleteBody => 'Ты открыл следующий шаг на карте.';

  @override
  String get lessonRewardStars => '+1 звезда';

  @override
  String lessonRewardXp(Object xp) {
    return '+$xp XP';
  }

  @override
  String get lessonBackToMap => 'На главную';

  @override
  String get courseCatalogTitle => 'Курсы и головоломки';

  @override
  String get courseLogicTitle => 'Логика';

  @override
  String get courseLogicSubtitle => 'Правила, лишнее и выводы';

  @override
  String get courseMathTitle => 'Математика';

  @override
  String get courseMathSubtitle => 'Счет, суммы и сравнение';

  @override
  String get courseSpatialTitle => 'Фигуры';

  @override
  String get courseSpatialSubtitle => 'Форма, путь и пространство';

  @override
  String get courseAttentionTitle => 'Внимание';

  @override
  String get courseAttentionSubtitle => 'Детали, память и фокус';

  @override
  String get courseRebusTitle => 'Ребусы';

  @override
  String get courseRebusSubtitle => 'Картинки, слова и загадки';

  @override
  String get courseMixedTitle => 'Микс дня';

  @override
  String get courseMixedSubtitle => 'Разные задачки подряд';

  @override
  String progressCardBody(Object level, Object stars) {
    return 'Уровень $level • $stars звезд';
  }

  @override
  String collectionCardBody(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count наклейки',
      many: '$count наклеек',
      few: '$count наклейки',
      one: '$count наклейка',
    );
    return '$_temp0';
  }

  @override
  String get dailyMissionBody =>
      'Короткая серия задач на логику, счет и внимание.';

  @override
  String get openCourseButton => 'Открыть';

  @override
  String courseProgress(Object completed, Object total) {
    return '$completed из $total уроков пройдено';
  }

  @override
  String courseLessonTitle(Object lesson) {
    return 'Урок $lesson';
  }

  @override
  String courseLessonMeta(num steps, Object xp) {
    String _temp0 = intl.Intl.pluralLogic(
      steps,
      locale: localeName,
      other: '$steps шага',
      many: '$steps шагов',
      few: '$steps шага',
      one: '$steps шаг',
    );
    return '$_temp0 • +$xp XP';
  }

  @override
  String get courseStartLessonButton => 'Старт';

  @override
  String get courseRepeatButton => 'Повтор';

  @override
  String get showHintButton => 'Подсказка';

  @override
  String get hideHintButton => 'Скрыть подсказку';

  @override
  String get lessonStickerUnlockedTitle => 'Новая наклейка!';

  @override
  String get lessonStickerUnlockedBody => 'Коллекция пополнилась после урока.';

  @override
  String get lessonRewardCollection => '+1 наклейка';

  @override
  String get lessonRewardStreak => 'Серия растет';

  @override
  String get challengeShadowMatchTitle => 'Подбери тень';

  @override
  String get challengeShadowMatchPrompt =>
      'Найди предмет, который подходит к тени.';

  @override
  String get challengeShadowMatchQuestion =>
      'У тени высокий корпус и два маленьких крыла. Что это?';

  @override
  String get challengeShadowMatchHint => 'Смотри на общий контур предмета.';

  @override
  String get challengeShadowMatchExplanation =>
      'Ракета подходит к тени: у нее высокий корпус и два боковых крыла.';

  @override
  String get challengeBalanceScaleTitle => 'Весы';

  @override
  String get challengeBalanceScalePrompt =>
      'Сравни стороны и выбери, чего не хватает.';

  @override
  String get challengeBalanceScaleQuestion =>
      'Слева 2 яблока. Справа 1 яблоко и ?. Что добавить?';

  @override
  String get challengeBalanceScaleHint =>
      'На обеих сторонах должно быть одинаковое количество яблок.';

  @override
  String get challengeBalanceScaleExplanation =>
      'Еще одно яблоко делает правую сторону равной левой: 2 и 2.';

  @override
  String get challengeShapeRotationTitle => 'Поворот фигуры';

  @override
  String get challengeShapeRotationPrompt =>
      'Представь, как фигура поворачивается.';

  @override
  String get challengeShapeRotationQuestion =>
      'Треугольник повернули вправо. Какая карточка показывает ту же фигуру?';

  @override
  String get challengeShapeRotationHint =>
      'Поворот меняет направление, но не саму фигуру.';

  @override
  String get challengeShapeRotationExplanation =>
      'Это тот же треугольник: он повернулся, но не стал другой фигурой.';

  @override
  String get choiceRocket => 'Ракета';

  @override
  String get choicePlanet => 'Планета';

  @override
  String get choiceSameTriangle => 'Тот же треугольник';

  @override
  String get choiceSquare => 'Квадрат';

  @override
  String get skillInsightsTitle => 'Навыки и рекомендации';

  @override
  String get strongestAreaLabel => 'Сильная зона';

  @override
  String get practiceFocusLabel => 'Зона фокуса';

  @override
  String get recommendedPracticeLabel => 'Что тренировать дальше';

  @override
  String get noSkillDataLabel => 'Пока мало данных';

  @override
  String get recommendationKeepGoing =>
      'Продолжайте короткие уроки: после нескольких занятий рекомендация станет точнее.';

  @override
  String get recommendationPracticeFocus =>
      'Добавьте 1-2 коротких урока по этой зоне на неделе.';

  @override
  String get courseNextMetricLabel => 'Дальше';

  @override
  String get courseStarsMetricLabel => 'Звезды';

  @override
  String get courseXpMetricLabel => 'XP';

  @override
  String get courseCompletedState => 'пройдено';

  @override
  String get courseOpenState => 'доступно';

  @override
  String get courseLockedState => 'закрыто';

  @override
  String get collectionScreenTitle => 'Коллекция наклеек';

  @override
  String get collectionScreenSubtitle =>
      'Собирай награды за уроки и регулярные занятия.';

  @override
  String collectionUnlockedCount(Object total, Object unlocked) {
    return 'Открыто $unlocked из $total';
  }

  @override
  String get collectionNextReward => 'Следующая награда';

  @override
  String get collectionAllRewardsUnlocked => 'Все награды открыты';

  @override
  String get collectionBackHome => 'На главную';

  @override
  String collectionLockedHint(Object stars) {
    return 'Откроется после $stars звезд';
  }

  @override
  String get rewardAstronautTitle => 'Звёздный помощник';

  @override
  String get rewardAstronautBody => 'За первую пройденную миссию.';

  @override
  String get rewardRocketTitle => 'Смелая ракета';

  @override
  String get rewardRocketBody => 'За открытие учебного курса.';

  @override
  String get rewardPlanetTitle => 'Маленькая планета';

  @override
  String get rewardPlanetBody => 'За два пройденных урока.';

  @override
  String get rewardLionTitle => 'Логический лев';

  @override
  String get rewardLionBody => 'За серию занятий.';

  @override
  String get rewardPuzzleTitle => 'Значок головоломок';

  @override
  String get rewardPuzzleBody => 'За смешанные задачки.';

  @override
  String get rewardChampionTitle => 'Космический чемпион';

  @override
  String get rewardChampionBody => 'За регулярную практику на неделе.';

  @override
  String get accuracyMetricLabel => 'Точность';

  @override
  String get hintsMetricLabel => 'Подсказки';

  @override
  String recommendationImproveAccuracy(Object skill) {
    return 'На этой неделе позанимайтесь темой $skill без спешки: главный сигнал сейчас - точность.';
  }

  @override
  String recommendationReduceHints(Object skill) {
    return 'Повторите тему $skill с меньшим числом подсказок: дайте ребенку паузу перед помощью.';
  }

  @override
  String recommendationRepeatAttempts(Object skill) {
    return 'Дайте теме $skill одно короткое повторение, чтобы снизить число ошибок.';
  }

  @override
  String get homeRecommendedLessonTitle => 'Следующий урок';

  @override
  String get homeRecommendedLessonSubtitle =>
      'Следующий короткий урок на учебном маршруте.';

  @override
  String get homeRecommendedLessonButton => 'Продолжить';

  @override
  String get homeRecommendedLessonCompleted => 'Маршрут пройден';

  @override
  String get lessonReviewTitle => 'Итог урока';

  @override
  String get lessonReviewPerfectBody =>
      'Отличный фокус: без подсказок и ошибок.';

  @override
  String get lessonReviewSupportBody =>
      'Хороший финиш. В следующий раз попробуй один шаг без помощи.';

  @override
  String get lessonReviewQuestionsLabel => 'Вопросы';

  @override
  String get lessonReviewHintsLabel => 'Подсказки';

  @override
  String get lessonReviewMistakesLabel => 'Ошибки';

  @override
  String get lessonNextRecommendedButton => 'Следующий урок';

  @override
  String get practiceHistoryTitle => 'История занятий';

  @override
  String get practiceHistorySubtitle =>
      'Последние уроки с точностью, подсказками и ошибками.';

  @override
  String get practiceHistoryEmpty => 'Пройденных уроков пока нет.';

  @override
  String practiceHistorySessionMeta(Object date, Object minutes) {
    return '$date - $minutes мин';
  }

  @override
  String get practiceHistoryMistakesLabel => 'Ошибки';

  @override
  String get lessonTryAgainButton => 'Попробовать еще';

  @override
  String get lessonHintTitle => 'Подумай по шагам';

  @override
  String get lessonRetryFeedback =>
      'Хорошая попытка. Прочитай подсказку и выбери еще раз.';

  @override
  String get languageSettingsTitle => 'Язык приложения';

  @override
  String get languageSettingsSubtitle =>
      'Выберите язык для детских и родительских экранов.';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get choicePear => 'Груша';

  @override
  String get challengeFruitPatternTitle => 'Фруктовый ряд';

  @override
  String get challengeFruitPatternPrompt =>
      'Продолжи фруктовую закономерность.';

  @override
  String get challengeFruitPatternQuestion =>
      'Яблоко, банан, яблоко, банан. Что дальше?';

  @override
  String get challengeFruitPatternHint =>
      'Фрукты повторяются по очереди: яблоко, потом банан.';

  @override
  String get challengeFruitPatternExplanation =>
      'После банана снова идет яблоко, потому что ряд повторяется.';

  @override
  String get challengeLockKeyTitle => 'Волшебная пара';

  @override
  String get challengeLockKeyPrompt => 'Выбери предмет, который образует пару.';

  @override
  String get challengeLockKeyQuestion =>
      'Ключ что-то открывает. Что к нему подходит?';

  @override
  String get challengeLockKeyHint => 'Вспомни, для чего нужен ключ.';

  @override
  String get challengeLockKeyExplanation =>
      'Ключ и замок работают вместе, поэтому это пара.';

  @override
  String get challengeSpaceSequenceTitle => 'Космический маршрут';

  @override
  String get challengeSpaceSequencePrompt =>
      'Найди следующий космический предмет.';

  @override
  String get challengeSpaceSequenceQuestion =>
      'Ракета, планета, ракета, планета. Что дальше?';

  @override
  String get challengeSpaceSequenceHint =>
      'Маршрут повторяется: ракета, потом планета.';

  @override
  String get challengeSpaceSequenceExplanation =>
      'После планеты снова идет ракета.';

  @override
  String get challengeShapeStackTitle => 'Башня фигур';

  @override
  String get challengeShapeStackPrompt => 'Продолжи правило башни.';

  @override
  String get challengeShapeStackQuestion =>
      'Квадрат, круг, квадрат, круг. Какая фигура дальше?';

  @override
  String get challengeShapeStackHint => 'Башня чередует две фигуры.';

  @override
  String get challengeShapeStackExplanation =>
      'После круга снова идет квадрат.';
}
