import '../../domain/learning_foundation.dart';

enum MiniGameEffectCue {
  tapPulse,
  cardFlip,
  pathTrace,
  nodeSnap,
  rotateTurn,
  shapeSnap,
  sparkleSuccess,
  softRetry,
  hintPulse,
  rewardBurst,
}

enum MiniGameHapticCue {
  selection,
  hint,
  success,
  retry,
  reward,
}

class MiniGameFeedbackProfile {
  const MiniGameFeedbackProfile({
    required this.effectCues,
    required this.hapticCues,
    required this.successEffectId,
    required this.retryEffectId,
    required this.hintEffectId,
  });

  final List<MiniGameEffectCue> effectCues;
  final List<MiniGameHapticCue> hapticCues;
  final String successEffectId;
  final String retryEffectId;
  final String hintEffectId;

  static MiniGameFeedbackProfile forContent(
    MiniGameContentConfig? config,
  ) {
    final effectCues = [
      for (final cueId in config?.effectCueIds ?? const <String>[])
        _effectCueForId(cueId),
    ].whereType<MiniGameEffectCue>().toSet().toList(growable: false);

    return MiniGameFeedbackProfile(
      effectCues: effectCues.isEmpty
          ? const [
              MiniGameEffectCue.tapPulse,
              MiniGameEffectCue.sparkleSuccess,
              MiniGameEffectCue.softRetry,
              MiniGameEffectCue.hintPulse,
            ]
          : effectCues,
      hapticCues: const [
        MiniGameHapticCue.selection,
        MiniGameHapticCue.hint,
        MiniGameHapticCue.retry,
        MiniGameHapticCue.success,
        MiniGameHapticCue.reward,
      ],
      successEffectId: config?.effectCueIds.firstWhere(
            (cue) => cue.contains('success') || cue.contains('sparkle'),
            orElse: () => 'sparkle_success',
          ) ??
          'sparkle_success',
      retryEffectId: config?.effectCueIds.firstWhere(
            (cue) => cue.contains('retry'),
            orElse: () => 'soft_retry',
          ) ??
          'soft_retry',
      hintEffectId: config?.effectCueIds.firstWhere(
            (cue) => cue.contains('hint'),
            orElse: () => 'hint_pulse',
          ) ??
          'hint_pulse',
    );
  }

  Map<String, Object?> toJson() {
    return {
      'effectCues': [
        for (final cue in effectCues) cue.name,
      ],
      'hapticCues': [
        for (final cue in hapticCues) cue.name,
      ],
      'successEffectId': successEffectId,
      'retryEffectId': retryEffectId,
      'hintEffectId': hintEffectId,
    };
  }

  static MiniGameEffectCue? _effectCueForId(String cueId) {
    return switch (cueId) {
      'tap_pulse' || 'mini.tap' => MiniGameEffectCue.tapPulse,
      'card_flip' => MiniGameEffectCue.cardFlip,
      'path_trace' => MiniGameEffectCue.pathTrace,
      'node_snap' => MiniGameEffectCue.nodeSnap,
      'rotate_turn' => MiniGameEffectCue.rotateTurn,
      'shape_snap' => MiniGameEffectCue.shapeSnap,
      'sparkle_success' => MiniGameEffectCue.sparkleSuccess,
      'soft_retry' => MiniGameEffectCue.softRetry,
      'hint_pulse' => MiniGameEffectCue.hintPulse,
      'reward_burst' || 'boss_reward' => MiniGameEffectCue.rewardBurst,
      _ => null,
    };
  }
}
