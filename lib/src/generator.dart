import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context.dart';
import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:dartx/dartx_io.dart';

class BusinessFormGenerator {
  Future<void> generateModel(File modelFile) async {
    AnalysisContextCollection collection =
        AnalysisContextCollection(includedPaths: [modelFile.path]);
    AnalysisContext context = collection.contextFor(modelFile.path);
    await _analyzeSingleFile(context, modelFile);
  }

  Future<void> _analyzeSingleFile(AnalysisContext context, File file) async {
    AnalysisSession session = context.currentSession;
    var result = await session.getUnitElement(file.path);
    if (result is UnitElementResult) {
      CompilationUnitElement element = result.element;
      final formFile = _createFile(file);
      _addImports(formFile, file);
    }
  }

  /// Creates a file with the model name and a _form suffix.
  File _createFile(File modelFile) {
    return File(
        '${modelFile.parent.path}/${modelFile.nameWithoutExtension}_form.dart')
      ..createSync();
  }

  void _addImports(File formFile, File modelFile) {
    formFile.writeAsStringSync('''
import 'package:business_object/business_object.dart';

import '${modelFile.name}';
    ''');
  }
}

void printMembers(CompilationUnitElement unitElement) {
  for (ClassElement classElement in unitElement.classes) {
    for (ConstructorElement constructorElement in classElement.constructors) {
      if (!constructorElement.isSynthetic) {
        print('  ${constructorElement.displayName}');
      }
    }
    for (FieldElement fieldElement in classElement.fields) {
      if (!fieldElement.isSynthetic) {
        print('  ${fieldElement.name}');
      }
    }
    for (PropertyAccessorElement accessorElement in classElement.accessors) {
      if (!accessorElement.isSynthetic) {
        print('  ${accessorElement.name}');
      }
    }
    for (MethodElement methodElement in classElement.methods) {
      if (!methodElement.isSynthetic) {
        print('  ${methodElement.name}');
      }
    }
  }
}
