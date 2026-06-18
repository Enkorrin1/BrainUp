import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';
import '../../mini_games/core/mini_game_definition.dart';
import '../../mini_games/core/mini_game_registry.dart';
import '../../mini_games/core/mini_game_result.dart';
import '../../mini_games/host/mini_game_host_screen.dart';

class _LessonPalette {
  static const background = Color(0xFF07132F);
  static const panel = Color(0xE51A2858);
  static const text = Colors.white;
  static const muted = Color(0xFFC6D0FF);
  static const aqua = Color(0xFF42F4D2);
  static const coral = Color(0xFFFF6F7D);
  static const star = Color(0xFFFFD15C);
  static const violet = Color(0xFF9C6AF2);
}

IconData _worldIcon(String worldId) {
  return switch (worldId) {
    'space_station' => Icons.rocket_launch_rounded,
    'forest_lab' => Icons.biotech_rounded,
    'robot_town' => Icons.smart_toy_rounded,
    'shape_garden' => Icons.category_rounded,
    'toy_shop' => Icons.toys_rounded,
    'underwater_city' => Icons.water_rounded,
    'dinosaur_island' => Icons.park_rounded,
    'riddle_castle' => Icons.castle_rounded,
    _ => Icons.auto_awesome_rounded,
  };
}

IconData _coachIcon(String characterId) {
  return switch (characterId) {
    'brainy' => Icons.auto_awesome_rounded,
    'lumi' => Icons.lightbulb_rounded,
    'quadra' => Icons.category_rounded,
    'numba' => Icons.calculate_rounded,
    'rulo' => Icons.psychology_rounded,
    'mira' => Icons.travel_explore_rounded,
    _ => Icons.emoji_objects_rounded,
  };
}

CharacterCoachDefinition _coachForChallenge(DailyChallenge challenge) {
  final characterId = challenge.characterId;
  if (characterId != null) {
    return FoundationCatalog.coachForCharacterId(characterId);
  }

  final skillTag = challenge.skillTag;
  if (skillTag != null) {
    return FoundationCatalog.coachForSkill(skillTag);
  }

  return FoundationCatalog.coachForCharacterId('brainy');
}

CharacterCoachMoment _coachMomentFor({
  required DailyChallenge challenge,
  required bool showHint,
  required bool hasSubmitted,
  required bool isCorrect,
}) {
  if (hasSubmitted && isCorrect) {
    return CharacterCoachMoment.correct;
  }
  if (hasSubmitted && !isCorrect) {
    return CharacterCoachMoment.retry;
  }
  if (showHint) {
    return CharacterCoachMoment.hint;
  }
  if (challenge.feedbackStyle == PuzzleFeedbackStyle.bossMilestone ||
      challenge.difficulty == PuzzleDifficulty.boss) {
    return CharacterCoachMoment.boss;
  }
  return CharacterCoachMoment.neutral;
}

