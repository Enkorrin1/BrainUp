import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';
import '../shared/practice_habit_strip.dart';

typedef AddChildProfile = Future<void> Function({
  required String childName,
  required ChildAge childAge,
  required LearningGoal learningGoal,
});

class ParentScreen extends StatelessWidget {
  const ParentScreen({
    required this.profile,
    required this.currentLocale,
    required this.onChildSelected,
    required this.onChildAdded,
    required this.onLocaleChanged,
    required this.onSubscriptionPlanChanged,
    required this.onResetProfile,
    super.key,
  });

  final FamilyProfile profile;
  final Locale currentLocale;
  final Future<void> Function(String childId) onChildSelected;
  final AddChildProfile onChildAdded;
  final Future<void> Function(Locale locale) onLocaleChanged;
  final Future<void> Function(FamilySubscriptionPlan plan)
      onSubscriptionPlanChanged;
  final Future<void> Function() onResetProfile;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final weeklySessions = profile.sessionsInLastDays(days: 7, now: now);
    final weeklyMinutes = weeklySessions.fold<int>(
      0,
      (total, session) => total + session.minutes,
    );
    final practiceDays = profile.practiceDays(days: 7, now: now);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _ParentBackdropPainter(),
            ),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 132),
              children: [
                _ParentHero(
                  profile: profile,
                  weeklySessionsCount: weeklySessions.length,
                  weeklyMinutes: weeklyMinutes,
                ),
                const SizedBox(height: 14),
                _ChildrenPanel(
                  profile: profile,
                  onChildSelected: onChildSelected,
                  onChildAdded: onChildAdded,
                ),
                const SizedBox(height: 14),
                _WeeklyProgressPanel(
                  profile: profile,
                  weeklySessions: weeklySessions,
                  weeklySessionsCount: weeklySessions.length,
                  weeklyMinutes: weeklyMinutes,
                  practiceDays: practiceDays,
                ),
                const SizedBox(height: 14),
                _SkillInsightsPanel(sessions: weeklySessions),
                const SizedBox(height: 14),
                _RecentSessionsPanel(
                  sessions: profile.activeChild.practiceSessions,
                ),
                const SizedBox(height: 14),
                _SubscriptionPanel(
                  profile: profile,
                  onPlanChanged: onSubscriptionPlanChanged,
                ),
                const SizedBox(height: 14),
                _LanguagePanel(
                  currentLocale: currentLocale,
                  onLocaleChanged: onLocaleChanged,
                ),
                const SizedBox(height: 14),
                _ResetProfilePanel(onReset: () => _confirmReset(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context) async {
    final l10n = context.l10n;
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          title: Text(l10n.resetDialogTitle),
          content: Text(l10n.resetDialogBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.cancelButton),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.resetConfirmButton),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      await onResetProfile();
    }
  }
}

class _ParentHero extends StatelessWidget {
  const _ParentHero({
    required this.profile,
    required this.weeklySessionsCount,
    required this.weeklyMinutes,
  });

