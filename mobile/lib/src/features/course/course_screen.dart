import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';
import '../home/home_screen.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({
    required this.profile,
    required this.course,
    required this.onStartLesson,
    required this.onBackHome,
    super.key,
  });

  final FamilyProfile profile;
  final CourseDefinition course;
  final ValueChanged<String> onStartLesson;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lessons = [
      for (final lessonId in course.lessonIds)
        FoundationCatalog.lessonForId(lessonId),
    ];
    final progress = _CourseProgress.fromLessons(
      lessons: lessons,
      completedLessonIds: profile.activeChild.completedLessonIds,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF07132F),
      body: Stack(
        children: [
          const Positioned.fill(child: _SpaceCourseBackdrop()),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
              children: [
                _CourseHeader(
                  title: l10n.titleForCourse(course),
                  subtitle: l10n.subtitleForCourse(course),
                  completedCount: progress.completedCount,
                  totalCount: lessons.length,
                  stars: progress.completedCount,
                  xp: progress.completedXp,
                  currentLessonIndex: progress.currentIndex,
                  onBackHome: onBackHome,
                ),
                const SizedBox(height: 16),
                for (var index = 0; index < lessons.length; index += 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LessonCard(
                      lesson: lessons[index],
                      index: index,
                      state: progress.stateFor(index),
                      onStart:
                          progress.stateFor(index) != _CourseLessonState.locked
                              ? () => onStartLesson(lessons[index].id)
                              : null,
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

class _SpaceCourseBackdrop extends StatelessWidget {
  const _SpaceCourseBackdrop();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _SpaceCourseBackdropPainter(),
      child: SizedBox.expand(),
    );
  }
}

class _SpaceCourseBackdropPainter extends CustomPainter {
  const _SpaceCourseBackdropPainter();

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

    final glow = Paint()
      ..color = const Color(0xFF42F4D2).withValues(alpha: 0.12);
    canvas.drawCircle(Offset(size.width * 0.92, size.height * 0.15), 106, glow);
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.62),
      86,
      Paint()..color = const Color(0xFF9C6AF2).withValues(alpha: 0.13),
    );

    final star = Paint()..color = Colors.white.withValues(alpha: 0.72);
    for (final point in const [
      Offset(0.16, 0.10),
      Offset(0.72, 0.12),
      Offset(0.88, 0.36),
      Offset(0.18, 0.52),
      Offset(0.80, 0.76),
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

class _CourseHeader extends StatelessWidget {
  const _CourseHeader({
    required this.title,
    required this.subtitle,
    required this.completedCount,
    required this.totalCount,
    required this.stars,
    required this.xp,
    required this.currentLessonIndex,
    required this.onBackHome,
  });

  final String title;
  final String subtitle;
  final int completedCount;
  final int totalCount;
  final int stars;
  final int xp;
  final int currentLessonIndex;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress =
        totalCount == 0 ? 0.0 : (completedCount / totalCount).clamp(0.0, 1.0);
    final nextLessonLabel = completedCount >= totalCount
        ? l10n.courseCompletedState
        : l10n.courseLessonTitle(currentLessonIndex + 1);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.44)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton.filledTonal(
                onPressed: onBackHome,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              const SizedBox(
                width: 72,
                height: 72,
                child: Image(
                  image: AssetImage('assets/images/generated/rocket.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              color: AppPalette.teal,
              backgroundColor: const Color(0xFFDDF8F4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.courseProgress(
                completedCount.clamp(0, totalCount), totalCount),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CourseMetric(
                  icon: Icons.flag_rounded,
                  label: l10n.courseNextMetricLabel,
                  value: nextLessonLabel,
                  color: AppPalette.coral,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CourseMetric(
                  icon: Icons.star_rounded,
                  label: l10n.courseStarsMetricLabel,
                  value: '$stars',
                  color: const Color(0xFFFFC739),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CourseMetric(
                  icon: Icons.bolt_rounded,
                  label: l10n.courseXpMetricLabel,
                  value: '$xp',
                  color: AppPalette.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.lesson,
    required this.index,
    required this.state,
    required this.onStart,
  });

  final Lesson lesson;
  final int index;
  final _CourseLessonState state;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final completed = state == _CourseLessonState.completed;
    final current = state == _CourseLessonState.current;
    final locked = state == _CourseLessonState.locked;
    final color = completed
        ? AppPalette.teal
        : current
            ? AppPalette.coral
            : const Color(0xFFB9CACD);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.38)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              completed
                  ? Icons.star_rounded
                  : locked
                      ? Icons.lock_rounded
                      : Icons.psychology_alt_rounded,
              color: color,
              size: 31,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.courseLessonTitle(index + 1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.courseLessonMeta(lesson.stepIds.length, lesson.xpReward),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppPalette.muted,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                _StatusPill(
                  label: _labelForState(l10n, state),
                  color: color,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: onStart,
            style: FilledButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              minimumSize: const Size(84, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              completed
                  ? l10n.courseRepeatButton
                  : l10n.courseStartLessonButton,
            ),
          ),
        ],
      ),
    );
  }

  String _labelForState(
    AppLocalizations l10n,
    _CourseLessonState state,
  ) {
    return switch (state) {
      _CourseLessonState.completed => l10n.courseCompletedState,
      _CourseLessonState.current => l10n.courseOpenState,
      _CourseLessonState.locked => l10n.courseLockedState,
    };
  }
}

enum _CourseLessonState {
  completed,
  current,
  locked,
}

class _CourseProgress {
  const _CourseProgress({
    required this.lessons,
    required this.completedLessonIds,
    required this.currentIndex,
  });

  final List<Lesson> lessons;
  final Set<String> completedLessonIds;
  final int currentIndex;

  int get completedCount {
    return lessons
        .where((lesson) => completedLessonIds.contains(lesson.id))
        .length;
  }

  int get completedXp {
    return lessons
        .where((lesson) => completedLessonIds.contains(lesson.id))
        .fold<int>(0, (total, lesson) => total + lesson.xpReward);
  }

  _CourseLessonState stateFor(int index) {
    final lesson = lessons[index];
    if (completedLessonIds.contains(lesson.id)) {
      return _CourseLessonState.completed;
    }
    if (index == currentIndex) {
      return _CourseLessonState.current;
    }
    return _CourseLessonState.locked;
  }

  static _CourseProgress fromLessons({
    required List<Lesson> lessons,
    required List<String> completedLessonIds,
  }) {
    final completed = completedLessonIds.toSet();
    var currentIndex = lessons.length;
    for (var index = 0; index < lessons.length; index += 1) {
      if (!completed.contains(lessons[index].id)) {
        currentIndex = index;
        break;
      }
    }

    return _CourseProgress(
      lessons: lessons,
      completedLessonIds: completed,
      currentIndex: currentIndex,
    );
  }
}

class _CourseMetric extends StatelessWidget {
  const _CourseMetric({
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
      constraints: const BoxConstraints(minHeight: 82),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}
