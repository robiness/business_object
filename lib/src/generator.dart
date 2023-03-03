import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:business_object/src/file_analyzer.dart';
import 'package:dart_style/dart_style.dart';
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
    _addComment();
    _addImports();

    final classElements = await analyzer.classElements();
    for (final classElement in classElements) {
      await _createClassDeclaration(classElement);
    }

    _writeFile();
  }

  /// Creates a file with the model name and a _form suffix.
  static File _createFormFile(File modelFile) {
    return File(
      '${modelFile.parent.path}/${modelFile.nameWithoutExtension}_form_data.dart',
    )..createSync();
  }

  void _addComment() {
    _content = modelFileComment;
  }

  void _addImports() {
    _content = _content += '''
import 'package:business_object/business_object.dart';

import '${modelFile.name}';
    ''';
  }

  /// Creates the actual business form class for a model class.
  Future<void> _createClassDeclaration(ClassElement classElement) async {
    final className = classElement.displayName;
    final modelName = className.decapitalize();

    final StringBuffer constructorArguments = StringBuffer();
    final StringBuffer fieldDeclarations = StringBuffer();
    final StringBuffer businessValuesAssignments = StringBuffer();

    for (final field in classElement.fields) {
      constructorArguments.write(_getConstructorArgument(field));
      fieldDeclarations.write(_getFieldDeclaration(field));
      businessValuesAssignments
          .write(_getBusinessValuesAssignment(field, className, modelName));
    }

    _content += '''
\nclass ${className}FormData extends BusinessFormData<$className> {
  ${className}FormData({
  required super.label,
  $constructorArguments
  }) : ${_getSuperConstructor(classElement)};

  $fieldDeclarations

  static ${className}FormData from$className($className? $modelName) {
  return ${className}FormData(
      label: '$className',
    $businessValuesAssignments
    );
  }
}''';
  }

  String _getConstructorArgument(FieldElement field) {
    // required this.name,
    return 'required this.${field.name},';
  }

  String _getSuperConstructor(ClassElement classElement) {
    // super(content: [name, amount, customer, status]),
    return 'super(content: [${classElement.fields.map((e) => e.name).join(', ')}])';
  }

  String _getFieldDeclaration(FieldElement field) {
    if (field.isEnum) {
      return 'BusinessSelectionValue<${field.type}?> ${field.name};';
    }

    if (field.isObject) {
      return '${field.type}FormData ${field.name};';
    }

    return 'BusinessFormValue<${field.type}?> ${field.name};';
  }

  String _getBusinessValuesAssignment(
      FieldElement field, String className, String modelName) {
    if (field.isEnum) {
      return '''
${field.name}: BusinessSelectionValue<${field.type}?>(
  label: '${field.name}', 
  initialValue: $modelName?.${field.name}, 
  options: ${field.type}.values,
)
''';
    }

    if (field.isObject) {
      return '''
${field.name}: ${field.type}FormData.from${field.name.capitalize()}($modelName?.${field.name}),
''';
    }
    return '''
${field.name}: BusinessFormValue(
label: '${field.name}',
initialValue: $modelName?.${field.name},
),
''';
  }

  void _writeFile() {
    final formattedContent = DartFormatter().format(_content);
    formFile.writeAsStringSync(formattedContent);
  }
}

extension GenerateExtension on File {
  Future<BusinessFormGenerator> generateBusinessObject() async =>
      BusinessFormGenerator.generateModel(this);
}

extension FieldElementExtensions on FieldElement {
  bool get isObject {
    return !type.isDartCoreString &&
        !type.isDartCoreInt &&
        !type.isDartCoreDouble &&
        !type.isDartCoreBool &&
        !isEnum;
  }

  bool get isEnum {
    // First recherche show that enums have an ordinal unequal to 1.
    return type.element!.kind.ordinal != 1;
  }
}

const String modelFileComment = '''
// ---------------------------------------
// Generated by the business_form_data package.
// 
// You can customize the behavior of your form by editing the BusinessFormValues.
// ---------------------------------------
''';
