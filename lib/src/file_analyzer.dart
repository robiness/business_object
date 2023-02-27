import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

class FileAnalyzer {
  final File file;

  FileAnalyzer._(this.file);

  late final AnalysisSession session;
  late final CompilationUnitElement element;

  Future<FileAnalyzer> analyze(File file) async {
    final AnalysisContextCollection collection =
        AnalysisContextCollection(includedPaths: [file.path]);
    final AnalysisContext context = collection.contextFor(file.path);
    session = context.currentSession;
    final unitElement = await session.getUnitElement(file.path);
    if (unitElement is UnitElementResult) {
      element = unitElement.element;
    }
    return FileAnalyzer._(file);
  }

  Iterable<ImportDirective> get imports {
    final test = session.getParsedUnit(file.path);
    if (test is ParsedUnitResult) {
      return test.unit.directives.whereType<ImportDirective>();
    }
    return [];
  }

  Iterable<ClassDeclaration> classDeclaration() {
    final test = session.getParsedUnit(file.path);
    if (test is ParsedUnitResult) {
      return test.unit.declarations.reversed.whereType<ClassDeclaration>();
    }
    return [];
  }

  Iterable<String> get importsAsStrings => imports.map((e) => e.toSource());

  Future<ClassElement> classElement() async {
    return element.classes.first;
  }
}

extension AnalyzerExtension on File {
  Future<FileAnalyzer> analyze() async {
    final analyzer = FileAnalyzer._(this);
    await analyzer.analyze(this);
    return analyzer;
  }
}
