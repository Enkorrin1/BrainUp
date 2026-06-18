import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_definition.dart';

class LogicPathGame extends FlameGame {
  LogicPathGame({required this.definition});

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
    _drawCircuitBackdrop(canvas, canvasSize, center);
    _drawPath(canvas, canvasSize);
    _drawLabel(canvas, canvasSize);
  }

  void _drawCircuitBackdrop(Canvas canvas, Size canvasSize, Offset center) {
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0x55FFD15C),
          Color(0x2242F4D2),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: canvasSize.shortestSide * 0.55),
      );
    canvas.drawCircle(center, canvasSize.shortestSide * 0.55, glowPaint);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.10);
    for (var index = 0; index < 6; index += 1) {
      final y = canvasSize.height * (0.22 + index * 0.08);
      canvas.drawLine(
        Offset(canvasSize.width * 0.1, y),
        Offset(canvasSize.width * 0.9, y + math.sin(_elapsed + index) * 16),
        linePaint,
      );
    }
  }

  void _drawPath(Canvas canvas, Size canvasSize) {
    final points = [
      Offset(canvasSize.width * 0.18, canvasSize.height * 0.46),
      Offset(canvasSize.width * 0.36, canvasSize.height * 0.36),
      Offset(canvasSize.width * 0.54, canvasSize.height * 0.48),
      Offset(canvasSize.width * 0.72, canvasSize.height * 0.38),
      Offset(canvasSize.width * 0.84, canvasSize.height * 0.50),
    ];
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index += 1) {
      path.lineTo(points[index].dx, points[index].dy);
    }

    final shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round
      ..color = const Color(0x2242F4D2);
    final pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xFFFFD15C);
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, pathPaint);

    for (var index = 0; index < points.length; index += 1) {
      _drawNode(canvas, points[index], index);
    }

    final progress = (_elapsed * 0.34) % 1;
    final tracerIndex = (progress * (points.length - 1)).floor();
    final localT = (progress * (points.length - 1)) - tracerIndex;
    final start = points[tracerIndex];
    final end = points[math.min(tracerIndex + 1, points.length - 1)];
    final tracer = Offset.lerp(start, end, localT)!;
    final tracerPaint = Paint()..color = const Color(0xFF42F4D2);
    canvas.drawCircle(tracer, 12, tracerPaint);
    canvas.drawCircle(
      tracer,
      22,
      Paint()..color = const Color(0x3342F4D2),
    );
  }

  void _drawNode(Canvas canvas, Offset center, int index) {
    final active = math.sin(_elapsed * 2 + index) > 0.15;
    final fillPaint = Paint()
      ..color = active ? const Color(0xFF42F4D2) : const Color(0xFF273B78);
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFFFFD15C);
    canvas.drawCircle(center, 18, fillPaint);
    canvas.drawCircle(center, 18, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${index + 1}',
        style: const TextStyle(
          color: Color(0xFF07132F),
          fontSize: 14,
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
