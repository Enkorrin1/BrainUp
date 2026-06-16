import 'package:flutter/material.dart';

import '../../app/app_controller.dart';
import '../../l10n/l10n.dart';
import '../collection/collection_screen.dart';
import '../lesson/lesson_screen.dart';
import '../parent/parent_screen.dart';
import '../path/path_screen.dart';

class FamilyShell extends StatefulWidget {
  const FamilyShell({
    required this.controller,
    required this.currentLocale,
    required this.onLocaleChanged,
    super.key,
  });

  final AppController controller;
  final Locale currentLocale;
  final Future<void> Function(Locale locale) onLocaleChanged;

  @override
  State<FamilyShell> createState() => _FamilyShellState();
}

class _FamilyShellState extends State<FamilyShell> {
  int _selectedIndex = 0;
  String? _activeLessonId;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        final profile = widget.controller.familyProfile;
        if (profile == null) {
          return const SizedBox.shrink();
        }

        final pages = [
          PathScreen(
            profile: profile,
            onLessonSelected: (lessonId) {
              setState(() {
                _activeLessonId = lessonId;
                _selectedIndex = 1;
              });
            },
          ),
          LessonScreen(
            key: ValueKey(_activeLessonId ?? 'daily-lesson'),
            profile: profile,
            lessonId: _activeLessonId,
            onLessonComplete: widget.controller.completeLesson,
            onNextLessonSelected: (lessonId) {
              setState(() {
                _activeLessonId = lessonId;
                _selectedIndex = 1;
              });
            },
            onBackToMap: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          CollectionScreen(
            profile: profile,
            onRewardEquipped: widget.controller.equipCollectionReward,
            onBackHome: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          ParentScreen(
            profile: profile,
            currentLocale: widget.currentLocale,
            onChildSelected: widget.controller.selectChildProfile,
            onChildAdded: widget.controller.addChildProfile,
            onLocaleChanged: widget.onLocaleChanged,
            onSubscriptionPlanChanged: widget.controller.updateSubscriptionPlan,
            onResetProfile: widget.controller.resetFamilyProfile,
          ),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          bottomNavigationBar: _PlayfulNavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}

class _PlayfulNavigationBar extends StatelessWidget {
  const _PlayfulNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1636).withValues(alpha: 0.94),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF050914).withValues(alpha: 0.30),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _DockItem(
                icon: Icons.explore_rounded,
                label: l10n.homeTab,
                selected: selectedIndex == 0,
                onTap: () => onDestinationSelected(0),
              ),
            ),
            Expanded(
              child: _DockItem(
                icon: Icons.rocket_launch_rounded,
                label: l10n.challengeTab,
                selected: selectedIndex == 1,
                onTap: () => onDestinationSelected(1),
              ),
            ),
            Expanded(
              child: _DockItem(
                icon: Icons.collections_bookmark_rounded,
                label: l10n.myCollectionTitle,
                selected: selectedIndex == 2,
                onTap: () => onDestinationSelected(2),
              ),
            ),
            Expanded(
              child: _DockItem(
                icon: Icons.shield_moon_rounded,
                label: l10n.parentTab,
                selected: selectedIndex == 3,
                onTap: () => onDestinationSelected(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 170),
        height: 58,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF40F0D0).withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFF40F0D0).withValues(alpha: 0.48)
                : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? const Color(0xFF40F0D0) : Colors.white70,
              size: selected ? 27 : 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: selected ? Colors.white : Colors.white70,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
