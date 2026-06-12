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
      _ => challenge.title,
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
      _ => challenge.prompt,
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
      _ => challenge.question,
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
      _ => challenge.hint,
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
      _ => challenge.explanation,
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
      _ => choice.label,
    };
  }

  String localizedSkill(String skill) {
    return switch (skill) {
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
