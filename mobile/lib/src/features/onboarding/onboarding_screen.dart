import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';

typedef CompleteOnboarding = Future<void> Function({
  required String childName,
  required ChildAge childAge,
  required LearningGoal learningGoal,
});

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    required this.onComplete,
    super.key,
  });

  final CompleteOnboarding onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();

  ChildAge _selectedAge = ChildAge.six;
  LearningGoal _selectedGoal = LearningGoal.logic;
  bool _showNameError = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final childName = _nameController.text.trim();
    if (childName.isEmpty) {
      setState(() {
        _showNameError = true;
      });
      return;
    }

    setState(() {
      _showNameError = false;
      _isSaving = true;
    });

    await widget.onComplete(
      childName: childName,
      childAge: _selectedAge,
      learningGoal: _selectedGoal,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF07132F),
      body: Stack(
        children: [
          const Positioned.fill(child: _BrainUpBackdrop()),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 26),
              children: [
                const _BrainUpMark(),
                const SizedBox(height: 18),
                Text(
                  l10n.onboardingTitle,
                  style: textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 34,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.onboardingSubtitle,
                  style: textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFBFCBFF),
                  ),
                ),
                const SizedBox(height: 22),
                _SetupPanel(
                  nameController: _nameController,
                  showNameError: _showNameError,
                  selectedAge: _selectedAge,
                  selectedGoal: _selectedGoal,
                  onAgeSelected: (age) {
                    setState(() {
                      _selectedAge = age;
                    });
                  },
                  onGoalSelected: (goal) {
                    setState(() {
                      _selectedGoal = goal;
                    });
                  },
                  onSubmitted: _submit,
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(_isSaving ? l10n.savingButton : l10n.startButton),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F7D),
                    minimumSize: const Size.fromHeight(58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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

class _BrainUpMark extends StatelessWidget {
  const _BrainUpMark();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: 216,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14245A),
            Color(0xFF392581),
            Color(0xFF07132F),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF020617).withValues(alpha: 0.34),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(
              child: CustomPaint(painter: _BrainGridPainter())),
          Positioned(
            left: 20,
            top: 20,
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF42F4D2), Color(0xFFA7F46A)],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.34),
                ),
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                color: Color(0xFF10172F),
                size: 44,
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Text(
              l10n.onboardingHeroTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          const Positioned(
            right: 18,
            top: 20,
            child: Row(
              children: [
                _SignalPill(color: Color(0xFFFFCA5C)),
                SizedBox(width: 8),
                _SignalPill(color: Color(0xFF7CFFCB)),
                SizedBox(width: 8),
                _SignalPill(color: Color(0xFFFF6B8A)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SignalPill extends StatelessWidget {
  const _SignalPill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _SetupPanel extends StatelessWidget {
  const _SetupPanel({
    required this.nameController,
    required this.showNameError,
    required this.selectedAge,
    required this.selectedGoal,
    required this.onAgeSelected,
    required this.onGoalSelected,
    required this.onSubmitted,
  });

  final TextEditingController nameController;
  final bool showNameError;
  final ChildAge selectedAge;
  final LearningGoal selectedGoal;
  final ValueChanged<ChildAge> onAgeSelected;
  final ValueChanged<LearningGoal> onGoalSelected;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.20),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: nameController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.childNameLabel,
              errorText: showNameError ? l10n.childNameError : null,
              prefixIcon: const Icon(Icons.account_circle_rounded),
              prefixIconColor: const Color(0xFF42F4D2),
              labelStyle: const TextStyle(color: Color(0xFFBFCBFF)),
              fillColor: Colors.white.withValues(alpha: 0.12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.16),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Color(0xFF42F4D2),
                  width: 2,
                ),
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
            onSubmitted: (_) => onSubmitted(),
          ),
          const SizedBox(height: 22),
          Text(
            l10n.ageSectionTitle,
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - 16) / 3;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final age in ChildAge.values)
                    _AgeTile(
                      width: itemWidth,
                      label: l10n.labelForAge(age),
                      selected: selectedAge == age,
                      onTap: () => onAgeSelected(age),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          Text(
            l10n.learningGoalSectionTitle,
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          for (final goal in LearningGoal.values) ...[
            _GoalOption(
              goal: goal,
              selected: selectedGoal == goal,
              onTap: () => onGoalSelected(goal),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _AgeTile extends StatelessWidget {
  const _AgeTile({
    required this.width,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final double width;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFF6F7D)
                : Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? const Color(0xFF42F4D2)
                  : Colors.white.withValues(alpha: 0.16),
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? Colors.white : const Color(0xFFBFCBFF),
                ),
          ),
        ),
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.goal,
    required this.selected,
    required this.onTap,
  });

  final LearningGoal goal;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF42F4D2).withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: selected
                ? const Color(0xFF42F4D2)
                : Colors.white.withValues(alpha: 0.14),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _goalColor(goal),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_goalIcon(goal), color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.labelForGoal(goal),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l10n.descriptionForGoal(goal),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFBFCBFF),
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? const Color(0xFF42F4D2) : Colors.white38,
            ),
          ],
        ),
      ),
    );
  }

  IconData _goalIcon(LearningGoal goal) {
    return switch (goal) {
      LearningGoal.logic => Icons.route_rounded,
      LearningGoal.math => Icons.functions_rounded,
      LearningGoal.attention => Icons.filter_center_focus_rounded,
    };
  }

  Color _goalColor(LearningGoal goal) {
    return switch (goal) {
      LearningGoal.logic => const Color(0xFF5D5FEF),
      LearningGoal.math => const Color(0xFFFF8A4C),
      LearningGoal.attention => const Color(0xFF00A88E),
    };
  }
}

