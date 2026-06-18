import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_canvas_visuals.dart';
import '../../core/mini_game_definition.dart';
import '../../core/mini_game_scene_controller.dart';

class PatternMachineGame extends FlameGame with TapCallbacks {
  PatternMachineGame({
    required this.definition,
    required this.sceneController,
  });

  final MiniGameDefinition definition;
  final MiniGameSceneController sceneController;
  double _elapsed = 0;
  double _pressPulse = 0;
  int? _pressedIndex;

  MiniGameRoundDefinition get _round {
    return definition.firstRound;
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF08183A);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _pressPulse = math.max(0, _pressPulse - dt * 3.2);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final canvasSize = Size(size.x, size.y);
    _drawBackdrop(canvas, canvasSize);
    _drawMachine(canvas, canvasSize);
    _drawChoiceButtons(canvas, canvasSize);
    _drawInstruction(canvas, canvasSize);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final point = Offset(event.canvasPosition.x, event.canvasPosition.y);
    final rects = _choiceRectsFor(Size(size.x, size.y));
    for (var index = 0; index < rects.length; index += 1) {
      if (rects[index].contains(point)) {
        _pressedIndex = index;
        _pressPulse = 1;
        sceneController.submitHotspot(index);
        return;
      }
    }
  }

  void _drawBackdrop(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height * 0.38);
    final glowPaint = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0x665C8EF7),
          Color(0x229C6AF2),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: canvasSize.shortestSide * 0.62),
      );
    canvas.drawCircle(center, canvasSize.shortestSide * 0.62, glowPaint);

    final railPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withValues(alpha: 0.10);
    for (var index = 0; index < 5; index += 1) {
      final y = canvasSize.height * (0.21 + index * 0.08);
      canvas.drawLine(
        Offset(canvasSize.width * 0.08, y),
        Offset(canvasSize.width * 0.92, y + math.sin(_elapsed + index) * 8),
        railPaint,
      );
    }
  }

  void _drawMachine(Canvas canvas, Size canvasSize) {
    final rect = Rect.fromCenter(
      center: Offset(canvasSize.width / 2, canvasSize.height * 0.38),
      width: math.min(360, canvasSize.width * 0.86),
      height: 168,
    );
    final rounded = RRect.fromRectAndRadius(rect, const Radius.circular(30));
    canvas.drawShadow(
      Path()..addRRect(rounded),
      Colors.black.withValues(alpha: 0.40),
      20,
      true,
    );
    canvas.drawRRect(
      rounded,
      Paint()..color = const Color(0xFF162B61).withValues(alpha: 0.94),
    );
    canvas.drawRRect(
      rounded,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF5C8EF7).withValues(alpha: 0.72),
    );

    _drawRuleTrack(canvas, rect);
    _drawPromptStrip(canvas, rect);
  }

  void _drawRuleTrack(Canvas canvas, Rect machineRect) {
    final tokens = _sequenceTokens;
    final visibleCount = math.min(5, math.max(3, tokens.length + 1));
    const gap = 10.0;
    final tokenSize = math.min(
      58.0,
      (machineRect.width - 42 - gap * (visibleCount - 1)) / visibleCount,
    );
    final totalWidth = visibleCount * tokenSize + (visibleCount - 1) * gap;
    final startX = machineRect.center.dx - totalWidth / 2;
    final y = machineRect.center.dy - 12;

    for (var index = 0; index < visibleCount; index += 1) {
      final isQuestionSlot = index == visibleCount - 1;
      final rawToken = index < tokens.length ? tokens[index] : '?';
      final token = isQuestionSlot ? '?' : rawToken;
      final rect = Rect.fromLTWH(
          startX + index * (tokenSize + gap), y, tokenSize, tokenSize);
      final color = isQuestionSlot
          ? const Color(0xFFFFD15C)
          : MiniGameCanvasVisuals.colorForChoice(token, index);
      final pulse = isQuestionSlot ? 0.5 + 0.5 * math.sin(_elapsed * 3) : 0.0;
      final rounded = RRect.fromRectAndRadius(
        rect.inflate(isQuestionSlot ? pulse * 4 : 0),
        Radius.circular(tokenSize * 0.28),
      );
      canvas.drawRRect(
        rounded,
        Paint()
          ..color = (isQuestionSlot
                  ? const Color(0xFFFFD15C)
                  : const Color(0xFF24386D))
              .withValues(alpha: isQuestionSlot ? 0.30 : 0.80),
      );
      canvas.drawRRect(
        rounded,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isQuestionSlot ? 3 : 2
          ..color = color.withValues(alpha: 0.88),
      );
      if (isQuestionSlot) {
        _drawCenteredText(
          canvas,
          rounded.outerRect.center,
          '?',
          maxWidth: tokenSize,
          fontSize: 28,
          color: const Color(0xFFFFD15C),
        );
      } else {
        MiniGameCanvasVisuals.drawChoiceGlyph(
          canvas,
          center: rounded.outerRect.center.translate(0, -8),
          choiceId: token,
          label: token,
          color: color,
          size: 34,
        );
        _drawCenteredText(
          canvas,
          rounded.outerRect.center.translate(0, 19),
          token,
          maxWidth: tokenSize - 8,
          fontSize: 11,
          color: Colors.white,
        );
      }
    }
  }

  void _drawPromptStrip(Canvas canvas, Rect machineRect) {
    _drawCenteredText(
      canvas,
      Offset(machineRect.center.dx, machineRect.bottom - 24),
      _shortPrompt,
      maxWidth: machineRect.width - 28,
      fontSize: 13,
      color: const Color(0xFFC6D0FF),
    );
  }

  void _drawChoiceButtons(Canvas canvas, Size canvasSize) {
    final rects = _choiceRectsFor(canvasSize);
    for (var index = 0; index < rects.length; index += 1) {
      final choiceId = _round.choiceIds[index];
      final selected = sceneController.selectedChoiceId == choiceId;
      final pressed = _pressedIndex == index ? _pressPulse : 0.0;
      final color = MiniGameCanvasVisuals.colorForChoice(choiceId, index);
      final rect = rects[index].inflate(selected ? 6 : pressed * 5);
      final rounded = RRect.fromRectAndRadius(rect, const Radius.circular(22));
      canvas.drawShadow(
        Path()..addRRect(rounded),
        Colors.black.withValues(alpha: selected ? 0.42 : 0.24),
        selected ? 15 : 8,
        true,
      );
      canvas.drawRRect(
        rounded,
        Paint()
          ..color = Color.lerp(
            const Color(0xFF24386D),
            color,
            selected ? 0.62 : 0.30,
          )!,
      );
      canvas.drawRRect(
        rounded,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 4 : 2
          ..color = (selected ? Colors.white : color).withValues(alpha: 0.78),
      );
      MiniGameCanvasVisuals.drawChoiceGlyph(
        canvas,
        center: rect.center.translate(0, -13),
        choiceId: choiceId,
        label: _round.labelForChoice(choiceId),
        color: selected ? Colors.white : color,
        size: 34,
      );
      _drawCenteredText(
        canvas,
        rect.center.translate(0, 23),
        _round.labelForChoice(choiceId),
        maxWidth: rect.width - 12,
        fontSize: 12,
        color: Colors.white,
      );
    }
  }

  List<Rect> _choiceRectsFor(Size canvasSize) {
    final count = _round.choiceIds.length;
    if (count == 0) {
      return const [];
    }
    final width = math.min(112.0, (canvasSize.width - 52) / count);
    const height = 86.0;
    final gap = count <= 3 ? 12.0 : 8.0;
    final totalWidth = count * width + (count - 1) * gap;
    final left = (canvasSize.width - totalWidth) / 2;
    final top = canvasSize.height * 0.66;
    return [
      for (var index = 0; index < count; index += 1)
        Rect.fromLTWH(left + index * (width + gap), top, width, height),
    ];
  }

  List<String> get _sequenceTokens {
    final beforeQuestion = definition.prompt.split('?').first;
    final cleaned = beforeQuestion
        .replaceAll('->', ',')
        .replaceAll('+', ',')
        .replaceAll('=', ',')
        .replaceAll(':', ',');
    final tokens = cleaned
        .split(RegExp(r'[,.;]'))
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (tokens.length >= 2) {
      return tokens.take(4).toList(growable: false);
    }
    final choices = _round.choiceIds.take(2).toList(growable: false);
    return choices.isEmpty ? const ['1', '2'] : choices;
  }

  String get _shortPrompt {
    final prompt = definition.prompt.trim();
    if (prompt.length <= 54) {
      return prompt;
    }
    return '${prompt.substring(0, 51)}...';
  }

  void _drawInstruction(Canvas canvas, Size canvasSize) {
    _drawCenteredText(
      canvas,
      Offset(canvasSize.width / 2, canvasSize.height - 82),
      _round.goal,
      maxWidth: canvasSize.width - 44,
      fontSize: 15,
      color: const Color(0xFFC6D0FF),
    );
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