class LessonScreen extends StatefulWidget {
  const LessonScreen({
    required this.profile,
    required this.onLessonComplete,
    required this.onBackToMap,
    required this.onNextLessonSelected,
    this.lessonId,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function({
    required String lessonId,
    required DailyChallenge challenge,
    int correctAnswers,
    int totalQuestions,
    int usedHints,
    int wrongAttempts,
    List<String> mistakePuzzleIds,
    List<String> reviewedPuzzleIds,
  }) onLessonComplete;
  final VoidCallback onBackToMap;
  final ValueChanged<String> onNextLessonSelected;
  final String? lessonId;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _stepIndex = 0;
  String? _selectedChoiceId;
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  bool _isComplete = false;
  bool _isSaving = false;
  bool _showHint = false;
  bool _bossIntroDismissed = false;
  final Set<int> _hintedStepIndexes = <int>{};
  final Set<String> _mistakePuzzleIds = <String>{};
  int _wrongAttempts = 0;

  @override
  Widget build(BuildContext context) {
    final child = widget.profile.activeChild;
    final lesson = widget.lessonId == null
        ? FoundationCatalog.lessonForNode(_currentNode(child))
        : FoundationCatalog.lessonForId(widget.lessonId!);
    final storyWorld = FoundationCatalog.storyWorldForLessonId(lesson.id);
    final bossMiniGame = FoundationCatalog.bossMiniGameForLessonId(lesson.id);
    final storyWorldProgressAfterLesson = storyWorld == null
        ? null
        : FoundationCatalog.storyWorldProgressFor(
            {
              ...child.completedLessonIds,
              lesson.id,
            }.toList(growable: false),
          ).firstWhere((progress) => progress.world.id == storyWorld.id);
    final challenges = _lessonChallenges(child, lesson);
    final challenge = challenges[_stepIndex];
    final miniGameDefinition =
        MiniGameRegistry.definitionForChallenge(challenge);
    final bossProgress = bossMiniGame == null
        ? null
        : FoundationCatalog.bossMiniGameProgressFor(
            lessonId: lesson.id,
            completedQuestions:
                _hasSubmitted && _isCorrect ? _stepIndex + 1 : _stepIndex,
            totalQuestions: challenges.length,
            wrongAttempts: _wrongAttempts,
            usedHints: _hintedStepIndexes.length,
          );

    if (_isComplete) {
      return _LessonCompleteView(
        lesson: lesson,
        isReviewLesson: lesson.id == FoundationCatalog.adaptiveReviewLesson.id,
        bossMiniGame: bossMiniGame,
        totalQuestions: challenges.length,
        usedHints: _hintedStepIndexes.length,
        wrongAttempts: _wrongAttempts,
        storyWorldProgress: storyWorldProgressAfterLesson,
        nextLessonId: lesson.id == FoundationCatalog.adaptiveReviewLesson.id
            ? null
            : _nextLessonIdAfter(lesson.id, child),
        onNextLessonSelected: widget.onNextLessonSelected,
        onBackToMap: widget.onBackToMap,
      );
    }

    if (bossMiniGame != null && !_bossIntroDismissed) {
      return _BossIntroView(
        miniGame: bossMiniGame,
        storyWorld: storyWorld,
        totalQuestions: challenges.length,
        onStart: () {
          setState(() {
            _bossIntroDismissed = true;
          });
        },
        onBackToMap: widget.onBackToMap,
      );
    }

    return Scaffold(
      backgroundColor: _LessonPalette.background,
      body: Stack(
        children: [
          const Positioned.fill(child: _LessonBackdrop()),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 136),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _LessonHeader(
                    currentStep: _stepIndex + 1,
                    totalSteps: challenges.length,
                    hearts: child.hearts,
                    storyWorld: storyWorld,
                  ),
                  if (bossProgress != null) ...[
                    const SizedBox(height: 14),
                    _BossStepTracker(progress: bossProgress),
                  ],
                  const SizedBox(height: 16),
                  _LessonQuestionCard(
                    challenge: challenge,
                    selectedChoiceId: _selectedChoiceId,
                    hasSubmitted: _hasSubmitted,
                    isCorrect: _isCorrect,
                    showHint: _showHint,
                    onToggleHint: _toggleHint,
                    onChoiceSelected: _selectChoice,
                  ),
                  if (miniGameDefinition != null) ...[
                    const SizedBox(height: 12),
                    _MiniGameLaunchCard(
                      definition: miniGameDefinition,
                      onPlay: () => _openMiniGame(
                        definition: miniGameDefinition,
                        challenge: challenge,
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: _selectedChoiceId == null || _isSaving
                        ? null
                        : () => _submitAnswer(lesson, challenge, challenges),
                    icon: Icon(
                      _hasSubmitted && _isCorrect
                          ? Icons.arrow_forward_rounded
                          : Icons.check_rounded,
                    ),
                    label: Text(_buttonLabel(context, challenges.length)),
                    style: FilledButton.styleFrom(
                      backgroundColor: _LessonPalette.coral,
                      minimumSize: const Size.fromHeight(58),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  MapNode _currentNode(ChildProfile child) {
    return FoundationCatalog.starterMap.nodes.firstWhere(
      (node) =>
          node.stateForCompletedNodes(child.completedMapNodeIds) ==
          MapNodeState.current,
      orElse: () => FoundationCatalog.starterMap.nodes.last,
    );
  }

  List<DailyChallenge> _lessonChallenges(ChildProfile child, Lesson lesson) {
    final puzzles = FoundationCatalog.puzzlesForLesson(
      lesson: lesson,
      ageBandId: _ageBandIdForChild(child),
      reviewProfile: PracticeReviewProfile.fromSessions(
        child.practiceSessions,
      ),
    );
    return [
      for (final puzzle in puzzles) dailyChallengeForPuzzle(puzzle, child.age),
    ];
  }

  AgeBandId _ageBandIdForChild(ChildProfile child) {
    return switch (child.age) {
      ChildAge.four || ChildAge.five => AgeBandId.age4to5,
      ChildAge.six => AgeBandId.age6,
      ChildAge.seven || ChildAge.eight => AgeBandId.age7to8,
    };
  }

  String? _nextLessonIdAfter(String lessonId, ChildProfile child) {
    final completedLessonIds = {
      ...child.completedLessonIds,
      lessonId,
    };

    for (final course in FoundationCatalog.starterCourses) {
      final lessonIndex = course.lessonIds.indexOf(lessonId);
      if (lessonIndex == -1) {
        continue;
      }

      for (var index = lessonIndex + 1;
          index < course.lessonIds.length;
          index += 1) {
        final candidateId = course.lessonIds[index];
        if (!completedLessonIds.contains(candidateId)) {
          return candidateId;
        }
      }
    }

    for (final course in FoundationCatalog.starterCourses) {
      for (final candidateId in course.lessonIds) {
        if (!completedLessonIds.contains(candidateId)) {
          return candidateId;
        }
      }
    }

    return null;
  }

  String _buttonLabel(BuildContext context, int totalSteps) {
    final l10n = context.l10n;
    if (_isSaving) {
      return l10n.checkingButton;
    }
    if (_hasSubmitted && !_isCorrect) {
      return l10n.lessonTryAgainButton;
    }
    if (!_hasSubmitted) {
      return l10n.checkAnswerButton;
    }
    if (_stepIndex == totalSteps - 1) {
      return l10n.lessonFinishButton;
    }
    return l10n.lessonNextButton;
  }

  void _selectChoice(String choiceId) {
    setState(() {
      _selectedChoiceId = choiceId;
      _hasSubmitted = false;
      _isCorrect = false;
    });
  }

  Future<void> _openMiniGame({
    required MiniGameDefinition definition,
    required DailyChallenge challenge,
  }) async {
    final result = await MiniGameHostScreen.play(
      context,
      definition: definition,
      challenge: challenge,
    );
    if (!mounted || result == null || result.exited) {
      return;
    }

    _applyMiniGameResult(result, challenge);
  }

  void _applyMiniGameResult(
    MiniGameResult result,
    DailyChallenge challenge,
  ) {
    final choiceId = result.selectedChoiceId;
    if (choiceId == null) {
      return;
    }

    final wrongAttemptDelta = result.wrongAttempts <= 0
        ? (result.isCorrect ? 0 : 1)
        : result.wrongAttempts;

    setState(() {
      _selectedChoiceId = choiceId;
      _hasSubmitted = true;
      _isCorrect = result.isCorrect;
      if (result.usedHints > 0 || wrongAttemptDelta > 0 || !result.isCorrect) {
        _showHint = true;
        _hintedStepIndexes.add(_stepIndex);
      }
      if (wrongAttemptDelta > 0) {
        _wrongAttempts += wrongAttemptDelta;
        _mistakePuzzleIds.addAll(result.mistakeSignals);
        _mistakePuzzleIds.add(challenge.id);
      }
    });
  }

  Future<void> _submitAnswer(
    Lesson lesson,
    DailyChallenge challenge,
    List<DailyChallenge> challenges,
  ) async {
    if (_hasSubmitted && !_isCorrect) {
      setState(() {
        _selectedChoiceId = null;
        _hasSubmitted = false;
        _isCorrect = false;
        _showHint = true;
        _hintedStepIndexes.add(_stepIndex);
      });
      return;
    }

    if (_hasSubmitted && _isCorrect) {
      if (_stepIndex == challenges.length - 1) {
        setState(() {
          _isSaving = true;
        });
        await widget.onLessonComplete(
          lessonId: lesson.id,
          challenge: challenge,
          correctAnswers: challenges.length,
          totalQuestions: challenges.length,
          usedHints: _hintedStepIndexes.length,
          wrongAttempts: _wrongAttempts,
          mistakePuzzleIds: _mistakePuzzleIds.toList(growable: false),
          reviewedPuzzleIds:
              lesson.id == FoundationCatalog.adaptiveReviewLesson.id
                  ? [
                      for (final reviewedChallenge in challenges)
                        reviewedChallenge.id,
                    ]
                  : const [],
        );
        if (!mounted) {
          return;
        }
        setState(() {
          _isSaving = false;
          _isComplete = true;
        });
        return;
      }

      setState(() {
        _stepIndex += 1;
        _selectedChoiceId = null;
        _hasSubmitted = false;
        _isCorrect = false;
        _showHint = false;
      });
      return;
    }

    final choiceId = _selectedChoiceId;
    if (choiceId == null) {
      return;
    }

    final isCorrect = challenge.isCorrectChoice(choiceId);
    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
      if (!isCorrect) {
        _wrongAttempts += 1;
        _mistakePuzzleIds.add(challenge.id);
        _showHint = true;
        _hintedStepIndexes.add(_stepIndex);
      }
    });
  }

  void _toggleHint() {
    setState(() {
      final nextShowHint = !_showHint;
      _showHint = nextShowHint;
      if (nextShowHint) {
        _hintedStepIndexes.add(_stepIndex);
      }
    });
  }
}

class _LessonBackdrop extends StatelessWidget {
  const _LessonBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LessonBackdropPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _LessonBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF07132F),
          Color(0xFF102466),
          Color(0xFF221D55),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    final glow = Paint()
      ..color = const Color(0xFF42F4D2).withValues(alpha: 0.10);
    canvas.drawCircle(Offset(size.width * 0.86, size.height * 0.18), 118, glow);

    final star = Paint()..color = Colors.white.withValues(alpha: 0.72);
    for (final point in const [
      Offset(0.14, 0.08),
      Offset(0.74, 0.10),
      Offset(0.92, 0.31),
      Offset(0.12, 0.46),
      Offset(0.82, 0.64),
      Offset(0.28, 0.84),
    ]) {
      canvas.drawCircle(
        Offset(size.width * point.dx, size.height * point.dy),
        2,
        star,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BossIntroView extends StatelessWidget {
  const _BossIntroView({
    required this.miniGame,
    required this.storyWorld,
    required this.totalQuestions,
    required this.onStart,
    required this.onBackToMap,
  });

  final BossMiniGameDefinition miniGame;
  final StoryWorldDefinition? storyWorld;
  final int totalQuestions;
  final VoidCallback onStart;
  final VoidCallback onBackToMap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(miniGame.accentHex);

    return Scaffold(
      backgroundColor: _LessonPalette.background,
      body: Stack(
        children: [
          const Positioned.fill(child: _LessonBackdrop()),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Row(
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'Back to map',
                      onPressed: onBackToMap,
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        storyWorld == null
                            ? 'Boss challenge'
                            : '${storyWorld!.title} boss',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _LessonPalette.muted,
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                DecoratedBox(
                  decoration: _panelDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: accent.withValues(alpha: 0.46),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              _worldIcon(miniGame.worldId),
                              color: accent,
                              size: 46,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          miniGame.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: _LessonPalette.text,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          miniGame.intro,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: _LessonPalette.muted,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 18),
                        _BossProblemCard(
                          accent: accent,
                          problem: miniGame.problem,
                          totalQuestions: totalQuestions,
                        ),
                        const SizedBox(height: 18),
                        for (var index = 0;
                            index < miniGame.steps.length;
                            index += 1) ...[
                          _BossIntroStepRow(
                            step: miniGame.steps[index],
                            index: index,
                            accent: accent,
                          ),
                          if (index != miniGame.steps.length - 1)
                            const SizedBox(height: 10),
                        ],
                        const SizedBox(height: 22),
                        FilledButton.icon(
                          onPressed: onStart,
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('Start boss'),
                          style: FilledButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: _LessonPalette.background,
                            minimumSize: const Size.fromHeight(56),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BossProblemCard extends StatelessWidget {
  const _BossProblemCard({
    required this.accent,
    required this.problem,
    required this.totalQuestions,
  });

  final Color accent;
  final String problem;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.34)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.extension_rounded, color: accent, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  problem,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  '3 boss steps -> $totalQuestions puzzle moments',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _LessonPalette.muted,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BossIntroStepRow extends StatelessWidget {
  const _BossIntroStepRow({
    required this.step,
    required this.index,
    required this.accent,
  });

  final BossMiniGameStepDefinition step;
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: 0.46)),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _LessonPalette.text,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: _LessonPalette.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                step.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _LessonPalette.muted,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BossStepTracker extends StatelessWidget {
  const _BossStepTracker({required this.progress});

  final BossMiniGameProgress progress;

  @override
  Widget build(BuildContext context) {
    final accent = Color(progress.miniGame.accentHex);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.workspace_premium_rounded, color: accent, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Boss step ${progress.currentStepIndex + 1}/${progress.miniGame.steps.length}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Text(
                '${(progress.progress * 100).round()}%',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _LessonPalette.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: progress.progress,
              color: accent,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            progress.currentStep.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: _LessonPalette.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 3),
          Text(
            progress.currentStep.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _LessonPalette.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({
    required this.currentStep,
    required this.totalSteps,
    required this.hearts,
    required this.storyWorld,
  });

  final int currentStep;
  final int totalSteps;
  final int hearts;
  final StoryWorldDefinition? storyWorld;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: _panelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (storyWorld != null) ...[
                    Text(
                      '${storyWorld!.title}: ${storyWorld!.missionTitle}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: _LessonPalette.star,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 5),
                  ],
                  Text(
                    l10n.lessonProgress(currentStep, totalSteps),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _LessonPalette.text,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 12,
                      value: currentStep / totalSteps,
                      color: _LessonPalette.aqua,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            _HeartPill(hearts: hearts),
          ],
        ),
      ),
    );
  }
}

class _HeartPill extends StatelessWidget {
  const _HeartPill({required this.hearts});

  final int hearts;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _LessonPalette.coral.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _LessonPalette.coral.withValues(alpha: 0.42),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const Icon(
              Icons.favorite_rounded,
              color: _LessonPalette.coral,
              size: 22,
            ),
            const SizedBox(width: 5),
            Text(
              '$hearts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: _LessonPalette.text,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoachAvatar extends StatelessWidget {
  const _CoachAvatar({
    required this.coach,
    this.size = 46,
  });

  final CharacterCoachDefinition coach;
  final double size;

  @override
  Widget build(BuildContext context) {
    final accent = Color(coach.accentHex);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent,
            _LessonPalette.aqua,
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.34),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.26),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        _coachIcon(coach.id),
        color: _LessonPalette.background,
        size: size * 0.56,
      ),
    );
  }
}

class _CoachSpeechCard extends StatelessWidget {
  const _CoachSpeechCard({
    required this.coach,
    required this.moment,
  });

  final CharacterCoachDefinition coach;
  final CharacterCoachMoment moment;

  @override
  Widget build(BuildContext context) {
    final accent = Color(coach.accentHex);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.34)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CoachAvatar(coach: coach, size: 42),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${coach.displayName} - ${coach.shortRole}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  coach.lineFor(moment),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonQuestionCard extends StatelessWidget {
  const _LessonQuestionCard({
    required this.challenge,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.showHint,
    required this.onToggleHint,
    required this.onChoiceSelected,
  });

  final DailyChallenge challenge;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final bool showHint;
  final VoidCallback onToggleHint;
  final ValueChanged<String> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final coach = _coachForChallenge(challenge);
    final coachMoment = _coachMomentFor(
      challenge: challenge,
      showHint: showHint,
      hasSubmitted: hasSubmitted,
      isCorrect: isCorrect,
    );

    return DecoratedBox(
      decoration: _panelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _LessonPalette.star,
                        _LessonPalette.aqua,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: _LessonPalette.aqua.withValues(alpha: 0.26),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const _PuzzleSvg(
                    asset: _PuzzleAssets.puzzleCard,
                    size: 42,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.titleForChallenge(challenge),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _LessonPalette.text,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.promptForChallenge(challenge),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _LessonPalette.muted,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _CoachSpeechCard(
              coach: coach,
              moment: coachMoment,
            ),
            const SizedBox(height: 18),
            _PuzzleVisual(challenge: challenge),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _LessonPalette.aqua.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _LessonPalette.aqua.withValues(alpha: 0.24),
                ),
              ),
              child: Text(
                l10n.questionForChallenge(challenge),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: _LessonPalette.text,
                      fontSize: 23,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            if (challenge.interaction != null) ...[
              _LessonInteractionStage(
                challenge: challenge,
                selectedChoiceId: selectedChoiceId,
                hasSubmitted: hasSubmitted,
                isCorrect: isCorrect,
                onChoiceSelected: onChoiceSelected,
              ),
              const SizedBox(height: 18),
            ],
            _HintButton(
              expanded: showHint,
              onPressed: onToggleHint,
            ),
            if (showHint && (!hasSubmitted || !isCorrect)) ...[
              const SizedBox(height: 10),
              _HintPanel(challenge: challenge),
            ],
            const SizedBox(height: 14),
            for (var index = 0; index < challenge.choices.length; index += 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LessonChoiceTile(
                  challenge: challenge,
                  choice: challenge.choices[index],
                  label: l10n.choiceLabelFor(
                    challenge,
                    challenge.choices[index],
                  ),
                  index: index,
                  selected: selectedChoiceId == challenge.choices[index].id,
                  submitted: hasSubmitted,
                  correct:
                      challenge.isCorrectChoice(challenge.choices[index].id),
                  onTap: () => onChoiceSelected(challenge.choices[index].id),
                ),
              ),
            if (hasSubmitted) ...[
              const SizedBox(height: 4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: Tween<double>(begin: 0.96, end: 1).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: _LessonFeedback(
                  key: ValueKey('${challenge.id}-$isCorrect'),
                  isCorrect: isCorrect,
                  challenge: challenge,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LessonInteractionStage extends StatelessWidget {
  const _LessonInteractionStage({
    required this.challenge,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.onChoiceSelected,
  });

  final DailyChallenge challenge;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final ValueChanged<String> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    final interaction = challenge.interaction;
    if (interaction == null) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _stageColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _stageBorderColor),
        boxShadow: [
          BoxShadow(
            color: _stageBorderColor.withValues(alpha: 0.18),
            blurRadius: hasSubmitted ? 18 : 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _InteractionBadge(type: interaction.type),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  interaction.instruction,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          switch (interaction.type) {
            PuzzleInteractionType.matchPairs => _MatchPairsStage(
                challenge: challenge,
                interaction: interaction,
                selectedChoiceId: selectedChoiceId,
                hasSubmitted: hasSubmitted,
                isCorrect: isCorrect,
                onChoiceSelected: onChoiceSelected,
              ),
            PuzzleInteractionType.dragToTarget ||
            PuzzleInteractionType.tracePath ||
            PuzzleInteractionType.sortObjects =>
              _DropTargetStage(
                challenge: challenge,
                interaction: interaction,
                selectedChoiceId: selectedChoiceId,
                hasSubmitted: hasSubmitted,
                isCorrect: isCorrect,
                onChoiceSelected: onChoiceSelected,
              ),
            PuzzleInteractionType.memoryReveal ||
            PuzzleInteractionType.reorderCards =>
              _MemoryRevealStage(
                challenge: challenge,
                interaction: interaction,
                selectedChoiceId: selectedChoiceId,
                hasSubmitted: hasSubmitted,
                isCorrect: isCorrect,
                onChoiceSelected: onChoiceSelected,
              ),
            PuzzleInteractionType.rotateObject => _RotateObjectStage(
                challenge: challenge,
                interaction: interaction,
                selectedChoiceId: selectedChoiceId,
                hasSubmitted: hasSubmitted,
                isCorrect: isCorrect,
                onChoiceSelected: onChoiceSelected,
              ),
            PuzzleInteractionType.multiStepBoss => _BossInteractionStage(
                challenge: challenge,
                interaction: interaction,
                selectedChoiceId: selectedChoiceId,
                hasSubmitted: hasSubmitted,
                isCorrect: isCorrect,
                onChoiceSelected: onChoiceSelected,
              ),
            PuzzleInteractionType.tapChoice => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }

  Color get _stageColor {
    if (hasSubmitted && isCorrect) {
      return _LessonPalette.aqua.withValues(alpha: 0.18);
    }
    if (hasSubmitted && !isCorrect) {
      return _LessonPalette.coral.withValues(alpha: 0.14);
    }
    return Colors.white.withValues(alpha: 0.08);
  }

  Color get _stageBorderColor {
    if (hasSubmitted && isCorrect) {
      return _LessonPalette.aqua.withValues(alpha: 0.72);
    }
    if (hasSubmitted && !isCorrect) {
      return _LessonPalette.coral.withValues(alpha: 0.64);
    }
    return _LessonPalette.aqua.withValues(alpha: 0.24);
  }
}

class _InteractionBadge extends StatelessWidget {
  const _InteractionBadge({required this.type});

  final PuzzleInteractionType type;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _LessonPalette.text,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get icon {
    return switch (type) {
      PuzzleInteractionType.dragToTarget => Icons.open_with_rounded,
      PuzzleInteractionType.reorderCards => Icons.swap_vert_rounded,
      PuzzleInteractionType.matchPairs => Icons.hub_rounded,
      PuzzleInteractionType.memoryReveal => Icons.style_rounded,
      PuzzleInteractionType.tracePath => Icons.route_rounded,
      PuzzleInteractionType.rotateObject => Icons.threesixty_rounded,
      PuzzleInteractionType.sortObjects => Icons.inventory_2_rounded,
      PuzzleInteractionType.multiStepBoss => Icons.auto_awesome_rounded,
      PuzzleInteractionType.tapChoice => Icons.touch_app_rounded,
    };
  }

  String get label {
    return switch (type) {
      PuzzleInteractionType.dragToTarget => 'Drag',
      PuzzleInteractionType.reorderCards => 'Order',
      PuzzleInteractionType.matchPairs => 'Match',
      PuzzleInteractionType.memoryReveal => 'Reveal',
      PuzzleInteractionType.tracePath => 'Trace',
      PuzzleInteractionType.rotateObject => 'Rotate',
      PuzzleInteractionType.sortObjects => 'Sort',
      PuzzleInteractionType.multiStepBoss => 'Boss',
      PuzzleInteractionType.tapChoice => 'Tap',
    };
  }

  Color get color {
    return switch (type) {
      PuzzleInteractionType.matchPairs ||
      PuzzleInteractionType.memoryReveal =>
        _LessonPalette.star,
      PuzzleInteractionType.dragToTarget ||
      PuzzleInteractionType.sortObjects =>
        _LessonPalette.aqua,
      PuzzleInteractionType.rotateObject ||
      PuzzleInteractionType.tracePath =>
        _LessonPalette.violet,
      PuzzleInteractionType.multiStepBoss => _LessonPalette.coral,
      PuzzleInteractionType.reorderCards ||
      PuzzleInteractionType.tapChoice =>
        _LessonPalette.aqua,
    };
  }
}

class _MatchPairsStage extends StatelessWidget {
  const _MatchPairsStage({
    required this.challenge,
    required this.interaction,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.onChoiceSelected,
  });

  final DailyChallenge challenge;
  final ChallengeInteractionSpec interaction;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final ValueChanged<String> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    final clue = interaction.items.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: DragTarget<String>(
                key: const ValueKey('stage-match-target'),
                onAcceptWithDetails: (details) {
                  onChoiceSelected(details.data);
                },
                builder: (context, candidateData, rejectedData) {
                  final active = candidateData.isNotEmpty;
                  return _InteractionCard(
                    icon: active
                        ? Icons.link_rounded
                        : Icons.psychology_alt_rounded,
                    title: selectedChoiceId == null
                        ? clue.label
                        : '${clue.label} -> ${_choiceLabel(selectedChoiceId!)}',
                    subtitle: selectedChoiceId == null
                        ? 'Drop match here'
                        : 'Connected',
                    selected: selectedChoiceId != null || active,
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                Icons.multiple_stop_rounded,
                color: _LessonPalette.star,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  for (final choice in challenge.choices)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _DraggableInteractionOption(
                        key: ValueKey('stage-draggable-${choice.id}'),
                        choiceId: choice.id,
                        label: choice.label,
                        selected: selectedChoiceId == choice.id,
                        icon: Icons.add_link_rounded,
                        onTap: () => onChoiceSelected(choice.id),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        _GestureResultBanner(
          hasSubmitted: hasSubmitted,
          isCorrect: isCorrect,
          idleText: 'Drag the matching answer onto the clue.',
        ),
      ],
    );
  }

  String _choiceLabel(String choiceId) {
    return challenge.choices
        .firstWhere(
          (choice) => choice.id == choiceId,
          orElse: () => ChallengeChoice(id: choiceId, label: choiceId),
        )
        .label;
  }
}

class _DropTargetStage extends StatelessWidget {
  const _DropTargetStage({
    required this.challenge,
    required this.interaction,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.onChoiceSelected,
  });

  final DailyChallenge challenge;
  final ChallengeInteractionSpec interaction;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final ValueChanged<String> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    final selectedChoice = selectedChoiceId == null
        ? null
        : challenge.choices.where((choice) => choice.id == selectedChoiceId);
    final selectedLabel = selectedChoice == null || selectedChoice.isEmpty
        ? 'Drop answer here'
        : selectedChoice.first.label;

    return Column(
      children: [
        DragTarget<String>(
          key: const ValueKey('stage-drag-target'),
          onAcceptWithDetails: (details) {
            onChoiceSelected(details.data);
          },
          builder: (context, candidateData, rejectedData) {
            final active = candidateData.isNotEmpty;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: active
                    ? _LessonPalette.star.withValues(alpha: 0.18)
                    : selectedChoiceId == null
                        ? Colors.white.withValues(alpha: 0.08)
                        : _LessonPalette.aqua.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: active
                      ? _LessonPalette.star
                      : selectedChoiceId == null
                          ? Colors.white.withValues(alpha: 0.20)
                          : _LessonPalette.aqua,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    active
                        ? Icons.download_done_rounded
                        : Icons.center_focus_strong_rounded,
                    color: active ? _LessonPalette.star : _LessonPalette.aqua,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      active ? 'Release to place' : selectedLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _LessonPalette.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        _DraggableChoiceWrap(
          choices: challenge.choices,
          selectedChoiceId: selectedChoiceId,
          icon: Icons.back_hand_rounded,
          onChoiceSelected: onChoiceSelected,
        ),
        _GestureResultBanner(
          hasSubmitted: hasSubmitted,
          isCorrect: isCorrect,
          idleText: 'Drag an answer card into the target.',
        ),
      ],
    );
  }
}

class _MemoryRevealStage extends StatefulWidget {
  const _MemoryRevealStage({
    required this.challenge,
    required this.interaction,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.onChoiceSelected,
  });

  final DailyChallenge challenge;
  final ChallengeInteractionSpec interaction;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final ValueChanged<String> onChoiceSelected;

  @override
  State<_MemoryRevealStage> createState() => _MemoryRevealStageState();
}

class _MemoryRevealStageState extends State<_MemoryRevealStage> {
  final Set<String> _revealedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var index = 0;
                index < widget.interaction.items.length;
                index += 1)
              _FlipMemoryToken(
                key: ValueKey('stage-flip-$index'),
                label: widget.interaction.items[index].label,
                index: index,
                revealed: _revealedIds.contains(
                  widget.interaction.items[index].id,
                ),
                onTap: () {
                  setState(() {
                    _revealedIds.add(widget.interaction.items[index].id);
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        _InteractionChoiceWrap(
          choices: widget.challenge.choices,
          selectedChoiceId: widget.selectedChoiceId,
          icon: Icons.visibility_rounded,
          onChoiceSelected: widget.onChoiceSelected,
        ),
        _GestureResultBanner(
          hasSubmitted: widget.hasSubmitted,
          isCorrect: widget.isCorrect,
          idleText: 'Flip the cards, remember them, then choose.',
        ),
      ],
    );
  }
}

class _RotateObjectStage extends StatefulWidget {
  const _RotateObjectStage({
    required this.challenge,
    required this.interaction,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.onChoiceSelected,
  });

  final DailyChallenge challenge;
  final ChallengeInteractionSpec interaction;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final ValueChanged<String> onChoiceSelected;

  @override
  State<_RotateObjectStage> createState() => _RotateObjectStageState();
}

class _RotateObjectStageState extends State<_RotateObjectStage> {
  double _turns = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          key: const ValueKey('stage-rotate-handle'),
          onHorizontalDragUpdate: (details) {
            setState(() {
              _turns = (_turns + details.delta.dx / 220).clamp(-0.55, 0.55);
            });
          },
          onHorizontalDragEnd: (_) {
            if (_turns.abs() >= 0.18) {
              widget.onChoiceSelected(widget.challenge.correctChoiceId);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: widget.selectedChoiceId == widget.challenge.correctChoiceId
                  ? _LessonPalette.violet.withValues(alpha: 0.24)
                  : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: _LessonPalette.violet.withValues(alpha: 0.46),
              ),
            ),
            child: Column(
              children: [
                Transform.rotate(
                  angle: _turns * 6.28,
                  child: const Icon(
                    Icons.change_history_rounded,
                    color: _LessonPalette.star,
                    size: 58,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Drag sideways to rotate',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _InteractionChoiceWrap(
          choices: widget.challenge.choices,
          selectedChoiceId: widget.selectedChoiceId,
          icon: Icons.threesixty_rounded,
          onChoiceSelected: widget.onChoiceSelected,
        ),
        _GestureResultBanner(
          hasSubmitted: widget.hasSubmitted,
          isCorrect: widget.isCorrect,
          idleText: 'Rotate the shape before you answer.',
        ),
      ],
    );
  }
}

class _BossInteractionStage extends StatelessWidget {
  const _BossInteractionStage({
    required this.challenge,
    required this.interaction,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.onChoiceSelected,
  });

  final DailyChallenge challenge;
  final ChallengeInteractionSpec interaction;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final ValueChanged<String> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            Expanded(
              child: _InteractionCard(
                icon: Icons.filter_1_rounded,
                title: 'Rule',
                subtitle: 'Find it',
                selected: true,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _InteractionCard(
                icon: Icons.filter_2_rounded,
                title: 'Skill',
                subtitle: 'Apply it',
                selected: true,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _InteractionCard(
                icon: Icons.filter_3_rounded,
                title: 'Final',
                subtitle: 'Combine',
                selected: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _InteractionChoiceWrap(
          choices: challenge.choices,
          selectedChoiceId: selectedChoiceId,
          icon: Icons.auto_awesome_rounded,
          onChoiceSelected: onChoiceSelected,
        ),
        _GestureResultBanner(
          hasSubmitted: hasSubmitted,
          isCorrect: isCorrect,
          idleText: 'Solve each clue before the boss answer.',
        ),
      ],
    );
  }
}

class _InteractionChoiceWrap extends StatelessWidget {
  const _InteractionChoiceWrap({
    required this.choices,
    required this.selectedChoiceId,
    required this.icon,
    required this.onChoiceSelected,
  });

  final List<ChallengeChoice> choices;
  final String? selectedChoiceId;
  final IconData icon;
  final ValueChanged<String> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final choice in choices)
          _InteractionOptionChip(
            label: choice.label,
            selected: selectedChoiceId == choice.id,
            icon: icon,
            onTap: () => onChoiceSelected(choice.id),
          ),
      ],
    );
  }
}

class _DraggableChoiceWrap extends StatelessWidget {
  const _DraggableChoiceWrap({
    required this.choices,
    required this.selectedChoiceId,
    required this.icon,
    required this.onChoiceSelected,
  });

  final List<ChallengeChoice> choices;
  final String? selectedChoiceId;
  final IconData icon;
  final ValueChanged<String> onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final choice in choices)
          _DraggableInteractionOption(
            key: ValueKey('stage-draggable-${choice.id}'),
            choiceId: choice.id,
            label: choice.label,
            selected: selectedChoiceId == choice.id,
            icon: icon,
            onTap: () => onChoiceSelected(choice.id),
          ),
      ],
    );
  }
}

class _DraggableInteractionOption extends StatelessWidget {
  const _DraggableInteractionOption({
    required this.choiceId,
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String choiceId;
  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chip = _InteractionOptionChip(
      label: label,
      selected: selected,
      icon: icon,
      onTap: onTap,
    );

    return Draggable<String>(
      data: choiceId,
      feedback: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 190),
          child: _InteractionOptionChip(
            label: label,
            selected: true,
            icon: Icons.open_with_rounded,
            onTap: () {},
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.35, child: chip),
      child: chip,
    );
  }
}

class _InteractionOptionChip extends StatelessWidget {
  const _InteractionOptionChip({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: const BoxConstraints(minHeight: 44, minWidth: 92),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? _LessonPalette.aqua.withValues(alpha: 0.24)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? _LessonPalette.aqua
                : Colors.white.withValues(alpha: 0.18),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected ? _LessonPalette.aqua : _LessonPalette.muted,
              size: 18,
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _LessonPalette.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GestureResultBanner extends StatelessWidget {
  const _GestureResultBanner({
    required this.hasSubmitted,
    required this.isCorrect,
    required this.idleText,
  });

  final bool hasSubmitted;
  final bool isCorrect;
  final String idleText;

  @override
  Widget build(BuildContext context) {
    final color = hasSubmitted
        ? isCorrect
            ? _LessonPalette.aqua
            : _LessonPalette.coral
        : _LessonPalette.muted;
    final icon = hasSubmitted
        ? isCorrect
            ? Icons.check_circle_rounded
            : Icons.refresh_rounded
        : Icons.touch_app_rounded;
    final text = hasSubmitted
        ? isCorrect
            ? 'Gesture solved.'
            : 'Try the gesture again with the hint.'
        : idleText;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractionCard extends StatelessWidget {
  const _InteractionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected
            ? _LessonPalette.star.withValues(alpha: 0.18)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? _LessonPalette.star.withValues(alpha: 0.70)
              : Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: _LessonPalette.star, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: _LessonPalette.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: _LessonPalette.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _FlipMemoryToken extends StatelessWidget {
  const _FlipMemoryToken({
    required this.label,
    required this.index,
    required this.revealed,
    required this.onTap,
    super.key,
  });

  final String label;
  final int index;
  final bool revealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final frontColor = index.isEven
        ? _LessonPalette.violet.withValues(alpha: 0.22)
        : _LessonPalette.star.withValues(alpha: 0.20);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Container(
          key: ValueKey(revealed),
          width: 88,
          height: 82,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: revealed ? frontColor : Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: revealed
                  ? Colors.white.withValues(alpha: 0.18)
                  : _LessonPalette.aqua.withValues(alpha: 0.34),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _LessonPalette.muted,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 1),
              Icon(
                revealed ? Icons.visibility_rounded : Icons.style_rounded,
                color: revealed ? _LessonPalette.star : _LessonPalette.aqua,
                size: revealed ? 14 : 18,
              ),
              const SizedBox(height: 1),
              Text(
                revealed ? label : 'Flip',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _LessonPalette.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonChoiceTile extends StatelessWidget {
  const _LessonChoiceTile({
    required this.challenge,
    required this.choice,
    required this.label,
    required this.index,
    required this.selected,
    required this.submitted,
    required this.correct,
    required this.onTap,
  });

  final DailyChallenge challenge;
  final ChallengeChoice choice;
  final String label;
  final int index;
  final bool selected;
  final bool submitted;
  final bool correct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(
            color: _borderColor,
            width: selected || (submitted && correct) ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            _ChoiceVisual(
              challenge: challenge,
              choice: choice,
              index: index,
              selected: selected,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _LessonPalette.text,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            if (submitted && (selected || correct)) ...[
              const SizedBox(width: 8),
              Icon(
                correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: correct ? _LessonPalette.aqua : _LessonPalette.coral,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _backgroundColor {
    if (submitted && correct) {
      return _LessonPalette.aqua.withValues(alpha: 0.20);
    }
    if (submitted && selected && !correct) {
      return _LessonPalette.coral.withValues(alpha: 0.18);
    }
    if (selected) {
      return _LessonPalette.aqua.withValues(alpha: 0.15);
    }
    return Colors.white.withValues(alpha: 0.08);
  }

  Color get _borderColor {
    if (submitted && correct) {
      return _LessonPalette.aqua;
    }
    if (submitted && selected && !correct) {
      return _LessonPalette.coral;
    }
    if (selected) {
      return _LessonPalette.aqua;
    }
    return Colors.white.withValues(alpha: 0.14);
  }
}

class _HintButton extends StatelessWidget {
  const _HintButton({
    required this.expanded,
    required this.onPressed,
  });

  final bool expanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: _LessonPalette.aqua,
          side: BorderSide(
            color: _LessonPalette.aqua.withValues(alpha: 0.42),
          ),
          backgroundColor: _LessonPalette.aqua.withValues(alpha: 0.08),
        ),
        icon: Icon(
          expanded
              ? Icons.visibility_off_rounded
              : Icons.tips_and_updates_rounded,
        ),
        label: Text(expanded ? l10n.hideHintButton : l10n.showHintButton),
      ),
    );
  }
}

class _HintPanel extends StatelessWidget {
  const _HintPanel({required this.challenge});

  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final coach = _coachForChallenge(challenge);
    final accent = Color(coach.accentHex);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.38)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CoachAvatar(coach: coach, size: 38),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lessonHintTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${coach.displayName} - ${coach.shortRole}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _LessonPalette.muted,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  coach.lineFor(CharacterCoachMoment.hint),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.hintForChallenge(challenge),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceVisual extends StatelessWidget {
  const _ChoiceVisual({
    required this.challenge,
    required this.choice,
    required this.index,
    required this.selected,
  });

  final DailyChallenge challenge;
  final ChallengeChoice choice;
  final int index;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final color =
        selected ? const Color(0xFF18B7AE) : _colorForChoice(choice.id);
    final asset = _assetForChoice(challenge.id, choice.id);
    final child = asset == null
        ? Text(
            choice.id.contains('+') ? '+' : choice.id,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
          )
        : _PuzzleSvg(asset: asset, size: 40);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF18B7AE).withValues(alpha: 0.16)
            : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(17),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Color _colorForChoice(String choiceId) {
    return switch (choiceId) {
      'circle' || 'red' || 'red-circles' => const Color(0xFFFF6F6B),
      'triangle' || 'blue' || 'blue-squares' => const Color(0xFF5C8EF7),
      'star' || 'green' || 'green-stars' => const Color(0xFF35B37E),
      'apple' => const Color(0xFFFF6F6B),
      'ball' => const Color(0xFFFF9F43),
      'banana' => const Color(0xFFFFC739),
      'pear' => const Color(0xFF35B37E),
      'rocket' || 'same' => const Color(0xFF18B7AE),
      'planet' || 'square' => const Color(0xFF5C8EF7),
      'lock' || '4+2+1' => const Color(0xFF18B7AE),
      'shoe' || '4+1' => const Color(0xFF9C6AF2),
      'cloud' || '2+1' => const Color(0xFF5C8EF7),
      _ => const Color(0xFFFF9D2E),
    };
  }
}

String? _assetForChoice(String challengeId, String choiceId) {
  return switch ('$challengeId:$choiceId') {
    'shape-path:triangle' => _PuzzleAssets.triangle,
    'shape-path:circle' => _PuzzleAssets.circle,
    'shape-path:star' => _PuzzleAssets.star,
    'fruit-pattern:apple' => _PuzzleAssets.apple,
    'fruit-pattern:banana' => _PuzzleAssets.banana,
    'fruit-pattern:pear' => _PuzzleAssets.pear,
    'odd-card:apple' => _PuzzleAssets.apple,
    'odd-card:ball' => _PuzzleAssets.ball,
    'odd-card:banana' => _PuzzleAssets.banana,
    'logic-train:blue' => _PuzzleAssets.trainBlue,
    'logic-train:red' => _PuzzleAssets.trainRed,
    'logic-train:green' => _PuzzleAssets.trainGreen,
    'memory-pairs:lock' => _PuzzleAssets.lock,
    'memory-pairs:shoe' => _PuzzleAssets.shoe,
    'memory-pairs:cloud' => _PuzzleAssets.cloud,
    'lock-key:lock' => _PuzzleAssets.lock,
    'lock-key:shoe' => _PuzzleAssets.shoe,
    'lock-key:cloud' => _PuzzleAssets.cloud,
    'shadow-match:rocket' => _PuzzleAssets.rocket,
    'shadow-match:planet' => _PuzzleAssets.planet,
    'shadow-match:star' => _PuzzleAssets.star,
    'balance-scale:apple' => _PuzzleAssets.apple,
    'balance-scale:star' => _PuzzleAssets.star,
    'balance-scale:ball' => _PuzzleAssets.ball,
    'shape-rotation:same' => _PuzzleAssets.triangle,
    'shape-rotation:circle' => _PuzzleAssets.circle,
    'shape-rotation:square' => _PuzzleAssets.square,
    'detail-count:blue-squares' => _PuzzleAssets.square,
    'detail-count:red-circles' => _PuzzleAssets.circle,
    'detail-count:green-stars' => _PuzzleAssets.star,
    'space-sequence:rocket' => _PuzzleAssets.rocket,
    'space-sequence:planet' => _PuzzleAssets.planet,
    'space-sequence:star' => _PuzzleAssets.star,
    'shape-stack:square' => _PuzzleAssets.square,
    'shape-stack:circle' => _PuzzleAssets.circle,
    'shape-stack:triangle' => _PuzzleAssets.triangle,
    _ => null,
  };
}

class _PuzzleAssets {
  static const circle = 'assets/images/puzzles/shape_circle.svg';
  static const square = 'assets/images/puzzles/shape_square.svg';
  static const triangle = 'assets/images/puzzles/shape_triangle.svg';
  static const star = 'assets/images/puzzles/shape_star.svg';
  static const cubeOrange = 'assets/images/puzzles/toy_cube_orange.svg';
  static const cubeBlue = 'assets/images/puzzles/toy_cube_blue.svg';
  static const ball = 'assets/images/puzzles/ball.svg';
  static const apple = 'assets/images/puzzles/apple.svg';
  static const banana = 'assets/images/puzzles/banana.svg';
  static const pear = 'assets/images/puzzles/pear.svg';
  static const rocket = 'assets/images/puzzles/rocket.svg';
  static const planet = 'assets/images/puzzles/planet.svg';
  static const lock = 'assets/images/puzzles/lock.svg';
  static const key = 'assets/images/puzzles/key.svg';
  static const shoe = 'assets/images/puzzles/shoe.svg';
  static const cloud = 'assets/images/puzzles/cloud.svg';
  static const trainBlue = 'assets/images/puzzles/train_blue.svg';
  static const trainRed = 'assets/images/puzzles/train_red.svg';
  static const trainGreen = 'assets/images/puzzles/train_green.svg';
  static const shadowRocket = 'assets/images/puzzles/shadow_rocket.svg';
  static const scale = 'assets/images/puzzles/scale.svg';
  static const puzzleCard = 'assets/images/puzzles/puzzle_card.svg';
}

class _PuzzleSvg extends StatelessWidget {
  const _PuzzleSvg({
    required this.asset,
    this.size = 48,
  });

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}

class _PuzzleVisual extends StatelessWidget {
  const _PuzzleVisual({required this.challenge});

  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final generatedVisual = _generatedVisualFor(challenge.id);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
      ),
      child: generatedVisual ??
          switch (challenge.id) {
            'shape-path' => const _ShapePatternVisual(),
            'fruit-pattern' => const _FruitPatternVisual(),
            'toy-count' => const _ToyCountVisual(),
            'odd-card' => const _OddCardVisual(),
            'logic-train' => const _LogicTrainVisual(),
            'sticker-sum' => const _StickerSumVisual(),
            'memory-pairs' => const _MemoryPairsVisual(),
            'lock-key' => const _LockKeyVisual(),
            'shadow-match' => const _ShadowMatchVisual(),
            'balance-scale' => const _BalanceScaleVisual(),
            'shape-rotation' => const _ShapeRotationVisual(),
            'code-grid' => const _CodeGridVisual(),
            'number-bridge' => const _NumberBridgeVisual(),
            'detail-count' => const _DetailCountVisual(),
            'space-sequence' => const _SpaceSequenceVisual(),
            'shape-stack' => const _ShapeStackVisual(),
            _ => const _DefaultPuzzleVisual(),
          },
    );
  }

  Widget? _generatedVisualFor(String id) {
    if (id.startsWith('pattern.trail.')) {
      return const _GeneratedPatternTrailVisual();
    }
    if (id.startsWith('memory.pairs.')) {
      return const _GeneratedMemoryGridVisual();
    }
    if (id.startsWith('math.bridge.')) {
      return const _GeneratedMathBridgeVisual();
    }
    if (id.startsWith('focus.details.')) {
      return const _GeneratedFocusDetailsVisual();
    }
    if (id.startsWith('logic.code.')) {
      return const _GeneratedLogicCodeVisual();
    }
    if (id.startsWith('space.turn.')) {
      return const _GeneratedSpaceTurnVisual();
    }
    if (id.startsWith('sort.odd.')) {
      return const _GeneratedSortOddVisual();
    }
    if (id.startsWith('category.groups.')) {
      return const _GeneratedSortOddVisual();
    }
    if (id.startsWith('route.path.')) {
      return const _GeneratedSpaceTurnVisual();
    }
    if (id.startsWith('analogy.link.')) {
      return const _GeneratedLogicCodeVisual();
    }
    if (id.startsWith('rebus.picture.')) {
      return const _GeneratedBossVisual();
    }
    if (id.startsWith('compare.weight.')) {
      return const _GeneratedMathBridgeVisual();
    }
    if (id.startsWith('memory.order.')) {
      return const _GeneratedMemoryGridVisual();
    }
    if (id.startsWith('mixed.boss.')) {
      return const _GeneratedBossVisual();
    }
    return null;
  }
}

class _ShapePatternVisual extends StatelessWidget {
  const _ShapePatternVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ShapeToken.circle(color: Color(0xFF18B7AE)),
        _ShapeToken.square(color: Color(0xFF5C8EF7)),
        _ShapeToken.circle(color: Color(0xFF18B7AE)),
        _ShapeToken.square(color: Color(0xFF5C8EF7)),
        _QuestionToken(),
      ],
    );
  }
}

class _FruitPatternVisual extends StatelessWidget {
  const _FruitPatternVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(asset: _PuzzleAssets.apple, color: Color(0xFFFF6F6B)),
        _ObjectCard(asset: _PuzzleAssets.banana, color: Color(0xFFFFC739)),
        _ObjectCard(asset: _PuzzleAssets.apple, color: Color(0xFFFF6F6B)),
        _ObjectCard(asset: _PuzzleAssets.banana, color: Color(0xFFFFC739)),
        _QuestionToken(),
      ],
    );
  }
}

class _ToyCountVisual extends StatelessWidget {
  const _ToyCountVisual();

  @override
  Widget build(BuildContext context) {
    return const _ShelfScene(
      children: [
        _CubeToy(
          color: Color(0xFFFFB84D),
          asset: _PuzzleAssets.cubeOrange,
        ),
        _CubeToy(
          color: Color(0xFF5C8EF7),
          asset: _PuzzleAssets.cubeBlue,
        ),
        _BallToy(color: Color(0xFFFF6F6B)),
      ],
    );
  }
}

class _OddCardVisual extends StatelessWidget {
  const _OddCardVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(asset: _PuzzleAssets.apple, color: Color(0xFFFF6F6B)),
        _ObjectCard(asset: _PuzzleAssets.pear, color: Color(0xFF35B37E)),
        _ObjectCard(asset: _PuzzleAssets.ball, color: Color(0xFFFF9F43)),
        _ObjectCard(asset: _PuzzleAssets.banana, color: Color(0xFFFFC739)),
      ],
    );
  }
}

class _LogicTrainVisual extends StatelessWidget {
  const _LogicTrainVisual();

  @override
  Widget build(BuildContext context) {
    return const _TrainRow(
      colors: [
        Color(0xFFFF6F6B),
        Color(0xFF5C8EF7),
        Color(0xFF5C8EF7),
        Color(0xFFFF6F6B),
        Color(0xFF5C8EF7),
        Color(0xFF5C8EF7),
      ],
    );
  }
}

class _StickerSumVisual extends StatelessWidget {
  const _StickerSumVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _StickerGroup(count: 3, color: Color(0xFFFFC739)),
        _MathSign('+'),
        _StickerGroup(count: 2, color: Color(0xFF9C6AF2)),
        _MathSign('='),
        _QuestionToken(),
      ],
    );
  }
}

class _MemoryPairsVisual extends StatelessWidget {
  const _MemoryPairsVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(asset: _PuzzleAssets.key, color: Color(0xFFFFB84D)),
        _MathSign('+'),
        _QuestionToken(),
      ],
    );
  }
}

class _LockKeyVisual extends StatelessWidget {
  const _LockKeyVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(asset: _PuzzleAssets.key, color: Color(0xFFFFB84D)),
        _MathSign('+'),
        _ObjectCard(asset: _PuzzleAssets.lock, color: Color(0xFF18B7AE)),
      ],
    );
  }
}

