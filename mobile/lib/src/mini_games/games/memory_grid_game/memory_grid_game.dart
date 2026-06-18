import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_canvas_interaction.dart';
import '../../core/mini_game_definition.dart';
import '../../core/mini_game_scene_controller.dart';

class MemoryGridGame extends FlameGame with TapCallbacks {
  MemoryGridGame({
    required this.definition,
    required this.sceneController,
  });

  final MiniGameDefinition definition;
  final MiniGameSceneController sceneController;
  double _elapsed = 0;
  int? _pressedTileIndex;
  double _pressPulse = 0;

  @override
  Color backgroundColor() {
    return const Color(0xFF07132F);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _pressPulse = math.max(0, _pressPulse - dt * 3.8);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final canvasSize = Size(size.x, size.y);
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0x6642F4D2),
          Color(0x119C6AF2),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: canvasSize.shortestSide * 0.58),
      );
    canvas.drawCircle(center, canvasSize.shortestSide * 0.58, glowPaint);

    _drawGrid(canvas, canvasSize);
    _drawOrbit(canvas, center, canvasSize.shortestSide);
    _drawLabel(canvas, canvasSize);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final point = Offset(event.canvasPosition.x, event.canvasPosition.y);
    final rects = _tileRectsFor(Size(size.x, size.y));
    for (var index = 0; index < rects.length; index += 1) {
      if (rects[index].contains(point)) {
        final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
          definition: definition,
          hotspotIndex: index,
        );
        if (choiceId == null) {
          return;
        }
        _pressedTileIndex = index;
        _pressPulse = 1;
        sceneController.submitHotspot(index);
        return;
      }
    }
  }

  void _drawGrid(Canvas canvas, Size canvasSize) {
    final rects = _tileRectsFor(canvasSize);

    for (var index = 0; index < rects.length; index += 1) {
      final pulse = 0.5 + 0.5 * math.sin(_elapsed * 2.2 + index);
      final rect = rects[index];
      final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
        definition: definition,
        hotspotIndex: index,
      );
      final selected =
          choiceId != null && choiceId == sceneController.selectedChoiceId;
      final pop = _pressedTileIndex == index ? _pressPulse : 0.0;
      final inflatedRect = rect.inflate(pop * 8);
      final rounded = RRect.fromRectAndRadius(
        inflatedRect,
        Radius.circular(rect.width * 0.22),
      );
      final paint = Paint()
        ..color = Color.lerp(
          const Color(0x3342F4D2),
          selected ? const Color(0xAA42F4D2) : const Color(0x669C6AF2),
          selected ? 1 : pulse,
        )!;
      final borderPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = selected ? 5 : 2
        ..color = Color.lerp(
          const Color(0x8842F4D2),
          selected ? Colors.white : const Color(0xFFFFD15C),
          selected ? 1 : pulse,
        )!;

      canvas.drawRRect(rounded, paint);
      canvas.drawRRect(rounded, borderPaint);
      if (selected) {
        canvas.drawCircle(
          inflatedRect.topRight - const Offset(10, -10),
          13,
          Paint()..color = const Color(0xFFFFD15C),
        );
      }
      _drawTileIcon(canvas, inflatedRect.center, index, pulse, selected);
    }
  }

  List<Rect> _tileRectsFor(Size canvasSize) {
    final choiceCount = definition.firstRound.choiceIds.length;
    if (choiceCount <= 3) {
      final tileWidth = math.min(
        118.0,
        (canvasSize.width - 56 - (choiceCount - 1) * 12) / choiceCount,
      );
      const tileHeight = 106.0;
      final totalWidth = tileWidth * choiceCount + (choiceCount - 1) * 12;
      final topLeft = Offset(
        (canvasSize.width - totalWidth) / 2,
        canvasSize.height * 0.43 - tileHeight / 2,
      );

      return [
        for (var index = 0; index < choiceCount; index += 1)
          Rect.fromLTWH(
            topLeft.dx + index * (tileWidth + 12),
            topLeft.dy,
            tileWidth,
            tileHeight,
          ),
      ];
    }

    if (choiceCount == 4) {
      final shortestSide = canvasSize.shortestSide;
      final tileSize = math.min(100.0, shortestSide / 3.2);
      final gap = tileSize * 0.18;
      final gridWidth = tileSize * 2 + gap;
      final topLeft = Offset(
        (canvasSize.width - gridWidth) / 2,
        (canvasSize.height - gridWidth) / 2 - 12,
      );

      return [
        for (var row = 0; row < 2; row += 1)
          for (var column = 0; column < 2; column += 1)
            Rect.fromLTWH(
              topLeft.dx + column * (tileSize + gap),
              topLeft.dy + row * (tileSize + gap),
              tileSize,
              tileSize,
            ),
      ];
    }

    final shortestSide = canvasSize.shortestSide;
    final tileSize = math.min(86.0, shortestSide / 4.2);
    final gap = tileSize * 0.16;
    final gridWidth = tileSize * 3 + gap * 2;
    final topLeft = Offset(
      (canvasSize.width - gridWidth) / 2,
      (canvasSize.height - gridWidth) / 2 - 12,
    );

    return [
      for (var row = 0; row < 3; row += 1)
        for (var column = 0; column < 3; column += 1)
          Rect.fromLTWH(
            topLeft.dx + column * (tileSize + gap),
            topLeft.dy + row * (tileSize + gap),
            tileSize,
            tileSize,
          ),
    ];
  }

  void _drawTileIcon(
    Canvas canvas,
    Offset center,
    int index,
    double pulse,
    bool selected,
  ) {
    final icons = ['+', '*', '#', '?', '='];
    final choiceIds = definition.firstRound.choiceIds;
    final choiceId = index < choiceIds.length ? choiceIds[index] : null;
    final label = choiceId == null
        ? icons[index % icons.length]
        : definition.firstRound.labelForChoice(choiceId);
    final visible =
        choiceId != null || selected || pulse > 0.34 || index.isEven;
    final textPainter = TextPainter(
      text: TextSpan(
        text: visible ? label : '?',
        style: TextStyle(
          color: Colors.white,
          fontSize: selected ? 18 : 15,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '...',
    )..layout(maxWidth: 78);

    final symbolPaint = Paint()
      ..color = selected
          ? const Color(0xFFFFD15C)
          : const Color(0xFF42F4D2).withValues(alpha: 0.84);
    canvas.drawCircle(
        center.translate(0, -22), selected ? 16 : 13, symbolPaint);
    canvas.drawCircle(
      center.translate(0, -22),
      selected ? 7 : 5,
      Paint()..color = const Color(0xFF07132F),
    );

    textPainter.paint(
      canvas,
      center.translate(0, 16) -
          Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  void _drawOrbit(Canvas canvas, Offset center, double shortestSide) {
    final radius = shortestSide * 0.33;
    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withValues(alpha: 0.12);
    canvas.drawCircle(center, radius, orbitPaint);

    final angle = _elapsed * 1.4;
    final dotCenter = Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
    final dotPaint = Paint()..color = const Color(0xFFFFD15C);
    canvas.drawCircle(dotCenter, 7, dotPaint);
  }

  void _drawLabel(Canvas canvas, Size canvasSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: definition.title,
        style: const TextStyle(
          color: Color(0xFFC6D0FF),
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: canvasSize.width - 40);

    textPainter.paint(
      canvas,
      Offset(
        (canvasSize.width - textPainter.width) / 2,
        canvasSize.height - 88,
      ),
    );
  }
}
