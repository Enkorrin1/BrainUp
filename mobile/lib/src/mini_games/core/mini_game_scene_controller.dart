import 'package:flutter/foundation.dart';

import 'mini_game_canvas_interaction.dart';
import 'mini_game_controller.dart';
import 'mini_game_definition.dart';
import 'mini_game_result.dart';

enum MiniGameSceneState {
  intro,
  playing,
  hint,
  retry,
  success,
  complete,
  exited,
}

enum MiniGameSceneAction {
  tap,
  drag,
  drop,
  trace,
  rotate,
  snap,
}

class MiniGameSceneEvent {
  const MiniGameSceneEvent({
    required this.action,
    required this.hotspotIndex,
    required this.choiceId,
    required this.autoSubmitted,
  });

  final MiniGameSceneAction action;
  final int hotspotIndex;
  final String choiceId;
  final bool autoSubmitted;

  Map<String, Object?> toJson() {
    return {
      'action': action.name,
      'hotspotIndex': hotspotIndex,
      'choiceId': choiceId,
      'autoSubmitted': autoSubmitted,
    };
  }
}

class MiniGameSceneSnapshot {
  const MiniGameSceneSnapshot({
    required this.state,
    required this.selectedChoiceId,
    required this.selectedHotspotIndex,
    required this.interactionCount,
    required this.usedHints,
    required this.wrongAttempts,
    required this.lastEvent,
  });

  final MiniGameSceneState state;
  final String? selectedChoiceId;
  final int? selectedHotspotIndex;
  final int interactionCount;
  final int usedHints;
  final int wrongAttempts;
  final MiniGameSceneEvent? lastEvent;

  Map<String, Object?> toJson() {
    return {
      'state': state.name,
      'selectedChoiceId': selectedChoiceId,
      'selectedHotspotIndex': selectedHotspotIndex,
      'interactionCount': interactionCount,
      'usedHints': usedHints,
      'wrongAttempts': wrongAttempts,
      if (lastEvent != null) 'lastEvent': lastEvent!.toJson(),
    };
  }
}

class MiniGameSceneController extends ChangeNotifier {
  MiniGameSceneController({
    required this.definition,
    DateTime? startedAt,
    this.onChoiceSelected,
    this.onResult,
  }) : _resultController = MiniGameController(
          definition: definition,
          startedAt: startedAt,
        );

  final MiniGameDefinition definition;
  final void Function(String choiceId)? onChoiceSelected;
  final void Function(MiniGameResult result)? onResult;
  final MiniGameController _resultController;

  MiniGameSceneState _state = MiniGameSceneState.intro;
  String? _selectedChoiceId;
  int? _selectedHotspotIndex;
  int _interactionCount = 0;
  MiniGameSceneEvent? _lastEvent;

  MiniGameSceneState get state {
    return _state;
  }

  String? get selectedChoiceId {
    return _selectedChoiceId;
  }

  int? get selectedHotspotIndex {
    return _selectedHotspotIndex;
  }

  int get interactionCount {
    return _interactionCount;
  }

  int get usedHints {
    return _resultController.usedHints;
  }

  int get wrongAttempts {
    return _resultController.wrongAttempts;
  }

  MiniGameSceneSnapshot get snapshot {
    return MiniGameSceneSnapshot(
      state: _state,
      selectedChoiceId: _selectedChoiceId,
      selectedHotspotIndex: _selectedHotspotIndex,
      interactionCount: _interactionCount,
      usedHints: usedHints,
      wrongAttempts: wrongAttempts,
      lastEvent: _lastEvent,
    );
  }

  void start() {
    _state = MiniGameSceneState.playing;
    notifyListeners();
  }

  void recordHint() {
    _resultController.recordHint();
    _state = MiniGameSceneState.hint;
    notifyListeners();
  }

  void selectChoice(
    String choiceId, {
    int? hotspotIndex,
    MiniGameSceneAction action = MiniGameSceneAction.tap,
    bool autoSubmitted = false,
  }) {
    _selectedChoiceId = choiceId;
    _selectedHotspotIndex = hotspotIndex;
    _interactionCount += 1;
    _state = MiniGameSceneState.playing;
    _lastEvent = MiniGameSceneEvent(
      action: action,
      hotspotIndex: hotspotIndex ?? -1,
      choiceId: choiceId,
      autoSubmitted: autoSubmitted,
    );
    onChoiceSelected?.call(choiceId);
    notifyListeners();
  }

  MiniGameResult? submitHotspot(
    int hotspotIndex, {
    MiniGameSceneAction action = MiniGameSceneAction.tap,
  }) {
    final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
      definition: definition,
      hotspotIndex: hotspotIndex,
    );
    if (choiceId == null) {
      return null;
    }

    selectChoice(
      choiceId,
      hotspotIndex: hotspotIndex,
      action: action,
      autoSubmitted: true,
    );
    return submitSelected();
  }

  MiniGameResult? submitSelected() {
    final choiceId = _selectedChoiceId;
    if (choiceId == null) {
      return null;
    }

    final result = _resultController.answer(choiceId);
    if (result.isCorrect) {
      _state = MiniGameSceneState.success;
    } else {
      _state = MiniGameSceneState.retry;
      _selectedChoiceId = null;
      _selectedHotspotIndex = null;
    }
    notifyListeners();
    onResult?.call(result);
    return result;
  }

  MiniGameResult exit() {
    _state = MiniGameSceneState.exited;
    notifyListeners();
    return _resultController.exit();
  }

  void markComplete() {
    _state = MiniGameSceneState.complete;
    notifyListeners();
  }
}
