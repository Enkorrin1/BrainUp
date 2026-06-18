import '../../domain/learning_foundation.dart';

enum MiniGameCharacterState {
  idle,
  thinking,
  hint,
  correct,
  retry,
  streak,
  boss,
  celebration,
}

class MiniGameCharacterReactionProfile {
  const MiniGameCharacterReactionProfile({
    required this.characterId,
    required this.fallbackIconKey,
    required this.stateLines,
    this.riveAssetKey,
  });

  final String characterId;
  final String fallbackIconKey;
  final String? riveAssetKey;
  final Map<MiniGameCharacterState, String> stateLines;

  String lineFor(MiniGameCharacterState state) {
    return stateLines[state] ?? stateLines[MiniGameCharacterState.idle] ?? '';
  }

  static MiniGameCharacterReactionProfile forCharacter({
    required String characterId,
    required SkillTag skillTag,
    required bool isBoss,
  }) {
    final roleLine = _roleLine(skillTag);
    return MiniGameCharacterReactionProfile(
      characterId: characterId,
      fallbackIconKey: 'character.$characterId.avatar',
      riveAssetKey: null,
      stateLines: {
        MiniGameCharacterState.idle: roleLine,
        MiniGameCharacterState.thinking: 'Think one move ahead.',
        MiniGameCharacterState.hint: 'Tiny clue unlocked.',
        MiniGameCharacterState.correct: 'Nice solve!',
        MiniGameCharacterState.retry: 'Try again with the clue.',
        MiniGameCharacterState.streak: 'Strong streak.',
        MiniGameCharacterState.boss:
            isBoss ? 'Boss gate is opening.' : 'Ready for the next move.',
        MiniGameCharacterState.celebration:
            isBoss ? 'Boss reward earned!' : 'Brain spark collected!',
      },
    );
  }

  Map<String, Object?> toJson() {
    return {
      'characterId': characterId,
      'fallbackIconKey': fallbackIconKey,
      if (riveAssetKey != null) 'riveAssetKey': riveAssetKey,
      'stateLines': {
        for (final entry in stateLines.entries) entry.key.name: entry.value,
      },
    };
  }

  static String _roleLine(SkillTag skillTag) {
    return switch (skillTag) {
      SkillTag.memory => 'Lumi is watching the pattern.',
      SkillTag.spatial => 'Quadra is tracing the shape.',
      SkillTag.arithmetic => 'Numba is checking the count.',
      SkillTag.attention => 'Mira is scanning the scene.',
      SkillTag.reasoning => 'Rulo is testing the rule.',
      SkillTag.pattern => 'Brainy is spotting the rhythm.',
      SkillTag.classification => 'Mira is sorting the clues.',
    };
  }
}
