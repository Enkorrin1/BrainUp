import '../../domain/learning_foundation.dart';

enum MiniGameAdaptiveDifficulty {
  support,
  steady,
  challenge,
}

class MiniGameAdaptiveProfile {
  const MiniGameAdaptiveProfile({
    required this.difficulty,
    required this.clutterLevel,
    required this.timePressure,
    required this.hintDelaySeconds,
    required this.maxAttemptsBeforeSupport,
    required this.reviewPriority,
  });

  final MiniGameAdaptiveDifficulty difficulty;
  final int clutterLevel;
  final bool timePressure;
  final int hintDelaySeconds;
  final int maxAttemptsBeforeSupport;
  final int reviewPriority;

  static MiniGameAdaptiveProfile fromContent({
    required PuzzleDifficulty puzzleDifficulty,
    required bool isBoss,
    MiniGameContentConfig? contentConfig,
  }) {
    final adaptiveDifficulty = switch (puzzleDifficulty) {
      PuzzleDifficulty.easy => MiniGameAdaptiveDifficulty.support,
      PuzzleDifficulty.normal => MiniGameAdaptiveDifficulty.steady,
      PuzzleDifficulty.hard ||
      PuzzleDifficulty.boss =>
        MiniGameAdaptiveDifficulty.challenge,
    };
    final maxDistractors = contentConfig?.maxDistractors ?? 1;
    final clutterLevel = switch (adaptiveDifficulty) {
      MiniGameAdaptiveDifficulty.support => maxDistractors.clamp(0, 1).toInt(),
      MiniGameAdaptiveDifficulty.steady => maxDistractors.clamp(1, 2).toInt(),
      MiniGameAdaptiveDifficulty.challenge =>
        maxDistractors.clamp(2, 4).toInt(),
    };

    return MiniGameAdaptiveProfile(
      difficulty: adaptiveDifficulty,
      clutterLevel: clutterLevel,
      timePressure: isBoss || puzzleDifficulty == PuzzleDifficulty.hard,
      hintDelaySeconds: switch (adaptiveDifficulty) {
        MiniGameAdaptiveDifficulty.support => 4,
        MiniGameAdaptiveDifficulty.steady => 7,
        MiniGameAdaptiveDifficulty.challenge => 10,
      },
      maxAttemptsBeforeSupport: isBoss ? 3 : 2,
      reviewPriority: switch (puzzleDifficulty) {
        PuzzleDifficulty.easy => 1,
        PuzzleDifficulty.normal => 2,
        PuzzleDifficulty.hard => 3,
        PuzzleDifficulty.boss => 4,
      },
    );
  }

  MiniGameAdaptiveProfile afterResult({
    required int wrongAttempts,
    required int usedHints,
    required bool strongStreak,
  }) {
    if (wrongAttempts >= maxAttemptsBeforeSupport || usedHints > 1) {
      return MiniGameAdaptiveProfile(
        difficulty: MiniGameAdaptiveDifficulty.support,
        clutterLevel: 0,
        timePressure: false,
        hintDelaySeconds: 2,
        maxAttemptsBeforeSupport: maxAttemptsBeforeSupport,
        reviewPriority: reviewPriority + 1,
      );
    }
    if (strongStreak && wrongAttempts == 0 && usedHints == 0) {
      return MiniGameAdaptiveProfile(
        difficulty: MiniGameAdaptiveDifficulty.challenge,
        clutterLevel: (clutterLevel + 1).clamp(1, 4).toInt(),
        timePressure: timePressure,
        hintDelaySeconds: hintDelaySeconds + 1,
        maxAttemptsBeforeSupport: maxAttemptsBeforeSupport,
        reviewPriority: reviewPriority,
      );
    }
    return this;
  }

  Map<String, Object?> toJson() {
    return {
      'difficulty': difficulty.name,
      'clutterLevel': clutterLevel,
      'timePressure': timePressure,
      'hintDelaySeconds': hintDelaySeconds,
      'maxAttemptsBeforeSupport': maxAttemptsBeforeSupport,
      'reviewPriority': reviewPriority,
    };
  }
}