class _ShadowMatchVisual extends StatelessWidget {
  const _ShadowMatchVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ShadowToken(),
        _MathSign('->'),
        _ObjectCard(asset: _PuzzleAssets.rocket, color: Color(0xFF18B7AE)),
      ],
    );
  }
}

class _BalanceScaleVisual extends StatelessWidget {
  const _BalanceScaleVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _VisualRow(
          children: [
            _ObjectCard(asset: _PuzzleAssets.apple, color: Color(0xFFFF6F6B)),
            _ObjectCard(asset: _PuzzleAssets.apple, color: Color(0xFFFF6F6B)),
            _MathSign('='),
            _ObjectCard(asset: _PuzzleAssets.apple, color: Color(0xFFFF6F6B)),
            _QuestionToken(),
          ],
        ),
        SizedBox(height: 8),
        _PuzzleSvg(asset: _PuzzleAssets.scale, size: 84),
      ],
    );
  }
}

class _ShapeRotationVisual extends StatelessWidget {
  const _ShapeRotationVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ShapeToken.triangle(color: Color(0xFF9C6AF2)),
        _MathSign('->'),
        _RotatedTriangleToken(),
      ],
    );
  }
}

class _CodeGridVisual extends StatelessWidget {
  const _CodeGridVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _NumberGridRow(values: ['2', '4', '6'], color: Color(0xFF5C8EF7)),
        SizedBox(height: 8),
        _NumberGridRow(values: ['3', '5', '?'], color: Color(0xFF18B7AE)),
      ],
    );
  }
}

