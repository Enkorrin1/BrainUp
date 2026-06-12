import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';

class AppPalette {
  const AppPalette._();

  static const ink = Color(0xFF164C55);
  static const muted = Color(0xFF426A70);
  static const teal = Color(0xFF18B7AE);
  static const coral = Color(0xFFFF6F6B);
  static const mint = Color(0xFFE6FAF3);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.profile,
    this.onStartMission,
    this.onCourseSelected,
    this.onLessonSelected,
    this.onCollectionSelected,
    super.key,
  });

  final FamilyProfile profile;
  final VoidCallback? onStartMission;
  final ValueChanged<CourseDefinition>? onCourseSelected;
  final ValueChanged<String>? onLessonSelected;
  final VoidCallback? onCollectionSelected;

  @override
  Widget build(BuildContext context) {
    final child = profile.activeChild;
    final stars = 125 + child.mapStars * 5;
    final hearts = child.hearts;
    final streak = math.max(1, child.currentStreak);
    final completedLessons = child.completedLessonIds.length;
    final recommendedLesson = _recommendedLessonFor(child);

    return Scaffold(
      backgroundColor: const Color(0xFF07132F),
      body: Stack(
        children: [
          const _SkyBackdrop(),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 112),
              children: [
                _HomeTopBar(
                  childName: profile.childName,
                  stars: stars,
                  hearts: hearts,
                  streak: streak,
                ),
                const SizedBox(height: 16),
                _DailyMissionCard(onStartMission: onStartMission),
                const SizedBox(height: 14),
                _RecommendedLessonCard(
                  lesson: recommendedLesson,
                  onLessonSelected: onLessonSelected,
                ),
                const SizedBox(height: 18),
                _CourseCatalog(
                  completedLessons: completedLessons,
                  onCourseSelected: onCourseSelected,
                ),
                const SizedBox(height: 16),
                _ProgressGrid(
                  level: math.max(
                    1,
                    math.max(child.completedChallenges, completedLessons) + 1,
                  ),
                  stars: stars,
                  stickerCount: math.max(15, completedLessons + 15),
                  onCollectionSelected: onCollectionSelected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Lesson? _recommendedLessonFor(ChildProfile child) {
    final preferredCourse = _preferredCourseFor(child.learningGoal);
    for (final lessonId in preferredCourse.lessonIds) {
      if (!child.completedLessonIds.contains(lessonId)) {
        return FoundationCatalog.lessonForId(lessonId);
      }
    }

    for (final course in FoundationCatalog.starterCourses) {
      for (final lessonId in course.lessonIds) {
        if (!child.completedLessonIds.contains(lessonId)) {
          return FoundationCatalog.lessonForId(lessonId);
        }
      }
    }

    return null;
  }

  CourseDefinition _preferredCourseFor(LearningGoal goal) {
    final track = switch (goal) {
      LearningGoal.logic => CourseTrack.logic,
      LearningGoal.math => CourseTrack.math,
      LearningGoal.attention => CourseTrack.attention,
    };

    return FoundationCatalog.starterCourses.firstWhere(
      (course) => course.track == track,
      orElse: () => FoundationCatalog.starterCourses.first,
    );
  }
}

class _SkyBackdrop extends StatelessWidget {
  const _SkyBackdrop();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF07132F),
                Color(0xFF102466),
                Color(0xFF38257F),
              ],
            ),
          ),
        ),
        const Positioned(top: 108, left: 22, child: _Cloud(width: 88)),
        const Positioned(top: 82, right: 28, child: _Cloud(width: 70)),
        const Positioned(top: 188, right: 34, child: _RocketBadge()),
        const Positioned(top: 218, left: 28, child: _SoftHill()),
      ],
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({
    required this.childName,
    required this.stars,
    required this.hearts,
    required this.streak,
  });

  final String childName;
  final int stars;
  final int hearts;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 78,
          height: 78,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppPalette.ink.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const ClipOval(
            child: Image(
              image: AssetImage('assets/images/generated/lion.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(
              l10n.homeGreeting(childName),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1.02,
                  ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TopMetric(
              icon: Icons.local_fire_department_rounded,
              value: '$streak',
              color: AppPalette.coral,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _TopMetric(
                  icon: Icons.favorite_rounded,
                  value: '$hearts',
                  color: const Color(0xFFFF5A7D),
                ),
                const SizedBox(width: 8),
                _TopMetric(
                  icon: Icons.star_rounded,
                  value: '$stars',
                  color: const Color(0xFFFFC739),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _TopMetric extends StatelessWidget {
  const _TopMetric({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _DailyMissionCard extends StatelessWidget {
  const _DailyMissionCard({required this.onStartMission});

  final VoidCallback? onStartMission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF0966D8),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0966D8).withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(right: -18, bottom: -10, child: _PlanetImage()),
          const Positioned(right: 18, top: 34, child: _MissionStars()),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 150, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MissionTag(label: l10n.dailyChallengeTag),
                const SizedBox(height: 18),
                Text(
                  l10n.homeMissionHelpTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.12,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.dailyMissionBody,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.86),
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppPalette.coral,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(150, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: onStartMission,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(l10n.missionStartButton),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 20,
            bottom: 10,
            width: 148,
            height: 148,
            child: Image(
              image: AssetImage('assets/images/generated/astronaut.png'),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _MissionTag extends StatelessWidget {
  const _MissionTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF9C6AF2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.event_available_rounded,
              color: Colors.white, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedLessonCard extends StatelessWidget {
  const _RecommendedLessonCard({
    required this.lesson,
    required this.onLessonSelected,
  });

  final Lesson? lesson;
  final ValueChanged<String>? onLessonSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selectedLesson = lesson;
    final title = selectedLesson == null
        ? l10n.homeRecommendedLessonCompleted
        : l10n.courseLessonTitle(_lessonNumber(selectedLesson.id));
    final meta = selectedLesson == null
        ? l10n.collectionAllRewardsUnlocked
        : l10n.courseLessonMeta(
            selectedLesson.stepIds.length,
            selectedLesson.xpReward,
          );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ink.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFE6FAF3),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppPalette.teal,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.homeRecommendedLessonTitle,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppPalette.muted,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  selectedLesson == null
                      ? l10n.homeRecommendedLessonSubtitle
                      : meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppPalette.muted,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppPalette.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(104, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: selectedLesson == null || onLessonSelected == null
                ? null
                : () => onLessonSelected?.call(selectedLesson.id),
            child: Text(l10n.homeRecommendedLessonButton),
          ),
        ],
      ),
    );
  }

  int _lessonNumber(String lessonId) {
    final rawNumber = lessonId.split('.').last;
    return int.tryParse(rawNumber) ?? 1;
  }
}

class _CourseCatalog extends StatelessWidget {
  const _CourseCatalog({
    required this.completedLessons,
    required this.onCourseSelected,
  });

  final int completedLessons;
  final ValueChanged<CourseDefinition>? onCourseSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final courses = [
      _CourseCardData(
        course: FoundationCatalog.starterCourses[0],
        title: l10n.titleForCourse(FoundationCatalog.starterCourses[0]),
        subtitle: l10n.subtitleForCourse(FoundationCatalog.starterCourses[0]),
        asset: _HomeSvgAssets.puzzleCard,
        color: AppPalette.teal,
        progress: math.min(1, completedLessons / 4),
      ),
      _CourseCardData(
        course: FoundationCatalog.starterCourses[1],
        title: l10n.titleForCourse(FoundationCatalog.starterCourses[1]),
        subtitle: l10n.subtitleForCourse(FoundationCatalog.starterCourses[1]),
        asset: _HomeSvgAssets.scale,
        color: const Color(0xFF5C8EF7),
        progress: math.min(1, completedLessons / 5),
      ),
      _CourseCardData(
        course: FoundationCatalog.starterCourses[2],
        title: l10n.titleForCourse(FoundationCatalog.starterCourses[2]),
        subtitle: l10n.subtitleForCourse(FoundationCatalog.starterCourses[2]),
        asset: _HomeSvgAssets.triangle,
        color: const Color(0xFFFF9F43),
        progress: math.min(1, completedLessons / 6),
      ),
      _CourseCardData(
        course: FoundationCatalog.starterCourses[3],
        title: l10n.titleForCourse(FoundationCatalog.starterCourses[3]),
        subtitle: l10n.subtitleForCourse(FoundationCatalog.starterCourses[3]),
        asset: _HomeSvgAssets.star,
        color: const Color(0xFF9C6AF2),
        progress: math.min(1, completedLessons / 7),
      ),
      _CourseCardData(
        course: FoundationCatalog.starterCourses[4],
        title: l10n.titleForCourse(FoundationCatalog.starterCourses[4]),
        subtitle: l10n.subtitleForCourse(FoundationCatalog.starterCourses[4]),
        asset: _HomeSvgAssets.lock,
        color: const Color(0xFFFF6F91),
        progress: math.min(1, completedLessons / 8),
      ),
      _CourseCardData(
        course: FoundationCatalog.starterCourses[5],
        title: l10n.titleForCourse(FoundationCatalog.starterCourses[5]),
        subtitle: l10n.subtitleForCourse(FoundationCatalog.starterCourses[5]),
        asset: _HomeSvgAssets.rocket,
        color: const Color(0xFF35B37E),
        progress: math.min(1, completedLessons / 3),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.courseCatalogTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppPalette.ink,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.18,
          ),
          itemBuilder: (context, index) => _CourseCard(
            data: courses[index],
            onTap: () => onCourseSelected?.call(courses[index].course),
          ),
        ),
      ],
    );
  }
}

class _CourseCardData {
  const _CourseCardData({
    required this.title,
    required this.subtitle,
    required this.course,
    required this.asset,
    required this.color,
    required this.progress,
  });

  final CourseDefinition course;
  final String title;
  final String subtitle;
  final String asset;
  final Color color;
  final double progress;
}

class _HomeSvgAssets {
  static const puzzleCard = 'assets/images/puzzles/puzzle_card.svg';
  static const scale = 'assets/images/puzzles/scale.svg';
  static const triangle = 'assets/images/puzzles/shape_triangle.svg';
  static const star = 'assets/images/puzzles/shape_star.svg';
  static const lock = 'assets/images/puzzles/lock.svg';
  static const rocket = 'assets/images/puzzles/rocket.svg';
  static const planet = 'assets/images/puzzles/planet.svg';
}

class _HomeSvg extends StatelessWidget {
  const _HomeSvg({
    required this.asset,
    required this.size,
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

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.data,
    required this.onTap,
  });

  final _CourseCardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppPalette.ink.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: data.color.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _HomeSvg(asset: data.asset, size: 34),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, color: data.color),
                ],
              ),
              const Spacer(),
              Text(
                data.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppPalette.ink,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                data.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.muted,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: data.progress,
                  minHeight: 7,
                  backgroundColor: data.color.withValues(alpha: 0.13),
                  color: data.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressGrid extends StatelessWidget {
  const _ProgressGrid({
    required this.level,
    required this.stars,
    required this.stickerCount,
    required this.onCollectionSelected,
  });

  final int level;
  final int stars;
  final int stickerCount;
  final VoidCallback? onCollectionSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: l10n.myProgressTitle,
            body: l10n.progressCardBody(level, stars),
            iconAsset: _HomeSvgAssets.planet,
            color: AppPalette.teal,
            asset: 'assets/images/generated/planet.png',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SummaryCard(
            title: l10n.myCollectionTitle,
            body: l10n.collectionCardBody(stickerCount),
            iconAsset: _HomeSvgAssets.rocket,
            color: const Color(0xFF9C6AF2),
            asset: 'assets/images/generated/rocket.png',
            onTap: onCollectionSelected,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.body,
    required this.iconAsset,
    required this.color,
    required this.asset,
    this.onTap,
  });

  final String title;
  final String body;
  final String iconAsset;
  final Color color;
  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 164),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppPalette.ink.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -8,
                bottom: -8,
                width: 88,
                height: 88,
                child: Image(image: AssetImage(asset), fit: BoxFit.contain),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppPalette.ink,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                      ),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.16),
                          shape: BoxShape.circle,
                        ),
                        child: _HomeSvg(asset: iconAsset, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: 112,
                    child: Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppPalette.ink,
                            fontWeight: FontWeight.w900,
                            height: 1.12,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cloud extends StatelessWidget {
  const _Cloud({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.86,
      child: Container(
        width: width,
        height: width * 0.34,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _RocketBadge extends StatelessWidget {
  const _RocketBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        shape: BoxShape.circle,
      ),
      child: const Image(
        image: AssetImage('assets/images/generated/rocket.png'),
        fit: BoxFit.contain,
      ),
    );
  }
}

class _SoftHill extends StatelessWidget {
  const _SoftHill();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 106,
      height: 56,
      decoration: BoxDecoration(
        color: AppPalette.teal.withValues(alpha: 0.52),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
    );
  }
}

class _PlanetImage extends StatelessWidget {
  const _PlanetImage();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Image.asset('assets/images/generated/planet.png'),
      ),
    );
  }
}

class _MissionStars extends StatelessWidget {
  const _MissionStars();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(Icons.star_rounded, color: Color(0xFFFFD84D), size: 22),
        SizedBox(width: 28),
        Icon(Icons.star_rounded, color: Color(0xFFFFD84D), size: 16),
      ],
    );
  }
}
