import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';

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
  final Set<int> _hintedStepIndexes = <int>{};
  int _wrongAttempts = 0;

  @override
  Widget build(BuildContext context) {
    final child = widget.profile.activeChild;
    final lesson = widget.lessonId == null
        ? FoundationCatalog.lessonForNode(_currentNode(child))
        : FoundationCatalog.lessonForId(widget.lessonId!);
    final challenges = _lessonChallenges(child, lesson);
    final challenge = challenges[_stepIndex];

    if (_isComplete) {
      return _LessonCompleteView(
        lesson: lesson,
        totalQuestions: challenges.length,
        usedHints: _hintedStepIndexes.length,
        wrongAttempts: _wrongAttempts,
        nextLessonId: _nextLessonIdAfter(lesson.id, child),
        onNextLessonSelected: widget.onNextLessonSelected,
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
                  ),
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

class _LessonHeader extends StatelessWidget {
  const _LessonHeader({
    required this.currentStep,
    required this.totalSteps,
    required this.hearts,
  });

  final int currentStep;
  final int totalSteps;
  final int hearts;

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
              _LessonFeedback(
                isCorrect: isCorrect,
                challenge: challenge,
              ),
            ],
          ],
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

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _LessonPalette.star.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _LessonPalette.star.withValues(alpha: 0.38)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_rounded,
            color: _LessonPalette.star,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.lessonHintTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: _LessonPalette.star,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
      ),
      child: switch (challenge.id) {
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
  });

  final bool isCorrect;
  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isCorrect
            ? _LessonPalette.aqua.withValues(alpha: 0.14)
            : _LessonPalette.coral.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isCorrect
              ? _LessonPalette.aqua.withValues(alpha: 0.34)
              : _LessonPalette.coral.withValues(alpha: 0.32),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.emoji_events_rounded : Icons.tips_and_updates,
            color: isCorrect ? _LessonPalette.aqua : _LessonPalette.coral,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isCorrect
                  ? l10n.answerCorrect(l10n.explanationForChallenge(challenge))
                  : l10n.lessonRetryFeedback,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _LessonPalette.text,
                    fontWeight: FontWeight.w700,
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
    required this.totalQuestions,
    required this.usedHints,
    required this.wrongAttempts,
    required this.nextLessonId,
    required this.onNextLessonSelected,
    required this.onBackToMap,
  });

  final Lesson lesson;
  final int totalQuestions;
  final int usedHints;
  final int wrongAttempts;
  final String? nextLessonId;
  final ValueChanged<String> onNextLessonSelected;
  final VoidCallback onBackToMap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                        const _StickerReward(),
                        const SizedBox(height: 18),
                        Text(
                          l10n.lessonCompleteTitle,
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
                          l10n.lessonCompleteBody,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: _LessonPalette.muted,
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 18),
                        _StickerUnlockCard(
                          title: l10n.lessonStickerUnlockedTitle,
                          body: l10n.lessonStickerUnlockedBody,
                        ),
                        const SizedBox(height: 18),
                        _LessonReviewCard(
                          totalQuestions: totalQuestions,
                          usedHints: usedHints,
                          wrongAttempts: wrongAttempts,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _RewardTile(
                                icon: Icons.star_rounded,
                                label: l10n.lessonRewardStars,
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
                                icon: Icons.auto_awesome_rounded,
                                label: l10n.lessonRewardCollection,
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
