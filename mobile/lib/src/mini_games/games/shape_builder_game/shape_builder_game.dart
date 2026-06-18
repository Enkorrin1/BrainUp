import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_definition.dart';

class ShapeBuilderGame extends FlameGame {
  ShapeBuilderGame({required this.definition});

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
    final center = Offset(canvasSize.width / 2, canvasSize.height * 0.42);
    _drawShapeGarden(canvas, canvasSize, center);
    _drawBuilderShape(canvas, center, canvasSize.shortestSide);
    _drawPieces(canvas, canvasSize);
    _drawLabel(canvas, canvasSize);
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

  void _drawPieces(Canvas canvas, Size canvasSize) {
    final y = canvasSize.height * 0.62;
    final pieces = [
      Offset(canvasSize.width * 0.24, y),
      Offset(canvasSize.width * 0.50, y + math.sin(_elapsed * 2) * 10),
      Offset(canvasSize.width * 0.76, y),
    ];
    for (var index = 0; index < pieces.length; index += 1) {
      final center = pieces[index];
      final size = 46.0 + math.sin(_elapsed * 1.8 + index) * 4;
      final rect = Rect.fromCenter(center: center, width: size, height: size);
      final paint = Paint()
        ..color = [
          const Color(0xFF42F4D2),
          const Color(0xFFFFD15C),
          const Color(0xFFFF6F7D),
        ][index]
            .withValues(alpha: 0.82);

      if (index == 1) {
        canvas.drawCircle(center, size / 2, paint);
      } else {
        canvas.save();
        canvas.translate(center.dx, center.dy);
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

      canvas.drawRect(
        rect.inflate(4),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = Colors.white.withValues(alpha: 0.10),
      );
    }
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
