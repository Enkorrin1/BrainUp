import '../../domain/learning_foundation.dart';

enum MiniGameAudioCue {
  tap,
  hint,
  correct,
  retry,
  reward,
  bossReward,
  ambience,
}

class MiniGameAudioSettings {
  const MiniGameAudioSettings({
    required this.enabled,
    required this.volume,
    required this.worldAmbienceEnabled,
  });

  final bool enabled;
  final double volume;
  final bool worldAmbienceEnabled;

  static const muted = MiniGameAudioSettings(
    enabled: false,
    volume: 0.45,
    worldAmbienceEnabled: false,
  );

  MiniGameAudioSettings copyWith({
    bool? enabled,
    double? volume,
    bool? worldAmbienceEnabled,
  }) {
    return MiniGameAudioSettings(
      enabled: enabled ?? this.enabled,
      volume: volume ?? this.volume,
      worldAmbienceEnabled: worldAmbienceEnabled ?? this.worldAmbienceEnabled,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'enabled': enabled,
      'volume': volume,
      'worldAmbienceEnabled': worldAmbienceEnabled,
    };
  }
}

class MiniGameAudioProfile {
  const MiniGameAudioProfile({
    required this.cueIds,
    required this.rewardCueId,
    this.worldAmbienceId,
  });

  final List<String> cueIds;
  final String rewardCueId;
  final String? worldAmbienceId;

  static MiniGameAudioProfile forContent({
    required String worldId,
    required bool isBoss,
    MiniGameContentConfig? contentConfig,
  }) {
    final cueIds = contentConfig?.audioCueIds ?? const <String>[];
    return MiniGameAudioProfile(
      cueIds: cueIds.isEmpty
          ? const [
              'mini.tap',
              'mini.hint',
              'mini.correct',
              'mini.retry',
            ]
          : cueIds,
      rewardCueId: isBoss ? 'mini.boss_reward' : 'mini.reward',
      worldAmbienceId: 'ambience.$worldId.soft_loop',
    );
  }

  Map<String, Object?> toJson() {
    return {
      'cueIds': cueIds,
      'rewardCueId': rewardCueId,
      if (worldAmbienceId != null) 'worldAmbienceId': worldAmbienceId,
    };
  }
}

class MiniGameAudioController {
  MiniGameAudioController({
    MiniGameAudioSettings settings = MiniGameAudioSettings.muted,
  }) : _settings = settings;

  MiniGameAudioSettings _settings;

  MiniGameAudioSettings get settings {
    return _settings;
  }

  void updateSettings(MiniGameAudioSettings settings) {
    _settings = settings;
  }

  void playCue(String cueId) {
    if (!_settings.enabled || cueId.trim().isEmpty) {
      return;
    }
    // Audio assets are resolved by content ids. The method is intentionally
    // a safe no-op until production sound files are bundled.
  }
}