class _NumberBridgeVisual extends StatelessWidget {
  const _NumberBridgeVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _NumberBubble('4', color: Color(0xFF5C8EF7)),
        _NumberBubble('2', color: Color(0xFF18B7AE)),
        _NumberBubble('1', color: Color(0xFFFFB84D)),
        _MathSign('->'),
        _NumberBubble('7', color: Color(0xFFFF6F6B)),
      ],
    );
  }
}

class _DetailCountVisual extends StatelessWidget {
  const _DetailCountVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _VisualRow(
          children: [
            _ShapeToken.circle(color: Color(0xFFFF6F6B)),
            _ShapeToken.circle(color: Color(0xFFFF6F6B)),
            _ShapeToken.circle(color: Color(0xFFFF6F6B)),
          ],
        ),
        SizedBox(height: 8),
        _VisualRow(
          children: [
            _ShapeToken.square(color: Color(0xFF5C8EF7)),
            _ShapeToken.square(color: Color(0xFF5C8EF7)),
            _ShapeToken.star(color: Color(0xFF35B37E)),
          ],
        ),
      ],
    );
  }
}

class _SpaceSequenceVisual extends StatelessWidget {
  const _SpaceSequenceVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(asset: _PuzzleAssets.rocket, color: Color(0xFF18B7AE)),
        _ObjectCard(asset: _PuzzleAssets.planet, color: Color(0xFF8B63E8)),
        _ObjectCard(asset: _PuzzleAssets.rocket, color: Color(0xFF18B7AE)),
        _ObjectCard(asset: _PuzzleAssets.planet, color: Color(0xFF8B63E8)),
        _QuestionToken(),
      ],
    );
  }
}

