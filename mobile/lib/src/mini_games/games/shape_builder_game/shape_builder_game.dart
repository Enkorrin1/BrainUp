import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_canvas_interaction.dart';
import '../../core/mini_game_definition.dart';
import '../../core/mini_game_scene_controller.dart';

class ShapeBuilderGame extends FlameGame with DragCallbacks, TapCallbacks {
  ShapeBuilderGame({
    required this.definition,
    required this.sceneController,
  });

  final MiniGameDefinition definition;
  final MiniGameSceneController sceneController;
  double _elapsed = 0;
  double _snapPulse = 0;
  double _invalidPulse = 0;
  int? _draggingPieceIndex;
  Offset? _draggedPieceCenter;

  @override
  Color backgroundColor() {
    return const Color(0xFF07132F);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _snapPulse = math.max(0, _snapPulse - dt * 2.8);
    _invalidPulse = math.max(0, _invalidPulse - dt * 3.4);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final canvasSize = Size(size.x, size.y);
    final center = Offset(canvasSize.width / 2, canvasSize.height * 0.42);
    _drawShapeGarden(canvas, canvasSize, center);
    _drawBuilderShape(canvas, center, canvasSize.shortestSide);
    _drawDropSocket(canvas, canvasSize);
    _drawPieces(canvas, canvasSize);
    _drawLabel(canvas, canvasSize);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final point = Offset(event.canvasPosition.x, event.canvasPosition.y);
    final pieces = _pieceCentersFor(Size(size.x, size.y));
    for (var index = 0; index < pieces.length; index += 1) {
      if ((point - pieces[index]).distance <= 54) {
        final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
          definition: definition,
          hotspotIndex: index,
        );
        if (choiceId == null) {
          return;
        }
        _snapPulse = 1;
        sceneController.submitHotspot(
          index,
          action: MiniGameSceneAction.snap,
        );
        return;
      }
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final point = Offset(event.canvasPosition.x, event.canvasPosition.y);
    final pieceIndex = _pieceIndexAt(point, Size(size.x, size.y));
    if (pieceIndex == null) {
      return;
    }

    _draggingPieceIndex = pieceIndex;
    _draggedPieceCenter = point;
    sceneController.recordDragStart(pieceIndex);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (_draggingPieceIndex == null) {
      return;
    }
    _draggedPieceCenter = Offset(
      event.canvasEndPosition.x,
      event.canvasEndPosition.y,
    );
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    final pieceIndex = _draggingPieceIndex;
    final dropPoint = _draggedPieceCenter;
    if (pieceIndex == null || dropPoint == null) {
      _clearDrag();
      return;
    }

    if (!_shapeSocketRectFor(Size(size.x, size.y)).contains(dropPoint)) {
      _invalidPulse = 1;
      _clearDrag();
      return;
    }

    final result = sceneController.submitDrop(
      hotspotIndex: pieceIndex,
      targetId: 'target.shape_socket',
      action: MiniGameSceneAction.snap,
    );
    _snapPulse = 1;
    if (result == null || !result.isCorrect) {
      _invalidPulse = 1;
    }
    _clearDrag();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _clearDrag();
  }

  void _clearDrag() {
    _draggingPieceIndex = null;
    _draggedPieceCenter = null;
  }

