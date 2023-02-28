import 'package:analyzer/dart/ast/ast.dart';
import 'package:business_object/src/file_analyzer.dart';
import 'package:business_object/src/generator.dart';
import 'package:dartx/dartx_io.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:test/test.dart';

void main() {
  late final Directory tmp;
  late final File modelFile;

  late final File formFile = tmp.childFile('invoice_form.dart');
  late final Directory localTestDirectory;

  // Enable for local testing. A test_output.dart will be generated in the model folder.
  const generateTestFile = true;

  /// The initial test setup.
  ///
  /// The invoice.dart from the model directory is used as a source for generation.
  ///
  setUpAll(() async {
    const fs = LocalFileSystem();
    tmp = await fs.systemTempDirectory.createTemp('business_object_test');
    modelFile = tmp.childFile('invoice.dart');
    final testInvoiceFile = fs.file('test/model/invoice.dart');
    final testInvoiceContent = testInvoiceFile.readAsStringSync();

    modelFile.writeAsStringSync(testInvoiceContent);

    localTestDirectory = fs.directory('test/model');
  });

  tearDown(() {
    formFile.deleteSync(recursive: true);
  });

  tearDownAll(() {
    if (generateTestFile) {
      localTestDirectory
          .childFile('test.dart')
          .writeAsStringSync(formFile.readAsStringSync());
    }
  });

  group('Build BusinessForm file', () {
    test('A new file is created with the name of the model and a _form suffix',
        () async {
      expect(tmp.fileNames, ['invoice.dart']);
      await modelFile.generateBusinessObject();
      expect(
        tmp.fileNames,
        ['invoice.dart', 'invoice_form.dart'],
      );
    });
    test('The business object library gets imported', () async {
      await modelFile.generateBusinessObject();
      final analyzer = await formFile.analyze();
      expect(
        analyzer.importsAsStrings,
        contains("import 'package:business_object/business_object.dart';"),
      );
    });
    test('The actual model file gets imported', () async {
      await modelFile.generateBusinessObject();
      final analyzer = await formFile.analyze();
      expect(
        analyzer.importsAsStrings,
        contains("import 'invoice.dart';"),
      );
    });
    test('The created class has the correct class name', () async {
      await modelFile.generateBusinessObject();
      final analyzer = await formFile.analyze();
      final classNames = await analyzer.classElementNames();
      expect(
        classNames,
        containsAll(['InvoiceForm']),
      );
    });
    test('The created class extends BusinessFormData<T>', () async {
      await modelFile.generateBusinessObject();
      final analyzer = await formFile.analyze();
      final superclasses = analyzer.superClasses();

      expect(
        superclasses.first,
        allOf(
          ExtendsClass('BusinessFormData'),
          IsTyped('Customer'),
        ),
      );
      expect(
        superclasses.second,
        allOf(
          ExtendsClass('BusinessFormData'),
          IsTyped('Invoice'),
        ),
      );
    });
  });
}

extension DirectoryExtension on Directory {
  List<String> get fileNames => listSync().map((e) => e.basename).toList();
}

class ExtendsClass extends CustomMatcher {
  ExtendsClass(matcher)
      : super("Class that extends from", "superclass", matcher);

  @override
  String? featureValueOf(dynamic actual) => (actual as NamedType?)?.name.name;
}

class IsTyped extends CustomMatcher {
  IsTyped(matcher) : super("Class that is typed with", "type", matcher);

  @override
  String? featureValueOf(dynamic actual) =>
      (actual as NamedType?)?.typeArguments?.arguments.first.toSource();
}
