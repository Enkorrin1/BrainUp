import 'dart:convert';
import 'dart:io';

import 'package:brain_up/src/domain/learning_foundation.dart';

void main(List<String> args) {
  final outputPath = args.isEmpty ? '../docs/content-manifest.json' : args[0];
  final outputFile = File(outputPath);
  final manifest = FoundationCatalog.contentManifest();
  const encoder = JsonEncoder.withIndent('  ');

  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync('${encoder.convert(manifest)}\n');

  final coverage = FoundationCatalog.contentCoverageReport();
  stdout.writeln(
    'Exported ${coverage.totalPuzzleCount} puzzles to ${outputFile.path}',
  );
}
