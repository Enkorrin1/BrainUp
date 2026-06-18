import '../../domain/learning_foundation.dart';

enum MiniGameCompletionReason {
  answered,
  exited,
}

enum MiniGameDifficultySignal {
  easier,
  steady,
  harder,
}

class MiniGameResult {
  const MiniGameResult({
    required this.miniGameId,
    required this.puzzleId,
    required this.isCorrect,
    required this.score,
    required this.stars,
    required this.durationSeconds,
    required this.wrongAttempts,
    required this.usedHints,
    required this.skillTags,
    required this.mistakeSignals,
    required this.rewardSignals,
    required this.difficultySignal,
    required this.completionReason,
    this.selectedChoiceId,
  });

  factory MiniGameResult.exited({
    required String miniGameId,
    required String puzzleId,
    required int durationSeconds,
    required int usedHints,
    required List<SkillTag> skillTags,
  }) {
    return MiniGameResult(
      miniGameId: miniGameId,
      puzzleId: puzzleId,
      isCorrect: false,
      selectedChoiceId: null,
      score: 0,
      stars: 0,
      durationSeconds: durationSeconds,
      wrongAttempts: 0,
      usedHints: usedHints,
      skillTags: skillTags,
      mistakeSignals: const [],
      rewardSignals: const [],
      difficultySignal: MiniGameDifficultySignal.steady,
      completionReason: MiniGameCompletionReason.exited,
    );
  }

  final String miniGameId;
  final String puzzleId;
  final bool isCorrect;
  final String? selectedChoiceId;
  final int score;
  final int stars;
  final int durationSeconds;
  final int wrongAttempts;
  final int usedHints;
  final List<SkillTag> skillTags;
  final List<String> mistakeSignals;
  final List<String> rewardSignals;
  final MiniGameDifficultySignal difficultySignal;
  final MiniGameCompletionReason completionReason;

  bool get exited {
    return completionReason == MiniGameCompletionReason.exited;
  }

  Map<String, Object?> toJson() {
    return {
      'miniGameId': miniGameId,
      'puzzleId': puzzleId,
      'isCorrect': isCorrect,
      'selectedChoiceId': selectedChoiceId,
      'score': score,
      'stars': stars,
      'durationSeconds': durationSeconds,
      'wrongAttempts': wrongAttempts,
      'usedHints': usedHints,
      'skillTags': [
        for (final skillTag in skillTags) skillTag.name,
      ],
      'mistakeSignals': mistakeSignals,
      'rewardSignals': rewardSignals,
      'difficultySignal': difficultySignal.name,
      'completionReason': completionReason.name,
    };
  }
}
