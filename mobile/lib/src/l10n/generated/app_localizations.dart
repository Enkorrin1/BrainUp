import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ru'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ru, this message translates to:
  /// **'BrainUp'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In ru, this message translates to:
  /// **'Карта'**
  String get homeTab;

  /// No description provided for @challengeTab.
  ///
  /// In ru, this message translates to:
  /// **'Урок'**
  String get challengeTab;

  /// No description provided for @parentTab.
  ///
  /// In ru, this message translates to:
  /// **'Родителю'**
  String get parentTab;

  /// No description provided for @homeGreeting.
  ///
  /// In ru, this message translates to:
  /// **'Привет,\n{childName}'**
  String homeGreeting(Object childName);

  /// No description provided for @dailyStreakTitle.
  ///
  /// In ru, this message translates to:
  /// **'Серия дня'**
  String get dailyStreakTitle;

  /// No description provided for @streakStart.
  ///
  /// In ru, this message translates to:
  /// **'Начни!'**
  String get streakStart;

  /// No description provided for @dayCount.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} день} few{{count} дня} many{{count} дней} other{{count} дня}}'**
  String dayCount(num count);

  /// No description provided for @dayCountShort.
  ///
  /// In ru, this message translates to:
  /// **'{count} дн.'**
  String dayCountShort(Object count);

  /// No description provided for @missionOpenButton.
  ///
  /// In ru, this message translates to:
  /// **'Открыть'**
  String get missionOpenButton;

  /// No description provided for @missionStartShortButton.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get missionStartShortButton;

  /// No description provided for @missionStartButton.
  ///
  /// In ru, this message translates to:
  /// **'Начать миссию'**
  String get missionStartButton;

  /// No description provided for @homeMissionCompletedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Миссия\nвыполнена!'**
  String get homeMissionCompletedTitle;

  /// No description provided for @homeMissionHelpTitle.
  ///
  /// In ru, this message translates to:
  /// **'Помоги космонавту\nсобрать звезды!'**
  String get homeMissionHelpTitle;

  /// No description provided for @dailyChallengeTag.
  ///
  /// In ru, this message translates to:
  /// **'Задание дня'**
  String get dailyChallengeTag;

  /// No description provided for @myProgressTitle.
  ///
  /// In ru, this message translates to:
  /// **'Мой прогресс'**
  String get myProgressTitle;

  /// No description provided for @levelLabel.
  ///
  /// In ru, this message translates to:
  /// **'Уровень {level}'**
  String levelLabel(Object level);

  /// No description provided for @myCollectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Моя коллекция'**
  String get myCollectionTitle;

  /// No description provided for @stickerCountLabel.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{наклейка} few{наклейки} many{наклеек} other{наклейки}}'**
  String stickerCountLabel(num count);

  /// No description provided for @homeParentHint.
  ///
  /// In ru, this message translates to:
  /// **'{ageLabel} • {goalLabel} • {minutes, plural, one{{minutes} мин за неделю} few{{minutes} мин за неделю} many{{minutes} мин за неделю} other{{minutes} мин за неделю}}'**
  String homeParentHint(Object ageLabel, Object goalLabel, num minutes);

  /// No description provided for @ageYears.
  ///
  /// In ru, this message translates to:
  /// **'{years, plural, one{{years} год} few{{years} года} many{{years} лет} other{{years} года}}'**
  String ageYears(num years);

  /// No description provided for @goalLogicLabel.
  ///
  /// In ru, this message translates to:
  /// **'Логика'**
  String get goalLogicLabel;

  /// No description provided for @goalLogicDescription.
  ///
  /// In ru, this message translates to:
  /// **'Закономерности, рассуждение и поиск правил.'**
  String get goalLogicDescription;

  /// No description provided for @goalMathLabel.
  ///
  /// In ru, this message translates to:
  /// **'Математика'**
  String get goalMathLabel;

  /// No description provided for @goalMathDescription.
  ///
  /// In ru, this message translates to:
  /// **'Числа, счет и аккуратные решения.'**
  String get goalMathDescription;

  /// No description provided for @goalAttentionLabel.
  ///
  /// In ru, this message translates to:
  /// **'Внимание'**
  String get goalAttentionLabel;

  /// No description provided for @goalAttentionDescription.
  ///
  /// In ru, this message translates to:
  /// **'Фокус, память и сравнение деталей.'**
  String get goalAttentionDescription;

  /// No description provided for @onboardingTitle.
  ///
  /// In ru, this message translates to:
  /// **'Соберем маршрут BrainUp'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Создайте профиль ученика и начните короткий путь мышления с логикой, вниманием и числами.'**
  String get onboardingSubtitle;

  /// No description provided for @childNameLabel.
  ///
  /// In ru, this message translates to:
  /// **'Имя ребенка'**
  String get childNameLabel;

  /// No description provided for @childNameError.
  ///
  /// In ru, this message translates to:
  /// **'Введите имя'**
  String get childNameError;

  /// No description provided for @ageSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Возраст'**
  String get ageSectionTitle;

  /// No description provided for @learningGoalSectionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Цель занятий'**
  String get learningGoalSectionTitle;

  /// No description provided for @learningGoalShortTitle.
  ///
  /// In ru, this message translates to:
  /// **'Цель'**
  String get learningGoalShortTitle;

  /// No description provided for @startButton.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get startButton;

  /// No description provided for @savingButton.
  ///
  /// In ru, this message translates to:
  /// **'Сохраняем'**
  String get savingButton;

  /// No description provided for @onboardingHeroTitle.
  ///
  /// In ru, this message translates to:
  /// **'Маршрут мышления готов'**
  String get onboardingHeroTitle;

  /// No description provided for @parentTag.
  ///
  /// In ru, this message translates to:
  /// **'Родителю'**
  String get parentTag;

  /// No description provided for @parentDashboardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сводка семьи'**
  String get parentDashboardTitle;

  /// No description provided for @familyProfileSummary.
  ///
  /// In ru, this message translates to:
  /// **'{childName} • {ageLabel} • {goalLabel}'**
  String familyProfileSummary(
      Object ageLabel, Object childName, Object goalLabel);

  /// No description provided for @currentStreakMetric.
  ///
  /// In ru, this message translates to:
  /// **'серия'**
  String get currentStreakMetric;

  /// No description provided for @sessionsMetric.
  ///
  /// In ru, this message translates to:
  /// **'сессий'**
  String get sessionsMetric;

  /// No description provided for @minutesMetric.
  ///
  /// In ru, this message translates to:
  /// **'минут'**
  String get minutesMetric;

  /// No description provided for @childrenProfilesTitle.
  ///
  /// In ru, this message translates to:
  /// **'Детские профили'**
  String get childrenProfilesTitle;

  /// No description provided for @addChildButton.
  ///
  /// In ru, this message translates to:
  /// **'Добавить ребенка'**
  String get addChildButton;

  /// No description provided for @childProgressChallengeCount.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} задание} few{{count} задания} many{{count} заданий} other{{count} задания}}'**
  String childProgressChallengeCount(num count);

  /// No description provided for @ageGoalSummary.
  ///
  /// In ru, this message translates to:
  /// **'{ageLabel} • {goalLabel}'**
  String ageGoalSummary(Object ageLabel, Object goalLabel);

  /// No description provided for @newChildTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новый ребенок'**
  String get newChildTitle;

  /// No description provided for @cancelButton.
  ///
  /// In ru, this message translates to:
  /// **'Отмена'**
  String get cancelButton;

  /// No description provided for @addButton.
  ///
  /// In ru, this message translates to:
  /// **'Добавить'**
  String get addButton;

  /// No description provided for @analyticsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Аналитика занятий'**
  String get analyticsTitle;

  /// No description provided for @streakMetricLabel.
  ///
  /// In ru, this message translates to:
  /// **'Серия'**
  String get streakMetricLabel;

  /// No description provided for @bestStreakLabel.
  ///
  /// In ru, this message translates to:
  /// **'Лучшее'**
  String get bestStreakLabel;

  /// No description provided for @last7DaysLabel.
  ///
  /// In ru, this message translates to:
  /// **'За 7 дней'**
  String get last7DaysLabel;

  /// No description provided for @weeklyMinutesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Минуты'**
  String get weeklyMinutesLabel;

  /// No description provided for @sessionsCountShort.
  ///
  /// In ru, this message translates to:
  /// **'{count} сесс.'**
  String sessionsCountShort(Object count);

  /// No description provided for @minutesShort.
  ///
  /// In ru, this message translates to:
  /// **'{count} мин'**
  String minutesShort(Object count);

  /// No description provided for @minutesNarrow.
  ///
  /// In ru, this message translates to:
  /// **'{count} м'**
  String minutesNarrow(Object count);

  /// No description provided for @lastSkillLabel.
  ///
  /// In ru, this message translates to:
  /// **'Последний навык'**
  String get lastSkillLabel;

  /// No description provided for @lastSessionLabel.
  ///
  /// In ru, this message translates to:
  /// **'Последняя сессия'**
  String get lastSessionLabel;

  /// No description provided for @notAvailable.
  ///
  /// In ru, this message translates to:
  /// **'Пока нет'**
  String get notAvailable;

  /// No description provided for @weeklyRhythmTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ритм недели'**
  String get weeklyRhythmTitle;

  /// No description provided for @weeklyRhythmSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Дни с практикой и минуты по каждому дню.'**
  String get weeklyRhythmSubtitle;

  /// No description provided for @subscriptionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Семейная подписка'**
  String get subscriptionTitle;

  /// No description provided for @currentPlanLabel.
  ///
  /// In ru, this message translates to:
  /// **'Текущий план'**
  String get currentPlanLabel;

  /// No description provided for @familySeatsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Семейные места'**
  String get familySeatsLabel;

  /// No description provided for @updatedLabel.
  ///
  /// In ru, this message translates to:
  /// **'Обновлен'**
  String get updatedLabel;

  /// No description provided for @recommendedLabel.
  ///
  /// In ru, this message translates to:
  /// **'Выгодно'**
  String get recommendedLabel;

  /// No description provided for @currentPlanButton.
  ///
  /// In ru, this message translates to:
  /// **'Текущий план'**
  String get currentPlanButton;

  /// No description provided for @chooseButton.
  ///
  /// In ru, this message translates to:
  /// **'Выбрать'**
  String get chooseButton;

  /// No description provided for @resetProfilePanel.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить локальный профиль и пройти настройку заново'**
  String get resetProfilePanel;

  /// No description provided for @resetButton.
  ///
  /// In ru, this message translates to:
  /// **'Сброс'**
  String get resetButton;

  /// No description provided for @resetDialogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить профиль?'**
  String get resetDialogTitle;

  /// No description provided for @resetDialogBody.
  ///
  /// In ru, this message translates to:
  /// **'Настройка откроется заново, а локальный прогресс BrainUp будет очищен.'**
  String get resetDialogBody;

  /// No description provided for @resetConfirmButton.
  ///
  /// In ru, this message translates to:
  /// **'Сбросить'**
  String get resetConfirmButton;

  /// No description provided for @limitPaidMessage.
  ///
  /// In ru, this message translates to:
  /// **'Все семейные места уже заняты.'**
  String get limitPaidMessage;

  /// No description provided for @limitStarterMessage.
  ///
  /// In ru, this message translates to:
  /// **'Еще профили доступны на семейном плане.'**
  String get limitStarterMessage;

  /// No description provided for @planStarterLabel.
  ///
  /// In ru, this message translates to:
  /// **'Стартовый'**
  String get planStarterLabel;

  /// No description provided for @planStarterPrice.
  ///
  /// In ru, this message translates to:
  /// **'0 ₽'**
  String get planStarterPrice;

  /// No description provided for @planStarterCapacity.
  ///
  /// In ru, this message translates to:
  /// **'1 детский профиль'**
  String get planStarterCapacity;

  /// No description provided for @planStarterDescription.
  ///
  /// In ru, this message translates to:
  /// **'Короткий daily loop и локальный прогресс.'**
  String get planStarterDescription;

  /// No description provided for @planMonthlyLabel.
  ///
  /// In ru, this message translates to:
  /// **'Семейный месяц'**
  String get planMonthlyLabel;

  /// No description provided for @planMonthlyPrice.
  ///
  /// In ru, this message translates to:
  /// **'399 ₽/мес'**
  String get planMonthlyPrice;

  /// No description provided for @planFamilyCapacity.
  ///
  /// In ru, this message translates to:
  /// **'до 3 детских профилей'**
  String get planFamilyCapacity;

  /// No description provided for @planMonthlyDescription.
  ///
  /// In ru, this message translates to:
  /// **'Полный доступ, семейные профили и родительская аналитика.'**
  String get planMonthlyDescription;

  /// No description provided for @planAnnualLabel.
  ///
  /// In ru, this message translates to:
  /// **'Семейный год'**
  String get planAnnualLabel;

  /// No description provided for @planAnnualPrice.
  ///
  /// In ru, this message translates to:
  /// **'2990 ₽/год'**
  String get planAnnualPrice;

  /// No description provided for @planAnnualDescription.
  ///
  /// In ru, this message translates to:
  /// **'То же, но выгоднее при оплате за год.'**
  String get planAnnualDescription;

  /// No description provided for @planActiveStatus.
  ///
  /// In ru, this message translates to:
  /// **'Активна'**
  String get planActiveStatus;

  /// No description provided for @planInactiveStatus.
  ///
  /// In ru, this message translates to:
  /// **'Не оформлена'**
  String get planInactiveStatus;

  /// No description provided for @missionCompletedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Миссия выполнена!'**
  String get missionCompletedTitle;

  /// No description provided for @childGoCta.
  ///
  /// In ru, this message translates to:
  /// **'{childName}, вперед!'**
  String childGoCta(Object childName);

  /// No description provided for @chooseAnswerTitle.
  ///
  /// In ru, this message translates to:
  /// **'Выбери ответ'**
  String get chooseAnswerTitle;

  /// No description provided for @checkingButton.
  ///
  /// In ru, this message translates to:
  /// **'Засчитываем'**
  String get checkingButton;

  /// No description provided for @checkAnswerButton.
  ///
  /// In ru, this message translates to:
  /// **'Проверить'**
  String get checkAnswerButton;

  /// No description provided for @answerCorrect.
  ///
  /// In ru, this message translates to:
  /// **'Верно! {explanation}'**
  String answerCorrect(Object explanation);

  /// No description provided for @answerAlmost.
  ///
  /// In ru, this message translates to:
  /// **'Почти. {hint}'**
  String answerAlmost(Object hint);

  /// No description provided for @challengeCompletedToday.
  ///
  /// In ru, this message translates to:
  /// **'Сегодняшнее задание выполнено'**
  String get challengeCompletedToday;

  /// No description provided for @weekdayMondayShort.
  ///
  /// In ru, this message translates to:
  /// **'Пн'**
  String get weekdayMondayShort;

  /// No description provided for @weekdayTuesdayShort.
  ///
  /// In ru, this message translates to:
  /// **'Вт'**
  String get weekdayTuesdayShort;

  /// No description provided for @weekdayWednesdayShort.
  ///
  /// In ru, this message translates to:
  /// **'Ср'**
  String get weekdayWednesdayShort;

  /// No description provided for @weekdayThursdayShort.
  ///
  /// In ru, this message translates to:
  /// **'Чт'**
  String get weekdayThursdayShort;

  /// No description provided for @weekdayFridayShort.
  ///
  /// In ru, this message translates to:
  /// **'Пт'**
  String get weekdayFridayShort;

  /// No description provided for @weekdaySaturdayShort.
  ///
  /// In ru, this message translates to:
  /// **'Сб'**
  String get weekdaySaturdayShort;

  /// No description provided for @weekdaySundayShort.
  ///
  /// In ru, this message translates to:
  /// **'Вс'**
  String get weekdaySundayShort;

  /// No description provided for @skillPatterns.
  ///
  /// In ru, this message translates to:
  /// **'Закономерности'**
  String get skillPatterns;

  /// No description provided for @skillCountingToFive.
  ///
  /// In ru, this message translates to:
  /// **'Счет до пяти'**
  String get skillCountingToFive;

  /// No description provided for @skillComparison.
  ///
  /// In ru, this message translates to:
  /// **'Сравнение'**
  String get skillComparison;

  /// No description provided for @skillSequences.
  ///
  /// In ru, this message translates to:
  /// **'Последовательности'**
  String get skillSequences;

  /// No description provided for @skillAdditionToTen.
  ///
  /// In ru, this message translates to:
  /// **'Сложение до десяти'**
  String get skillAdditionToTen;

  /// No description provided for @skillWorkingMemory.
  ///
  /// In ru, this message translates to:
  /// **'Рабочая память'**
  String get skillWorkingMemory;

  /// No description provided for @skillLogicDeduction.
  ///
  /// In ru, this message translates to:
  /// **'Логика и дедукция'**
  String get skillLogicDeduction;

  /// No description provided for @skillMathThinking.
  ///
  /// In ru, this message translates to:
  /// **'Математическое мышление'**
  String get skillMathThinking;

  /// No description provided for @skillDetailComparison.
  ///
  /// In ru, this message translates to:
  /// **'Сравнение деталей'**
  String get skillDetailComparison;

  /// No description provided for @challengeShapePathTitle.
  ///
  /// In ru, this message translates to:
  /// **'Дорожка фигур'**
  String get challengeShapePathTitle;

  /// No description provided for @challengeShapePathPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Посмотри на ряд и найди, что должно идти дальше.'**
  String get challengeShapePathPrompt;

  /// No description provided for @challengeShapePathQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Круг, квадрат, круг, квадрат. Что дальше?'**
  String get challengeShapePathQuestion;

  /// No description provided for @challengeShapePathHint.
  ///
  /// In ru, this message translates to:
  /// **'Фигуры чередуются: одна, потом другая, потом снова первая.'**
  String get challengeShapePathHint;

  /// No description provided for @challengeShapePathExplanation.
  ///
  /// In ru, this message translates to:
  /// **'После квадрата снова идет круг, потому что ряд повторяется через одну фигуру.'**
  String get challengeShapePathExplanation;

  /// No description provided for @challengeToyCountTitle.
  ///
  /// In ru, this message translates to:
  /// **'Сколько игрушек'**
  String get challengeToyCountTitle;

  /// No description provided for @challengeToyCountPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Посчитай предметы и выбери точный ответ.'**
  String get challengeToyCountPrompt;

  /// No description provided for @challengeToyCountQuestion.
  ///
  /// In ru, this message translates to:
  /// **'На полке 2 кубика и 1 мяч. Сколько игрушек всего?'**
  String get challengeToyCountQuestion;

  /// No description provided for @challengeToyCountHint.
  ///
  /// In ru, this message translates to:
  /// **'Сначала посчитай кубики, потом добавь мяч.'**
  String get challengeToyCountHint;

  /// No description provided for @challengeToyCountExplanation.
  ///
  /// In ru, this message translates to:
  /// **'2 кубика и 1 мяч дают 3 игрушки всего.'**
  String get challengeToyCountExplanation;

  /// No description provided for @challengeOddCardTitle.
  ///
  /// In ru, this message translates to:
  /// **'Лишняя карточка'**
  String get challengeOddCardTitle;

  /// No description provided for @challengeOddCardPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Найди предмет, который отличается от остальных.'**
  String get challengeOddCardPrompt;

  /// No description provided for @challengeOddCardQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Яблоко, груша, мяч, банан. Что лишнее?'**
  String get challengeOddCardQuestion;

  /// No description provided for @challengeOddCardHint.
  ///
  /// In ru, this message translates to:
  /// **'Три предмета можно съесть, а один нужен для игры.'**
  String get challengeOddCardHint;

  /// No description provided for @challengeOddCardExplanation.
  ///
  /// In ru, this message translates to:
  /// **'Мяч лишний: яблоко, груша и банан - это фрукты.'**
  String get challengeOddCardExplanation;

  /// No description provided for @challengeLogicTrainTitle.
  ///
  /// In ru, this message translates to:
  /// **'Логический поезд'**
  String get challengeLogicTrainTitle;

  /// No description provided for @challengeLogicTrainPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Расставь вагоны по правилу.'**
  String get challengeLogicTrainPrompt;

  /// No description provided for @challengeLogicTrainQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Красный, синий, синий, красный, синий, синий. Какой следующий?'**
  String get challengeLogicTrainQuestion;

  /// No description provided for @challengeLogicTrainHint.
  ///
  /// In ru, this message translates to:
  /// **'Правило повторяется тройками: один красный и два синих.'**
  String get challengeLogicTrainHint;

  /// No description provided for @challengeLogicTrainExplanation.
  ///
  /// In ru, this message translates to:
  /// **'Следующий вагон красный: после двух синих начинается новая тройка.'**
  String get challengeLogicTrainExplanation;

  /// No description provided for @challengeStickerSumTitle.
  ///
  /// In ru, this message translates to:
  /// **'Наклейки в альбоме'**
  String get challengeStickerSumTitle;

  /// No description provided for @challengeStickerSumPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Сложи две маленькие группы предметов.'**
  String get challengeStickerSumPrompt;

  /// No description provided for @challengeStickerSumQuestion.
  ///
  /// In ru, this message translates to:
  /// **'У Ники было 3 наклейки, потом дали еще 2. Сколько стало?'**
  String get challengeStickerSumQuestion;

  /// No description provided for @challengeStickerSumHint.
  ///
  /// In ru, this message translates to:
  /// **'Начни с трех и досчитай еще два шага.'**
  String get challengeStickerSumHint;

  /// No description provided for @challengeStickerSumExplanation.
  ///
  /// In ru, this message translates to:
  /// **'3 + 2 = 5, значит стало пять наклеек.'**
  String get challengeStickerSumExplanation;

  /// No description provided for @challengeMemoryPairsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Пары по памяти'**
  String get challengeMemoryPairsTitle;

  /// No description provided for @challengeMemoryPairsPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Вспомни пару для каждого предмета.'**
  String get challengeMemoryPairsPrompt;

  /// No description provided for @challengeMemoryPairsQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Что подходит к ключу?'**
  String get challengeMemoryPairsQuestion;

  /// No description provided for @challengeMemoryPairsHint.
  ///
  /// In ru, this message translates to:
  /// **'Ключ нужен, чтобы что-то открыть.'**
  String get challengeMemoryPairsHint;

  /// No description provided for @challengeMemoryPairsExplanation.
  ///
  /// In ru, this message translates to:
  /// **'К ключу подходит замок: вместе они образуют смысловую пару.'**
  String get challengeMemoryPairsExplanation;

  /// No description provided for @challengeCodeGridTitle.
  ///
  /// In ru, this message translates to:
  /// **'Кодовая сетка'**
  String get challengeCodeGridTitle;

  /// No description provided for @challengeCodeGridPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Разгадай правило и выбери правильную клетку.'**
  String get challengeCodeGridPrompt;

  /// No description provided for @challengeCodeGridQuestion.
  ///
  /// In ru, this message translates to:
  /// **'В первой строке 2, 4, 6. Во второй 3, 5, ?. Какое число пропущено?'**
  String get challengeCodeGridQuestion;

  /// No description provided for @challengeCodeGridHint.
  ///
  /// In ru, this message translates to:
  /// **'Во второй строке числа тоже растут на 2.'**
  String get challengeCodeGridHint;

  /// No description provided for @challengeCodeGridExplanation.
  ///
  /// In ru, this message translates to:
  /// **'После 3 и 5 идет 7: каждый шаг увеличивает число на два.'**
  String get challengeCodeGridExplanation;

  /// No description provided for @challengeNumberBridgeTitle.
  ///
  /// In ru, this message translates to:
  /// **'Числовой мост'**
  String get challengeNumberBridgeTitle;

  /// No description provided for @challengeNumberBridgePrompt.
  ///
  /// In ru, this message translates to:
  /// **'Соедини числа так, чтобы получить нужный маршрут.'**
  String get challengeNumberBridgePrompt;

  /// No description provided for @challengeNumberBridgeQuestion.
  ///
  /// In ru, this message translates to:
  /// **'У тебя есть 4, 2 и 1. Как получить 7?'**
  String get challengeNumberBridgeQuestion;

  /// No description provided for @challengeNumberBridgeHint.
  ///
  /// In ru, this message translates to:
  /// **'Попробуй использовать все числа один раз.'**
  String get challengeNumberBridgeHint;

  /// No description provided for @challengeNumberBridgeExplanation.
  ///
  /// In ru, this message translates to:
  /// **'4 + 2 + 1 = 7, значит все три числа вместе дают нужный результат.'**
  String get challengeNumberBridgeExplanation;

  /// No description provided for @challengeDetailCountTitle.
  ///
  /// In ru, this message translates to:
  /// **'Карта деталей'**
  String get challengeDetailCountTitle;

  /// No description provided for @challengeDetailCountPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Удержи в голове несколько деталей и сравни их.'**
  String get challengeDetailCountPrompt;

  /// No description provided for @challengeDetailCountQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Есть 3 красных круга, 2 синих квадрата и 1 зеленая звезда. Чего больше всего?'**
  String get challengeDetailCountQuestion;

  /// No description provided for @challengeDetailCountHint.
  ///
  /// In ru, this message translates to:
  /// **'Сравни количества: 3, 2 и 1.'**
  String get challengeDetailCountHint;

  /// No description provided for @challengeDetailCountExplanation.
  ///
  /// In ru, this message translates to:
  /// **'Больше всего красных кругов: их три.'**
  String get challengeDetailCountExplanation;

  /// No description provided for @choiceTriangle.
  ///
  /// In ru, this message translates to:
  /// **'Треугольник'**
  String get choiceTriangle;

  /// No description provided for @choiceCircle.
  ///
  /// In ru, this message translates to:
  /// **'Круг'**
  String get choiceCircle;

  /// No description provided for @choiceStar.
  ///
  /// In ru, this message translates to:
  /// **'Звезда'**
  String get choiceStar;

  /// No description provided for @choiceApple.
  ///
  /// In ru, this message translates to:
  /// **'Яблоко'**
  String get choiceApple;

  /// No description provided for @choiceBall.
  ///
  /// In ru, this message translates to:
  /// **'Мяч'**
  String get choiceBall;

  /// No description provided for @choiceBanana.
  ///
  /// In ru, this message translates to:
  /// **'Банан'**
  String get choiceBanana;

  /// No description provided for @choiceBlue.
  ///
  /// In ru, this message translates to:
  /// **'Синий'**
  String get choiceBlue;

  /// No description provided for @choiceRed.
  ///
  /// In ru, this message translates to:
  /// **'Красный'**
  String get choiceRed;

  /// No description provided for @choiceGreen.
  ///
  /// In ru, this message translates to:
  /// **'Зеленый'**
  String get choiceGreen;

  /// No description provided for @choiceLock.
  ///
  /// In ru, this message translates to:
  /// **'Замок'**
  String get choiceLock;

  /// No description provided for @choiceShoe.
  ///
  /// In ru, this message translates to:
  /// **'Ботинок'**
  String get choiceShoe;

  /// No description provided for @choiceCloud.
  ///
  /// In ru, this message translates to:
  /// **'Облако'**
  String get choiceCloud;

  /// No description provided for @choiceBlueSquares.
  ///
  /// In ru, this message translates to:
  /// **'Синих квадратов'**
  String get choiceBlueSquares;

  /// No description provided for @choiceRedCircles.
  ///
  /// In ru, this message translates to:
  /// **'Красных кругов'**
  String get choiceRedCircles;

  /// No description provided for @choiceGreenStars.
  ///
  /// In ru, this message translates to:
  /// **'Зеленых звезд'**
  String get choiceGreenStars;

  /// No description provided for @mapLessonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Урок {lesson}'**
  String mapLessonTitle(Object lesson);

  /// No description provided for @mapLessonSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Логика, счёт и внимание в одном коротком уроке'**
  String get mapLessonSubtitle;

  /// No description provided for @mapStartButton.
  ///
  /// In ru, this message translates to:
  /// **'Начать'**
  String get mapStartButton;

  /// No description provided for @mapNodeStart.
  ///
  /// In ru, this message translates to:
  /// **'Старт'**
  String get mapNodeStart;

  /// No description provided for @mapNodeShapes.
  ///
  /// In ru, this message translates to:
  /// **'Фигуры'**
  String get mapNodeShapes;

  /// No description provided for @mapNodePairs.
  ///
  /// In ru, this message translates to:
  /// **'Пары'**
  String get mapNodePairs;

  /// No description provided for @mapNodeCounting.
  ///
  /// In ru, this message translates to:
  /// **'Счёт'**
  String get mapNodeCounting;

  /// No description provided for @mapNodePath.
  ///
  /// In ru, this message translates to:
  /// **'Путь'**
  String get mapNodePath;

  /// No description provided for @mapNodeRhythm.
  ///
  /// In ru, this message translates to:
  /// **'Ритм'**
  String get mapNodeRhythm;

  /// No description provided for @mapNodeCompare.
  ///
  /// In ru, this message translates to:
  /// **'Сравни'**
  String get mapNodeCompare;

  /// No description provided for @mapNodeFinal.
  ///
  /// In ru, this message translates to:
  /// **'Финал'**
  String get mapNodeFinal;

  /// No description provided for @mapNodeCompleted.
  ///
  /// In ru, this message translates to:
  /// **'пройдено'**
  String get mapNodeCompleted;

  /// No description provided for @mapNodeCurrent.
  ///
  /// In ru, this message translates to:
  /// **'доступно'**
  String get mapNodeCurrent;

  /// No description provided for @mapNodeLocked.
  ///
  /// In ru, this message translates to:
  /// **'закрыто'**
  String get mapNodeLocked;

  /// No description provided for @mapPreviewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Урок {lesson}'**
  String mapPreviewTitle(Object lesson);

  /// No description provided for @mapPreviewSteps.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} шаг} few{{count} шага} many{{count} шагов} other{{count} шага}}'**
  String mapPreviewSteps(num count);

  /// No description provided for @mapPreviewReward.
  ///
  /// In ru, this message translates to:
  /// **'+{xp} XP'**
  String mapPreviewReward(Object xp);

  /// No description provided for @mapPreviewHearts.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} сердце} few{{count} сердца} many{{count} сердец} other{{count} сердца}}'**
  String mapPreviewHearts(num count);

  /// No description provided for @mapPreviewBody.
  ///
  /// In ru, this message translates to:
  /// **'Короткий урок со смешанными задачками: логика, счёт, сравнение и внимание.'**
  String get mapPreviewBody;

  /// No description provided for @mapPreviewStart.
  ///
  /// In ru, this message translates to:
  /// **'Начать урок'**
  String get mapPreviewStart;

  /// No description provided for @mapPreviewClose.
  ///
  /// In ru, this message translates to:
  /// **'Позже'**
  String get mapPreviewClose;

  /// No description provided for @lessonProgress.
  ///
  /// In ru, this message translates to:
  /// **'Шаг {current} из {total}'**
  String lessonProgress(Object current, Object total);

  /// No description provided for @lessonNextButton.
  ///
  /// In ru, this message translates to:
  /// **'Дальше'**
  String get lessonNextButton;

  /// No description provided for @lessonFinishButton.
  ///
  /// In ru, this message translates to:
  /// **'Завершить урок'**
  String get lessonFinishButton;

  /// No description provided for @lessonCompleteTitle.
  ///
  /// In ru, this message translates to:
  /// **'Урок пройден!'**
  String get lessonCompleteTitle;

  /// No description provided for @lessonCompleteBody.
  ///
  /// In ru, this message translates to:
  /// **'Ты открыл следующий шаг на карте.'**
  String get lessonCompleteBody;

  /// No description provided for @lessonRewardStars.
  ///
  /// In ru, this message translates to:
  /// **'+1 звезда'**
  String get lessonRewardStars;

  /// No description provided for @lessonRewardXp.
  ///
  /// In ru, this message translates to:
  /// **'+{xp} XP'**
  String lessonRewardXp(Object xp);

  /// No description provided for @lessonBackToMap.
  ///
  /// In ru, this message translates to:
  /// **'На главную'**
  String get lessonBackToMap;

  /// No description provided for @courseCatalogTitle.
  ///
  /// In ru, this message translates to:
  /// **'Курсы и головоломки'**
  String get courseCatalogTitle;

  /// No description provided for @courseLogicTitle.
  ///
  /// In ru, this message translates to:
  /// **'Логика'**
  String get courseLogicTitle;

  /// No description provided for @courseLogicSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Правила, лишнее и выводы'**
  String get courseLogicSubtitle;

  /// No description provided for @courseMathTitle.
  ///
  /// In ru, this message translates to:
  /// **'Математика'**
  String get courseMathTitle;

  /// No description provided for @courseMathSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Счет, суммы и сравнение'**
  String get courseMathSubtitle;

  /// No description provided for @courseSpatialTitle.
  ///
  /// In ru, this message translates to:
  /// **'Фигуры'**
  String get courseSpatialTitle;

  /// No description provided for @courseSpatialSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Форма, путь и пространство'**
  String get courseSpatialSubtitle;

  /// No description provided for @courseAttentionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Внимание'**
  String get courseAttentionTitle;

  /// No description provided for @courseAttentionSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Детали, память и фокус'**
  String get courseAttentionSubtitle;

  /// No description provided for @courseRebusTitle.
  ///
  /// In ru, this message translates to:
  /// **'Ребусы'**
  String get courseRebusTitle;

  /// No description provided for @courseRebusSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Картинки, слова и загадки'**
  String get courseRebusSubtitle;

  /// No description provided for @courseMixedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Микс дня'**
  String get courseMixedTitle;

  /// No description provided for @courseMixedSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Разные задачки подряд'**
  String get courseMixedSubtitle;

  /// No description provided for @progressCardBody.
  ///
  /// In ru, this message translates to:
  /// **'Уровень {level} • {stars} звезд'**
  String progressCardBody(Object level, Object stars);

  /// No description provided for @collectionCardBody.
  ///
  /// In ru, this message translates to:
  /// **'{count, plural, one{{count} наклейка} few{{count} наклейки} many{{count} наклеек} other{{count} наклейки}}'**
  String collectionCardBody(num count);

  /// No description provided for @dailyMissionBody.
  ///
  /// In ru, this message translates to:
  /// **'Короткая серия задач на логику, счет и внимание.'**
  String get dailyMissionBody;

  /// No description provided for @openCourseButton.
  ///
  /// In ru, this message translates to:
  /// **'Открыть'**
  String get openCourseButton;

  /// No description provided for @courseProgress.
  ///
  /// In ru, this message translates to:
  /// **'{completed} из {total} уроков пройдено'**
  String courseProgress(Object completed, Object total);

  /// No description provided for @courseLessonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Урок {lesson}'**
  String courseLessonTitle(Object lesson);

  /// No description provided for @courseLessonMeta.
  ///
  /// In ru, this message translates to:
  /// **'{steps, plural, one{{steps} шаг} few{{steps} шага} many{{steps} шагов} other{{steps} шага}} • +{xp} XP'**
  String courseLessonMeta(num steps, Object xp);

  /// No description provided for @courseStartLessonButton.
  ///
  /// In ru, this message translates to:
  /// **'Старт'**
  String get courseStartLessonButton;

  /// No description provided for @courseRepeatButton.
  ///
  /// In ru, this message translates to:
  /// **'Повтор'**
  String get courseRepeatButton;

  /// No description provided for @showHintButton.
  ///
  /// In ru, this message translates to:
  /// **'Подсказка'**
  String get showHintButton;

  /// No description provided for @hideHintButton.
  ///
  /// In ru, this message translates to:
  /// **'Скрыть подсказку'**
  String get hideHintButton;

  /// No description provided for @lessonStickerUnlockedTitle.
  ///
  /// In ru, this message translates to:
  /// **'Новая наклейка!'**
  String get lessonStickerUnlockedTitle;

  /// No description provided for @lessonStickerUnlockedBody.
  ///
  /// In ru, this message translates to:
  /// **'Коллекция пополнилась после урока.'**
  String get lessonStickerUnlockedBody;

  /// No description provided for @lessonRewardCollection.
  ///
  /// In ru, this message translates to:
  /// **'+1 наклейка'**
  String get lessonRewardCollection;

  /// No description provided for @lessonRewardStreak.
  ///
  /// In ru, this message translates to:
  /// **'Серия растет'**
  String get lessonRewardStreak;

  /// No description provided for @challengeShadowMatchTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подбери тень'**
  String get challengeShadowMatchTitle;

  /// No description provided for @challengeShadowMatchPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Найди предмет, который подходит к тени.'**
  String get challengeShadowMatchPrompt;

  /// No description provided for @challengeShadowMatchQuestion.
  ///
  /// In ru, this message translates to:
  /// **'У тени высокий корпус и два маленьких крыла. Что это?'**
  String get challengeShadowMatchQuestion;

  /// No description provided for @challengeShadowMatchHint.
  ///
  /// In ru, this message translates to:
  /// **'Смотри на общий контур предмета.'**
  String get challengeShadowMatchHint;

  /// No description provided for @challengeShadowMatchExplanation.
  ///
  /// In ru, this message translates to:
  /// **'Ракета подходит к тени: у нее высокий корпус и два боковых крыла.'**
  String get challengeShadowMatchExplanation;

  /// No description provided for @challengeBalanceScaleTitle.
  ///
  /// In ru, this message translates to:
  /// **'Весы'**
  String get challengeBalanceScaleTitle;

  /// No description provided for @challengeBalanceScalePrompt.
  ///
  /// In ru, this message translates to:
  /// **'Сравни стороны и выбери, чего не хватает.'**
  String get challengeBalanceScalePrompt;

  /// No description provided for @challengeBalanceScaleQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Слева 2 яблока. Справа 1 яблоко и ?. Что добавить?'**
  String get challengeBalanceScaleQuestion;

  /// No description provided for @challengeBalanceScaleHint.
  ///
  /// In ru, this message translates to:
  /// **'На обеих сторонах должно быть одинаковое количество яблок.'**
  String get challengeBalanceScaleHint;

  /// No description provided for @challengeBalanceScaleExplanation.
  ///
  /// In ru, this message translates to:
  /// **'Еще одно яблоко делает правую сторону равной левой: 2 и 2.'**
  String get challengeBalanceScaleExplanation;

  /// No description provided for @challengeShapeRotationTitle.
  ///
  /// In ru, this message translates to:
  /// **'Поворот фигуры'**
  String get challengeShapeRotationTitle;

  /// No description provided for @challengeShapeRotationPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Представь, как фигура поворачивается.'**
  String get challengeShapeRotationPrompt;

  /// No description provided for @challengeShapeRotationQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Треугольник повернули вправо. Какая карточка показывает ту же фигуру?'**
  String get challengeShapeRotationQuestion;

  /// No description provided for @challengeShapeRotationHint.
  ///
  /// In ru, this message translates to:
  /// **'Поворот меняет направление, но не саму фигуру.'**
  String get challengeShapeRotationHint;

  /// No description provided for @challengeShapeRotationExplanation.
  ///
  /// In ru, this message translates to:
  /// **'Это тот же треугольник: он повернулся, но не стал другой фигурой.'**
  String get challengeShapeRotationExplanation;

  /// No description provided for @choiceRocket.
  ///
  /// In ru, this message translates to:
  /// **'Ракета'**
  String get choiceRocket;

  /// No description provided for @choicePlanet.
  ///
  /// In ru, this message translates to:
  /// **'Планета'**
  String get choicePlanet;

  /// No description provided for @choiceSameTriangle.
  ///
  /// In ru, this message translates to:
  /// **'Тот же треугольник'**
  String get choiceSameTriangle;

  /// No description provided for @choiceSquare.
  ///
  /// In ru, this message translates to:
  /// **'Квадрат'**
  String get choiceSquare;

  /// No description provided for @skillInsightsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Навыки и рекомендации'**
  String get skillInsightsTitle;

  /// No description provided for @strongestAreaLabel.
  ///
  /// In ru, this message translates to:
  /// **'Сильная зона'**
  String get strongestAreaLabel;

  /// No description provided for @practiceFocusLabel.
  ///
  /// In ru, this message translates to:
  /// **'Зона фокуса'**
  String get practiceFocusLabel;

  /// No description provided for @recommendedPracticeLabel.
  ///
  /// In ru, this message translates to:
  /// **'Что тренировать дальше'**
  String get recommendedPracticeLabel;

  /// No description provided for @noSkillDataLabel.
  ///
  /// In ru, this message translates to:
  /// **'Пока мало данных'**
  String get noSkillDataLabel;

  /// No description provided for @recommendationKeepGoing.
  ///
  /// In ru, this message translates to:
  /// **'Продолжайте короткие уроки: после нескольких занятий рекомендация станет точнее.'**
  String get recommendationKeepGoing;

  /// No description provided for @recommendationPracticeFocus.
  ///
  /// In ru, this message translates to:
  /// **'Добавьте 1-2 коротких урока по этой зоне на неделе.'**
  String get recommendationPracticeFocus;

  /// No description provided for @courseNextMetricLabel.
  ///
  /// In ru, this message translates to:
  /// **'Дальше'**
  String get courseNextMetricLabel;

  /// No description provided for @courseStarsMetricLabel.
  ///
  /// In ru, this message translates to:
  /// **'Звезды'**
  String get courseStarsMetricLabel;

  /// No description provided for @courseXpMetricLabel.
  ///
  /// In ru, this message translates to:
  /// **'XP'**
  String get courseXpMetricLabel;

  /// No description provided for @courseCompletedState.
  ///
  /// In ru, this message translates to:
  /// **'пройдено'**
  String get courseCompletedState;

  /// No description provided for @courseOpenState.
  ///
  /// In ru, this message translates to:
  /// **'доступно'**
  String get courseOpenState;

  /// No description provided for @courseLockedState.
  ///
  /// In ru, this message translates to:
  /// **'закрыто'**
  String get courseLockedState;

  /// No description provided for @collectionScreenTitle.
  ///
  /// In ru, this message translates to:
  /// **'Коллекция наклеек'**
  String get collectionScreenTitle;

  /// No description provided for @collectionScreenSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Собирай награды за уроки и регулярные занятия.'**
  String get collectionScreenSubtitle;

  /// No description provided for @collectionUnlockedCount.
  ///
  /// In ru, this message translates to:
  /// **'Открыто {unlocked} из {total}'**
  String collectionUnlockedCount(Object total, Object unlocked);

  /// No description provided for @collectionNextReward.
  ///
  /// In ru, this message translates to:
  /// **'Следующая награда'**
  String get collectionNextReward;

  /// No description provided for @collectionAllRewardsUnlocked.
  ///
  /// In ru, this message translates to:
  /// **'Все награды открыты'**
  String get collectionAllRewardsUnlocked;

  /// No description provided for @collectionBackHome.
  ///
  /// In ru, this message translates to:
  /// **'На главную'**
  String get collectionBackHome;

  /// No description provided for @collectionLockedHint.
  ///
  /// In ru, this message translates to:
  /// **'Откроется после {stars} звезд'**
  String collectionLockedHint(Object stars);

  /// No description provided for @rewardAstronautTitle.
  ///
  /// In ru, this message translates to:
  /// **'Звёздный помощник'**
  String get rewardAstronautTitle;

  /// No description provided for @rewardAstronautBody.
  ///
  /// In ru, this message translates to:
  /// **'За первую пройденную миссию.'**
  String get rewardAstronautBody;

  /// No description provided for @rewardRocketTitle.
  ///
  /// In ru, this message translates to:
  /// **'Смелая ракета'**
  String get rewardRocketTitle;

  /// No description provided for @rewardRocketBody.
  ///
  /// In ru, this message translates to:
  /// **'За открытие учебного курса.'**
  String get rewardRocketBody;

  /// No description provided for @rewardPlanetTitle.
  ///
  /// In ru, this message translates to:
  /// **'Маленькая планета'**
  String get rewardPlanetTitle;

  /// No description provided for @rewardPlanetBody.
  ///
  /// In ru, this message translates to:
  /// **'За два пройденных урока.'**
  String get rewardPlanetBody;

  /// No description provided for @rewardLionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Логический лев'**
  String get rewardLionTitle;

  /// No description provided for @rewardLionBody.
  ///
  /// In ru, this message translates to:
  /// **'За серию занятий.'**
  String get rewardLionBody;

  /// No description provided for @rewardPuzzleTitle.
  ///
  /// In ru, this message translates to:
  /// **'Значок головоломок'**
  String get rewardPuzzleTitle;

  /// No description provided for @rewardPuzzleBody.
  ///
  /// In ru, this message translates to:
  /// **'За смешанные задачки.'**
  String get rewardPuzzleBody;

  /// No description provided for @rewardChampionTitle.
  ///
  /// In ru, this message translates to:
  /// **'Космический чемпион'**
  String get rewardChampionTitle;

  /// No description provided for @rewardChampionBody.
  ///
  /// In ru, this message translates to:
  /// **'За регулярную практику на неделе.'**
  String get rewardChampionBody;

  /// No description provided for @accuracyMetricLabel.
  ///
  /// In ru, this message translates to:
  /// **'Точность'**
  String get accuracyMetricLabel;

  /// No description provided for @hintsMetricLabel.
  ///
  /// In ru, this message translates to:
  /// **'Подсказки'**
  String get hintsMetricLabel;

  /// No description provided for @recommendationImproveAccuracy.
  ///
  /// In ru, this message translates to:
  /// **'На этой неделе позанимайтесь темой {skill} без спешки: главный сигнал сейчас - точность.'**
  String recommendationImproveAccuracy(Object skill);

  /// No description provided for @recommendationReduceHints.
  ///
  /// In ru, this message translates to:
  /// **'Повторите тему {skill} с меньшим числом подсказок: дайте ребенку паузу перед помощью.'**
  String recommendationReduceHints(Object skill);

  /// No description provided for @recommendationRepeatAttempts.
  ///
  /// In ru, this message translates to:
  /// **'Дайте теме {skill} одно короткое повторение, чтобы снизить число ошибок.'**
  String recommendationRepeatAttempts(Object skill);

  /// No description provided for @homeRecommendedLessonTitle.
  ///
  /// In ru, this message translates to:
  /// **'Следующий урок'**
  String get homeRecommendedLessonTitle;

  /// No description provided for @homeRecommendedLessonSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Следующий короткий урок на учебном маршруте.'**
  String get homeRecommendedLessonSubtitle;

  /// No description provided for @homeRecommendedLessonButton.
  ///
  /// In ru, this message translates to:
  /// **'Продолжить'**
  String get homeRecommendedLessonButton;

  /// No description provided for @homeRecommendedLessonCompleted.
  ///
  /// In ru, this message translates to:
  /// **'Маршрут пройден'**
  String get homeRecommendedLessonCompleted;

  /// No description provided for @lessonReviewTitle.
  ///
  /// In ru, this message translates to:
  /// **'Итог урока'**
  String get lessonReviewTitle;

  /// No description provided for @lessonReviewPerfectBody.
  ///
  /// In ru, this message translates to:
  /// **'Отличный фокус: без подсказок и ошибок.'**
  String get lessonReviewPerfectBody;

  /// No description provided for @lessonReviewSupportBody.
  ///
  /// In ru, this message translates to:
  /// **'Хороший финиш. В следующий раз попробуй один шаг без помощи.'**
  String get lessonReviewSupportBody;

  /// No description provided for @lessonReviewQuestionsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Вопросы'**
  String get lessonReviewQuestionsLabel;

  /// No description provided for @lessonReviewHintsLabel.
  ///
  /// In ru, this message translates to:
  /// **'Подсказки'**
  String get lessonReviewHintsLabel;

  /// No description provided for @lessonReviewMistakesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Ошибки'**
  String get lessonReviewMistakesLabel;

  /// No description provided for @lessonNextRecommendedButton.
  ///
  /// In ru, this message translates to:
  /// **'Следующий урок'**
  String get lessonNextRecommendedButton;

  /// No description provided for @practiceHistoryTitle.
  ///
  /// In ru, this message translates to:
  /// **'История занятий'**
  String get practiceHistoryTitle;

  /// No description provided for @practiceHistorySubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Последние уроки с точностью, подсказками и ошибками.'**
  String get practiceHistorySubtitle;

  /// No description provided for @practiceHistoryEmpty.
  ///
  /// In ru, this message translates to:
  /// **'Пройденных уроков пока нет.'**
  String get practiceHistoryEmpty;

  /// No description provided for @practiceHistorySessionMeta.
  ///
  /// In ru, this message translates to:
  /// **'{date} - {minutes} мин'**
  String practiceHistorySessionMeta(Object date, Object minutes);

  /// No description provided for @practiceHistoryMistakesLabel.
  ///
  /// In ru, this message translates to:
  /// **'Ошибки'**
  String get practiceHistoryMistakesLabel;

  /// No description provided for @lessonTryAgainButton.
  ///
  /// In ru, this message translates to:
  /// **'Попробовать еще'**
  String get lessonTryAgainButton;

  /// No description provided for @lessonHintTitle.
  ///
  /// In ru, this message translates to:
  /// **'Подумай по шагам'**
  String get lessonHintTitle;

  /// No description provided for @lessonRetryFeedback.
  ///
  /// In ru, this message translates to:
  /// **'Хорошая попытка. Прочитай подсказку и выбери еще раз.'**
  String get lessonRetryFeedback;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In ru, this message translates to:
  /// **'Язык приложения'**
  String get languageSettingsTitle;

  /// No description provided for @languageSettingsSubtitle.
  ///
  /// In ru, this message translates to:
  /// **'Выберите язык для детских и родительских экранов.'**
  String get languageSettingsSubtitle;

  /// No description provided for @languageRussian.
  ///
  /// In ru, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In ru, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @choicePear.
  ///
  /// In ru, this message translates to:
  /// **'Груша'**
  String get choicePear;

  /// No description provided for @challengeFruitPatternTitle.
  ///
  /// In ru, this message translates to:
  /// **'Фруктовый ряд'**
  String get challengeFruitPatternTitle;

  /// No description provided for @challengeFruitPatternPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Продолжи фруктовую закономерность.'**
  String get challengeFruitPatternPrompt;

  /// No description provided for @challengeFruitPatternQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Яблоко, банан, яблоко, банан. Что дальше?'**
  String get challengeFruitPatternQuestion;

  /// No description provided for @challengeFruitPatternHint.
  ///
  /// In ru, this message translates to:
  /// **'Фрукты повторяются по очереди: яблоко, потом банан.'**
  String get challengeFruitPatternHint;

  /// No description provided for @challengeFruitPatternExplanation.
  ///
  /// In ru, this message translates to:
  /// **'После банана снова идет яблоко, потому что ряд повторяется.'**
  String get challengeFruitPatternExplanation;

  /// No description provided for @challengeLockKeyTitle.
  ///
  /// In ru, this message translates to:
  /// **'Волшебная пара'**
  String get challengeLockKeyTitle;

  /// No description provided for @challengeLockKeyPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Выбери предмет, который образует пару.'**
  String get challengeLockKeyPrompt;

  /// No description provided for @challengeLockKeyQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Ключ что-то открывает. Что к нему подходит?'**
  String get challengeLockKeyQuestion;

  /// No description provided for @challengeLockKeyHint.
  ///
  /// In ru, this message translates to:
  /// **'Вспомни, для чего нужен ключ.'**
  String get challengeLockKeyHint;

  /// No description provided for @challengeLockKeyExplanation.
  ///
  /// In ru, this message translates to:
  /// **'Ключ и замок работают вместе, поэтому это пара.'**
  String get challengeLockKeyExplanation;

  /// No description provided for @challengeSpaceSequenceTitle.
  ///
  /// In ru, this message translates to:
  /// **'Космический маршрут'**
  String get challengeSpaceSequenceTitle;

  /// No description provided for @challengeSpaceSequencePrompt.
  ///
  /// In ru, this message translates to:
  /// **'Найди следующий космический предмет.'**
  String get challengeSpaceSequencePrompt;

  /// No description provided for @challengeSpaceSequenceQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Ракета, планета, ракета, планета. Что дальше?'**
  String get challengeSpaceSequenceQuestion;

  /// No description provided for @challengeSpaceSequenceHint.
  ///
  /// In ru, this message translates to:
  /// **'Маршрут повторяется: ракета, потом планета.'**
  String get challengeSpaceSequenceHint;

  /// No description provided for @challengeSpaceSequenceExplanation.
  ///
  /// In ru, this message translates to:
  /// **'После планеты снова идет ракета.'**
  String get challengeSpaceSequenceExplanation;

  /// No description provided for @challengeShapeStackTitle.
  ///
  /// In ru, this message translates to:
  /// **'Башня фигур'**
  String get challengeShapeStackTitle;

  /// No description provided for @challengeShapeStackPrompt.
  ///
  /// In ru, this message translates to:
  /// **'Продолжи правило башни.'**
  String get challengeShapeStackPrompt;

  /// No description provided for @challengeShapeStackQuestion.
  ///
  /// In ru, this message translates to:
  /// **'Квадрат, круг, квадрат, круг. Какая фигура дальше?'**
  String get challengeShapeStackQuestion;

  /// No description provided for @challengeShapeStackHint.
  ///
  /// In ru, this message translates to:
  /// **'Башня чередует две фигуры.'**
  String get challengeShapeStackHint;

  /// No description provided for @challengeShapeStackExplanation.
  ///
  /// In ru, this message translates to:
  /// **'После круга снова идет квадрат.'**
  String get challengeShapeStackExplanation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