class _ShapeStackVisual extends StatelessWidget {
  const _ShapeStackVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ShapeToken.square(color: Color(0xFF5C8EF7)),
        _ShapeToken.circle(color: Color(0xFF18B7AE)),
        _ShapeToken.square(color: Color(0xFF5C8EF7)),
        _ShapeToken.circle(color: Color(0xFF18B7AE)),
        _QuestionToken(),
      ],
    );
  }
}

class _GeneratedPatternTrailVisual extends StatelessWidget {
  const _GeneratedPatternTrailVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(asset: _PuzzleAssets.planet, color: Color(0xFF8B63E8)),
        _ObjectCard(asset: _PuzzleAssets.star, color: Color(0xFFFFC739)),
        _ObjectCard(asset: _PuzzleAssets.planet, color: Color(0xFF8B63E8)),
        _ObjectCard(asset: _PuzzleAssets.star, color: Color(0xFFFFC739)),
        _QuestionToken(),
      ],
    );
  }
}

class _GeneratedMemoryGridVisual extends StatelessWidget {
  const _GeneratedMemoryGridVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(asset: _PuzzleAssets.key, color: Color(0xFFFFB84D)),
        _MathSign('+'),
        _QuestionToken(),
        _ObjectCard(asset: _PuzzleAssets.lock, color: Color(0xFF18B7AE)),
      ],
    );
  }
}

