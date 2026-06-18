import 'dart:math' as math;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../core/mini_game_canvas_interaction.dart';
import '../../core/mini_game_definition.dart';
import '../../core/mini_game_scene_controller.dart';

class LogicPathGame extends FlameGame with DragCallbacks {
  LogicPathGame({
    required this.definition,
    required this.sceneController,
  });

  final MiniGameDefinition definition;
  final MiniGameSceneController sceneController;
  final List<int> _tracedNodeIndices = [];
  final List<int> _failedTraceNodeIndices = [];
  final List<Offset> _fingerTrail = [];
  double _elapsed = 0;
  double _tracePulse = 0;
  double _retryPulse = 0;
  bool _isTracing = false;

  int get _nodeCount {
    return math.max(5, definition.firstRound.choiceIds.length + 2);
  }

  int get _expectedEndpointIndex {
    return MiniGameCanvasInteraction.traceEndpointHotspotIndex(
          definition: definition,
          nodeCount: _nodeCount,
        ) ??
        (_nodeCount - 1);
  }

  @override
  Color backgroundColor() {
    return const Color(0xFF07132F);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _tracePulse = math.max(0, _tracePulse - dt * 2.6);
    _retryPulse = math.max(0, _retryPulse - dt * 2.8);
    if (_retryPulse == 0 && _failedTraceNodeIndices.isNotEmpty) {
      _failedTraceNodeIndices.clear();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final canvasSize = Size(size.x, size.y);
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    _drawCircuitBackdrop(canvas, canvasSize, center);
    _drawPath(canvas, canvasSize);
    _drawTraceInstruction(canvas, canvasSize);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    final canvasSize = Size(size.x, size.y);
    final point = Offset(event.canvasPosition.x, event.canvasPosition.y);
    final nodeIndex = _nodeIndexAt(point, canvasSize);
    if (nodeIndex != 0) {
      _retryPulse = 1;
      return;
    }

    _isTracing = true;
    _tracedNodeIndices.clear();
    _failedTraceNodeIndices.clear();
    _fingerTrail
      ..clear()
      ..add(point);
    _addTraceNode(0);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!_isTracing) {
      return;
    }

    final canvasSize = Size(size.x, size.y);
    final point = Offset(
      event.canvasEndPosition.x,
      event.canvasEndPosition.y,
    );
    if (_fingerTrail.isEmpty || (point - _fingerTrail.last).distance > 6) {
      _fingerTrail.add(point);
    }

    final nodeIndex = _nodeIndexAt(point, canvasSize);
    if (nodeIndex != null) {
      _addTraceNode(nodeIndex);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _finishTrace();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _cancelTrace();
  }

  void _addTraceNode(int nodeIndex) {
    if (nodeIndex < 0 || nodeIndex >= _nodeCount) {
      return;
    }
    if (_tracedNodeIndices.isNotEmpty && _tracedNodeIndices.last == nodeIndex) {
      return;
    }

    final lastNodeIndex =
        _tracedNodeIndices.isEmpty ? -1 : _tracedNodeIndices.last;
    if (lastNodeIndex >= 0 && nodeIndex != lastNodeIndex + 1) {
      _retryPulse = 0.7;
    }

    _tracedNodeIndices.add(nodeIndex);
    _tracePulse = 1;
    if (_tracedNodeIndices.length == 1) {
      sceneController.beginTrace(nodeIndex);
    } else {
      sceneController.recordTraceHotspot(nodeIndex);
    }
  }

  void _finishTrace() {
    if (!_isTracing) {
      return;
    }
    _isTracing = false;

    final result = sceneController.submitTrace(
      hotspotIndices: _tracedNodeIndices,
      nodeCount: _nodeCount,
    );
    if (result?.isCorrect == true) {
      _failedTraceNodeIndices.clear();
      _fingerTrail.clear();
      _tracePulse = 1;
      return;
    }

    _failedTraceNodeIndices
      ..clear()
      ..addAll(_tracedNodeIndices);
    _tracedNodeIndices.clear();
    _fingerTrail.clear();
    _retryPulse = 1;
  }

  void _cancelTrace() {
    _isTracing = false;
    _tracedNodeIndices.clear();
    _fingerTrail.clear();
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
    final points = _pathPointsFor(canvasSize);
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index += 1) {
      path.lineTo(points[index].dx, points[index].dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round
        ..color = const Color(0x2242F4D2),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFFFFD15C).withValues(alpha: 0.70),
    );

    _drawExpectedRoute(canvas, points);
    _drawFailedRoute(canvas, points);
    _drawFingerTrail(canvas);
    _drawGuideTracer(canvas, points);
    _drawRouteBlockers(canvas, points);

    for (var index = 0; index < points.length; index += 1) {
      final traced = _tracedNodeIndices.contains(index);
      final failed = _failedTraceNodeIndices.contains(index);
      final endpoint = index == _expectedEndpointIndex;
      final beyondEndpoint = index > _expectedEndpointIndex;
      _drawNode(
        canvas,
        points[index],
        index,
        traced: traced,
        failed: failed,
        endpoint: endpoint,
        blocked: beyondEndpoint,
      );
    }
  }

