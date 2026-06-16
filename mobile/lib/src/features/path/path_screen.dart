import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/duolingo_path.dart';
import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';

class PathScreen extends StatelessWidget {
  const PathScreen({
    required this.profile,
    required this.onLessonSelected,
    super.key,
  });

  final FamilyProfile profile;
  final ValueChanged<String> onLessonSelected;

  @override
  Widget build(BuildContext context) {
    final child = profile.activeChild;
    final path = PrototypeLearningPathCatalog.mainPath;
    final completedNodeIds =
        PrototypeLearningPathCatalog.completedNodeIdsFromLessons(
            child.completedLessonIds);
    final currentNode = path.nextNode(completedNodeIds);
    final reviewProfile =
        PracticeReviewProfile.fromSessions(child.practiceSessions);
    final worldProgress = FoundationCatalog.storyWorldProgressFor(
      child.completedLessonIds,
    );
    final currentWorldProgress = FoundationCatalog.currentStoryWorldProgress(
      child.completedLessonIds,
    );

    return Scaffold(
      backgroundColor: _PathPalette.voidBlue,
      body: Stack(
        children: [
          const Positioned.fill(child: _MissionBackdrop()),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 116),
              children: [
                _MissionStatusBar(
                  hearts: math.max(0, child.hearts),
                  streak: math.max(0, child.currentStreak),
                  xp: math.max(0, child.mapXp),
                ),
                const SizedBox(height: 18),
                _LaunchPanel(
                  childName: child.name,
                  currentNode: currentNode,
                  worldProgress: currentWorldProgress,
                  onStart: currentNode == null
                      ? null
                      : () => onLessonSelected(currentNode.lessonId),
                ),
                if (reviewProfile.hasSignals) ...[
                  const SizedBox(height: 14),
                  _AdaptiveReviewPanel(
                    reviewProfile: reviewProfile,
                    onStart: () => onLessonSelected(
                      FoundationCatalog.adaptiveReviewLesson.id,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                _StoryWorldStrip(progress: worldProgress),
                const SizedBox(height: 26),
                _StarRoute(
                  path: path,
                  completedNodeIds: completedNodeIds,
                  onLessonSelected: onLessonSelected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdaptiveReviewPanel extends StatelessWidget {
  const _AdaptiveReviewPanel({
    required this.reviewProfile,
    required this.onStart,
  });

  final PracticeReviewProfile reviewProfile;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final count = math.max(
      reviewProfile.mistakePuzzleIds.length,
      reviewProfile.weakSkillTags.length,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _PathPalette.aqua.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _PathPalette.aqua.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: _PathPalette.aqua.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.replay_rounded,
                color: _PathPalette.aqua,
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.adaptiveReviewTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    l10n.adaptiveReviewBody(math.max(1, count)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _PathPalette.lavender,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 104,
              child: FilledButton(
                onPressed: onStart,
                style: FilledButton.styleFrom(
                  backgroundColor: _PathPalette.aqua,
                  foregroundColor: _PathPalette.ink,
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  l10n.adaptiveReviewButton,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathPalette {
  const _PathPalette._();

  static const voidBlue = Color(0xFF07132F);
  static const deepBlue = Color(0xFF0E2460);
  static const nebula = Color(0xFF502E91);
  static const star = Color(0xFFFFD15C);
  static const coral = Color(0xFFFF6F7D);
  static const aqua = Color(0xFF42F4D2);
  static const lime = Color(0xFFA7F46A);
  static const lavender = Color(0xFFBFCBFF);
  static const ink = Color(0xFF10172F);
}

IconData _iconForWorld(String worldId) {
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

String _stateLabel(StoryWorldState state) {
  return switch (state) {
    StoryWorldState.locked => 'locked',
    StoryWorldState.active => 'active',
    StoryWorldState.repaired => 'repairing',
    StoryWorldState.completed => 'completed',
  };
}

class _MissionBackdrop extends StatelessWidget {
  const _MissionBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MissionBackdropPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _MissionBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _PathPalette.voidBlue,
          _PathPalette.deepBlue,
          _PathPalette.nebula,
        ],
      ).createShader(rect);
    canvas.drawRect(rect, bg);

    final planetA = Paint()..color = _PathPalette.aqua.withValues(alpha: 0.14);
    final planetB = Paint()..color = _PathPalette.star.withValues(alpha: 0.12);
    canvas.drawCircle(
        Offset(size.width * 0.02, size.height * 0.18), 82, planetA);
    canvas.drawCircle(
        Offset(size.width * 0.98, size.height * 0.38), 112, planetB);

    final orbit = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    for (final data in const [
      (Offset(0.28, 0.20), 88.0, -0.30),
      (Offset(0.74, 0.54), 132.0, 0.22),
      (Offset(0.16, 0.82), 104.0, -0.12),
    ]) {
      canvas.save();
      canvas.translate(size.width * data.$1.dx, size.height * data.$1.dy);
      canvas.rotate(data.$3);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: data.$2 * 1.9,
          height: data.$2,
        ),
        orbit,
      );
      canvas.restore();
    }

    final star = Paint()..color = Colors.white.withValues(alpha: 0.76);
    for (final offset in const [
      Offset(0.10, 0.08),
      Offset(0.50, 0.11),
      Offset(0.83, 0.16),
      Offset(0.20, 0.36),
      Offset(0.72, 0.42),
      Offset(0.36, 0.63),
      Offset(0.92, 0.72),
      Offset(0.14, 0.88),
    ]) {
      canvas.drawCircle(
        Offset(size.width * offset.dx, size.height * offset.dy),
        2.2,
        star,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MissionStatusBar extends StatelessWidget {
  const _MissionStatusBar({
    required this.hearts,
    required this.streak,
    required this.xp,
  });

  final int hearts;
  final int streak;
  final int xp;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        _MissionChip(
          icon: Icons.favorite_rounded,
          value: '$hearts',
          color: _PathPalette.coral,
        ),
        const SizedBox(width: 8),
        _MissionChip(
          icon: Icons.local_fire_department_rounded,
          value: '$streak',
          color: _PathPalette.star,
        ),
        const Spacer(),
        _MissionChip(
          icon: Icons.bolt_rounded,
          value: '$xp ${l10n.courseXpMetricLabel}',
          color: _PathPalette.aqua,
        ),
      ],
    );
  }
}

class _MissionChip extends StatelessWidget {
  const _MissionChip({
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
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(width: 7),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _LaunchPanel extends StatelessWidget {
  const _LaunchPanel({
    required this.childName,
    required this.currentNode,
    required this.worldProgress,
    required this.onStart,
  });

  final String childName;
  final PathNode? currentNode;
  final StoryWorldProgress worldProgress;
  final VoidCallback? onStart;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final world = worldProgress.world;
    final title = currentNode == null
        ? l10n.homeRecommendedLessonCompleted
        : l10n.homeGreeting(childName);
    final body = currentNode == null
        ? l10n.homeRecommendedLessonCompleted
        : world.missionSummary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _RocketWindow(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WorldMissionTag(world: world),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 25,
                                  height: 1.03,
                                ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _PathPalette.lavender,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _WorldMissionProgress(progress: worldProgress),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onStart,
              icon: const Icon(Icons.rocket_launch_rounded),
              label: Text(l10n.homeRecommendedLessonButton),
              style: FilledButton.styleFrom(
                backgroundColor: _PathPalette.coral,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorldMissionTag extends StatelessWidget {
  const _WorldMissionTag({required this.world});

  final StoryWorldDefinition world;

  @override
  Widget build(BuildContext context) {
    final color = Color(world.accentHex);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(_iconForWorld(world.id), color: color, size: 18),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '${world.title}: ${world.missionTitle}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorldMissionProgress extends StatelessWidget {
  const _WorldMissionProgress({required this.progress});

  final StoryWorldProgress progress;

  @override
  Widget build(BuildContext context) {
    final color = Color(progress.world.accentHex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _stateLabel(progress.state),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _PathPalette.lavender,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            Text(
              '${progress.completedLessonCount}/${progress.totalLessonCount}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: progress.progress,
            color: color,
            backgroundColor: Colors.white.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}

class _StoryWorldStrip extends StatelessWidget {
  const _StoryWorldStrip({required this.progress});

  final List<StoryWorldProgress> progress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: progress.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return _StoryWorldCard(progress: progress[index]);
        },
      ),
    );
  }
}

class _StoryWorldCard extends StatelessWidget {
  const _StoryWorldCard({required this.progress});

  final StoryWorldProgress progress;

  @override
  Widget build(BuildContext context) {
    final world = progress.world;
    final accent = Color(world.accentHex);
    final locked = progress.state == StoryWorldState.locked;

    return Container(
      width: 178,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: locked
            ? Colors.white.withValues(alpha: 0.06)
            : accent.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: locked
              ? Colors.white.withValues(alpha: 0.12)
              : accent.withValues(alpha: 0.42),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                locked ? Icons.lock_rounded : _iconForWorld(world.id),
                color: locked ? _PathPalette.lavender : accent,
                size: 22,
              ),
              const Spacer(),
              Text(
                _stateLabel(progress.state),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _PathPalette.lavender,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            world.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            world.missionTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _PathPalette.lavender,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _RocketWindow extends StatelessWidget {
  const _RocketWindow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_PathPalette.aqua, _PathPalette.lime],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _PathPalette.aqua.withValues(alpha: 0.24),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Icon(
        Icons.rocket_launch_rounded,
        color: _PathPalette.ink,
        size: 42,
      ),
    );
  }
}

class _StarRoute extends StatelessWidget {
  const _StarRoute({
    required this.path,
    required this.completedNodeIds,
    required this.onLessonSelected,
  });

  final LearningPath path;
  final Set<String> completedNodeIds;
  final ValueChanged<String> onLessonSelected;

  @override
  Widget build(BuildContext context) {
    final nodes = path.nodes;

    return SizedBox(
      height: nodes.length * 118,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _RouteLinePainter(itemCount: nodes.length),
            ),
          ),
          for (var index = 0; index < nodes.length; index += 1)
            Positioned(
              top: index * 116.0,
              left: _nodeLeft(context, index),
              child: _PlanetNode(
                node: nodes[index],
                state: path.stateForNode(
                  node: nodes[index],
                  completedNodeIds: completedNodeIds,
                ),
                onLessonSelected: onLessonSelected,
              ),
            ),
        ],
      ),
    );
  }

  double _nodeLeft(BuildContext context, int index) {
    final width = MediaQuery.sizeOf(context).width - 32;
    final nodeWidth = index == 0 ? 174.0 : 138.0;
    final anchor = switch (index % 4) {
      0 => 0.04,
      1 => 0.58,
      2 => 0.18,
      _ => 0.50,
    };
    return math.min(width - nodeWidth, math.max(0, width * anchor));
  }
}

class _RouteLinePainter extends CustomPainter {
  const _RouteLinePainter({required this.itemCount});

  final int itemCount;

  @override
  void paint(Canvas canvas, Size size) {
    if (itemCount < 2) {
      return;
    }

    final points = <Offset>[
      for (var index = 0; index < itemCount; index += 1)
        Offset(
          size.width *
              switch (index % 4) {
                0 => 0.27,
                1 => 0.76,
                2 => 0.36,
                _ => 0.68,
              },
          index * 116.0 + 58,
        ),
    ];

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.26)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index += 1) {
      final previous = points[index - 1];
      final current = points[index];
      path.cubicTo(
        previous.dx,
        previous.dy + 54,
        current.dx,
        current.dy - 54,
        current.dx,
        current.dy,
      );
    }
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = _PathPalette.star.withValues(alpha: 0.72);
    for (final point in points.skip(1)) {
      canvas.drawCircle(point.translate(0, -56), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RouteLinePainter oldDelegate) {
    return oldDelegate.itemCount != itemCount;
  }
}

class _PlanetNode extends StatelessWidget {
  const _PlanetNode({
    required this.node,
    required this.state,
    required this.onLessonSelected,
  });

  final PathNode node;
  final PathNodeState state;
  final ValueChanged<String> onLessonSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final title = _titleForNode(context, node);
    final status = switch (state) {
      PathNodeState.completed => l10n.mapNodeCompleted,
      PathNodeState.current => l10n.mapNodeCurrent,
      PathNodeState.locked => l10n.mapNodeLocked,
    };
    final locked = state == PathNodeState.locked;
    final current = state == PathNodeState.current;

    return Semantics(
      button: true,
      enabled: !locked,
      label: '$title, $status',
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: locked ? null : () => onLessonSelected(node.lessonId),
        child: SizedBox(
          width: current ? 174 : 138,
          height: 104,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: current ? 44 : 32,
                top: 7,
                child: _NodePlanet(
                  state: state,
                  type: node.type,
                  current: current,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: current
                        ? _PathPalette.star.withValues(alpha: 0.20)
                        : locked
                            ? Colors.white.withValues(alpha: 0.07)
                            : Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: current
                          ? _PathPalette.star
                          : Colors.white.withValues(alpha: 0.16),
                      width: current ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: current
                                  ? Colors.white
                                  : locked
                                      ? _PathPalette.lavender
                                      : Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        current ? l10n.mapPreviewReward(node.rewardXp) : status,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: current
                                  ? _PathPalette.star
                                  : _PathPalette.lavender,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _titleForNode(BuildContext context, PathNode node) {
    final l10n = context.l10n;
    if (node.titleKey == 'skill') {
      return _skillTitle(context, node.primarySkillTag);
    }
    return switch (node.titleKey) {
      'mapNodeStart' => l10n.mapNodeStart,
      'mapNodeShapes' => l10n.mapNodeShapes,
      'mapNodePairs' => l10n.mapNodePairs,
      'mapNodeCounting' => l10n.mapNodeCounting,
      'mapNodePath' => l10n.mapNodePath,
      'mapNodeRhythm' => l10n.mapNodeRhythm,
      'mapNodeCompare' => l10n.mapNodeCompare,
      'mapNodeFinal' => l10n.mapNodeFinal,
      _ => l10n.mapPreviewTitle(node.order),
    };
  }

  String _skillTitle(BuildContext context, SkillTag skillTag) {
    final l10n = context.l10n;
    return switch (skillTag) {
      SkillTag.attention => l10n.goalAttentionLabel,
      SkillTag.memory => l10n.skillWorkingMemory,
      SkillTag.pattern => l10n.skillPatterns,
      SkillTag.classification => l10n.skillComparison,
      SkillTag.arithmetic => l10n.skillMathThinking,
      SkillTag.spatial => l10n.courseSpatialTitle,
      SkillTag.reasoning => l10n.skillLogicDeduction,
    };
  }
}

class _NodePlanet extends StatelessWidget {
  const _NodePlanet({
    required this.state,
    required this.type,
    required this.current,
  });

  final PathNodeState state;
  final PathNodeType type;
  final bool current;

  @override
  Widget build(BuildContext context) {
    final locked = state == PathNodeState.locked;
    final completed = state == PathNodeState.completed;
    final color = switch (state) {
      PathNodeState.completed => _PathPalette.aqua,
      PathNodeState.current => _PathPalette.star,
      PathNodeState.locked => const Color(0xFF3B4474),
    };
    final icon = switch (state) {
      PathNodeState.completed => Icons.check_rounded,
      PathNodeState.locked => Icons.lock_rounded,
      PathNodeState.current => switch (type) {
          PathNodeType.review => Icons.replay_rounded,
          PathNodeType.reward => Icons.auto_awesome_rounded,
          PathNodeType.boss => Icons.flag_rounded,
          PathNodeType.practice => Icons.psychology_alt_rounded,
          PathNodeType.lesson => Icons.play_arrow_rounded,
        },
    };

    return SizedBox(
      width: current ? 86 : 72,
      height: current ? 86 : 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (!locked)
            Container(
              width: current ? 86 : 72,
              height: current ? 86 : 72,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
            ),
          Transform.rotate(
            angle: -0.24,
            child: Container(
              width: current ? 72 : 60,
              height: current ? 72 : 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    completed
                        ? _PathPalette.lime
                        : locked
                            ? const Color(0xFF262F5D)
                            : _PathPalette.coral,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  if (!locked)
                    BoxShadow(
                      color: color.withValues(alpha: 0.38),
                      blurRadius: current ? 26 : 16,
                      offset: const Offset(0, 10),
                    ),
                ],
              ),
            ),
          ),
          Container(
            width: current ? 44 : 38,
            height: current ? 44 : 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: locked ? 0.16 : 0.92),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: locked ? _PathPalette.lavender : _PathPalette.ink,
              size: current ? 28 : 24,
            ),
          ),
          Positioned(
            right: 5,
            top: 12,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: locked ? Colors.white24 : Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