class _GeneratedMathBridgeVisual extends StatelessWidget {
  const _GeneratedMathBridgeVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _NumberBubble('5', color: Color(0xFF5C8EF7)),
        _MathSign('+'),
        _NumberBubble('3', color: Color(0xFF18B7AE)),
        _MathSign('='),
        _QuestionToken(),
      ],
    );
  }
}

class _GeneratedFocusDetailsVisual extends StatelessWidget {
  const _GeneratedFocusDetailsVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _VisualRow(
          children: [
            _ShapeToken.circle(color: Color(0xFFFF6F6B)),
            _ShapeToken.circle(color: Color(0xFFFF6F6B)),
            _ShapeToken.circle(color: Color(0xFFFF6F6B)),
          ],
        ),
        SizedBox(height: 8),
        _VisualRow(
          children: [
            _ShapeToken.square(color: Color(0xFF5C8EF7)),
            _ShapeToken.square(color: Color(0xFF5C8EF7)),
            _ShapeToken.star(color: Color(0xFF35B37E)),
          ],
        ),
      ],
    );
  }
}

class _GeneratedLogicCodeVisual extends StatelessWidget {
  const _GeneratedLogicCodeVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _NumberGridRow(values: ['2', '3', '5'], color: Color(0xFF5C8EF7)),
        SizedBox(height: 8),
        _NumberGridRow(values: ['4', '6', '?'], color: Color(0xFF18B7AE)),
      ],
    );
  }
}

