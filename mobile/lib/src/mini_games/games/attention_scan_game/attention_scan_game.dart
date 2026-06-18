import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_canvas_visuals.dart';
import '../../core/mini_game_definition.dart';
import '../../core/mini_game_scene_controller.dart';

class AttentionScanGame extends FlameGame with TapCallbacks {
  AttentionScanGame({
    required this.definition,
    required this.sceneController,
  });

  final MiniGameDefinition definition;
  final MiniGameSceneController sceneController;
  double _elapsed = 0;
  double _scanSweep = 0;
  int? _pressedIndex;

  MiniGameRoundDefinition get _round {
    return definition.firstRound;
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF0B2434);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _scanSweep = (_scanSweep + dt * 0.46) % 1;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final canvasSize = Size(size.x, size.y);
    _drawBackdrop(canvas, canvasSize);
    _drawScanPanel(canvas, canvasSize);
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
          Color(0x6668D391),
          Color(0x2242F4D2),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: canvasSize.shortestSide * 0.62),
      );
    canvas.drawCircle(center, canvasSize.shortestSide * 0.62, glowPaint);

    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.08);
    for (var x = canvasSize.width * 0.12;
        x <= canvasSize.width * 0.9;
        x += 34) {
      canvas.drawLine(
        Offset(x, canvasSize.height * 0.15),
        Offset(x + math.sin(_elapsed + x) * 8, canvasSize.height * 0.58),
        gridPaint,
      );
    }
  }

  void _drawScanPanel(Canvas canvas, Size canvasSize) {
    final rect = Rect.fromCenter(
      center: Offset(canvasSize.width / 2, canvasSize.height * 0.38),
      width: math.min(360, canvasSize.width * 0.86),
      height: 188,
    );
    final rounded = RRect.fromRectAndRadius(rect, const Radius.circular(30));
    canvas.drawShadow(
      Path()..addRRect(rounded),
      Colors.black.withValues(alpha: 0.38),
      18,
      true,
    );
    canvas.drawRRect(
      rounded,
      Paint()..color = const Color(0xFF15375A).withValues(alpha: 0.95),
    );
    canvas.drawRRect(
      rounded,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF68D391).withValues(alpha: 0.70),
    );

    _drawGroups(canvas, rect);
    _drawSweep(canvas, rect);
  }

  void _drawGroups(Canvas canvas, Rect panelRect) {
    final groups = _detailGroups;
    final count = groups.length;
    if (count == 0) {
      return;
    }
    const gap = 10.0;
    final width = (panelRect.width - 32 - gap * (count - 1)) / count;
    final groupHeight = panelRect.height - 52;
    final top = panelRect.top + 18;
    for (var index = 0; index < count; index += 1) {
      final group = groups[index];
      final rect = Rect.fromLTWH(
        panelRect.left + 16 + index * (width + gap),
        top,
        width,
        groupHeight,
      );
      final color = MiniGameCanvasVisuals.colorForChoice(group.label, index);
      final rounded = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(22),
      );
      canvas.drawRRect(
        rounded,
        Paint()..color = color.withValues(alpha: 0.18),
      );
      canvas.drawRRect(
        rounded,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = color.withValues(alpha: 0.58),
      );
      _drawObjectCluster(canvas, rect, group, color);
      _drawCenteredText(
        canvas,
        Offset(rect.center.dx, rect.bottom - 18),
        group.label,
        maxWidth: rect.width - 8,
        fontSize: 11,
        color: Colors.white,
      );
    }
  }

  void _drawObjectCluster(
    Canvas canvas,
    Rect rect,
    _DetailGroup group,
    Color color,
  ) {
    final count = group.count.clamp(1, 6);
    final rows = count > 3 ? 2 : 1;
    final columns = (count / rows).ceil();
    final spacingX = math.min(28.0, rect.width / math.max(2, columns));
    final spacingY = rows == 1 ? 0.0 : 30.0;
    final start = Offset(
      rect.center.dx - (columns - 1) * spacingX / 2,
      rect.top + 44 - (rows - 1) * spacingY / 2,
    );
    for (var index = 0; index < count; index += 1) {
      final row = index ~/ columns;
      final column = index % columns;
      final center = start.translate(column * spacingX, row * spacingY);
      MiniGameCanvasVisuals.drawChoiceGlyph(
        canvas,
        center: center,
        choiceId: group.label,
        label: group.label,
        color: color,
        size: count > 4 ? 24 : 30,
      );
    }
    _drawCenteredText(
      canvas,
      Offset(rect.center.dx, rect.top + 15),
      '${group.count}',
      maxWidth: rect.width,
      fontSize: 17,
      color: const Color(0xFFFFD15C),
    );
  }

  void _drawSweep(Canvas canvas, Rect panelRect) {
    final y = panelRect.top + panelRect.height * _scanSweep;
    canvas.drawLine(
      Offset(panelRect.left + 16, y),
      Offset(panelRect.right - 16, y),
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF42F4D2).withValues(alpha: 0.54),
    );
  }

  void _drawChoiceButtons(Canvas canvas, Size canvasSize) {
    final rects = _choiceRectsFor(canvasSize);
    for (var index = 0; index < rects.length; index += 1) {
      final choiceId = _round.choiceIds[index];
      final selected = sceneController.selectedChoiceId == choiceId;
      final pressed = _pressedIndex == index;
      final color = MiniGameCanvasVisuals.colorForChoice(choiceId, index);
      final rect = rects[index].inflate(selected
          ? 5
          : pressed
              ? 2
              : 0);
      final rounded = RRect.fromRectAndRadius(rect, const Radius.circular(22));
      canvas.drawShadow(
        Path()..addRRect(rounded),
        Colors.black.withValues(alpha: selected ? 0.40 : 0.24),
        selected ? 15 : 8,
        true,
      );
      canvas.drawRRect(
        rounded,
        Paint()
          ..color = Color.lerp(
            const Color(0xFF24386D),
            color,
            selected ? 0.58 : 0.26,
          )!,
      );
      canvas.drawRRect(
        rounded,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = selected ? 4 : 2
          ..color = (selected ? Colors.white : color).withValues(alpha: 0.78),
      );
      _drawCenteredText(
        canvas,
        rect.center,
        _round.labelForChoice(choiceId),
        maxWidth: rect.width - 14,
        fontSize: 13,
        color: Colors.white,
      );
    }
  }

  List<Rect> _choiceRectsFor(Size canvasSize) {
    final count = _round.choiceIds.length;
    if (count == 0) {
      return const [];
    }
    final width = math.min(118.0, (canvasSize.width - 52) / count);
    const height = 62.0;
    final gap = count <= 3 ? 12.0 : 8.0;
    final totalWidth = count * width + (count - 1) * gap;
    final left = (canvasSize.width - totalWidth) / 2;
    final top = canvasSize.height * 0.67;
    return [
      for (var index = 0; index < count; index += 1)
        Rect.fromLTWH(left + index * (width + gap), top, width, height),
    ];
  }

  List<_DetailGroup> get _detailGroups {
    final matches = RegExp(r'(\d+)\s+([^,.?]+)')
        .allMatches(definition.prompt)
        .map((match) {
          final count = int.tryParse(match.group(1) ?? '') ?? 1;
          final label = (match.group(2) ?? '').trim();
          return _DetailGroup(count: count, label: label);
        })
        .where((group) => group.label.isNotEmpty)
        .toList(growable: false);

    if (matches.length >= 2) {
      return matches.take(3).toList(growable: false);
    }

    return [
      for (var index = 0; index < _round.choiceIds.length; index += 1)
        _DetailGroup(
          count: index + 2,
          label: _round.labelForChoice(_round.choiceIds[index]),
        ),
    ].take(3).toList(growable: false);
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

class _DetailGroup {
  const _DetailGroup({
    required this.count,
    required this.label,
  });

  final int count;
  final String label;
}
