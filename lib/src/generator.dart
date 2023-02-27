import 'dart:io';

import 'package:business_object/src/file_analyzer.dart';
import 'package:dartx/dartx_io.dart';

class BusinessFormGenerator {
  final FileAnalyzer analyzer;
  final File formFile;
  final File modelFile;

  String _content = '';

  BusinessFormGenerator({
    required this.analyzer,
    required this.formFile,
    required this.modelFile,
  });

  static Future<BusinessFormGenerator> generateModel(File modelFile) async {
    final analyzer = await modelFile.analyze();
    final formFile = _createFormFile(modelFile);

    final generator = BusinessFormGenerator(
      analyzer: analyzer,
      formFile: formFile,
      modelFile: modelFile,
    );

    await generator._writeFormFile();
    return generator;
  }

  Future<void> _writeFormFile() async {
    _addImports();
    await _createClass();
    _writeFile();
  }

  /// Creates a file with the model name and a _form suffix.
  static File _createFormFile(File modelFile) {
    return File(
      '${modelFile.parent.path}/${modelFile.nameWithoutExtension}_form.dart',
    )..createSync();
  }

  void _addImports() {
    _content = '''
import 'package:business_object/business_object.dart';

import '${modelFile.name}';
    ''';
  }

  Future<void> _createClass() async {
    final className = (await analyzer.classElement()).displayName;
    _content += '''
\nclass ${className}Form extends BusinessFormObject<$className> {
  ${className}Form({required super.content, required super.label});

  @override
  BusinessFormObject<${className}> create(${className}? model) {
    CREATE_CONTENT
  }
}''';
  }

  void _writeFile() {
    formFile.writeAsStringSync(_content);
  }
}

extension GenerateExtension on File {
  Future<BusinessFormGenerator> generateBusinessObject() async =>
      BusinessFormGenerator.generateModel(this);
}
