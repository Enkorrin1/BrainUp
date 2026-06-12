import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../l10n/l10n.dart';
import '../home/home_screen.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({
    required this.profile,
    required this.onBackHome,
    super.key,
  });

  final FamilyProfile profile;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final child = profile.activeChild;
    final rewards = _rewardData(context);
    final stars = child.mapStars;
    final unlockedCount = rewards
        .where((reward) => reward.requiredStars <= stars)
        .length
        .clamp(0, rewards.length);
    final lockedRewards = rewards.where((reward) {
      return reward.requiredStars > stars;
    }).toList(growable: false);
    final nextReward = lockedRewards.isEmpty ? null : lockedRewards.first;

    return Scaffold(
      backgroundColor: const Color(0xFF07132F),
      body: Stack(
        children: [
          const Positioned.fill(child: _SpaceCollectionBackdrop()),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
              children: [
                _CollectionHeader(
                  unlockedCount: unlockedCount,
                  totalCount: rewards.length,
                  stars: stars,
                  nextReward: nextReward,
                  onBackHome: onBackHome,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rewards.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.84,
                  ),
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    return _RewardStickerCard(
                      reward: reward,
                      unlocked: reward.requiredStars <= stars,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_RewardSticker> _rewardData(BuildContext context) {
    final l10n = context.l10n;
    return [
      _RewardSticker(
        title: l10n.rewardAstronautTitle,
        body: l10n.rewardAstronautBody,
        requiredStars: 0,
        icon: Icons.auto_awesome_rounded,
        asset: 'assets/images/generated/astronaut.png',
        color: const Color(0xFF5C8EF7),
      ),
      _RewardSticker(
        title: l10n.rewardRocketTitle,
        body: l10n.rewardRocketBody,
        requiredStars: 1,
        icon: Icons.rocket_launch_rounded,
        asset: 'assets/images/generated/rocket.png',
        color: const Color(0xFFFF6F6B),
      ),
      _RewardSticker(
        title: l10n.rewardPlanetTitle,
        body: l10n.rewardPlanetBody,
        requiredStars: 2,
        icon: Icons.public_rounded,
        asset: 'assets/images/generated/planet.png',
        color: AppPalette.teal,
      ),
      _RewardSticker(
        title: l10n.rewardLionTitle,
        body: l10n.rewardLionBody,
        requiredStars: 4,
        icon: Icons.pets_rounded,
        asset: 'assets/images/generated/lion.png',
        color: const Color(0xFFFF9F43),
      ),
      _RewardSticker(
        title: l10n.rewardPuzzleTitle,
        body: l10n.rewardPuzzleBody,
        requiredStars: 6,
        icon: Icons.extension_rounded,
        asset: 'assets/images/generated/sticker.png',
        color: const Color(0xFF9C6AF2),
      ),
      _RewardSticker(
        title: l10n.rewardChampionTitle,
        body: l10n.rewardChampionBody,
        requiredStars: 8,
        icon: Icons.workspace_premium_rounded,
        asset: 'assets/images/generated/sticker.png',
        color: const Color(0xFFFFC739),
      ),
    ];
  }
}

class _SpaceCollectionBackdrop extends StatelessWidget {
  const _SpaceCollectionBackdrop();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _SpaceCollectionBackdropPainter(),
      child: SizedBox.expand(),
    );
  }
}

class _SpaceCollectionBackdropPainter extends CustomPainter {
  const _SpaceCollectionBackdropPainter();

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

    canvas.drawCircle(
      Offset(size.width * 0.90, size.height * 0.18),
      112,
      Paint()..color = const Color(0xFFFFD15C).withValues(alpha: 0.12),
    );
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.70),
      90,
      Paint()..color = const Color(0xFF42F4D2).withValues(alpha: 0.11),
    );

    final orbit = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.48, size.height * 0.28),
        width: 260,
        height: 96,
      ),
      orbit,
    );

    final star = Paint()..color = Colors.white.withValues(alpha: 0.72);
    for (final point in const [
      Offset(0.18, 0.12),
      Offset(0.74, 0.13),
      Offset(0.86, 0.42),
      Offset(0.20, 0.56),
      Offset(0.78, 0.80),
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

class _CollectionHeader extends StatelessWidget {
  const _CollectionHeader({
    required this.unlockedCount,
    required this.totalCount,
    required this.stars,
    required this.nextReward,
    required this.onBackHome,
  });

  final int unlockedCount;
  final int totalCount;
  final int stars;
  final _RewardSticker? nextReward;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = totalCount == 0 ? 0.0 : unlockedCount / totalCount;
    final nextRewardText = nextReward == null
        ? l10n.collectionAllRewardsUnlocked
        : l10n.collectionLockedHint(nextReward!.requiredStars);

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
              const Spacer(),
              _StarCounter(stars: stars),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.collectionScreenTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                  height: 1.06,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.collectionScreenSubtitle,
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
              color: const Color(0xFF9C6AF2),
              backgroundColor: const Color(0xFFF1E9FF),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _HeaderMetric(
                  icon: Icons.collections_bookmark_rounded,
                  label: l10n.myCollectionTitle,
                  value: l10n.collectionUnlockedCount(
                    unlockedCount,
                    totalCount,
                  ),
                  color: const Color(0xFF9C6AF2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeaderMetric(
                  icon: Icons.lock_open_rounded,
                  label: l10n.collectionNextReward,
                  value: nextRewardText,
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

class _RewardStickerCard extends StatelessWidget {
  const _RewardStickerCard({
    required this.reward,
    required this.unlocked,
  });

  final _RewardSticker reward;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = unlocked ? reward.color : const Color(0xFF9AAEB2);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked
            ? Colors.white.withValues(alpha: 0.94)
            : Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: unlocked
              ? Colors.white.withValues(alpha: 0.42)
              : const Color(0xFFE2E9E8),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: unlocked ? 0.16 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 108,
                    height: 108,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Opacity(
                    opacity: unlocked ? 1 : 0.34,
                    child: Image(
                      image: AssetImage(reward.asset),
                      width: 94,
                      height: 94,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (!unlocked)
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF7E98A0),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(reward.icon, color: color, size: 19),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  reward.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            unlocked
                ? reward.body
                : l10n.collectionLockedHint(reward.requiredStars),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppPalette.muted,
                  fontWeight: FontWeight.w700,
                  height: 1.16,
                ),
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({
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
      constraints: const BoxConstraints(minHeight: 84),
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
            maxLines: 2,
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

class _StarCounter extends StatelessWidget {
  const _StarCounter({required this.stars});

  final int stars;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFC739)),
          const SizedBox(width: 5),
          Text(
            '${math.max(0, stars)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppPalette.ink,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _RewardSticker {
  const _RewardSticker({
    required this.title,
    required this.body,
    required this.requiredStars,
    required this.icon,
    required this.asset,
    required this.color,
  });

  final String title;
  final String body;
  final int requiredStars;
  final IconData icon;
  final String asset;
  final Color color;
}