  void _drawExpectedRoute(Canvas canvas, List<Offset> points) {
    final visibleTrace = _tracedNodeIndices.isNotEmpty
        ? _tracedNodeIndices
        : sceneController.traceHotspotIndices;
    if (visibleTrace.length < 2) {
      return;
    }

    final routePath = _pathForNodeIndices(points, visibleTrace);
    canvas.drawPath(
      routePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13 + _tracePulse * 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = const Color(0xFF42F4D2).withValues(
          alpha: 0.62 + _tracePulse * 0.24,
        ),
    );
    canvas.drawPath(
      routePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white.withValues(alpha: 0.82),
    );
  }

  void _drawFailedRoute(Canvas canvas, List<Offset> points) {
    if (_failedTraceNodeIndices.length < 2 || _retryPulse == 0) {
      return;
    }

    final routePath = _pathForNodeIndices(points, _failedTraceNodeIndices);
    canvas.drawPath(
      routePath.shift(Offset(math.sin(_elapsed * 26) * 4 * _retryPulse, 0)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = const Color(0xFFFF6F7D).withValues(alpha: _retryPulse),
    );
  }

  void _drawFingerTrail(Canvas canvas) {
    if (_fingerTrail.length < 2) {
      return;
    }
    final trailPath = Path()
      ..moveTo(_fingerTrail.first.dx, _fingerTrail.first.dy);
    for (var index = 1; index < _fingerTrail.length; index += 1) {
      trailPath.lineTo(_fingerTrail[index].dx, _fingerTrail[index].dy);
    }
    canvas.drawPath(
      trailPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: 0.34),
    );
  }

  void _drawGuideTracer(Canvas canvas, List<Offset> points) {
    if (_isTracing || _tracedNodeIndices.isNotEmpty) {
      return;
    }
    final guideEnd = _expectedEndpointIndex.clamp(1, points.length - 1);
    final progress = (_elapsed * 0.34) % 1;
    final tracerIndex = (progress * guideEnd).floor().clamp(0, guideEnd - 1);
    final localT = (progress * guideEnd) - tracerIndex;
    final start = points[tracerIndex];
    final end = points[math.min(tracerIndex + 1, guideEnd)];
    final tracer = Offset.lerp(start, end, localT)!;
    canvas.drawCircle(tracer, 12, Paint()..color = const Color(0xFF42F4D2));
    canvas.drawCircle(
      tracer,
      22,
      Paint()..color = const Color(0x3342F4D2),
    );
  }

