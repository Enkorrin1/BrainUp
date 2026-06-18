import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_definition.dart';

class BossMixGame extends FlameGame {
  BossMixGame({required this.definition});

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
    _drawBossBackdrop(canvas, canvasSize, center);
    _drawGate(canvas, center, canvasSize.shortestSide);
    _drawStepOrbs(canvas, canvasSize);
    _drawRewardHint(canvas, canvasSize);
  }

  void _drawBossBackdrop(Canvas canvas, Size canvasSize, Offset center) {
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0x66FF6F7D),
          Color(0x3342F4D2),
          Color(0x119C6AF2),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: canvasSize.shortestSide * 0.62),
      );
    canvas.drawCircle(center, canvasSize.shortestSide * 0.62, glowPaint);

    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.18);
    for (var index = 0; index < 22; index += 1) {
      final angle = index * math.pi * 2 / 22 + _elapsed * 0.08;
      final radius = canvasSize.shortestSide * (0.2 + (index % 5) * 0.07);
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      canvas.drawCircle(point, 1.6 + (index % 3), starPaint);
    }
  }

  void _drawGate(Canvas canvas, Offset center, double shortestSide) {
    final gateRadius = math.min(142.0, shortestSide * 0.28);
    for (var ring = 0; ring < 3; ring += 1) {
      final pulse = 0.5 + 0.5 * math.sin(_elapsed * 1.7 + ring);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9 - ring * 2
        ..color = [
          const Color(0xFFFF6F7D),
          const Color(0xFFFFD15C),
          const Color(0xFF42F4D2),
        ][ring]
            .withValues(alpha: 0.38 + pulse * 0.32);
      canvas.drawCircle(center, gateRadius - ring * 26, paint);
    }

    final doorPath = Path();
    const sides = 6;
    for (var index = 0; index < sides; index += 1) {
      final angle = _elapsed * 0.18 + index * math.pi * 2 / sides;
      final point = Offset(
        center.dx + math.cos(angle) * gateRadius * 0.52,
        center.dy + math.sin(angle) * gateRadius * 0.52,
      );
      if (index == 0) {
        doorPath.moveTo(point.dx, point.dy);
      } else {
        doorPath.lineTo(point.dx, point.dy);
      }
    }
    doorPath.close();
    canvas.drawShadow(doorPath, Colors.black.withValues(alpha: 0.44), 18, true);
    canvas.drawPath(
      doorPath,
      Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF42F4D2),
            Color(0xFF9C6AF2),
            Color(0xFFFF6F7D),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: gateRadius),
        ),
    );
  }

  void _drawStepOrbs(Canvas canvas, Size canvasSize) {
    final y = canvasSize.height * 0.66;
    const labels = ['MEM', 'LOGIC', 'FINAL'];
    for (var index = 0; index < labels.length; index += 1) {
      final x = canvasSize.width * (0.24 + index * 0.26);
      final center = Offset(x, y + math.sin(_elapsed * 1.4 + index) * 6);
      final active = index <= (_elapsed / 3).floor() % labels.length;
      final color = [
        const Color(0xFF42F4D2),
        const Color(0xFFFFD15C),
        const Color(0xFFFF6F7D),
      ][index];
      canvas.drawCircle(
        center,
        active ? 25 : 21,
        Paint()..color = color.withValues(alpha: active ? 0.78 : 0.38),
      );
      canvas.drawCircle(
        center,
        29,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withValues(alpha: 0.22),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[index],
          style: const TextStyle(
            color: Color(0xFF07132F),
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 58);
      textPainter.paint(
        canvas,
        center - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  void _drawRewardHint(Canvas canvas, Size canvasSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: definition.firstRound.goal,
        style: const TextStyle(
          color: Color(0xFFC6D0FF),
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
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
