import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_definition.dart';

class MemoryGridGame extends FlameGame {
  MemoryGridGame({required this.definition});

  final MiniGameDefinition definition;
  double _elapsed = 0;

  @override
  Color backgroundColor() {
    return const Color(0xFF07132F);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
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

  void _drawGrid(Canvas canvas, Size canvasSize) {
    final shortestSide = canvasSize.shortestSide;
    final tileSize = math.min(86.0, shortestSide / 4.2);
    final gap = tileSize * 0.16;
    final gridWidth = tileSize * 3 + gap * 2;
    final topLeft = Offset(
      (canvasSize.width - gridWidth) / 2,
      (canvasSize.height - gridWidth) / 2 - 12,
    );

    for (var row = 0; row < 3; row += 1) {
      for (var column = 0; column < 3; column += 1) {
        final index = row * 3 + column;
        final pulse = 0.5 + 0.5 * math.sin(_elapsed * 2.2 + index);
        final rect = Rect.fromLTWH(
          topLeft.dx + column * (tileSize + gap),
          topLeft.dy + row * (tileSize + gap),
          tileSize,
          tileSize,
        );
        final rounded = RRect.fromRectAndRadius(
          rect,
          Radius.circular(tileSize * 0.22),
        );
        final paint = Paint()
          ..color = Color.lerp(
            const Color(0x3342F4D2),
            const Color(0x669C6AF2),
            pulse,
          )!;
        final borderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Color.lerp(
            const Color(0x8842F4D2),
            const Color(0xFFFFD15C),
            pulse,
          )!;

        canvas.drawRRect(rounded, paint);
        canvas.drawRRect(rounded, borderPaint);
        _drawTileIcon(canvas, rect.center, index, pulse);
      }
    }
  }

  void _drawTileIcon(Canvas canvas, Offset center, int index, double pulse) {
    final icons = ['+', '*', '#', '?', '='];
    final visible = pulse > 0.34 || index.isEven;
    final textPainter = TextPainter(
      text: TextSpan(
        text: visible ? icons[index % icons.length] : '?',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
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
