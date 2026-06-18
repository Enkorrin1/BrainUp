import 'dart:math' as math;

import 'package:flutter/material.dart';

class MiniGameCanvasVisuals {
  const MiniGameCanvasVisuals._();

  static void drawChoiceGlyph(
    Canvas canvas, {
    required Offset center,
    required String choiceId,
    required String label,
    required Color color,
    double size = 34,
    bool highContrast = false,
  }) {
    final key = _normalizedKey(choiceId);
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = highContrast ? const Color(0xFF07132F) : color;
    final accentPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = highContrast ? color : const Color(0xFF07132F);

    if (key.contains('apple')) {
      canvas.drawCircle(center.translate(-size * 0.12, 0), size * 0.34, paint);
      canvas.drawCircle(center.translate(size * 0.12, 0), size * 0.34, paint);
      canvas.drawOval(
        Rect.fromCenter(
          center: center.translate(size * 0.17, -size * 0.44),
          width: size * 0.32,
          height: size * 0.18,
        ),
        Paint()..color = const Color(0xFF68D391),
      );
      return;
    }

    if (key.contains('pear')) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center.translate(0, size * 0.08),
          width: size * 0.56,
          height: size * 0.74,
        ),
        paint,
      );
      canvas.drawCircle(center.translate(0, -size * 0.22), size * 0.22, paint);
      canvas.drawOval(
        Rect.fromCenter(
          center: center.translate(size * 0.16, -size * 0.52),
          width: size * 0.28,
          height: size * 0.16,
        ),
        Paint()..color = const Color(0xFF68D391),
      );
      return;
    }

    if (key.contains('banana')) {
      final path = Path()
        ..moveTo(center.dx - size * 0.44, center.dy + size * 0.10)
        ..quadraticBezierTo(
          center.dx,
          center.dy + size * 0.48,
          center.dx + size * 0.46,
          center.dy - size * 0.22,
        )
        ..quadraticBezierTo(
          center.dx,
          center.dy + size * 0.16,
          center.dx - size * 0.34,
          center.dy - size * 0.10,
        )
        ..close();
      canvas.drawPath(path, paint);
      return;
    }

    if (key.contains('rocket')) {
      final body = Path()
        ..moveTo(center.dx, center.dy - size * 0.52)
        ..lineTo(center.dx + size * 0.28, center.dy + size * 0.25)
        ..lineTo(center.dx, center.dy + size * 0.14)
        ..lineTo(center.dx - size * 0.28, center.dy + size * 0.25)
        ..close();
      canvas.drawPath(body, paint);
      canvas.drawCircle(center.translate(0, -size * 0.12), size * 0.11,
          Paint()..color = const Color(0xFF42F4D2));
      canvas.drawPath(
        Path()
          ..moveTo(center.dx - size * 0.13, center.dy + size * 0.22)
          ..lineTo(center.dx, center.dy + size * 0.52)
          ..lineTo(center.dx + size * 0.13, center.dy + size * 0.22)
          ..close(),
        Paint()..color = const Color(0xFFFFD15C),
      );
      return;
    }

    if (key.contains('planet')) {
      canvas.drawCircle(center, size * 0.32, paint);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(-0.35);
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset.zero, width: size * 0.9, height: size * 0.24),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(2, size * 0.08)
          ..color = const Color(0xFFFFD15C),
      );
      canvas.restore();
      return;
    }

    if (key.contains('star')) {
      canvas.drawPath(_starPath(center, size * 0.42), paint);
      return;
    }

    if (key.contains('lock')) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center.translate(0, size * 0.08),
            width: size * 0.62,
            height: size * 0.48,
          ),
          Radius.circular(size * 0.12),
        ),
        paint,
      );
      canvas.drawArc(
        Rect.fromCenter(
          center: center.translate(0, -size * 0.16),
          width: size * 0.44,
          height: size * 0.44,
        ),
        math.pi,
        math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(3, size * 0.1)
          ..color = paint.color,
      );
      return;
    }

    if (key.contains('key')) {
      canvas.drawCircle(center.translate(-size * 0.22, 0), size * 0.18, paint);
      canvas.drawLine(
        center.translate(-size * 0.04, 0),
        center.translate(size * 0.38, 0),
        Paint()
          ..strokeWidth = math.max(4, size * 0.12)
          ..strokeCap = StrokeCap.round
          ..color = paint.color,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: center.translate(size * 0.32, size * 0.13),
          width: size * 0.13,
          height: size * 0.18,
        ),
        paint,
      );
      return;
    }

    if (key.contains('shoe')) {
      final path = Path()
        ..moveTo(center.dx - size * 0.44, center.dy + size * 0.20)
        ..lineTo(center.dx + size * 0.32, center.dy + size * 0.20)
        ..quadraticBezierTo(
          center.dx + size * 0.50,
          center.dy + size * 0.14,
          center.dx + size * 0.40,
          center.dy,
        )
        ..lineTo(center.dx - size * 0.06, center.dy - size * 0.10)
        ..lineTo(center.dx - size * 0.26, center.dy - size * 0.28)
        ..lineTo(center.dx - size * 0.44, center.dy + size * 0.20)
        ..close();
      canvas.drawPath(path, paint);
      return;
    }

    if (key.contains('cloud')) {
      canvas.drawCircle(
          center.translate(-size * 0.20, size * 0.04), size * 0.22, paint);
      canvas.drawCircle(
          center.translate(size * 0.02, -size * 0.08), size * 0.28, paint);
      canvas.drawCircle(
          center.translate(size * 0.26, size * 0.05), size * 0.20, paint);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: center.translate(0, size * 0.12),
              width: size * 0.75,
              height: size * 0.26),
          Radius.circular(size * 0.14),
        ),
        paint,
      );
      return;
    }

    if (key.contains('cube') || key.contains('block')) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: center, width: size * 0.68, height: size * 0.60),
          Radius.circular(size * 0.12),
        ),
        paint,
      );
      canvas.drawLine(
        center.translate(-size * 0.22, -size * 0.08),
        center.translate(size * 0.22, -size * 0.08),
        Paint()
          ..strokeWidth = 2
          ..color = Colors.white.withValues(alpha: 0.35),
      );
      return;
    }

    if (key.contains('circle') || key.contains('ball')) {
      canvas.drawCircle(center, size * 0.34, paint);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: size * 0.24),
        -0.8,
        1.6,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withValues(alpha: 0.42),
      );
      return;
    }

    if (key.contains('square')) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: center, width: size * 0.66, height: size * 0.66),
          Radius.circular(size * 0.12),
        ),
        paint,
      );
      return;
    }

    if (key.contains('triangle')) {
      canvas.drawPath(
        Path()
          ..moveTo(center.dx, center.dy - size * 0.42)
          ..lineTo(center.dx + size * 0.42, center.dy + size * 0.34)
          ..lineTo(center.dx - size * 0.42, center.dy + size * 0.34)
          ..close(),
        paint,
      );
      return;
    }

    if (key.contains('rain') || key.contains('water')) {
      final dropPath = Path()
        ..moveTo(center.dx, center.dy - size * 0.42)
        ..quadraticBezierTo(
          center.dx + size * 0.36,
          center.dy,
          center.dx,
          center.dy + size * 0.40,
        )
        ..quadraticBezierTo(
          center.dx - size * 0.36,
          center.dy,
          center.dx,
          center.dy - size * 0.42,
        )
        ..close();
      canvas.drawPath(dropPath, paint);
      canvas.drawCircle(
        center.translate(size * 0.16, size * 0.08),
        size * 0.07,
        Paint()..color = Colors.white.withValues(alpha: 0.48),
      );
      return;
    }

    if (key.contains('moon')) {
      canvas.drawCircle(center, size * 0.36, paint);
      canvas.drawCircle(
        center.translate(size * 0.16, -size * 0.08),
        size * 0.34,
        Paint()..color = const Color(0xFF07132F),
      );
      return;
    }

    if (key.contains('sun')) {
      canvas.drawCircle(center, size * 0.28, paint);
      final rayPaint = Paint()
        ..strokeWidth = math.max(2, size * 0.07)
        ..strokeCap = StrokeCap.round
        ..color = paint.color;
      for (var index = 0; index < 8; index += 1) {
        final angle = index * math.pi / 4;
        canvas.drawLine(
          center.translate(
            math.cos(angle) * size * 0.40,
            math.sin(angle) * size * 0.40,
          ),
          center.translate(
            math.cos(angle) * size * 0.54,
            math.sin(angle) * size * 0.54,
          ),
          rayPaint,
        );
      }
      return;
    }

    if (key.contains('flower')) {
      for (var index = 0; index < 6; index += 1) {
        final angle = index * math.pi / 3;
        canvas.drawOval(
          Rect.fromCenter(
            center: center.translate(
              math.cos(angle) * size * 0.23,
              math.sin(angle) * size * 0.23,
            ),
            width: size * 0.28,
            height: size * 0.18,
          ),
          paint,
        );
      }
      canvas.drawCircle(
        center,
        size * 0.14,
        Paint()..color = const Color(0xFFFFD15C),
      );
      return;
    }

    if (key.contains('fish')) {
      canvas.drawOval(
        Rect.fromCenter(
            center: center, width: size * 0.72, height: size * 0.42),
        paint,
      );
      canvas.drawPath(
        Path()
          ..moveTo(center.dx + size * 0.36, center.dy)
          ..lineTo(center.dx + size * 0.58, center.dy - size * 0.22)
          ..lineTo(center.dx + size * 0.58, center.dy + size * 0.22)
          ..close(),
        paint,
      );
      canvas.drawCircle(
        center.translate(-size * 0.22, -size * 0.06),
        size * 0.04,
        accentPaint,
      );
      return;
    }

    if (key.contains('foot')) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center.translate(0, size * 0.10),
          width: size * 0.42,
          height: size * 0.68,
        ),
        paint,
      );
      for (var index = 0; index < 4; index += 1) {
        canvas.drawCircle(
          center.translate(-size * 0.18 + index * size * 0.12, -size * 0.30),
          size * (0.07 - index * 0.004),
          paint,
        );
      }
      return;
    }

    if (key.contains('leaf') || key.contains('carrot')) {
      canvas.drawOval(
        Rect.fromCenter(
            center: center, width: size * 0.42, height: size * 0.72),
        paint,
      );
      canvas.drawLine(
        center.translate(0, -size * 0.26),
        center.translate(0, size * 0.30),
        Paint()
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withValues(alpha: 0.48),
      );
      return;
    }

    if (key.contains('same')) {
      _drawCenteredText(canvas, center, '=', size * 0.95, paint.color);
      return;
    }

    if (key.contains('left')) {
      _drawCenteredText(canvas, center, '<', size * 0.74, paint.color);
      return;
    }

    if (key.contains('right')) {
      _drawCenteredText(canvas, center, '>', size * 0.74, paint.color);
      return;
    }

    _drawCenteredText(
      canvas,
      center,
      _fallbackToken(label.isEmpty ? choiceId : label),
      size * 0.42,
      accentPaint.color,
    );
  }

  static Color colorForChoice(String choiceId, int index) {
    final key = _normalizedKey(choiceId);
    if (key.contains('apple') ||
        key.contains('red') ||
        key.contains('flower')) {
      return const Color(0xFFFF6F7D);
    }
    if (key.contains('pear') ||
        key.contains('green') ||
        key.contains('leaf') ||
        key.contains('carrot')) {
      return const Color(0xFF68D391);
    }
    if (key.contains('banana') ||
        key.contains('star') ||
        key.contains('key') ||
        key.contains('sun')) {
      return const Color(0xFFFFD15C);
    }
    if (key.contains('rocket') ||
        key.contains('blue') ||
        key.contains('rain') ||
        key.contains('water')) {
      return const Color(0xFF42F4D2);
    }
    if (key.contains('planet') ||
        key.contains('shape') ||
        key.contains('moon') ||
        key.contains('fish') ||
        key.contains('foot')) {
      return const Color(0xFF9C6AF2);
    }
    const palette = [
      Color(0xFFFF6F7D),
      Color(0xFFFFD15C),
      Color(0xFF42F4D2),
      Color(0xFF68D391),
      Color(0xFF9C6AF2),
    ];
    return palette[index % palette.length];
  }

  static String _normalizedKey(String value) {
    var normalized = value.toLowerCase();
    const aliases = {
      'яблок': ' apple ',
      'груш': ' pear ',
      'банан': ' banana ',
      'мяч': ' ball ',
      'ракет': ' rocket ',
      'планет': ' planet ',
      'звезд': ' star ',
      'звёзд': ' star ',
      'лун': ' moon ',
      'солн': ' sun ',
      'дожд': ' rain ',
      'вод': ' water ',
      'облак': ' cloud ',
      'туч': ' cloud ',
      'ключ': ' key ',
      'зам': ' lock ',
      'ботин': ' shoe ',
      'стоп': ' foot ',
      'рыб': ' fish ',
      'цвет': ' flower ',
      'лист': ' leaf ',
      'морков': ' carrot ',
      'круг': ' circle ',
      'квадрат': ' square ',
      'треуг': ' triangle ',
      'куб': ' cube ',
      'лев': ' left ',
      'прав': ' right ',
      'одинак': ' same ',
    };
    for (final entry in aliases.entries) {
      if (normalized.contains(entry.key)) {
        normalized += entry.value;
      }
    }
    return normalized.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }

  static String _fallbackToken(String label) {
    final trimmed = label.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    if (trimmed.length <= 2) {
      return trimmed.toUpperCase();
    }
    return trimmed.substring(0, math.min(2, trimmed.length)).toUpperCase();
  }

  static void _drawCenteredText(
    Canvas canvas,
    Offset center,
    String text,
    double fontSize,
    Color color,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  static Path _starPath(Offset center, double radius) {
    final path = Path();
    for (var index = 0; index < 10; index += 1) {
      final currentRadius = index.isEven ? radius : radius * 0.45;
      final angle = -math.pi / 2 + index * math.pi / 5;
      final point = Offset(
        center.dx + math.cos(angle) * currentRadius,
        center.dy + math.sin(angle) * currentRadius,
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }
}
