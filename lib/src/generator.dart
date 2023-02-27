import 'dart:io';

import 'package:dartx/dartx_io.dart';

class BusinessFormGenerator {
  Future<void> generateModel(File modelFile) async {
    final formFile = _createFile(modelFile);
    _addImports(formFile, modelFile);
  }

  /// Creates a file with the model name and a _form suffix.
  File _createFile(File modelFile) {
    return File(
      '${modelFile.parent.path}/${modelFile.nameWithoutExtension}_form.dart',
    )..createSync();
  }

  void _addImports(File formFile, File modelFile) {
    formFile.writeAsStringSync('''
import 'package:business_object/business_object.dart';

import '${modelFile.name}';
    ''');
  }
}

extension GenerateExtension on File {
  Future<BusinessFormGenerator> generate() async =>
      BusinessFormGenerator()..generateModel(this);
}
