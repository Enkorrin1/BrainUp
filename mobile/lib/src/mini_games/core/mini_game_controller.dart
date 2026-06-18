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
  int _wrongAttempts = 0;

  int get usedHints {
    return _usedHints;
  }

  int get wrongAttempts {
    return _wrongAttempts;
  }

  void recordHint() {
    _usedHints += 1;
  }

  MiniGameResult answer(String choiceId) {
    return answerWithCorrectness(
      choiceId: choiceId,
      isCorrect: choiceId == definition.firstRound.correctChoiceId,
    );
  }

  MiniGameResult answerWithCorrectness({
    required String choiceId,
    required bool isCorrect,
  }) {
    if (!isCorrect) {
      _wrongAttempts += 1;
    }

    return MiniGameResult(
      miniGameId: definition.id,
      puzzleId: definition.puzzleId,
      isCorrect: isCorrect,
      selectedChoiceId: choiceId,
      score: isCorrect ? _scoreForCorrectAnswer : 0,
      stars: isCorrect ? _starsForCorrectAnswer : 0,
      durationSeconds: _durationSeconds,
      wrongAttempts: _wrongAttempts,
      usedHints: _usedHints,
      skillTags: [definition.skillTag],
      mistakeSignals: _wrongAttempts == 0 ? const [] : [definition.puzzleId],
      rewardSignals: isCorrect ? [_rewardSignal] : const [],
      difficultySignal: _difficultySignalFor(
        isCorrect: isCorrect,
        wrongAttempts: _wrongAttempts,
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
    if (_wrongAttempts > 0) {
      return 60;
    }
    return _usedHints == 0 ? 100 : 75;
  }

  int get _starsForCorrectAnswer {
    if (_wrongAttempts > 0) {
      return 1;
    }
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
