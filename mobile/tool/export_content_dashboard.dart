import 'dart:convert';
import 'dart:io';

import 'package:brain_up/src/domain/learning_foundation.dart';

void main(List<String> args) {
  final jsonPath = args.isEmpty ? '../docs/content-dashboard.json' : args.first;
  final markdownPath =
      args.length < 2 ? '../docs/content-dashboard.md' : args[1];
  final report = FoundationCatalog.contentDashboardReport();
  const encoder = JsonEncoder.withIndent('  ');

  final jsonFile = File(jsonPath);
  jsonFile.parent.createSync(recursive: true);
  jsonFile.writeAsStringSync('${encoder.convert(report.toJson())}\n');

  final markdownFile = File(markdownPath);
  markdownFile.parent.createSync(recursive: true);
  markdownFile.writeAsStringSync(_renderMarkdown(report));

  stdout.writeln(
    'Exported content dashboard to ${jsonFile.path} and ${markdownFile.path}',
  );
}

String _renderMarkdown(ContentDashboardReport report) {
  final buffer = StringBuffer()
    ..writeln('# BrainUp Content Dashboard')
    ..writeln()
    ..writeln('## Summary')
    ..writeln()
    ..writeln('| Metric | Value |')
    ..writeln('| --- | ---: |')
    ..writeln('| Total puzzles | ${report.totalPuzzleCount} |')
    ..writeln('| Visual puzzles | ${report.visualPuzzleCount} |')
    ..writeln('| Visual coverage | ${report.visualCoveragePercent}% |')
    ..writeln('| Quality gate passes | ${report.qualityGatePasses} |')
    ..writeln('| Blocking issues | ${report.hasBlockingIssues} |')
    ..writeln()
    ..writeln('## Coverage By Age')
    ..writeln()
    ..writeln(_tableFromEnumCounts(report.coverage.countByAgeBand))
    ..writeln()
    ..writeln('## Coverage By Skill')
    ..writeln()
    ..writeln(_tableFromEnumCounts(report.coverage.countBySkill))
    ..writeln()
    ..writeln('## Coverage By Type')
    ..writeln()
    ..writeln(_tableFromEnumCounts(report.coverage.countByType))
    ..writeln()
    ..writeln('## Coverage By Difficulty')
    ..writeln()
    ..writeln(_tableFromEnumCounts(report.coverage.countByDifficulty))
    ..writeln()
    ..writeln('## Placement Rules')
    ..writeln()
    ..writeln('| Placement | Min | Default | Max |')
    ..writeln('| --- | ---: | ---: | ---: |');

  for (final rule in report.placementRules) {
    buffer.writeln(
      '| ${rule.placement.name} | ${rule.minPuzzleCount} | '
      '${rule.defaultPuzzleCount} | ${rule.maxPuzzleCount} |',
    );
  }

  buffer
    ..writeln()
    ..writeln('## Coverage Issues')
    ..writeln()
    ..writeln(_issueLine('Skill gaps', report.skillGaps.length))
    ..writeln(_issueLine('Low type coverage', report.lowTypeCoverage.length))
    ..writeln(
      _issueLine(
          'Puzzles without assets', report.puzzleIdsWithoutAssets.length),
    )
    ..writeln(
      _issueLine('Puzzles without hints', report.puzzleIdsWithoutHints.length),
    )
    ..writeln()
    ..writeln('## QA')
    ..writeln()
    ..writeln('| Metric | Value |')
    ..writeln('| --- | ---: |')
    ..writeln('| QA passes | ${report.qaReport.passes} |')
    ..writeln('| Blockers | ${report.qaReport.blockers.length} |')
    ..writeln('| Warnings | ${report.qaReport.warnings.length} |')
    ..writeln()
    ..writeln('### QA Warning Types')
    ..writeln()
    ..writeln('| Type | Count |')
    ..writeln('| --- | ---: |');

  final warningCounts = _qaCountsByType(report.qaReport.warnings);
  if (warningCounts.isEmpty) {
    buffer.writeln('| none | 0 |');
  } else {
    for (final entry in warningCounts.entries) {
      buffer.writeln('| ${entry.key.name} | ${entry.value} |');
    }
  }

  buffer
    ..writeln()
    ..writeln('## Repeated Families')
    ..writeln()
    ..writeln('| Family | Count | Examples |')
    ..writeln('| --- | ---: | --- |');

  if (report.repeatedFamilies.isEmpty) {
    buffer.writeln('| none | 0 | - |');
  } else {
    for (final family in report.repeatedFamilies) {
      buffer.writeln(
        '| ${family.familyId} | ${family.count} | '
        '${family.examplePayloadRefs.join(', ')} |',
      );
    }
  }

  buffer
    ..writeln()
    ..writeln('## Next QA Focus')
    ..writeln()
    ..writeln('- Add visual metadata to puzzles listed without assets.')
    ..writeln(
        '- Keep type coverage above the minimum before adding new routes.')
    ..writeln('- Split repeated families when the dashboard shows saturation.')
    ..writeln();

  return buffer.toString();
}

String _tableFromEnumCounts<T extends Enum>(Map<T, int> counts) {
  final buffer = StringBuffer()
    ..writeln('| Name | Count |')
    ..writeln('| --- | ---: |');
  for (final entry in counts.entries) {
    buffer.writeln('| ${entry.key.name} | ${entry.value} |');
  }
  return buffer.toString().trimRight();
}

String _issueLine(String label, int count) {
  final status = count == 0 ? 'OK' : 'Needs review';
  return '- $label: $count ($status)';
}

Map<ContentQaIssueType, int> _qaCountsByType(List<ContentQaIssue> issues) {
  final counts = <ContentQaIssueType, int>{};
  for (final issue in issues) {
    counts.update(issue.type, (count) => count + 1, ifAbsent: () => 1);
  }
  return counts;
}