class _GeneratedSpaceTurnVisual extends StatelessWidget {
  const _GeneratedSpaceTurnVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ShapeToken.triangle(color: Color(0xFF9C6AF2)),
        _MathSign('turn'),
        _RotatedTriangleToken(),
      ],
    );
  }
}

class _GeneratedSortOddVisual extends StatelessWidget {
  const _GeneratedSortOddVisual();

  @override
  Widget build(BuildContext context) {
    return const _VisualRow(
      children: [
        _ObjectCard(asset: _PuzzleAssets.apple, color: Color(0xFFFF6F6B)),
        _ObjectCard(asset: _PuzzleAssets.pear, color: Color(0xFF35B37E)),
        _ObjectCard(asset: _PuzzleAssets.banana, color: Color(0xFFFFC739)),
        _ObjectCard(asset: _PuzzleAssets.rocket, color: Color(0xFF18B7AE)),
      ],
    );
  }
}

class _GeneratedBossVisual extends StatelessWidget {
  const _GeneratedBossVisual();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _VisualRow(
          children: [
            _NumberBubble('2', color: Color(0xFF5C8EF7)),
            _NumberBubble('4', color: Color(0xFF18B7AE)),
            _NumberBubble('6', color: Color(0xFFFFB84D)),
            _QuestionToken(),
          ],
        ),
        SizedBox(height: 8),
        _VisualRow(
          children: [
            _PuzzleSvg(asset: _PuzzleAssets.puzzleCard, size: 42),
            _MathSign('+'),
            _ObjectCard(asset: _PuzzleAssets.star, color: Color(0xFFFFC739)),
          ],
        ),
      ],
    );
  }
}

class _DefaultPuzzleVisual extends StatelessWidget {
  const _DefaultPuzzleVisual();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 82,
      child: Center(
        child: _PuzzleSvg(asset: _PuzzleAssets.puzzleCard, size: 64),
      ),
    );
  }
}

class _VisualRow extends StatelessWidget {
  const _VisualRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: children,
    );
  }
}

class _ShapeToken extends StatelessWidget {
  const _ShapeToken.circle({required this.color}) : shape = _TokenShape.circle;
  const _ShapeToken.square({required this.color}) : shape = _TokenShape.square;
  const _ShapeToken.star({required this.color}) : shape = _TokenShape.star;
  const _ShapeToken.triangle({required this.color})
      : shape = _TokenShape.triangle;

  final Color color;
  final _TokenShape shape;

  @override
  Widget build(BuildContext context) {
    final asset = switch (shape) {
      _TokenShape.circle => _PuzzleAssets.circle,
      _TokenShape.square => _PuzzleAssets.square,
      _TokenShape.star => _PuzzleAssets.star,
      _TokenShape.triangle => _PuzzleAssets.triangle,
    };

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.20),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: _PuzzleSvg(asset: asset, size: 40),
    );
  }
}

enum _TokenShape { circle, square, star, triangle }

class _ShadowToken extends StatelessWidget {
  const _ShadowToken();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        color: const Color(0xFF164C55).withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const _PuzzleSvg(asset: _PuzzleAssets.shadowRocket, size: 54),
    );
  }
}

class _RotatedTriangleToken extends StatelessWidget {
  const _RotatedTriangleToken();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 1.5708,
      child: const _ShapeToken.triangle(color: Color(0xFF9C6AF2)),
    );
  }
}

class _QuestionToken extends StatelessWidget {
  const _QuestionToken();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFFFECA8),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        '?',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFFF9D2E),
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}

class _ShelfScene extends StatelessWidget {
  const _ShelfScene({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _VisualRow(children: children),
        const SizedBox(height: 10),
        Container(
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFBFEAE4),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ],
    );
  }
}

class _CubeToy extends StatelessWidget {
  const _CubeToy({
    required this.color,
    required this.asset,
  });

  final Color color;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.08,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.24),
              blurRadius: 10,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: _PuzzleSvg(asset: asset, size: 44),
      ),
    );
  }
}

class _BallToy extends StatelessWidget {
  const _BallToy({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.24),
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: const _PuzzleSvg(asset: _PuzzleAssets.ball, size: 46),
    );
  }
}

class _ObjectCard extends StatelessWidget {
  const _ObjectCard({
    required this.asset,
    required this.color,
  });

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: _PuzzleSvg(asset: asset, size: 48),
    );
  }
}

class _TrainRow extends StatelessWidget {
  const _TrainRow({required this.colors});

  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final color in colors) ...[
            _TrainCar(color: color),
            const SizedBox(width: 6),
          ],
          const _QuestionToken(),
        ],
      ),
    );
  }
}

class _TrainCar extends StatelessWidget {
  const _TrainCar({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 38,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 4),
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _TrainWheel(),
            SizedBox(width: 18),
            _TrainWheel(),
          ],
        ),
      ],
    );
  }
}

class _TrainWheel extends StatelessWidget {
  const _TrainWheel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: const BoxDecoration(
        color: Color(0xFF164C55),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StickerGroup extends StatelessWidget {
  const _StickerGroup({
    required this.count,
    required this.color,
  });

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 58,
      child: Stack(
        children: [
          for (var index = 0; index < count; index += 1)
            Positioned(
              left: (index % 3) * 22,
              top: (index ~/ 3) * 20,
              child: const _PuzzleSvg(asset: _PuzzleAssets.star, size: 32),
            ),
        ],
      ),
    );
  }
}

class _MathSign extends StatelessWidget {
  const _MathSign(this.sign);

  final String sign;

  @override
  Widget build(BuildContext context) {
    return Text(
      sign,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF164C55),
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class _NumberGridRow extends StatelessWidget {
  const _NumberGridRow({
    required this.values,
    required this.color,
  });

  final List<String> values;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return _VisualRow(
      children: [
        for (final value in values) _NumberBubble(value, color: color),
      ],
    );
  }
}

class _NumberBubble extends StatelessWidget {
  const _NumberBubble(
    this.value, {
    required this.color,
  });

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        value,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}

class _LessonFeedback extends StatelessWidget {
  const _LessonFeedback({
    required this.isCorrect,
    required this.challenge,
    super.key,
  });

