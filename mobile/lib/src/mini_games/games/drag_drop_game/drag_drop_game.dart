import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_canvas_visuals.dart';
import '../../core/mini_game_definition.dart';
import '../../core/mini_game_scene_controller.dart';

class DragDropGame extends FlameGame with DragCallbacks {
  DragDropGame({
    required this.definition,
    required this.sceneController,
  });

  final MiniGameDefinition definition;
  final MiniGameSceneController sceneController;
  double _elapsed = 0;
  double _dropPulse = 0;
  double _invalidPulse = 0;
  int? _activeItemIndex;
  Offset? _dragPosition;
  Offset? _lastDropPosition;
  bool _lastDropAccepted = false;

  MiniGameRoundDefinition get _round {
    return definition.firstRound;
  }

  bool get _isSortLab {
    return definition.type == MiniGameType.sortLab;
  }

  @override
  Color backgroundColor() {
    return _isSortLab ? const Color(0xFF123224) : const Color(0xFF07132F);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _dropPulse = math.max(0, _dropPulse - dt * 2.8);
    _invalidPulse = math.max(0, _invalidPulse - dt * 3.6);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final canvasSize = Size(size.x, size.y);
    _drawBackdrop(canvas, canvasSize);
    _drawTargets(canvas, canvasSize);
    _drawDraggableItems(canvas, canvasSize);
    _drawInstruction(canvas, canvasSize);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final itemIndex = _itemIndexAt(
      Offset(event.canvasPosition.x, event.canvasPosition.y),
      Size(size.x, size.y),
    );
    if (itemIndex == null) {
      return;
    }

    _activeItemIndex = itemIndex;
    _dragPosition = Offset(
      event.canvasPosition.x,
      event.canvasPosition.y,
    );
    sceneController.recordDragStart(itemIndex);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_activeItemIndex == null) {
      return;
    }
    _dragPosition = Offset(
      event.canvasEndPosition.x,
      event.canvasEndPosition.y,
    );
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _finishDrag();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _activeItemIndex = null;
    _dragPosition = null;
  }

  void _finishDrag() {
    final itemIndex = _activeItemIndex;
    final dropPosition = _dragPosition;
    if (itemIndex == null || dropPosition == null) {
      _activeItemIndex = null;
      _dragPosition = null;
      return;
    }

    final targetId = _targetIdAt(dropPosition, Size(size.x, size.y));
    if (targetId == null) {
      _invalidPulse = 1;
      _activeItemIndex = null;
      _dragPosition = null;
      return;
    }

    final result = sceneController.submitDrop(
      hotspotIndex: itemIndex,
      targetId: targetId,
      action: MiniGameSceneAction.drop,
    );
    _lastDropPosition = dropPosition;
    _lastDropAccepted = result?.isCorrect ?? false;
    _dropPulse = 1;
    if (result == null || !result.isCorrect) {
      _invalidPulse = 1;
    }
    _activeItemIndex = null;
    _dragPosition = null;
  }

  int? _itemIndexAt(Offset point, Size canvasSize) {
    final centers = _itemCentersFor(canvasSize);
    for (var index = centers.length - 1; index >= 0; index -= 1) {
      final rect = Rect.fromCenter(
        center: centers[index],
        width: 104,
        height: 76,
      );
      if (rect.inflate(12).contains(point)) {
        return index;
      }
    }
    return null;
  }

  String? _targetIdAt(Offset point, Size canvasSize) {
    final rects = _targetRectsFor(canvasSize);
    for (final entry in rects.entries) {
      if (entry.value.contains(point)) {
        return entry.key;
      }
    }
    return null;
  }

  Map<String, Rect> _targetRectsFor(Size canvasSize) {
    final targets = _round.dropTargets;
    if (targets.isEmpty) {
      return const {};
    }

    if (_isSortLab && targets.length > 1) {
      final y = canvasSize.height * 0.43;
      final width = math.min(142.0, canvasSize.width * 0.34);
      const height = 104.0;
      return {
        targets[0].id: Rect.fromCenter(
          center: Offset(canvasSize.width * 0.31, y),
          width: width,
          height: height,
        ),
        targets[1].id: Rect.fromCenter(
          center: Offset(canvasSize.width * 0.69, y),
          width: width,
          height: height,
        ),
      };
    }

    final target = targets.first;
    return {
      target.id: Rect.fromCenter(
        center: Offset(canvasSize.width * 0.5, canvasSize.height * 0.42),
        width: math.min(210.0, canvasSize.width * 0.54),
        height: 126,
      ),
    };
  }

  List<Offset> _itemCentersFor(Size canvasSize) {
    final count = _round.choiceIds.length;
    if (count == 0) {
      return const [];
    }

    final y = canvasSize.height * 0.68;
    final startX = canvasSize.width * 0.22;
    final endX = canvasSize.width * 0.78;
    if (count == 1) {
      return [Offset(canvasSize.width / 2, y)];
    }
    return [
      for (var index = 0; index < count; index += 1)
        Offset(
          startX + (endX - startX) * index / (count - 1),
          y + math.sin(_elapsed * 1.6 + index) * 5,
        ),
    ];
  }

  void _drawBackdrop(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height * 0.43);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: _isSortLab
            ? const [
                Color(0x6668D391),
                Color(0x22E9C46A),
                Colors.transparent,
              ]
            : const [
                Color(0x66FF6F7D),
                Color(0x2242F4D2),
                Colors.transparent,
              ],
      ).createShader(
        Rect.fromCircle(center: center, radius: canvasSize.shortestSide * 0.62),
      );
    canvas.drawCircle(center, canvasSize.shortestSide * 0.62, glowPaint);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = Colors.white.withValues(alpha: 0.10);
    for (var index = 0; index < 7; index += 1) {
      final y = canvasSize.height * (0.18 + index * 0.075);
      canvas.drawLine(
        Offset(canvasSize.width * 0.08, y),
        Offset(
          canvasSize.width * 0.92,
          y + math.sin(_elapsed * 0.8 + index) * 12,
        ),
        linePaint,
      );
    }
  }

  void _drawTargets(Canvas canvas, Size canvasSize) {
    final targetRects = _targetRectsFor(canvasSize);
    if (targetRects.isEmpty) {
      return;
    }

    if (_isSortLab) {
      _drawSortTargets(canvas, targetRects);
    } else {
      _drawBalanceTarget(canvas, canvasSize, targetRects.values.first);
    }

    if (_lastDropPosition != null && _dropPulse > 0) {
      canvas.drawCircle(
        _lastDropPosition!,
        18 + _dropPulse * 34,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = (_lastDropAccepted
                  ? const Color(0xFF42F4D2)
                  : const Color(0xFFFF6F7D))
              .withValues(alpha: _dropPulse),
      );
    }
  }

  void _drawBalanceTarget(
    Canvas canvas,
    Size canvasSize,
    Rect targetRect,
  ) {
    final center = targetRect.center;
    final tilt = math.sin(_elapsed * 1.2) * 0.04 - _invalidPulse * 0.08;
    final beamPaint = Paint()
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFD15C);
    canvas.save();
    canvas.translate(center.dx, center.dy - 8);
    canvas.rotate(tilt);
    canvas.drawLine(
      Offset(-targetRect.width * 0.42, 0),
      Offset(targetRect.width * 0.42, 0),
      beamPaint,
    );
    _drawBalanceClueObjects(canvas, targetRect);
    canvas.restore();

    _drawTargetLabel(
      canvas,
      targetRect,
      _round.dropTargets.first.label,
      const Color(0xFFFFD15C),
    );
  }

  void _drawBalanceClueObjects(Canvas canvas, Rect targetRect) {
    final prompt = definition.prompt.toLowerCase();
    if (prompt.contains('two apples') && prompt.contains('one pear')) {
      _drawScaleGroup(
        canvas,
        center: Offset(-targetRect.width * 0.32, 36),
        objects: const ['apple', 'apple'],
      );
      _drawScaleGroup(
        canvas,
        center: Offset(targetRect.width * 0.32, 36),
        objects: const ['pear'],
      );
      return;
    }

    if (prompt.contains('3 stars') && prompt.contains('2 stars')) {
      _drawScaleGroup(
        canvas,
        center: Offset(-targetRect.width * 0.32, 36),
        objects: const ['star', 'star', 'star'],
      );
      _drawScaleGroup(
        canvas,
        center: Offset(targetRect.width * 0.32, 36),
        objects: const ['star', 'star'],
      );
      return;
    }

    if (prompt.contains('big cube') || prompt.contains('small cubes')) {
      _drawScaleGroup(
        canvas,
        center: Offset(-targetRect.width * 0.32, 36),
        objects: const ['cube'],
        size: 36,
      );
      _drawScaleGroup(
        canvas,
        center: Offset(targetRect.width * 0.32, 36),
        objects: const ['cube', 'cube', 'cube'],
        size: 25,
      );
      return;
    }

    final choiceIds = _round.choiceIds;
    _drawScaleGroup(
      canvas,
      center: Offset(-targetRect.width * 0.32, 36),
      objects: choiceIds.isEmpty ? const ['left'] : [choiceIds.first],
    );
    _drawScaleGroup(
      canvas,
      center: Offset(targetRect.width * 0.32, 36),
      objects: choiceIds.length < 2 ? const ['right'] : [choiceIds[1]],
    );
  }

  void _drawScaleGroup(
    Canvas canvas, {
    required Offset center,
    required List<String> objects,
    double size = 28,
  }) {
    final width = math.max(1, objects.length) * size * 0.58;
    for (var index = 0; index < objects.length; index += 1) {
      final choiceId = objects[index];
      final itemCenter = center.translate(
        -width / 2 + index * size * 0.58 + size * 0.29,
        objects.length > 2 && index.isOdd ? -size * 0.18 : 0,
      );
      MiniGameCanvasVisuals.drawChoiceGlyph(
        canvas,
        center: itemCenter,
        choiceId: choiceId,
        label: choiceId,
        color: MiniGameCanvasVisuals.colorForChoice(choiceId, index),
        size: size,
      );
    }
  }

  void _drawSortTargets(Canvas canvas, Map<String, Rect> targetRects) {
    final targetsById = {
      for (final target in _round.dropTargets) target.id: target,
    };
    var index = 0;
    for (final entry in targetRects.entries) {
      final rect = entry.value;
      final target = targetsById[entry.key];
      final color =
          index == 0 ? const Color(0xFF68D391) : const Color(0xFFE9C46A);
      final basket = RRect.fromRectAndRadius(
        rect.translate(0, 8),
        const Radius.circular(20),
      );
      canvas.drawRRect(
        basket,
        Paint()..color = color.withValues(alpha: 0.32),
      );
      canvas.drawRRect(
        basket,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = color.withValues(alpha: 0.82),
      );
      canvas.drawLine(
        rect.topLeft + const Offset(18, 18),
        rect.topRight + const Offset(-18, 18),
        Paint()
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withValues(alpha: 0.44),
      );
      _drawTargetLabel(canvas, rect, target?.label ?? entry.key, color);
      index += 1;
    }
  }

  void _drawTargetLabel(
    Canvas canvas,
    Rect rect,
    String label,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: rect.width - 16);
    textPainter.paint(
      canvas,
      Offset(
        rect.center.dx - textPainter.width / 2,
        rect.bottom + 8,
      ),
    );
    canvas.drawCircle(
      Offset(rect.center.dx, rect.top + 12),
      6,
      Paint()..color = color,
    );
  }

  void _drawDraggableItems(Canvas canvas, Size canvasSize) {
    final centers = _itemCentersFor(canvasSize);
    for (var index = 0; index < centers.length; index += 1) {
      if (_activeItemIndex == index) {
        continue;
      }
      _drawItemCard(
        canvas,
        center: centers[index],
        choiceId: _round.choiceIds[index],
        index: index,
        dragging: false,
      );
    }

    final activeIndex = _activeItemIndex;
    final dragPosition = _dragPosition;
    if (activeIndex != null && dragPosition != null) {
      _drawItemCard(
        canvas,
        center: dragPosition,
        choiceId: _round.choiceIds[activeIndex],
        index: activeIndex,
        dragging: true,
      );
    }
  }

  void _drawItemCard(
    Canvas canvas, {
    required Offset center,
    required String choiceId,
    required int index,
    required bool dragging,
  }) {
    final selected = choiceId == sceneController.selectedChoiceId;
    final color = _itemColor(index);
    final lift = dragging ? 16.0 : 0.0;
    final pulse = selected ? 1.0 : 0.0;
    final rect = Rect.fromCenter(
      center: center.translate(0, -lift),
      width: dragging ? 116 : 104,
      height: dragging ? 82 : 74,
    );
    final rounded = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(20),
    );

    canvas.drawShadow(
      Path()..addRRect(rounded),
      Colors.black.withValues(alpha: dragging ? 0.44 : 0.28),
      dragging ? 18 : 10,
      true,
    );
    canvas.drawRRect(
      rounded,
      Paint()
        ..color = color.withValues(
          alpha: dragging ? 0.96 : 0.80,
        ),
    );
    canvas.drawRRect(
      rounded,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected || dragging ? 4 : 2
        ..color = Colors.white.withValues(
          alpha: selected || dragging ? 0.82 : 0.30,
        ),
    );

    final label = _round.labelForChoice(choiceId);
    _drawItemSymbol(
      canvas,
      rect.center.translate(0, -9),
      choiceId: choiceId,
      label: label,
      index: index,
      color: color,
    );
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF07132F),
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '...',
    )..layout(maxWidth: rect.width - 16);
    textPainter.paint(
      canvas,
      Offset(
        rect.center.dx - textPainter.width / 2,
        rect.bottom - textPainter.height - 8,
      ),
    );

    if (_invalidPulse > 0 && selected) {
      canvas.drawRRect(
        rounded.inflate(_invalidPulse * 8),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0xFFFF6F7D).withValues(alpha: _invalidPulse),
      );
    }

    if (pulse > 0) {
      canvas.drawCircle(
        rect.topRight - const Offset(12, -12),
        12,
        Paint()..color = Colors.white.withValues(alpha: 0.78),
      );
    }
  }

  void _drawItemSymbol(
    Canvas canvas,
    Offset center, {
    required String choiceId,
    required String label,
    required int index,
    required Color color,
  }) {
    if (_isSortLab) {
      MiniGameCanvasVisuals.drawChoiceGlyph(
        canvas,
        center: center,
        choiceId: choiceId,
        label: label,
        color: const Color(0xFF07132F),
        size: 38,
        highContrast: true,
      );
      return;
    }

    MiniGameCanvasVisuals.drawChoiceGlyph(
      canvas,
      center: center,
      choiceId: choiceId,
      label: label,
      color: const Color(0xFF07132F),
      size: 38,
      highContrast: true,
    );
  }

  Color _itemColor(int index) {
    if (index >= 0 && index < _round.choiceIds.length) {
      return MiniGameCanvasVisuals.colorForChoice(
          _round.choiceIds[index], index);
    }
    final palette = _isSortLab
        ? const [
            Color(0xFF68D391),
            Color(0xFFE9C46A),
            Color(0xFF42F4D2),
          ]
        : const [
            Color(0xFFFF6F7D),
            Color(0xFFFFD15C),
            Color(0xFF42F4D2),
          ];
    return palette[index % palette.length];
  }

  void _drawInstruction(Canvas canvas, Size canvasSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _round.goal,
        style: const TextStyle(
          color: Color(0xFFC6D0FF),
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '...',
    )..layout(maxWidth: canvasSize.width - 48);

    textPainter.paint(
      canvas,
      Offset(
        (canvasSize.width - textPainter.width) / 2,
        canvasSize.height - 98,
      ),
    );
  }
}
