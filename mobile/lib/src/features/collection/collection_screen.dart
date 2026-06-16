import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/family_profile.dart';
import '../../domain/learning_foundation.dart';
import '../../l10n/l10n.dart';
import '../home/home_screen.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({
    required this.profile,
    required this.onBackHome,
    required this.onRewardEquipped,
    super.key,
  });

  final FamilyProfile profile;
  final VoidCallback onBackHome;
  final ValueChanged<String> onRewardEquipped;

  @override
  Widget build(BuildContext context) {
    final child = profile.activeChild;
    const rewards = FoundationCatalog.collectionRewards;
    final stars = child.mapStars;
    final unlockedRewards = FoundationCatalog.collectionRewardsForStars(stars);
    final nextReward = FoundationCatalog.nextCollectionRewardForStars(stars);

    return Scaffold(
      backgroundColor: const Color(0xFF07132F),
      body: Stack(
        children: [
          const Positioned.fill(child: _CollectionBackdrop()),
          SafeArea(
            bottom: false,
            child: ListView(
              key: const ValueKey('collection-scroll'),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
              children: [
                _CollectionHeader(
                  unlockedCount: unlockedRewards.length,
                  totalCount: rewards.length,
                  stars: stars,
                  nextReward: nextReward,
                  onBackHome: onBackHome,
                ),
                const SizedBox(height: 14),
                _CollectionRoom(child: child),
                const SizedBox(height: 18),
                _RewardSection(
                  title: 'Stickers',
                  subtitle: 'Tiny trophies from every world.',
                  icon: Icons.collections_bookmark_rounded,
                  rewards: _rewardsFor(RewardType.sticker),
                  child: child,
                  onRewardEquipped: onRewardEquipped,
                ),
                _RewardSection(
                  title: 'Outfits',
                  subtitle: 'Dress helpers for their favorite missions.',
                  icon: Icons.checkroom_rounded,
                  rewards: _rewardsFor(RewardType.avatarItem),
                  child: child,
                  onRewardEquipped: onRewardEquipped,
                ),
                _RewardSection(
                  title: 'Room decor',
                  subtitle: 'Make the collection room feel earned.',
                  icon: Icons.chair_rounded,
                  rewards: _rewardsFor(RewardType.decoration),
                  child: child,
                  onRewardEquipped: onRewardEquipped,
                ),
                _RewardSection(
                  title: 'Puzzle badges',
                  subtitle: 'Badges for strong thinking habits.',
                  icon: Icons.workspace_premium_rounded,
                  rewards: _rewardsFor(RewardType.badge),
                  child: child,
                  onRewardEquipped: onRewardEquipped,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<RewardDefinition> _rewardsFor(RewardType type) {
    return [
      for (final reward in FoundationCatalog.collectionRewards)
        if (reward.type == type) reward,
    ];
  }
}

class _CollectionBackdrop extends StatelessWidget {
  const _CollectionBackdrop();

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _CollectionBackdropPainter(),
      child: SizedBox.expand(),
    );
  }
}

class _CollectionBackdropPainter extends CustomPainter {
  const _CollectionBackdropPainter();

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

    final aqua = Paint()
      ..color = const Color(0xFF42F4D2).withValues(alpha: 0.12);
    final coral = Paint()
      ..color = const Color(0xFFFF6F7D).withValues(alpha: 0.10);
    canvas.drawCircle(Offset(size.width * 0.08, size.height * 0.20), 92, aqua);
    canvas.drawCircle(
        Offset(size.width * 0.94, size.height * 0.54), 128, coral);

    final orbit = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.50, size.height * 0.26),
        width: 280,
        height: 104,
      ),
      orbit,
    );

    final star = Paint()..color = Colors.white.withValues(alpha: 0.72);
    for (final point in const [
      Offset(0.18, 0.12),
      Offset(0.74, 0.14),
      Offset(0.86, 0.42),
      Offset(0.20, 0.58),
      Offset(0.78, 0.82),
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
  final RewardDefinition? nextReward;
  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final progress = totalCount == 0 ? 0.0 : unlockedCount / totalCount;
    final nextRewardText = nextReward == null
        ? l10n.collectionAllRewardsUnlocked
        : '${nextReward!.titleKey} - ${l10n.collectionLockedHint(nextReward!.unlockedAfterStars)}';

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
                tooltip: l10n.collectionBackHome,
              ),
              const Spacer(),
              _StarCounter(stars: stars),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.myCollectionTitle,
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
                    totalCount,
                    unlockedCount,
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

class _CollectionRoom extends StatelessWidget {
  const _CollectionRoom({required this.child});

  final ChildProfile child;

  @override
  Widget build(BuildContext context) {
    final outfit = child.selectedOutfitRewardId == null
        ? null
        : FoundationCatalog.rewardForId(child.selectedOutfitRewardId!);
    final decoration = child.selectedDecorationRewardId == null
        ? null
        : FoundationCatalog.rewardForId(child.selectedDecorationRewardId!);
    final badge = child.selectedBadgeRewardId == null
        ? null
        : FoundationCatalog.rewardForId(child.selectedBadgeRewardId!);
    final coach = FoundationCatalog.coachForCharacterId(
      child.selectedCharacterId,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          _HeroAvatar(
            coach: coach,
            outfit: outfit,
            badge: badge,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Collection room',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  outfit?.titleKey ?? 'Choose an outfit',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFBFCBFF),
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                _RoomSlot(
                  icon: _iconForReward(decoration),
                  label: decoration?.titleKey ?? 'No decor equipped',
                  color: decoration == null
                      ? const Color(0xFFBFCBFF)
                      : Color(decoration.accentHex),
                ),
                const SizedBox(height: 6),
                _RoomSlot(
                  icon: _iconForReward(badge),
                  label: badge?.titleKey ?? 'No badge equipped',
                  color: badge == null
                      ? const Color(0xFFBFCBFF)
                      : Color(badge.accentHex),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroAvatar extends StatelessWidget {
  const _HeroAvatar({
    required this.coach,
    required this.outfit,
    required this.badge,
  });

  final CharacterCoachDefinition coach;
  final RewardDefinition? outfit;
  final RewardDefinition? badge;

  @override
  Widget build(BuildContext context) {
    final color = Color(outfit?.accentHex ?? coach.accentHex);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 520),
      tween: Tween<double>(begin: 0.94, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 112,
        height: 112,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: color.withValues(alpha: 0.58), width: 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              _iconForCharacter(coach.id),
              color: color,
              size: 56,
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Icon(
                outfit == null
                    ? Icons.auto_awesome_rounded
                    : Icons.checkroom_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            if (badge != null)
              Positioned(
                left: 10,
                bottom: 10,
                child: Icon(
                  _iconForReward(badge),
                  color: Color(badge!.accentHex),
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RoomSlot extends StatelessWidget {
  const _RoomSlot({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 19),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
      ],
    );
  }
}

class _RewardSection extends StatelessWidget {
  const _RewardSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.rewards,
    required this.child,
    required this.onRewardEquipped,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<RewardDefinition> rewards;
  final ChildProfile child;
  final ValueChanged<String> onRewardEquipped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF42F4D2), size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFBFCBFF),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 218,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: rewards.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final reward = rewards[index];
                return SizedBox(
                  width: 164,
                  child: _RewardCard(
                    reward: reward,
                    unlocked: reward.isUnlockedForStars(child.mapStars),
                    equipped: _isEquipped(child, reward),
                    onRewardEquipped: onRewardEquipped,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isEquipped(ChildProfile child, RewardDefinition reward) {
    return switch (reward.type) {
      RewardType.avatarItem => child.selectedOutfitRewardId == reward.id,
      RewardType.decoration => child.selectedDecorationRewardId == reward.id,
      RewardType.badge => child.selectedBadgeRewardId == reward.id,
      RewardType.sticker || RewardType.booster => false,
    };
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.reward,
    required this.unlocked,
    required this.equipped,
    required this.onRewardEquipped,
  });

  final RewardDefinition reward;
  final bool unlocked;
  final bool equipped;
  final ValueChanged<String> onRewardEquipped;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final color = unlocked ? Color(reward.accentHex) : const Color(0xFF9AAEB2);
    final actionLabel = _actionLabel();

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: unlocked ? 430 : 220),
      tween: Tween<double>(begin: unlocked ? 0.96 : 1, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: unlocked && reward.canEquip && !equipped
            ? () => onRewardEquipped(reward.id)
            : null,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: unlocked
                ? Colors.white.withValues(alpha: 0.94)
                : Colors.white.withValues(alpha: 0.70),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: equipped
                  ? color
                  : unlocked
                      ? Colors.white.withValues(alpha: 0.42)
                      : const Color(0xFFE2E9E8),
              width: equipped ? 2.4 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: unlocked ? 0.16 : 0.07),
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
                  child: _RewardVisual(
                    reward: reward,
                    color: color,
                    unlocked: unlocked,
                  ),
                ),
              ),
              const SizedBox(height: 9),
              Row(
                children: [
                  Icon(_iconForReward(reward), color: color, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      reward.titleKey,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppPalette.ink,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                unlocked
                    ? reward.descriptionKey
                    : l10n.collectionLockedHint(reward.unlockedAfterStars),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppPalette.muted,
                      fontWeight: FontWeight.w700,
                      height: 1.16,
                    ),
              ),
              const SizedBox(height: 9),
              Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: equipped ? 0.20 : 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  actionLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppPalette.ink,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _actionLabel() {
    if (!unlocked) {
      return 'Locked';
    }
    if (!reward.canEquip) {
      return 'Collected';
    }
    return equipped ? 'Equipped' : 'Equip';
  }
}

class _RewardVisual extends StatelessWidget {
  const _RewardVisual({
    required this.reward,
    required this.color,
    required this.unlocked,
  });

  final RewardDefinition reward;
  final Color color;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
        ),
        Opacity(
          opacity: unlocked ? 1 : 0.34,
          child: _RewardImageOrIcon(reward: reward, color: color),
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
    );
  }
}

class _RewardImageOrIcon extends StatelessWidget {
  const _RewardImageOrIcon({
    required this.reward,
    required this.color,
  });

  final RewardDefinition reward;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (reward.visualKey.startsWith('assets/')) {
      return Image(
        image: AssetImage(reward.visualKey),
        width: 86,
        height: 86,
        fit: BoxFit.contain,
      );
    }

    return Icon(
      _iconForReward(reward),
      color: color,
      size: 58,
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

IconData _iconForReward(RewardDefinition? reward) {
  if (reward == null) {
    return Icons.auto_awesome_rounded;
  }

  return switch (reward.visualKey) {
    'icon.window' => Icons.window_rounded,
    'icon.psychology' => Icons.psychology_rounded,
    'icon.science' => Icons.biotech_rounded,
    'icon.center_focus' => Icons.center_focus_strong_rounded,
    'icon.lightbulb' => Icons.lightbulb_rounded,
    'icon.schema' => Icons.schema_rounded,
    'icon.category' => Icons.category_rounded,
    'icon.change_circle' => Icons.change_circle_rounded,
    'icon.toys' => Icons.toys_rounded,
    'icon.functions' => Icons.functions_rounded,
    'icon.water' => Icons.water_rounded,
    'icon.military_tech' => Icons.military_tech_rounded,
    _ => switch (reward.type) {
        RewardType.sticker => Icons.collections_bookmark_rounded,
        RewardType.avatarItem => Icons.checkroom_rounded,
        RewardType.decoration => Icons.chair_rounded,
        RewardType.badge => Icons.workspace_premium_rounded,
        RewardType.booster => Icons.bolt_rounded,
      },
  };
}

IconData _iconForCharacter(String characterId) {
  return switch (characterId) {
    'lumi' => Icons.light_mode_rounded,
    'quadra' => Icons.category_rounded,
    'numba' => Icons.calculate_rounded,
    'rulo' => Icons.schema_rounded,
    'mira' => Icons.center_focus_strong_rounded,
    _ => Icons.psychology_rounded,
  };
}
