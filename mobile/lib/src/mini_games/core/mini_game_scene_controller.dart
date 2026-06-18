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
    this.targetId,
    this.accepted,
    this.traceHotspotIndices = const [],
    this.rotationQuarterTurns,
    this.assembledHotspotIndices = const [],
  });

  final MiniGameSceneAction action;
  final int hotspotIndex;
  final String choiceId;
  final bool autoSubmitted;
  final String? targetId;
  final bool? accepted;
  final List<int> traceHotspotIndices;
  final int? rotationQuarterTurns;
  final List<int> assembledHotspotIndices;

  Map<String, Object?> toJson() {
    return {
      'action': action.name,
      'hotspotIndex': hotspotIndex,
      'choiceId': choiceId,
      'autoSubmitted': autoSubmitted,
      if (targetId != null) 'targetId': targetId,
      if (accepted != null) 'accepted': accepted,
      if (traceHotspotIndices.isNotEmpty)
        'traceHotspotIndices': traceHotspotIndices,
      if (rotationQuarterTurns != null)
        'rotationQuarterTurns': rotationQuarterTurns,
      if (assembledHotspotIndices.isNotEmpty)
        'assembledHotspotIndices': assembledHotspotIndices,
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
    required this.traceHotspotIndices,
    required this.rotationQuarterTurnsByHotspot,
    required this.assembledHotspotIndices,
  });

  final MiniGameSceneState state;
  final String? selectedChoiceId;
  final int? selectedHotspotIndex;
  final int interactionCount;
  final int usedHints;
  final int wrongAttempts;
  final MiniGameSceneEvent? lastEvent;
  final List<int> traceHotspotIndices;
  final Map<int, int> rotationQuarterTurnsByHotspot;
  final List<int> assembledHotspotIndices;

  Map<String, Object?> toJson() {
    return {
      'state': state.name,
      'selectedChoiceId': selectedChoiceId,
      'selectedHotspotIndex': selectedHotspotIndex,
      'interactionCount': interactionCount,
      'usedHints': usedHints,
      'wrongAttempts': wrongAttempts,
      'traceHotspotIndices': traceHotspotIndices,
      'rotationQuarterTurnsByHotspot': rotationQuarterTurnsByHotspot.map(
        (hotspotIndex, quarterTurns) {
          return MapEntry(hotspotIndex.toString(), quarterTurns);
        },
      ),
      'assembledHotspotIndices': assembledHotspotIndices,
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
  final List<int> _traceHotspotIndices = [];
  final Map<int, int> _rotationQuarterTurnsByHotspot = {};
  final List<int> _assembledHotspotIndices = [];

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

  List<int> get traceHotspotIndices {
    return List.unmodifiable(_traceHotspotIndices);
  }

  Map<int, int> get rotationQuarterTurnsByHotspot {
    return Map.unmodifiable(_rotationQuarterTurnsByHotspot);
  }

  List<int> get assembledHotspotIndices {
    return List.unmodifiable(_assembledHotspotIndices);
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
      traceHotspotIndices: traceHotspotIndices,
      rotationQuarterTurnsByHotspot: rotationQuarterTurnsByHotspot,
      assembledHotspotIndices: assembledHotspotIndices,
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
    String? targetId,
    bool? accepted,
    List<int> traceHotspotIndices = const [],
    int? rotationQuarterTurns,
    List<int> assembledHotspotIndices = const [],
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
      targetId: targetId,
      accepted: accepted,
      traceHotspotIndices: traceHotspotIndices,
      rotationQuarterTurns: rotationQuarterTurns,
      assembledHotspotIndices: assembledHotspotIndices,
    );
    onChoiceSelected?.call(choiceId);
    notifyListeners();
  }

  void recordDragStart(int hotspotIndex) {
    final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
      definition: definition,
      hotspotIndex: hotspotIndex,
    );
    if (choiceId == null) {
      return;
    }

    selectChoice(
      choiceId,
      hotspotIndex: hotspotIndex,
      action: MiniGameSceneAction.drag,
    );
  }

  void recordRotation({
    required int hotspotIndex,
    required int quarterTurns,
  }) {
    final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
      definition: definition,
      hotspotIndex: hotspotIndex,
    );
    if (choiceId == null) {
      return;
    }

    final normalized =
        MiniGameCanvasInteraction.normalizedQuarterTurns(quarterTurns);
    _rotationQuarterTurnsByHotspot[hotspotIndex] = normalized;
    selectChoice(
      choiceId,
      hotspotIndex: hotspotIndex,
      action: MiniGameSceneAction.rotate,
      rotationQuarterTurns: normalized,
      assembledHotspotIndices: assembledHotspotIndices,
    );
  }

  void beginTrace(int hotspotIndex) {
    _traceHotspotIndices.clear();
    recordTraceHotspot(hotspotIndex);
  }

  void recordTraceHotspot(int hotspotIndex) {
    final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
      definition: definition,
      hotspotIndex: hotspotIndex,
    );
    if (choiceId == null) {
      return;
    }

    if (_traceHotspotIndices.isEmpty ||
        _traceHotspotIndices.last != hotspotIndex) {
      _traceHotspotIndices.add(hotspotIndex);
    }
    selectChoice(
      choiceId,
      hotspotIndex: hotspotIndex,
      action: MiniGameSceneAction.trace,
      traceHotspotIndices: traceHotspotIndices,
    );
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

  MiniGameResult? submitTrace({
    required List<int> hotspotIndices,
    required int nodeCount,
  }) {
    final normalized = MiniGameCanvasInteraction.normalizedHotspotSequence(
      hotspotIndices,
    );
    if (normalized.isEmpty) {
      return null;
    }

    _traceHotspotIndices
      ..clear()
      ..addAll(normalized);
    final endpointIndex = normalized.last;
    final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
      definition: definition,
      hotspotIndex: endpointIndex,
    );
    if (choiceId == null) {
      return null;
    }

    final accepted = MiniGameCanvasInteraction.isValidTraceRoute(
      definition: definition,
      hotspotIndices: normalized,
      nodeCount: nodeCount,
    );
    selectChoice(
      choiceId,
      hotspotIndex: endpointIndex,
      action: MiniGameSceneAction.trace,
      autoSubmitted: true,
      accepted: accepted,
      traceHotspotIndices: traceHotspotIndices,
    );
    return submitSelected(isCorrectOverride: accepted);
  }

  MiniGameResult? submitDrop({
    required int hotspotIndex,
    required String targetId,
    MiniGameSceneAction action = MiniGameSceneAction.drop,
  }) {
    if (!MiniGameCanvasInteraction.isKnownDropTarget(
      definition: definition,
      targetId: targetId,
    )) {
      return null;
    }

    final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
      definition: definition,
      hotspotIndex: hotspotIndex,
    );
    if (choiceId == null) {
      return null;
    }

    final accepted = MiniGameCanvasInteraction.isCorrectDrop(
      definition: definition,
      choiceId: choiceId,
      targetId: targetId,
    );
    selectChoice(
      choiceId,
      hotspotIndex: hotspotIndex,
      action: action,
      autoSubmitted: true,
      targetId: targetId,
      accepted: accepted,
    );
    return submitSelected(isCorrectOverride: accepted);
  }

  MiniGameResult? submitAssembly({
    required int hotspotIndex,
    required String targetId,
    required int quarterTurns,
  }) {
    if (!MiniGameCanvasInteraction.isKnownDropTarget(
      definition: definition,
      targetId: targetId,
    )) {
      return null;
    }

    final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
      definition: definition,
      hotspotIndex: hotspotIndex,
    );
    if (choiceId == null) {
      return null;
    }

    final normalized =
        MiniGameCanvasInteraction.normalizedQuarterTurns(quarterTurns);
    _rotationQuarterTurnsByHotspot[hotspotIndex] = normalized;
    final accepted = MiniGameCanvasInteraction.isCorrectRotationAssembly(
      definition: definition,
      choiceId: choiceId,
      targetId: targetId,
      quarterTurns: normalized,
    );
    if (accepted && !_assembledHotspotIndices.contains(hotspotIndex)) {
      _assembledHotspotIndices.add(hotspotIndex);
    }

    selectChoice(
      choiceId,
      hotspotIndex: hotspotIndex,
      action: MiniGameSceneAction.snap,
      autoSubmitted: true,
      targetId: targetId,
      accepted: accepted,
      rotationQuarterTurns: normalized,
      assembledHotspotIndices: assembledHotspotIndices,
    );
    return submitSelected(isCorrectOverride: accepted);
  }

  MiniGameResult? submitSelected({bool? isCorrectOverride}) {
    final choiceId = _selectedChoiceId;
    if (choiceId == null) {
      return null;
    }

    final result = isCorrectOverride == null
        ? _resultController.answer(choiceId)
        : _resultController.answerWithCorrectness(
            choiceId: choiceId,
            isCorrect: isCorrectOverride,
          );
    if (result.isCorrect) {
      _state = MiniGameSceneState.success;
    } else {
      _state = MiniGameSceneState.retry;
      _selectedChoiceId = null;
      _selectedHotspotIndex = null;
      _traceHotspotIndices.clear();
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
