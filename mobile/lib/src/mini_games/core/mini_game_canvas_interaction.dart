import 'mini_game_definition.dart';

class MiniGameCanvasInteraction {
  const MiniGameCanvasInteraction._();

  static String? choiceIdForHotspot({
    required MiniGameDefinition definition,
    required int hotspotIndex,
  }) {
    final choices = definition.firstRound.choiceIds;
    if (choices.isEmpty || hotspotIndex < 0) {
      return null;
    }
    return choices[hotspotIndex % choices.length];
  }
}
