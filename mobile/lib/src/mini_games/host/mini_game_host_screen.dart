import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../domain/daily_challenge.dart';
import '../core/mini_game_controller.dart';
import '../core/mini_game_definition.dart';
import '../core/mini_game_result.dart';
import '../games/memory_grid_game/memory_grid_preview_game.dart';

class MiniGameHostScreen extends StatefulWidget {
  const MiniGameHostScreen({
    required this.definition,
    required this.challenge,
    super.key,
  });

  final MiniGameDefinition definition;
  final DailyChallenge challenge;

  static Future<MiniGameResult?> play(
    BuildContext context, {
    required MiniGameDefinition definition,
    required DailyChallenge challenge,
  }) {
    return Navigator.of(context).push<MiniGameResult>(
      MaterialPageRoute(
        builder: (context) {
          return MiniGameHostScreen(
            definition: definition,
            challenge: challenge,
          );
        },
      ),
    );
  }

  @override
  State<MiniGameHostScreen> createState() => _MiniGameHostScreenState();
}

class _MiniGameHostScreenState extends State<MiniGameHostScreen> {
  late final MiniGameController _controller;
  String? _selectedChoiceId;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _controller = MiniGameController(definition: widget.definition);
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentFor(widget.definition.type);

    return Scaffold(
      backgroundColor: const Color(0xFF07132F),
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget(
              game: MemoryGridPreviewGame(definition: widget.definition),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF07132F).withValues(alpha: 0.18),
                    const Color(0xFF07132F).withValues(alpha: 0.04),
                    const Color(0xFF07132F).withValues(alpha: 0.92),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _MiniGameTopBar(
                    title: widget.definition.title,
                    subtitle: widget.challenge.skill,
                    accent: accent,
                    onExit: _exit,
                  ),
                  const Spacer(),
                  _MiniGameControlPanel(
                    challenge: widget.challenge,
                    definition: widget.definition,
                    accent: accent,
                    selectedChoiceId: _selectedChoiceId,
                    showHint: _showHint,
                    onHint: _showMiniGameHint,
                    onChoiceSelected: (choiceId) {
                      setState(() {
                        _selectedChoiceId = choiceId;
                      });
                    },
                    onSubmit: _selectedChoiceId == null ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMiniGameHint() {
    setState(() {
      _showHint = true;
    });
    _controller.recordHint();
  }

  void _submit() {
    final choiceId = _selectedChoiceId;
    if (choiceId == null) {
      return;
    }

    Navigator.of(context).pop(_controller.answer(choiceId));
  }

  void _exit() {
    Navigator.of(context).pop(_controller.exit());
  }

  Color _accentFor(MiniGameType type) {
    return switch (type) {
      MiniGameType.memoryGrid => const Color(0xFF42F4D2),
      MiniGameType.logicPath => const Color(0xFFFFD15C),
      MiniGameType.mathBubbles => const Color(0xFFFF6F7D),
      MiniGameType.shapeBuilder => const Color(0xFF9C6AF2),
      MiniGameType.attentionScan => const Color(0xFF68D391),
      MiniGameType.patternMachine => const Color(0xFF5C8EF7),
      MiniGameType.sortLab => const Color(0xFFE9C46A),
      MiniGameType.bossMix => const Color(0xFFFF6F7D),
    };
  }
}

class _MiniGameTopBar extends StatelessWidget {
  const _MiniGameTopBar({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onExit,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.18),
            shape: BoxShape.circle,
            border: Border.all(color: accent.withValues(alpha: 0.46)),
          ),
          child: Icon(Icons.grid_view_rounded, color: accent),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFFC6D0FF),
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Exit mini-game',
          onPressed: onExit,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

class _MiniGameControlPanel extends StatelessWidget {
  const _MiniGameControlPanel({
    required this.challenge,
    required this.definition,
    required this.accent,
    required this.selectedChoiceId,
    required this.showHint,
    required this.onHint,
    required this.onChoiceSelected,
    required this.onSubmit,
  });

  final DailyChallenge challenge;
  final MiniGameDefinition definition;
  final Color accent;
  final String? selectedChoiceId;
  final bool showHint;
  final VoidCallback onHint;
  final ValueChanged<String> onChoiceSelected;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xEE1A2858),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: accent.withValues(alpha: 0.36)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            definition.prompt,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final choice in challenge.choices)
                _MiniGameChoiceChip(
                  label: choice.label,
                  selected: selectedChoiceId == choice.id,
                  accent: accent,
                  onTap: () => onChoiceSelected(choice.id),
                ),
            ],
          ),
          if (showHint) ...[
            const SizedBox(height: 12),
            Text(
              challenge.hint,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFC6D0FF),
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: showHint ? null : onHint,
                  icon: const Icon(Icons.lightbulb_rounded),
                  label: const Text('Hint'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: onSubmit,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Submit mini-game'),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: const Color(0xFF07132F),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniGameChoiceChip extends StatelessWidget {
  const _MiniGameChoiceChip({
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.24)
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? accent : Colors.white.withValues(alpha: 0.18),
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
        ),
      ),
    );
  }
}