  final FamilyProfile profile;
  final int weeklySessionsCount;
  final int weeklyMinutes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      height: 246,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14245A),
            Color(0xFF38257F),
            Color(0xFF07132F),
          ],
        ),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: Container(
              width: 122,
              height: 122,
              decoration: const BoxDecoration(
                color: Color(0x2442F4D2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Positioned(
            right: 8,
            top: 20,
            child: SizedBox(
              width: 104,
              height: 104,
              child: Image(
                image: AssetImage('assets/images/generated/sticker.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            right: 122,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TinyPill(
                  icon: Icons.supervisor_account_rounded,
                  label: l10n.parentTag,
                  color: const Color(0xFF8B63E8),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.parentDashboardTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.familyProfileSummary(
                    profile.childName,
                    l10n.labelForAge(profile.childAge),
                    l10n.labelForGoal(profile.learningGoal),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFBFCBFF),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Row(
              children: [
                Expanded(
                  child: _HeroMetric(
                    icon: Icons.local_fire_department_rounded,
                    value: l10n.dayCountShort(profile.currentStreak),
                    label: l10n.currentStreakMetric,
                    color: const Color(0xFFFFA93B),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HeroMetric(
                    icon: Icons.assignment_turned_in_rounded,
                    value: '$weeklySessionsCount',
                    label: l10n.sessionsMetric,
                    color: const Color(0xFF18B7AE),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _HeroMetric(
                    icon: Icons.timer_rounded,
                    value: '$weeklyMinutes',
                    label: l10n.minutesMetric,
                    color: const Color(0xFF8B63E8),
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

class _ChildrenPanel extends StatelessWidget {
  const _ChildrenPanel({
    required this.profile,
    required this.onChildSelected,
    required this.onChildAdded,
  });

  final FamilyProfile profile;
  final Future<void> Function(String childId) onChildSelected;
  final AddChildProfile onChildAdded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final children = profile.children;
    final limit = profile.subscriptionPlan.childProfileLimit;

    return DecoratedBox(
      decoration: _softPanelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.child_care_rounded,
              title: l10n.childrenProfilesTitle,
              trailing: '${children.length} / $limit',
              color: const Color(0xFF18B7AE),
            ),
            const SizedBox(height: 14),
            for (final child in children) ...[
              _ChildProfileTile(
                child: child,
                selected: child.id == profile.activeChild.id,
                onTap: () => onChildSelected(child.id),
              ),
              const SizedBox(height: 10),
            ],
            if (profile.canAddChild)
              FilledButton.icon(
                onPressed: () => _showAddChildDialog(context),
                icon: const Icon(Icons.person_add_alt_rounded),
                label: Text(l10n.addChildButton),
              )
            else
              _LimitMessage(plan: profile.subscriptionPlan),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddChildDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return _AddChildDialog(onChildAdded: onChildAdded);
      },
    );
  }
}

class _ChildProfileTile extends StatelessWidget {
  const _ChildProfileTile({
    required this.child,
    required this.selected,
    required this.onTap,
  });

  final ChildProfile child;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: selected ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDDF8F4) : const Color(0xFFFFFBF2),
          border: Border.all(
            color: selected ? const Color(0xFF18B7AE) : Colors.white,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7ABDB8).withValues(alpha: 0.10),
              blurRadius: 14,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconBubble(
              icon: selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.face_retouching_natural_rounded,
              color:
                  selected ? const Color(0xFF18B7AE) : const Color(0xFFFFA93B),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.ageGoalSummary(
                      l10n.labelForAge(child.age),
                      l10n.labelForGoal(child.learningGoal),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _TinyPill(
                        icon: Icons.task_alt_rounded,
                        label: l10n.childProgressChallengeCount(
                          child.completedChallenges,
                        ),
                        color: const Color(0xFF18B7AE),
                        compact: true,
                      ),
                      _TinyPill(
                        icon: Icons.local_fire_department_rounded,
                        label: l10n.dayCountShort(child.currentStreak),
                        color: const Color(0xFFFFA93B),
                        compact: true,
                      ),
                    ],
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

class _AddChildDialog extends StatefulWidget {
  const _AddChildDialog({required this.onChildAdded});

  final AddChildProfile onChildAdded;

  @override
  State<_AddChildDialog> createState() => _AddChildDialogState();
}

class _AddChildDialogState extends State<_AddChildDialog> {
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

    await widget.onChildAdded(
      childName: childName,
      childAge: _selectedAge,
      learningGoal: _selectedGoal,
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      title: Text(l10n.newChildTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: l10n.childNameLabel,
                errorText: _showNameError ? l10n.childNameError : null,
                prefixIcon: const Icon(Icons.child_care_rounded),
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.ageSectionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final age in ChildAge.values)
                  ChoiceChip(
                    label: Text(l10n.labelForAge(age)),
                    selected: _selectedAge == age,
                    onSelected: (_) {
                      setState(() {
                        _selectedAge = age;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              l10n.learningGoalShortTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final goal in LearningGoal.values) ...[
              _GoalOption(
                goal: goal,
                selected: _selectedGoal == goal,
                onTap: () {
                  setState(() {
                    _selectedGoal = goal;
                  });
                },
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancelButton),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: Text(_isSaving ? l10n.savingButton : l10n.addButton),
        ),
      ],
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
          color: selected ? const Color(0xFFDDF8F4) : const Color(0xFFFFFBF2),
          border: Border.all(
            color: selected ? const Color(0xFF18B7AE) : const Color(0xFFE4F1EE),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color:
                  selected ? const Color(0xFF18B7AE) : const Color(0xFF9AB3B4),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.labelForGoal(goal),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(l10n.descriptionForGoal(goal)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyProgressPanel extends StatelessWidget {
  const _WeeklyProgressPanel({
    required this.profile,
    required this.weeklySessions,
    required this.weeklySessionsCount,
    required this.weeklyMinutes,
    required this.practiceDays,
  });

  final FamilyProfile profile;
  final List<PracticeSession> weeklySessions;
  final int weeklySessionsCount;
  final int weeklyMinutes;
  final List<PracticeDaySummary> practiceDays;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lastSession = profile.lastSession;
    final correctAnswers = weeklySessions.fold<int>(
      0,
      (total, session) => total + session.correctAnswers,
    );
    final totalQuestions = weeklySessions.fold<int>(
      0,
      (total, session) => total + session.totalQuestions,
    );
    final weeklyAccuracy = totalQuestions == 0
        ? l10n.notAvailable
        : '${(correctAnswers / totalQuestions * 100).round()}%';

    return DecoratedBox(
      decoration: _softPanelDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.insights_rounded,
              title: l10n.analyticsTitle,
              color: const Color(0xFF8B63E8),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _SummaryStat(
                    label: l10n.streakMetricLabel,
                    value: l10n.dayCountShort(profile.currentStreak),
                    color: const Color(0xFFFFA93B),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryStat(
                    label: l10n.bestStreakLabel,
                    value: l10n.dayCountShort(profile.bestStreak),
                    color: const Color(0xFF18B7AE),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SummaryStat(
                    label: l10n.last7DaysLabel,
                    value: l10n.sessionsCountShort(weeklySessionsCount),
                    color: const Color(0xFF44A8F2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryStat(
                    label: l10n.weeklyMinutesLabel,
                    value: l10n.minutesShort(weeklyMinutes),
                    color: const Color(0xFF8B63E8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _SummaryStat(
                    label: l10n.accuracyMetricLabel,
                    value: weeklyAccuracy,
                    color: const Color(0xFF18B7AE),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _SummaryStat(
                    label: l10n.hintsMetricLabel,
                    value: '${weeklySessions.fold<int>(
                      0,
                      (total, session) => total + session.usedHints,
                    )}',
                    color: const Color(0xFFFF6F61),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.school_rounded,
              label: l10n.lastSkillLabel,
              value: lastSession == null
                  ? l10n.notAvailable
                  : l10n.localizedSkill(lastSession.skill),
            ),
            _InfoRow(
              icon: Icons.event_available_rounded,
              label: l10n.lastSessionLabel,
              value: lastSession == null
                  ? l10n.notAvailable
                  : l10n.formatShortDate(lastSession.completedAt),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBF2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: PracticeHabitStrip(
                title: l10n.weeklyRhythmTitle,
                subtitle: l10n.weeklyRhythmSubtitle,
                days: practiceDays,
                showMinutes: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionPanel extends StatelessWidget {
  const _SubscriptionPanel({
    required this.profile,
    required this.onPlanChanged,
  });

  final FamilyProfile profile;
  final Future<void> Function(FamilySubscriptionPlan plan) onPlanChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentPlan = profile.subscriptionPlan;

    return DecoratedBox(
      decoration: _softPanelDecoration(color: const Color(0xFFF4E9FF)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.workspace_premium_rounded,
              title: l10n.subscriptionTitle,
              trailing: l10n.statusForPlan(currentPlan),
              color: const Color(0xFF8B63E8),
            ),
            const SizedBox(height: 14),
            _InfoRow(
              icon: Icons.credit_card_rounded,
              label: l10n.currentPlanLabel,
              value: l10n.labelForPlan(currentPlan),
            ),
            _InfoRow(
              icon: Icons.group_rounded,
              label: l10n.familySeatsLabel,
              value: l10n.capacityForPlan(currentPlan),
            ),
            _InfoRow(
              icon: Icons.update_rounded,
              label: l10n.updatedLabel,
              value: profile.subscriptionUpdatedAt == null
                  ? l10n.notAvailable
                  : l10n.formatShortDate(profile.subscriptionUpdatedAt!),
            ),
            const SizedBox(height: 8),
            for (final plan in FamilySubscriptionPlan.values) ...[
              _PlanOption(
                plan: plan,
                selected: plan == currentPlan,
                recommended: plan == FamilySubscriptionPlan.annual,
                onSelect: () => onPlanChanged(plan),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

class _LanguagePanel extends StatelessWidget {
  const _LanguagePanel({
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  final Locale currentLocale;
  final Future<void> Function(Locale locale) onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: _softPanelDecoration(color: const Color(0xFFEAF9FF)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.language_rounded,
              title: l10n.languageSettingsTitle,
              color: const Color(0xFF44A8F2),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.languageSettingsSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF426A70),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _LanguageOption(
                    label: l10n.languageRussian,
                    flag: 'RU',
                    selected: currentLocale.languageCode == 'ru',
                    onTap: () => onLocaleChanged(const Locale('ru')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _LanguageOption(
                    label: l10n.languageEnglish,
                    flag: 'EN',
                    selected: currentLocale.languageCode == 'en',
                    onTap: () => onLocaleChanged(const Locale('en')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.flag,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String flag;
  final bool selected;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF18B7AE) : const Color(0xFF7E98A0);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFDDF8F4) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF18B7AE) : const Color(0xFFE4F1EE),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                flag,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF164C55),
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: const Color(0xFF164C55),
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF18B7AE),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SkillInsightsPanel extends StatelessWidget {
  const _SkillInsightsPanel({required this.sessions});

  final List<PracticeSession> sessions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final insights = _SkillInsights.fromSessions(sessions);
    final strongest = insights.strongestSkill;
    final focus = insights.focusSkill;

    return DecoratedBox(
      decoration: _softPanelDecoration(color: const Color(0xFFEFFAF8)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.psychology_rounded,
              title: l10n.skillInsightsTitle,
              color: const Color(0xFF18B7AE),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _InsightCard(
                    icon: Icons.emoji_events_rounded,
                    label: l10n.strongestAreaLabel,
                    value: strongest == null
                        ? l10n.noSkillDataLabel
                        : l10n.localizedSkill(strongest),
                    color: const Color(0xFFFFA93B),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _InsightCard(
                    icon: Icons.flag_rounded,
                    label: l10n.practiceFocusLabel,
                    value: focus == null
                        ? l10n.noSkillDataLabel
                        : l10n.localizedSkill(focus),
                    color: const Color(0xFF8B63E8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _IconBubble(
                    icon: Icons.lightbulb_rounded,
                    color: Color(0xFF44A8F2),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.recommendedPracticeLabel,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          insights.recommendationFor(l10n),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
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

class _SkillInsights {
  const _SkillInsights({
    required this.strongestSkill,
    required this.focusSkill,
    required this.focusAccuracy,
    required this.focusHints,
    required this.focusWrongAttempts,
  });

  final String? strongestSkill;
  final String? focusSkill;
  final double? focusAccuracy;
  final int focusHints;
  final int focusWrongAttempts;

  String recommendationFor(AppLocalizations l10n) {
    final skill = focusSkill;
    if (skill == null) {
      return l10n.recommendationKeepGoing;
    }

    final localizedSkill = l10n.localizedSkill(skill);
    final accuracy = focusAccuracy;
    if (accuracy != null && accuracy < 0.8) {
      return l10n.recommendationImproveAccuracy(localizedSkill);
    }
    if (focusHints > 1) {
      return l10n.recommendationReduceHints(localizedSkill);
    }
    if (focusWrongAttempts > 1) {
      return l10n.recommendationRepeatAttempts(localizedSkill);
    }

    return l10n.recommendationPracticeFocus;
  }

  static _SkillInsights fromSessions(List<PracticeSession> sessions) {
    if (sessions.isEmpty) {
      return const _SkillInsights(
        strongestSkill: null,
        focusSkill: null,
        focusAccuracy: null,
        focusHints: 0,
        focusWrongAttempts: 0,
      );
    }

    final summaries = <String, _SkillQualitySummary>{};
    for (final session in sessions) {
      summaries
          .putIfAbsent(session.skill, () => _SkillQualitySummary(session.skill))
          .add(session);
    }

    final sorted = summaries.values.toList()
      ..sort((first, second) {
        final scoreCompare = second.qualityScore.compareTo(first.qualityScore);
        if (scoreCompare != 0) {
          return scoreCompare;
        }
        return first.skill.compareTo(second.skill);
      });

    final focusCandidates = summaries.values.toList()
      ..sort((first, second) {
        final scoreCompare = first.qualityScore.compareTo(second.qualityScore);
        if (scoreCompare != 0) {
          return scoreCompare;
        }
        final sessionCompare = first.sessionsCount.compareTo(
          second.sessionsCount,
        );
        if (sessionCompare != 0) {
          return sessionCompare;
        }
        return first.skill.compareTo(second.skill);
      });
    final focus = focusCandidates.first;

    return _SkillInsights(
      strongestSkill: sorted.first.skill,
      focusSkill: focus.skill,
      focusAccuracy: focus.accuracy,
      focusHints: focus.usedHints,
      focusWrongAttempts: focus.wrongAttempts,
    );
  }
}

class _SkillQualitySummary {
  _SkillQualitySummary(this.skill);

  final String skill;
  int sessionsCount = 0;
  int correctAnswers = 0;
  int totalQuestions = 0;
  int usedHints = 0;
  int wrongAttempts = 0;

  double? get accuracy {
    if (totalQuestions == 0) {
      return null;
    }
    return correctAnswers / totalQuestions;
  }

  double get qualityScore {
    final accuracyScore = accuracy ?? 1;
    final hintPenalty = usedHints * 0.06;
    final wrongPenalty = wrongAttempts * 0.08;
    return accuracyScore - hintPenalty - wrongPenalty + sessionsCount * 0.01;
  }

  void add(PracticeSession session) {
    sessionsCount += 1;
    correctAnswers += session.correctAnswers;
    totalQuestions += session.totalQuestions;
    usedHints += session.usedHints;
    wrongAttempts += session.wrongAttempts;
  }
}

class _RecentSessionsPanel extends StatelessWidget {
  const _RecentSessionsPanel({required this.sessions});

  final List<PracticeSession> sessions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final recentSessions = [
      ...sessions
    ]..sort((first, second) => second.completedAt.compareTo(first.completedAt));
    final visibleSessions = recentSessions.take(5).toList();

    return DecoratedBox(
      decoration: _softPanelDecoration(color: const Color(0xFFFFF6E5)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              icon: Icons.history_rounded,
              title: l10n.practiceHistoryTitle,
              color: const Color(0xFFFFA93B),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.practiceHistorySubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF426A70),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 14),
            if (visibleSessions.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  l10n.practiceHistoryEmpty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF426A70),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              )
            else
              for (final session in visibleSessions) ...[
                _RecentSessionRow(session: session),
                if (session != visibleSessions.last) const SizedBox(height: 10),
              ],
          ],
        ),
      ),
    );
  }
}

class _RecentSessionRow extends StatelessWidget {
  const _RecentSessionRow({required this.session});

  final PracticeSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totalQuestions = session.totalQuestions;
    final accuracy = totalQuestions == 0
        ? l10n.notAvailable
        : '${(session.correctAnswers / totalQuestions * 100).round()}%';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1D4),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: Color(0xFFFFA93B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.localizedSkill(session.skill),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.practiceHistorySessionMeta(
                    l10n.formatShortDate(session.completedAt),
                    session.minutes,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF426A70),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HistoryMetricChip(
                      label: l10n.accuracyMetricLabel,
                      value: accuracy,
                      color: const Color(0xFF18B7AE),
                    ),
                    _HistoryMetricChip(
                      label: l10n.hintsMetricLabel,
                      value: '${session.usedHints}',
                      color: const Color(0xFF8B63E8),
                    ),
                    _HistoryMetricChip(
                      label: l10n.practiceHistoryMistakesLabel,
                      value: '${session.wrongAttempts}',
                      color: const Color(0xFFFF6F61),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryMetricChip extends StatelessWidget {
  const _HistoryMetricChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$label $value',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: const Color(0xFF164C55),
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 124),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _PlanOption extends StatelessWidget {
  const _PlanOption({
    required this.plan,
    required this.selected,
    required this.recommended,
    required this.onSelect,
  });

  final FamilySubscriptionPlan plan;
  final bool selected;
  final bool recommended;
  final Future<void> Function() onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.white.withValues(alpha: 0.72),
        border: Border.all(
          color: selected ? const Color(0xFF8B63E8) : Colors.white,
          width: selected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: const Color(0xFF8B63E8).withValues(alpha: 0.13),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  l10n.labelForPlan(plan),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (recommended)
                _TinyPill(
                  icon: Icons.star_rounded,
                  label: l10n.recommendedLabel,
                  color: const Color(0xFFFFA93B),
                  compact: true,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.priceForPlan(plan),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF6D4AD8),
                ),
          ),
          const SizedBox(height: 4),
          Text(l10n.descriptionForPlan(plan)),
          const SizedBox(height: 12),
          selected
              ? OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: Text(l10n.currentPlanButton),
                )
              : FilledButton.icon(
                  onPressed: onSelect,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(l10n.chooseButton),
                ),
        ],
      ),
    );
  }
}

class _ResetProfilePanel extends StatelessWidget {
  const _ResetProfilePanel({required this.onReset});

  final Future<void> Function() onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: _softPanelDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const _IconBubble(
              icon: Icons.restart_alt_rounded,
              color: Color(0xFFFF8A42),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.resetProfilePanel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: onReset,
              child: Text(l10n.resetButton),
            ),
          ],
        ),
      ),
    );
  }
}

class _LimitMessage extends StatelessWidget {
  const _LimitMessage({required this.plan});

  final FamilySubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D1),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_rounded,
            color: Color(0xFFFF9D2E),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              plan.isPaid ? l10n.limitPaidMessage : l10n.limitStarterMessage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Color color;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final trailingText = trailing;

    return Row(
      children: [
        _IconBubble(icon: icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (trailingText != null) ...[
          const SizedBox(width: 10),
          Text(
            trailingText,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 3),
          Text(label),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF18B7AE)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 25),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({
    required this.icon,
    required this.label,
    required this.color,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: compact ? 0.14 : 1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 9 : 12,
          vertical: compact ? 6 : 8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: compact ? color : Colors.white,
              size: compact ? 15 : 18,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: compact ? const Color(0xFF164C55) : Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParentBackdropPainter extends CustomPainter {
  const _ParentBackdropPainter();

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

    final mintPaint = Paint()
      ..color = const Color(0xFF42F4D2).withValues(alpha: 0.11);
    final lavenderPaint = Paint()
      ..color = const Color(0xFF9C6AF2).withValues(alpha: 0.13);
    canvas.drawCircle(
        Offset(size.width * 0.92, size.height * 0.14), 88, mintPaint);
    canvas.drawCircle(
      Offset(size.width * 0.06, size.height * 0.55),
      78,
      lavenderPaint,
    );

    final orbitPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.75, size.height * 0.36),
        width: 240,
        height: 92,
      ),
      orbitPaint,
    );

    final starPaint = Paint()..color = const Color(0xFFFFE05E);
    _drawStar(
        canvas, Offset(size.width * 0.16, size.height * 0.16), 8, starPaint);
    _drawStar(
        canvas, Offset(size.width * 0.86, size.height * 0.42), 9, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

BoxDecoration _softPanelDecoration({Color color = Colors.white}) {
  return BoxDecoration(
    color: color.withValues(alpha: 0.92),
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