  void _drawShapeGarden(Canvas canvas, Size canvasSize, Offset center) {
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0x669C6AF2),
          Color(0x1142F4D2),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: canvasSize.shortestSide * 0.56),
      );
    canvas.drawCircle(center, canvasSize.shortestSide * 0.56, glowPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withValues(alpha: 0.12);
    for (var index = 0; index < 3; index += 1) {
      canvas.drawCircle(
        center,
        canvasSize.shortestSide * (0.18 + index * 0.12),
        ringPaint,
      );
    }
  }

  void _drawBuilderShape(Canvas canvas, Offset center, double shortestSide) {
    final radius = math.min(118.0, shortestSide * 0.22);
    const sides = 5;
    final rotation = _elapsed * 0.7;
    final path = Path();
    for (var index = 0; index < sides; index += 1) {
      final angle = rotation + index * math.pi * 2 / sides - math.pi / 2;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF9C6AF2),
          Color(0xFF42F4D2),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..color = const Color(0xFFFFD15C);

    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.45), 18, true);
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);

    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withValues(alpha: 0.32);
    canvas.drawCircle(center, radius * 0.48, innerPaint);
  }

  void _drawDropSocket(Canvas canvas, Size canvasSize) {
    final socketRect = _shapeSocketRectFor(canvasSize);
    final socket = RRect.fromRectAndRadius(
      socketRect,
      const Radius.circular(28),
    );
    canvas.drawRRect(
      socket,
      Paint()..color = const Color(0x229C6AF2),
    );
    canvas.drawRRect(
      socket,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 + _snapPulse * 3
        ..color = (_invalidPulse > 0
                ? const Color(0xFFFF6F7D)
                : const Color(0xFFFFD15C))
            .withValues(alpha: 0.36 + _snapPulse * 0.28 + _invalidPulse * 0.32),
    );

    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'DROP',
        style: TextStyle(
          color: Color(0xFFC6D0FF),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: socketRect.width);
    textPainter.paint(
      canvas,
      Offset(
        socketRect.center.dx - textPainter.width / 2,
        socketRect.bottom + 8,
      ),
    );
  }

  void _drawPieces(Canvas canvas, Size canvasSize) {
    final pieces = _pieceCentersFor(canvasSize);
    final buildTarget = Offset(canvasSize.width / 2, canvasSize.height * 0.42);
    for (var index = 0; index < pieces.length; index += 1) {
      final dragging = _draggingPieceIndex == index;
      final center = dragging && _draggedPieceCenter != null
          ? _draggedPieceCenter!
          : pieces[index];
      final choiceId = MiniGameCanvasInteraction.choiceIdForHotspot(
        definition: definition,
        hotspotIndex: index,
      );
      final selected =
          choiceId != null && choiceId == sceneController.selectedChoiceId;
      final snap = selected ? _snapPulse : 0.0;
      final displayCenter =
          dragging ? center : Offset.lerp(center, buildTarget, snap * 0.22)!;
      final size = 46.0 +
          math.sin(_elapsed * 1.8 + index) * 4 +
          snap * 14 +
          (dragging ? 10 : 0);
      final rect = Rect.fromCenter(center: center, width: size, height: size);
      final paint = Paint()
        ..color = [
          const Color(0xFF42F4D2),
          const Color(0xFFFFD15C),
          const Color(0xFFFF6F7D),
        ][index]
            .withValues(alpha: 0.82);

      if (selected) {
        canvas.drawLine(
          displayCenter,
          buildTarget,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4
            ..strokeCap = StrokeCap.round
            ..color = const Color(0x66FFD15C),
        );
      }

      if (index == 1) {
        canvas.drawCircle(displayCenter, size / 2, paint);
      } else {
        canvas.save();
        canvas.translate(displayCenter.dx, displayCenter.dy);
        canvas.rotate(_elapsed * (index == 0 ? 0.8 : -0.8));
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: size, height: size),
            const Radius.circular(12),
          ),
          paint,
        );
        canvas.restore();
      }

      final outlineRect = Rect.fromCenter(
        center: displayCenter,
        width: rect.width,
        height: rect.height,
      ).inflate(selected ? 10 : 4);
      canvas.drawRect(
        outlineRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 4 : 1.5
          ..color = selected
              ? Colors.white.withValues(alpha: 0.76)
              : Colors.white.withValues(alpha: 0.10),
      );

      if (_invalidPulse > 0 && selected) {
        canvas.drawRect(
          outlineRect.inflate(_invalidPulse * 8),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3
            ..color = const Color(0xFFFF6F7D).withValues(alpha: _invalidPulse),
        );
      }
    }
  }

  List<Offset> _pieceCentersFor(Size canvasSize) {
    final y = canvasSize.height * 0.62;
    return [
      Offset(canvasSize.width * 0.24, y),
      Offset(canvasSize.width * 0.50, y + math.sin(_elapsed * 2) * 10),
      Offset(canvasSize.width * 0.76, y),
    ];
  }

  int? _pieceIndexAt(Offset point, Size canvasSize) {
    final pieces = _pieceCentersFor(canvasSize);
    for (var index = pieces.length - 1; index >= 0; index -= 1) {
      if ((point - pieces[index]).distance <= 58) {
        return index;
      }
    }
    return null;
  }

  Rect _shapeSocketRectFor(Size canvasSize) {
    return Rect.fromCenter(
      center: Offset(canvasSize.width / 2, canvasSize.height * 0.42),
      width: math.min(188.0, canvasSize.width * 0.48),
      height: math.min(188.0, canvasSize.width * 0.48),
    );
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