  final bool isCorrect;
  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final coach = _coachForChallenge(challenge);
    final accent = isCorrect ? Color(coach.accentHex) : _LessonPalette.coral;
    final coachMoment =
        isCorrect ? CharacterCoachMoment.correct : CharacterCoachMoment.retry;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: accent.withValues(alpha: 0.34),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CoachAvatar(coach: coach, size: 42),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${coach.displayName} - ${coach.shortRole}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Color(coach.accentHex),
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  coach.lineFor(coachMoment),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  isCorrect
                      ? l10n.answerCorrect(
                          l10n.explanationForChallenge(challenge),
                        )
                      : l10n.lessonRetryFeedback,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                if (!isCorrect) ...[
                  const SizedBox(height: 5),
                  Text(
                    l10n.hintForChallenge(challenge),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _LessonPalette.muted,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniGameLaunchCard extends StatelessWidget {
  const _MiniGameLaunchCard({
    required this.definition,
    required this.onPlay,
  });

  final MiniGameDefinition definition;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final accent = switch (definition.type) {
      MiniGameType.memoryGrid => _LessonPalette.aqua,
      MiniGameType.logicPath => _LessonPalette.star,
      MiniGameType.mathBubbles => _LessonPalette.coral,
      MiniGameType.shapeBuilder => _LessonPalette.violet,
      MiniGameType.attentionScan => const Color(0xFF68D391),
      MiniGameType.patternMachine => const Color(0xFF5C8EF7),
      MiniGameType.sortLab => const Color(0xFFE9C46A),
      MiniGameType.bossMix => _LessonPalette.coral,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.34)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sports_esports_rounded,
                  color: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${definition.title} mode',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: _LessonPalette.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Play this puzzle as a mini-game.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _LessonPalette.muted,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onPlay,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Play mini-game'),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: _LessonPalette.background,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCompleteView extends StatelessWidget {
  const _LessonCompleteView({
    required this.lesson,
    required this.isReviewLesson,
    required this.bossMiniGame,
    required this.totalQuestions,
    required this.usedHints,
    required this.wrongAttempts,
    required this.storyWorldProgress,
    required this.nextLessonId,
    required this.onNextLessonSelected,
    required this.onBackToMap,
  });

  final Lesson lesson;
  final bool isReviewLesson;
  final BossMiniGameDefinition? bossMiniGame;
  final int totalQuestions;
  final int usedHints;
  final int wrongAttempts;
  final StoryWorldProgress? storyWorldProgress;
  final String? nextLessonId;
  final ValueChanged<String> onNextLessonSelected;
  final VoidCallback onBackToMap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isBossLesson = bossMiniGame != null;
    final completionCoach = isReviewLesson
        ? FoundationCatalog.coachForCharacterId('brainy')
        : FoundationCatalog.coachForCharacterId(
            storyWorldProgress?.world.helperCharacterId,
          );

    return Scaffold(
      backgroundColor: _LessonPalette.background,
      body: Stack(
        children: [
          const Positioned.fill(child: _LessonBackdrop()),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                DecoratedBox(
                  decoration: _panelDecoration(),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        if (isReviewLesson)
                          const _ReviewReward()
                        else if (isBossLesson)
                          _BossRewardReveal(miniGame: bossMiniGame!)
                        else
                          const _StickerReward(),
                        const SizedBox(height: 18),
                        Text(
                          isReviewLesson
                              ? l10n.adaptiveReviewCompleteTitle
                              : isBossLesson
                                  ? 'Boss cleared!'
                                  : l10n.lessonCompleteTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: _LessonPalette.text,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isReviewLesson
                              ? l10n.adaptiveReviewCompleteBody
                              : isBossLesson
                                  ? 'You combined every clue and unlocked a bigger reward moment.'
                                  : l10n.lessonCompleteBody,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: _LessonPalette.muted,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 18),
                        _CoachCelebrationCard(
                          coach: completionCoach,
                          isReviewLesson: isReviewLesson,
                        ),
                        const SizedBox(height: 18),
                        if (!isReviewLesson) ...[
                          if (isBossLesson)
                            _BossRewardCard(miniGame: bossMiniGame!)
                          else
                            _StickerUnlockCard(
                              title: l10n.lessonStickerUnlockedTitle,
                              body: l10n.lessonStickerUnlockedBody,
                            ),
                          const SizedBox(height: 18),
                        ],
                        if (storyWorldProgress != null) ...[
                          _WorldMissionCompleteCard(
                            progress: storyWorldProgress!,
                          ),
                          const SizedBox(height: 18),
                        ],
                        _LessonReviewCard(
                          totalQuestions: totalQuestions,
                          usedHints: usedHints,
                          wrongAttempts: wrongAttempts,
                        ),
                        if (isBossLesson) ...[
                          const SizedBox(height: 18),
                          _BossPerformanceSummaryCard(
                            miniGame: bossMiniGame!,
                            totalQuestions: totalQuestions,
                            usedHints: usedHints,
                            wrongAttempts: wrongAttempts,
                          ),
                        ],
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _RewardTile(
                                icon: isReviewLesson
                                    ? Icons.psychology_alt_rounded
                                    : Icons.star_rounded,
                                label: isReviewLesson
                                    ? l10n.adaptiveReviewRewardFocus
                                    : l10n.lessonRewardStars,
                                color: const Color(0xFFFFC739),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _RewardTile(
                                icon: Icons.bolt_rounded,
                                label: l10n.lessonRewardXp(lesson.xpReward),
                                color: const Color(0xFF42F4D2),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _RewardTile(
                                icon: isReviewLesson
                                    ? Icons.replay_rounded
                                    : isBossLesson
                                        ? Icons.workspace_premium_rounded
                                        : Icons.auto_awesome_rounded,
                                label: isReviewLesson
                                    ? l10n.adaptiveReviewRewardMistakes
                                    : isBossLesson
                                        ? 'Boss reward'
                                        : l10n.lessonRewardCollection,
                                color: const Color(0xFF9C6AF2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _RewardTile(
                                icon: Icons.local_fire_department_rounded,
                                label: l10n.lessonRewardStreak,
                                color: const Color(0xFFFF6F7D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        if (nextLessonId != null) ...[
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () =>
                                  onNextLessonSelected(nextLessonId!),
                              icon: const Icon(Icons.arrow_forward_rounded),
                              label: Text(l10n.lessonNextRecommendedButton),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: onBackToMap,
                            icon: const Icon(Icons.explore_rounded),
                            label: Text(l10n.lessonBackToMap),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StickerReward extends StatelessWidget {
  const _StickerReward();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      height: 176,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 164,
            height: 164,
            decoration: BoxDecoration(
              color: _LessonPalette.star.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: _LessonPalette.star.withValues(alpha: 0.34),
              ),
            ),
          ),
          Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFC739).withValues(alpha: 0.25),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Image(
              image: AssetImage('assets/images/generated/sticker.png'),
              fit: BoxFit.contain,
            ),
          ),
          const Positioned(
            top: 12,
            right: 14,
            child: Icon(Icons.star_rounded, color: Color(0xFFFFC739), size: 32),
          ),
          const Positioned(
            left: 12,
            bottom: 22,
            child: Icon(Icons.star_rounded, color: Color(0xFFFFC739), size: 24),
          ),
        ],
      ),
    );
  }
}

class _BossRewardReveal extends StatelessWidget {
  const _BossRewardReveal({required this.miniGame});

  final BossMiniGameDefinition miniGame;

  @override
  Widget build(BuildContext context) {
    final accent = Color(miniGame.accentHex);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.86, end: 1),
      duration: const Duration(milliseconds: 520),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: SizedBox(
        width: 184,
        height: 184,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 172,
              height: 172,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: accent.withValues(alpha: 0.38)),
              ),
            ),
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accent,
                    _LessonPalette.star,
                  ],
                ),
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.28),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: _LessonPalette.background,
                size: 66,
              ),
            ),
            const Positioned(
              top: 12,
              right: 18,
              child: Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFFFFD15C),
                size: 34,
              ),
            ),
            const Positioned(
              left: 18,
              bottom: 22,
              child: Icon(
                Icons.shield_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BossRewardCard extends StatelessWidget {
  const _BossRewardCard({required this.miniGame});

  final BossMiniGameDefinition miniGame;

  @override
  Widget build(BuildContext context) {
    final accent = Color(miniGame.accentHex);
    final reward = FoundationCatalog.rewardForId(miniGame.rewardId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.36)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: _LessonPalette.background,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward?.titleKey ?? 'Boss reward unlocked',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${miniGame.title} is cleared. This badge marks a mixed-skill win.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.muted,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BossPerformanceSummaryCard extends StatelessWidget {
  const _BossPerformanceSummaryCard({
    required this.miniGame,
    required this.totalQuestions,
    required this.usedHints,
    required this.wrongAttempts,
  });

  final BossMiniGameDefinition miniGame;
  final int totalQuestions;
  final int usedHints;
  final int wrongAttempts;

  @override
  Widget build(BuildContext context) {
    final accent = Color(miniGame.accentHex);
    final correctEstimate = (totalQuestions - wrongAttempts).clamp(
      0,
      totalQuestions,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.family_restroom_rounded, color: accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Parent summary',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Mixed skills: ${miniGame.mixedSkillTags.map((skill) => skill.name).join(', ')}.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _LessonPalette.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ReviewMetric(
                  value: '$correctEstimate/$totalQuestions',
                  label: 'Boss accuracy',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ReviewMetric(
                  value: '$usedHints',
                  label: 'Hints used',
                ),
              ),
            ],
          ),
          if (wrongAttempts > 0) ...[
            const SizedBox(height: 10),
            Text(
              'Boss mistakes saved for adaptive review.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CoachCelebrationCard extends StatelessWidget {
  const _CoachCelebrationCard({
    required this.coach,
    required this.isReviewLesson,
  });

  final CharacterCoachDefinition coach;
  final bool isReviewLesson;

  @override
  Widget build(BuildContext context) {
    final accent = Color(coach.accentHex);
    final moment = isReviewLesson
        ? CharacterCoachMoment.streak
        : CharacterCoachMoment.celebrate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.36)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CoachAvatar(coach: coach, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${coach.displayName} - ${coach.shortRole}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  coach.lineFor(moment),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorldMissionCompleteCard extends StatelessWidget {
  const _WorldMissionCompleteCard({required this.progress});

  final StoryWorldProgress progress;

  @override
  Widget build(BuildContext context) {
    final world = progress.world;
    final accent = Color(world.accentHex);
    final completed = progress.state == StoryWorldState.completed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accent.withValues(alpha: 0.38)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _worldIcon(world.id),
            color: accent,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  completed
                      ? '${world.title} completed'
                      : '${world.title} mission',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  completed ? world.completionSummary : world.missionSummary,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.muted,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 9,
                    value: progress.progress,
                    color: accent,
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${progress.completedLessonCount}/${progress.totalLessonCount} lessons repaired',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: _LessonPalette.muted,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewReward extends StatelessWidget {
  const _ReviewReward();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 176,
      height: 176,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 164,
            height: 164,
            decoration: BoxDecoration(
              color: _LessonPalette.aqua.withValues(alpha: 0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: _LessonPalette.aqua.withValues(alpha: 0.34),
              ),
            ),
          ),
          Container(
            width: 124,
            height: 124,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _LessonPalette.aqua,
                  _LessonPalette.violet,
                ],
              ),
              borderRadius: BorderRadius.circular(34),
              boxShadow: [
                BoxShadow(
                  color: _LessonPalette.aqua.withValues(alpha: 0.24),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.psychology_alt_rounded,
              color: _LessonPalette.text,
              size: 62,
            ),
          ),
          const Positioned(
            top: 14,
            right: 18,
            child: Icon(
              Icons.replay_rounded,
              color: Color(0xFF42F4D2),
              size: 32,
            ),
          ),
          const Positioned(
            left: 20,
            bottom: 24,
            child: Icon(
              Icons.check_circle_rounded,
              color: Color(0xFFFFD15C),
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class _StickerUnlockCard extends StatelessWidget {
  const _StickerUnlockCard({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _LessonPalette.violet.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _LessonPalette.violet.withValues(alpha: 0.36),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: Color(0xFF9C6AF2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _LessonPalette.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _LessonPalette.muted,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonReviewCard extends StatelessWidget {
  const _LessonReviewCard({
    required this.totalQuestions,
    required this.usedHints,
    required this.wrongAttempts,
  });

  final int totalQuestions;
  final int usedHints;
  final int wrongAttempts;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final perfectRun = usedHints == 0 && wrongAttempts == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _LessonPalette.aqua.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _LessonPalette.aqua.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF18B7AE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.lessonReviewTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _LessonPalette.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      perfectRun
                          ? l10n.lessonReviewPerfectBody
                          : l10n.lessonReviewSupportBody,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _LessonPalette.muted,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ReviewMetric(
                  value: '$totalQuestions',
                  label: l10n.lessonReviewQuestionsLabel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ReviewMetric(
                  value: '$usedHints',
                  label: l10n.lessonReviewHintsLabel,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ReviewMetric(
                  value: '$wrongAttempts',
                  label: l10n.lessonReviewMistakesLabel,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewMetric extends StatelessWidget {
  const _ReviewMetric({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: _LessonPalette.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: _LessonPalette.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 34),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: _LessonPalette.text,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: _LessonPalette.panel,
    borderRadius: BorderRadius.circular(28),
    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.28),
        blurRadius: 24,
        offset: const Offset(0, 14),
      ),
    ],
  );
}