class _BrainUpBackdrop extends StatelessWidget {
  const _BrainUpBackdrop();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _BrainUpBackdropPainter(),
      child: SizedBox.expand(),
    );
  }
}

class _BrainUpBackdropPainter extends CustomPainter {
  const _BrainUpBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF07132F),
          Color(0xFF102466),
          Color(0xFF41287F),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, base);

    final accentA = Paint()
      ..color = const Color(0xFF42F4D2).withValues(alpha: 0.12);
    final accentB = Paint()
      ..color = const Color(0xFFFFD15C).withValues(alpha: 0.12);
    final accentC = Paint()..color = Colors.white.withValues(alpha: 0.05);
    canvas.drawCircle(
        Offset(size.width * 0.09, size.height * 0.16), 92, accentA);
    canvas.drawCircle(
        Offset(size.width * 0.98, size.height * 0.34), 126, accentB);
    canvas.drawCircle(
        Offset(size.width * 0.04, size.height * 0.82), 118, accentC);

    final star = Paint()..color = Colors.white.withValues(alpha: 0.70);
    for (final point in const [
      Offset(0.18, 0.08),
      Offset(0.48, 0.14),
      Offset(0.86, 0.18),
      Offset(0.24, 0.36),
      Offset(0.77, 0.52),
      Offset(0.14, 0.70),
      Offset(0.92, 0.86),
    ]) {
      canvas.drawCircle(
        Offset(size.width * point.dx, size.height * point.dy),
        2,
        star,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _BrainGridPainter extends CustomPainter {
  const _BrainGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final nodePaint = Paint()..color = Colors.white.withValues(alpha: 0.82);
    final activePaint = Paint()..color = const Color(0xFF42F4D2);

    final points = [
      Offset(size.width * 0.24, size.height * 0.34),
      Offset(size.width * 0.44, size.height * 0.22),
      Offset(size.width * 0.66, size.height * 0.34),
      Offset(size.width * 0.36, size.height * 0.58),
      Offset(size.width * 0.62, size.height * 0.66),
      Offset(size.width * 0.82, size.height * 0.50),
    ];

    final route = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index += 1) {
      final previous = points[index - 1];
      final current = points[index];
      route.quadraticBezierTo(
        (previous.dx + current.dx) / 2,
        math.min(previous.dy, current.dy) - 26,
        current.dx,
        current.dy,
      );
    }
    canvas.drawPath(route, linePaint);

    for (var index = 0; index < points.length; index += 1) {
      canvas.drawCircle(points[index], index.isEven ? 7 : 5,
          index == 4 ? activePaint : nodePaint);
    }

    final orbitPaint = Paint()
      ..color = const Color(0xFFFFD15C).withValues(alpha: 0.34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.80, size.height * 0.42),
        width: 180,
        height: 72,
      ),
      -0.2,
      math.pi * 1.35,
      false,
      orbitPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
