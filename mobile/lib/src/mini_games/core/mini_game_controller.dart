import 'mini_game_definition.dart';
import 'mini_game_result.dart';

class MiniGameController {
  MiniGameController({
    required this.definition,
    DateTime? startedAt,
  }) : _startedAt = startedAt ?? DateTime.now();

  final MiniGameDefinition definition;
  final DateTime _startedAt;
  int _usedHints = 0;

  int get usedHints {
    return _usedHints;
  }

  void recordHint() {
    _usedHints += 1;
  }

  MiniGameResult answer(String choiceId) {
    final isCorrect = choiceId == definition.firstRound.correctChoiceId;
    final wrongAttempts = isCorrect ? 0 : 1;

    return MiniGameResult(
      miniGameId: definition.id,
      puzzleId: definition.puzzleId,
      isCorrect: isCorrect,
      selectedChoiceId: choiceId,
      score: isCorrect ? _scoreForCorrectAnswer : 0,
      stars: isCorrect ? _starsForCorrectAnswer : 0,
      durationSeconds: _durationSeconds,
      wrongAttempts: wrongAttempts,
      usedHints: _usedHints,
      skillTags: [definition.skillTag],
      mistakeSignals: isCorrect ? const [] : [definition.puzzleId],
      rewardSignals: isCorrect ? [_rewardSignal] : const [],
      difficultySignal: _difficultySignalFor(
        isCorrect: isCorrect,
        wrongAttempts: wrongAttempts,
      ),
      completionReason: MiniGameCompletionReason.answered,
    );
  }

  MiniGameResult exit() {
    return MiniGameResult.exited(
      miniGameId: definition.id,
      puzzleId: definition.puzzleId,
      durationSeconds: _durationSeconds,
      usedHints: _usedHints,
      skillTags: [definition.skillTag],
    );
  }

  int get _durationSeconds {
    return DateTime.now().difference(_startedAt).inSeconds;
  }

  int get _scoreForCorrectAnswer {
    return _usedHints == 0 ? 100 : 75;
  }

  int get _starsForCorrectAnswer {
    return _usedHints == 0 ? 3 : 2;
  }

  String get _rewardSignal {
    return definition.isBoss ? 'boss_clear' : 'mini_game_clear';
  }

  MiniGameDifficultySignal _difficultySignalFor({
    required bool isCorrect,
    required int wrongAttempts,
  }) {
    if (!isCorrect || wrongAttempts > 0) {
      return MiniGameDifficultySignal.easier;
    }
    if (_usedHints == 0 && definition.estimatedSeconds <= 35) {
      return MiniGameDifficultySignal.harder;
    }
    return MiniGameDifficultySignal.steady;
  }
}