  void _drawRouteBlockers(Canvas canvas, List<Offset> points) {
    for (var index = 1; index < points.length; index += 1) {
      if (index <= _expectedEndpointIndex) {
        continue;
      }
      final center = points[index];
      final barrierOffset = Offset(0, 34 + math.sin(_elapsed * 2 + index) * 4);
      final barrierCenter = center + barrierOffset;
      canvas.drawCircle(
        barrierCenter,
        12,
        Paint()..color = const Color(0x55FF6F7D),
      );
      canvas.drawLine(
        barrierCenter - const Offset(7, 7),
        barrierCenter + const Offset(7, 7),
        Paint()
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFFF6F7D),
      );
      canvas.drawLine(
        barrierCenter + const Offset(7, -7),
        barrierCenter - const Offset(7, -7),
        Paint()
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFFF6F7D),
      );
    }
  }

  Path _pathForNodeIndices(List<Offset> points, List<int> nodeIndices) {
    final clamped = [
      for (final nodeIndex in nodeIndices)
        nodeIndex.clamp(0, points.length - 1).toInt(),
    ];
    final path = Path()
      ..moveTo(points[clamped.first].dx, points[clamped.first].dy);
    for (var index = 1; index < clamped.length; index += 1) {
      final point = points[clamped[index]];
      path.lineTo(point.dx, point.dy);
    }
    return path;
  }

  List<Offset> _pathPointsFor(Size canvasSize) {
    if (_nodeCount == 5) {
      return [
        Offset(canvasSize.width * 0.18, canvasSize.height * 0.46),
        Offset(canvasSize.width * 0.36, canvasSize.height * 0.36),
        Offset(canvasSize.width * 0.54, canvasSize.height * 0.48),
        Offset(canvasSize.width * 0.72, canvasSize.height * 0.38),
        Offset(canvasSize.width * 0.84, canvasSize.height * 0.50),
      ];
    }

    return [
      for (var index = 0; index < _nodeCount; index += 1)
        Offset(
          canvasSize.width * (0.14 + 0.72 * index / (_nodeCount - 1)),
          canvasSize.height * (index.isEven ? 0.47 : 0.36 + (index % 3) * 0.03),
        ),
    ];
  }

  int? _nodeIndexAt(Offset point, Size canvasSize) {
    final nodes = _pathPointsFor(canvasSize);
    for (var index = 0; index < nodes.length; index += 1) {
      if ((point - nodes[index]).distance <= 38) {
        return index;
      }
    }
    return null;
  }

  void _drawNode(
    Canvas canvas,
    Offset center,
    int index, {
    required bool traced,
    required bool failed,
    required bool endpoint,
    required bool blocked,
  }) {
    final active = traced || endpoint || math.sin(_elapsed * 2 + index) > 0.15;
    final fillPaint = Paint()
      ..color = failed
          ? const Color(0xFFFF6F7D)
          : blocked
              ? const Color(0xFF273B78).withValues(alpha: 0.62)
              : endpoint
                  ? const Color(0xFFFFD15C)
                  : traced
                      ? const Color(0xFF42F4D2)
                      : active
                          ? const Color(0xFF42F4D2)
                          : const Color(0xFF273B78);
    final radius = traced || endpoint ? 24 : 18;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = traced || endpoint ? 5 : 3
      ..color = failed
          ? Colors.white.withValues(alpha: 0.82)
          : endpoint
              ? const Color(0xFFFFD15C)
              : blocked
                  ? const Color(0xFFFF6F7D).withValues(alpha: 0.52)
                  : const Color(0xFFFFD15C);
    canvas.drawCircle(center, radius.toDouble(), fillPaint);
    canvas.drawCircle(center, radius.toDouble(), borderPaint);

    if (endpoint) {
      canvas.drawCircle(
        center,
        32 + _tracePulse * 10,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0xFFFFD15C).withValues(alpha: 0.40),
      );
    }

    final label = endpoint ? 'GO' : '${index + 1}';
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color(0xFF07132F),
          fontSize: 13,
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

  void _drawTraceInstruction(Canvas canvas, Size canvasSize) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: definition.firstRound.goal,
        style: const TextStyle(
          color: Color(0xFFC6D0FF),
          fontSize: 16,
          fontWeight: FontWeight.w900,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: '...',
    )..layout(maxWidth: canvasSize.width - 40);

    textPainter.paint(
      canvas,
      Offset(
        (canvasSize.width - textPainter.width) / 2,
        canvasSize.height - 92,
      ),
    );
  }
}
