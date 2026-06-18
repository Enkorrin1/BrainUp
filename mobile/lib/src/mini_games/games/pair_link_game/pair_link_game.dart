import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_canvas_visuals.dart';
import '../../core/mini_game_definition.dart';
import '../../core/mini_game_scene_controller.dart';

class PairLinkGame extends FlameGame with TapCallbacks {
  PairLinkGame({
    required this.definition,
    required this.sceneController,
  });

  final MiniGameDefinition definition;
  final MiniGameSceneController sceneController;
  double _elapsed = 0;
  double _tapPulse = 0;
  int? _pressedChoiceIndex;

  MiniGameRoundDefinition get _round {
    return definition.firstRound;
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF07132F);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _tapPulse = math.max(0, _tapPulse - dt * 3.4);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final canvasSize = Size(size.x, size.y);
    _drawBackdrop(canvas, canvasSize);
    _drawConnector(canvas, canvasSize);
    _drawClue(canvas, canvasSize);
    _drawChoices(canvas, canvasSize);
    _drawInstruction(canvas, canvasSize);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final point = Offset(event.canvasPosition.x, event.canvasPosition.y);
    final rects = _choiceRectsFor(Size(size.x, size.y));
    for (var index = 0; index < rects.length; index += 1) {
      if (rects[index].contains(point)) {
        _pressedChoiceIndex = index;
        _tapPulse = 1;
        sceneController.submitHotspot(index);
        return;
      }
    }
  }

  void _drawBackdrop(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width * 0.45, canvasSize.height * 0.42);
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0x66FFD15C),
          Color(0x2242F4D2),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: canvasSize.shortestSide * 0.6),
      );
    canvas.drawCircle(center, canvasSize.shortestSide * 0.6, glowPaint);

    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.12);
    for (var index = 0; index < 18; index += 1) {
      final angle = index * math.pi * 2 / 18 + _elapsed * 0.15;
      final radius = canvasSize.shortestSide * (0.18 + (index % 4) * 0.055);
      canvas.drawCircle(
        Offset(
          center.dx + math.cos(angle) * radius,
          center.dy + math.sin(angle) * radius,
        ),
        2.5 + (index % 3),
        dotPaint,
      );
    }
  }

  void _drawConnector(Canvas canvas, Size canvasSize) {
    final clueRect = _clueRectFor(canvasSize);
    final choiceRects = _choiceRectsFor(canvasSize);
    final selectedChoiceId = sceneController.selectedChoiceId;
    final selectedIndex = selectedChoiceId == null
        ? null
        : _round.choiceIds.indexOf(selectedChoiceId);
    if (choiceRects.isEmpty) {
      return;
    }
    final fallbackIndex =
        (_pressedChoiceIndex ?? 1).clamp(0, choiceRects.length - 1).toInt();
    final targetIndex = selectedIndex == null || selectedIndex < 0
        ? fallbackIndex
        : selectedIndex;

    final start = clueRect.centerRight.translate(-8, 0);
    final end = choiceRects[targetIndex].centerLeft.translate(8, 0);
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(
        canvasSize.width * 0.48,
        start.dy + math.sin(_elapsed * 2) * 24,
        canvasSize.width * 0.58,
        end.dy - math.cos(_elapsed * 2) * 22,
        end.dx,
        end.dy,
      );
    final solved = selectedIndex != null && selectedIndex >= 0;
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = solved ? 8 : 5
        ..color = (solved ? const Color(0xFF42F4D2) : const Color(0xFFFFD15C))
            .withValues(alpha: solved ? 0.84 : 0.46),
    );
  }

  void _drawClue(Canvas canvas, Size canvasSize) {
    final rect = _clueRectFor(canvasSize);
    final clue = _clueLabel;
    final color = MiniGameCanvasVisuals.colorForChoice(clue, 0);
    final rounded = RRect.fromRectAndRadius(rect, const Radius.circular(28));
    canvas.drawShadow(
      Path()..addRRect(rounded),
      Colors.black.withValues(alpha: 0.36),
      16,
      true,
    );
    canvas.drawRRect(
      rounded,
      Paint()..color = const Color(0xFF172B5F).withValues(alpha: 0.94),
    );
    canvas.drawRRect(
      rounded,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = color.withValues(alpha: 0.70),
    );

    MiniGameCanvasVisuals.drawChoiceGlyph(
      canvas,
      center: rect.center.translate(0, -18),
      choiceId: clue,
      label: clue,
      color: color,
      size: 58,
    );
    _drawCenteredText(
      canvas,
      rect.center.translate(0, 34),
      clue,
      maxWidth: rect.width - 20,
      fontSize: 17,
      color: Colors.white,
    );
  }

  void _drawChoices(Canvas canvas, Size canvasSize) {
    final rects = _choiceRectsFor(canvasSize);
    for (var index = 0; index < rects.length; index += 1) {
      final choiceId = _round.choiceIds[index];
      final selected = sceneController.selectedChoiceId == choiceId;
      final pressed = _pressedChoiceIndex == index ? _tapPulse : 0.0;
      final rect = rects[index].inflate(selected ? 5 : pressed * 6);
      final color = MiniGameCanvasVisuals.colorForChoice(choiceId, index + 1);
      final rounded = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(22),
      );
      canvas.drawShadow(
        Path()..addRRect(rounded),
        Colors.black.withValues(alpha: selected ? 0.42 : 0.26),
        selected ? 16 : 9,
        true,
      );
      canvas.drawRRect(
        rounded,
        Paint()
          ..color = Color.lerp(
            const Color(0xFF24386D),
            color,
            selected ? 0.62 : 0.24,
          )!,
      );
      canvas.drawRRect(
        rounded,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 4 : 2
          ..color = (selected ? Colors.white : color).withValues(alpha: 0.76),
      );
      MiniGameCanvasVisuals.drawChoiceGlyph(
        canvas,
        center: rect.centerLeft.translate(34, 0),
        choiceId: choiceId,
        label: _round.labelForChoice(choiceId),
        color: selected ? Colors.white : color,
        size: 36,
      );
      _drawText(
        canvas,
        _round.labelForChoice(choiceId),
        Offset(rect.left + 70, rect.center.dy - 12),
        maxWidth: rect.width - 82,
        fontSize: 16,
        color: Colors.white,
      );
    }
  }

  Rect _clueRectFor(Size canvasSize) {
    return Rect.fromCenter(
      center: Offset(canvasSize.width * 0.28, canvasSize.height * 0.43),
      width: math.min(150, canvasSize.width * 0.36),
      height: 138,
    );
  }

  List<Rect> _choiceRectsFor(Size canvasSize) {
    final count = _round.choiceIds.length;
    if (count == 0) {
      return const [];
    }
    final width = math.min(178.0, canvasSize.width * 0.43);
    final height = count <= 3 ? 62.0 : 54.0;
    const gap = 10.0;
    final totalHeight = count * height + (count - 1) * gap;
    final top = canvasSize.height * 0.43 - totalHeight / 2;
    return [
      for (var index = 0; index < count; index += 1)
        Rect.fromLTWH(
          canvasSize.width * 0.56,
          top + index * (height + gap),
          width,
          height,
        ),
    ];
  }

  String get _clueLabel {
    final prompt = definition.prompt.trim();
    final markers = [
      ' goes with',
      ' is to ',
      ' makes',
      ' =',
      ' +',
      ' связан',
      ' подходит',
      ' относится',
      ' =',
    ];
    for (final marker in markers) {
      final index = prompt.toLowerCase().indexOf(marker.toLowerCase());
      if (index > 0) {
        return prompt.substring(0, index).replaceAll(':', '').trim();
      }
    }
    final beforeDots = prompt.split('...').first.trim();
    if (beforeDots.length < prompt.length && beforeDots.isNotEmpty) {
      return beforeDots;
    }
    return prompt.length > 18 ? '${prompt.substring(0, 18)}...' : prompt;
  }

  void _drawInstruction(Canvas canvas, Size canvasSize) {
    _drawCenteredText(
      canvas,
      Offset(canvasSize.width / 2, canvasSize.height - 86),
      _round.goal,
      maxWidth: canvasSize.width - 44,
      fontSize: 15,
      color: const Color(0xFFC6D0FF),
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    required double maxWidth,
    required double fontSize,
    required Color color,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '...',
    )..layout(maxWidth: maxWidth);
    painter.paint(canvas, offset);
  }

  void _drawCenteredText(
    Canvas canvas,
    Offset center,
    String text, {
    required double maxWidth,
    required double fontSize,
    required Color color,
  }) {
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
      maxLines: 2,
      ellipsis: '...',
    )..layout(maxWidth: maxWidth);
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }
}
