import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';

class PracticeHabitStrip extends StatelessWidget {
  const PracticeHabitStrip({
    required this.days,
    required this.title,
    this.subtitle,
    this.showMinutes = false,
    super.key,
  });

  final List<PracticeDaySummary> days;
  final String title;
  final String? subtitle;
  final bool showMinutes;

  @override
  Widget build(BuildContext context) {
    final subtitleText = subtitle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (subtitleText != null) ...[
          const SizedBox(height: 4),
          Text(subtitleText),
        ],
        const SizedBox(height: 14),
        Row(
          children: [
            for (final day in days)
              Expanded(
                child: _PracticeDayDot(
                  day: day,
                  showMinutes: showMinutes,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _PracticeDayDot extends StatelessWidget {
  const _PracticeDayDot({
    required this.day,
    required this.showMinutes,
  });

  final PracticeDaySummary day;
  final bool showMinutes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final completed = day.completed;

    return Column(
      children: [
        Text(
          l10n.weekdayShort(day.date),
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: completed ? colorScheme.primary : colorScheme.surface,
            border: Border.all(
              color: completed ? colorScheme.primary : colorScheme.outline,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            completed ? Icons.check_rounded : Icons.remove_rounded,
            size: 18,
            color: completed ? colorScheme.onPrimary : colorScheme.outline,
          ),
        ),
        if (showMinutes) ...[
          const SizedBox(height: 6),
          Text(
            day.minutes == 0 ? '-' : l10n.minutesNarrow(day.minutes),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ],
    );
  }
}
