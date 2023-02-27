import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';

class FileAnalyzer {
  final File file;

  FileAnalyzer._(this.file);

  late final AnalysisSession session;

  Future<FileAnalyzer> analyze(File file) async {
    final AnalysisContextCollection collection =
        AnalysisContextCollection(includedPaths: [file.path]);
    final AnalysisContext context = collection.contextFor(file.path);
    session = context.currentSession;
    return FileAnalyzer._(file);
  }

  Iterable<ImportDirective> get imports {
    final test = session.getParsedUnit(file.path);
    if (test is ParsedUnitResult) {
      return test.unit.directives.whereType<ImportDirective>();
    }
    return [];
  }

  Iterable<String> get importsAsStrings => imports.map((e) => e.toSource());
}

extension AnalyzerExtension on File {
  Future<FileAnalyzer> analyze() async => FileAnalyzer._(this)..analyze(this);
}
