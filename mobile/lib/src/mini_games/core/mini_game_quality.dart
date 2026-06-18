import 'mini_game_definition.dart';

enum MiniGameQualitySeverity {
  blocker,
  warning,
}

class MiniGameQualityIssue {
  const MiniGameQualityIssue({
    required this.definitionId,
    required this.severity,
    required this.message,
  });

  final String definitionId;
  final MiniGameQualitySeverity severity;
  final String message;

  Map<String, Object?> toJson() {
    return {
      'definitionId': definitionId,
      'severity': severity.name,
      'message': message,
    };
  }
}

class MiniGameQualityReport {
  const MiniGameQualityReport({
    required this.definitionCount,
    required this.issues,
  });

  final int definitionCount;
  final List<MiniGameQualityIssue> issues;

  List<MiniGameQualityIssue> get blockers {
    return issues
        .where((issue) => issue.severity == MiniGameQualitySeverity.blocker)
        .toList(growable: false);
  }

  bool get passes {
    return blockers.isEmpty;
  }

  Map<String, Object?> toJson() {
    return {
      'definitionCount': definitionCount,
      'passes': passes,
      'blockerCount': blockers.length,
      'issues': [
        for (final issue in issues) issue.toJson(),
      ],
    };
  }
}

class MiniGameQualityAudit {
  const MiniGameQualityAudit._();

  static MiniGameQualityReport auditDefinitions(
    Iterable<MiniGameDefinition> definitions,
  ) {
    final definitionList = definitions.toList(growable: false);
    final issues = <MiniGameQualityIssue>[];

    for (final definition in definitionList) {
      final contentConfig = definition.contentConfig;
      if (contentConfig?.isValid != true) {
        issues.add(
          MiniGameQualityIssue(
            definitionId: definition.id,
            severity: MiniGameQualitySeverity.blocker,
            message: 'Missing or invalid content-driven mini-game config.',
          ),
        );
      }
      if (definition.rounds.isEmpty) {
        issues.add(
          MiniGameQualityIssue(
            definitionId: definition.id,
            severity: MiniGameQualitySeverity.blocker,
            message: 'Mini-game definition has no playable rounds.',
          ),
        );
      }
      if (definition.assetKeys.length < 2) {
        issues.add(
          MiniGameQualityIssue(
            definitionId: definition.id,
            severity: MiniGameQualitySeverity.warning,
            message: 'Mini-game has a thin asset set.',
          ),
        );
      }
      if (definition.estimatedSeconds <= 0) {
        issues.add(
          MiniGameQualityIssue(
            definitionId: definition.id,
            severity: MiniGameQualitySeverity.blocker,
            message: 'Mini-game estimated seconds must be positive.',
          ),
        );
      }
      if (contentConfig != null && !contentConfig.reducedMotionSafe) {
        issues.add(
          MiniGameQualityIssue(
            definitionId: definition.id,
            severity: MiniGameQualitySeverity.warning,
            message: 'Mini-game should declare a reduced-motion safe path.',
          ),
        );
      }
      if (definition.characterReactionProfile.stateLines.isEmpty) {
        issues.add(
          MiniGameQualityIssue(
            definitionId: definition.id,
            severity: MiniGameQualitySeverity.warning,
            message: 'Mini-game has no character reaction copy.',
          ),
        );
      }
    }

    return MiniGameQualityReport(
      definitionCount: definitionList.length,
      issues: issues,
    );
  }
}
