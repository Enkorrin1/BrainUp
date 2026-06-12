import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/daily_challenge.dart';
import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({
    required this.profile,
    required this.onChallengeComplete,
    super.key,
  });

  final FamilyProfile profile;
  final Future<void> Function(DailyChallenge challenge) onChallengeComplete;

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  String? _selectedChoiceId;
  String? _activeChallengeId;
  bool _hasSubmitted = false;
  bool _isCorrect = false;
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final challenge = dailyChallengeForDate(
      widget.profile.childAge,
      DateTime.now(),
      goal: widget.profile.learningGoal,
    );
    final completedToday = widget.profile.completedOn(DateTime.now());
    _syncChallenge(challenge);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _ChallengeBackdropPainter(),
            ),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
              children: [
                _ChallengeHero(
                  childName: widget.profile.childName,
                  goalLabel: l10n.labelForGoal(widget.profile.learningGoal),
                  completedToday: completedToday,
                  challenge: challenge,
                ),
                const SizedBox(height: 14),
                if (completedToday)
                  _CompletedChallengeCard(challenge: challenge)
                else
                  _InteractiveChallengeCard(
                    challenge: challenge,
                    selectedChoiceId: _selectedChoiceId,
                    hasSubmitted: _hasSubmitted,
                    isCorrect: _isCorrect,
                    isCompleting: _isCompleting,
                    onChoiceSelected: _selectChoice,
                    onSubmit: _submitAnswer,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _syncChallenge(DailyChallenge challenge) {
    if (_activeChallengeId == challenge.id) {
      return;
    }

    _activeChallengeId = challenge.id;
    _selectedChoiceId = null;
    _hasSubmitted = false;
    _isCorrect = false;
    _isCompleting = false;
  }

  void _selectChoice(String choiceId) {
    setState(() {
      _selectedChoiceId = choiceId;
      _hasSubmitted = false;
      _isCorrect = false;
    });
  }

  Future<void> _submitAnswer(DailyChallenge challenge) async {
    final choiceId = _selectedChoiceId;
    if (choiceId == null || _isCompleting) {
      return;
    }

    final isCorrect = challenge.isCorrectChoice(choiceId);
    setState(() {
      _hasSubmitted = true;
      _isCorrect = isCorrect;
      _isCompleting = isCorrect;
    });

    if (!isCorrect) {
      return;
    }

    await widget.onChallengeComplete(challenge);

    if (!mounted) {
      return;
    }

    setState(() {
      _isCompleting = false;
    });
  }
}

class _ChallengeHero extends StatelessWidget {
  const _ChallengeHero({
    required this.childName,
    required this.goalLabel,
    required this.completedToday,
    required this.challenge,
  });

  final String childName;
  final String goalLabel;
  final bool completedToday;
  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: 238,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1155D8),
            Color(0xFF079FEF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B68CA).withValues(alpha: 0.22),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(child: _MissionStars()),
          Positioned(
            right: -8,
            bottom: -24,
            child: Container(
              width: 178,
              height: 104,
              decoration: const BoxDecoration(
                color: Color(0xFF70DACB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                ),
              ),
            ),
          ),
          const Positioned(
            right: -2,
            bottom: 2,
            child: SizedBox(
              width: 164,
              height: 156,
              child: Image(
                image: AssetImage('assets/images/generated/astronaut.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: _MissionTag(
              icon: completedToday
                  ? Icons.task_alt_rounded
                  : Icons.assignment_turned_in_rounded,
              label: l10n.dailyChallengeTag,
            ),
          ),
          Positioned(
            left: 20,
            top: 76,
            right: 154,
            child: Text(
              completedToday
                  ? l10n.missionCompletedTitle
                  : l10n.childGoCta(childName),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.04,
                  ),
            ),
          ),
          Positioned(
            left: 20,
            right: 154,
            bottom: 22,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoPill(
                  icon: Icons.psychology_alt_rounded,
                  label: l10n.skillForChallenge(challenge),
                ),
                _InfoPill(
                  icon: Icons.timer_rounded,
                  label: l10n.minutesShort(challenge.minutes),
                ),
                _InfoPill(
                  icon: Icons.flag_rounded,
                  label: goalLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InteractiveChallengeCard extends StatelessWidget {
  const _InteractiveChallengeCard({
    required this.challenge,
    required this.selectedChoiceId,
    required this.hasSubmitted,
    required this.isCorrect,
    required this.isCompleting,
    required this.onChoiceSelected,
    required this.onSubmit,
  });

  final DailyChallenge challenge;
  final String? selectedChoiceId;
  final bool hasSubmitted;
  final bool isCorrect;
  final bool isCompleting;
  final ValueChanged<String> onChoiceSelected;
  final Future<void> Function(DailyChallenge challenge) onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: _softPanelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFECA8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: Color(0xFFFFB000),
                    size: 32,
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
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l10n.promptForChallenge(challenge),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF9FF),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                l10n.questionForChallenge(challenge),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 23,
                      height: 1.12,
                    ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.chooseAnswerTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            for (var index = 0; index < challenge.choices.length; index += 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ChoiceTile(
                  label: l10n.choiceLabelFor(
                    challenge,
                    challenge.choices[index],
                  ),
                  index: index,
                  selected: selectedChoiceId == challenge.choices[index].id,
                  onTap: () => onChoiceSelected(challenge.choices[index].id),
                ),
              ),
            if (hasSubmitted) ...[
              const SizedBox(height: 2),
              _AnswerFeedback(
                isCorrect: isCorrect,
                challenge: challenge,
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: selectedChoiceId == null || isCompleting
                  ? null
                  : () => onSubmit(challenge),
              icon: Icon(
                isCompleting
                    ? Icons.hourglass_top_rounded
                    : Icons.check_rounded,
              ),
              label: Text(
                isCompleting ? l10n.checkingButton : l10n.checkAnswerButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int index;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDDF8F4) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF18B7AE) : const Color(0xFFE4F1EE),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7ABDB8).withValues(
                alpha: selected ? 0.18 : 0.08,
              ),
              blurRadius: selected ? 18 : 10,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF18B7AE)
                    : const Color(0xFFFFF3D1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                String.fromCharCode(65 + index),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: selected ? Colors.white : const Color(0xFFFF9D2E),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color:
                  selected ? const Color(0xFF18B7AE) : const Color(0xFF9AB3B4),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerFeedback extends StatelessWidget {
  const _AnswerFeedback({
    required this.isCorrect,
    required this.challenge,
  });

  final bool isCorrect;
  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = isCorrect ? const Color(0xFFDDF8F4) : const Color(0xFFFFEFE4);
    final accent =
        isCorrect ? const Color(0xFF18B7AE) : const Color(0xFFFF8A42);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.emoji_events_rounded : Icons.tips_and_updates,
            color: accent,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isCorrect
                  ? l10n.answerCorrect(l10n.explanationForChallenge(challenge))
                  : l10n.answerAlmost(l10n.hintForChallenge(challenge)),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedChallengeCard extends StatelessWidget {
  const _CompletedChallengeCard({required this.challenge});

  final DailyChallenge challenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: _softPanelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.titleForChallenge(challenge),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.explanationForChallenge(challenge),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  width: 82,
                  height: 96,
                  child: Image(
                    image: AssetImage('assets/images/generated/rocket.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFDDF8F4),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.task_alt_rounded,
                    color: Color(0xFF18B7AE),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.challengeCompletedToday,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionTag extends StatelessWidget {
  const _MissionTag({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF9D68F2),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 5),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionStars extends StatelessWidget {
  const _MissionStars();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MissionStarsPainter(),
    );
  }
}

class _MissionStarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final starPaint = Paint()..color = const Color(0xFFFFDD45);
    _drawStar(
        canvas, Offset(size.width * 0.48, size.height * 0.29), 12, starPaint);
    _drawStar(
        canvas, Offset(size.width * 0.66, size.height * 0.47), 14, starPaint);
    _drawStar(
        canvas, Offset(size.width * 0.56, size.height * 0.71), 13, starPaint);

    final planetPaint = Paint()..color = const Color(0xFF8155E8);
    final ringPaint = Paint()
      ..color = const Color(0xFFB978FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    final planetCenter = Offset(size.width * 0.91, size.height * 0.30);
    canvas.drawCircle(planetCenter, 25, planetPaint);
    canvas.drawOval(
      Rect.fromCenter(center: planetCenter, width: 68, height: 22),
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _ChallengeBackdropPainter extends CustomPainter {
  const _ChallengeBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF07132F),
          Color(0xFF102466),
          Color(0xFF38257F),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, background);

    final aquaPaint = Paint()
      ..color = const Color(0xFF42F4D2).withValues(alpha: 0.12);
    canvas.drawCircle(
        Offset(size.width * 0.94, size.height * 0.12), 86, aquaPaint);
    canvas.drawCircle(
        Offset(size.width * 0.05, size.height * 0.64), 72, aquaPaint);

    final orbitPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.72, size.height * 0.42),
        width: 260,
        height: 96,
      ),
      orbitPaint,
    );

    final starPaint = Paint()..color = const Color(0xFFFFE05E);
    _drawStar(
        canvas, Offset(size.width * 0.13, size.height * 0.17), 8, starPaint);
    _drawStar(
        canvas, Offset(size.width * 0.86, size.height * 0.55), 9, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

BoxDecoration _softPanelDecoration() {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: 0.94),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: Colors.white.withValues(alpha: 0.44), width: 1.5),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.18),
        blurRadius: 24,
        offset: const Offset(0, 12),
      ),
    ],
  );
}

void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
  final path = Path();
  for (var index = 0; index < 10; index += 1) {
    final angle = -math.pi / 2 + index * math.pi / 5;
    final currentRadius = index.isEven ? radius : radius * 0.45;
    final point = Offset(
      center.dx + math.cos(angle) * currentRadius,
      center.dy + math.sin(angle) * currentRadius,
    );
    if (index == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  path.close();
  canvas.drawPath(path, paint);
}
