import 'dart:convert';
import 'dart:io';

import 'package:brain_up/src/domain/daily_challenge.dart';
import 'package:brain_up/src/domain/family_profile.dart';
import 'package:brain_up/src/domain/learning_foundation.dart';
import 'package:brain_up/src/mini_games/core/mini_game_definition.dart';
import 'package:brain_up/src/mini_games/core/mini_game_quality.dart';
import 'package:brain_up/src/mini_games/core/mini_game_registry.dart';

void main(List<String> args) {
  final readyPuzzles = FoundationCatalog.allPuzzles
      .where(FoundationCatalog.isMiniGameReadyPuzzle)
      .toList(growable: false);
  final definitions = readyPuzzles
      .map((puzzle) {
        final challenge = dailyChallengeForPuzzle(puzzle, ChildAge.seven);
        return MiniGameRegistry.definitionForChallenge(challenge);
      })
      .whereType<MiniGameDefinition>()
      .toList(growable: false);
  final contentQa = FoundationCatalog.contentQaReport();
  final quality = MiniGameQualityAudit.auditDefinitions(definitions);
  final wave = FoundationCatalog.miniGameContentWaveManifest();
  final previewFixtures = [
    for (final definition in definitions.take(12))
      {
        'id': definition.id,
        'type': definition.type.name,
        'worldId': definition.worldId,
        'characterId': definition.characterId,
        'templateId': definition.contentConfig?.templateId,
        'editorTemplatePath': definition.contentConfig?.editorTemplatePath,
        'roundCount': definition.rounds.length,
      },
  ];
  final report = {
    'schemaVersion': 1,
    'readyPuzzleCount': readyPuzzles.length,
    'definitionCount': definitions.length,
    'contentQaPasses': contentQa.passes,
    'miniGameQuality': quality.toJson(),
    'contentWave': wave,
    'previewFixtures': previewFixtures,
  };

  if (args.contains('--write-preview')) {
    final outputFile = File('../docs/mini-game-preview-fixtures.json');
    outputFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert({
        'schemaVersion': 1,
        'source': 'tool/validate_mini_game_content.dart --write-preview',
        'fixtures': previewFixtures,
      }),
    );
  }

  stdout.writeln(const JsonEncoder.withIndent('  ').convert(report));

  final hasBlockers = !contentQa.passes ||
      !quality.passes ||
      wave['passes'] != true ||
      definitions.length != readyPuzzles.length;
  if (hasBlockers) {
    exitCode = 1;
  }
}
