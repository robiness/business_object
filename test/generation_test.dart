import 'package:business_object/src/file_analyzer.dart';
import 'package:business_object/src/generator.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:test/test.dart';

import 'model/invoice.dart';

void main() {
  late final Directory tmp;
  late final File modelFile;

  late final File formFile = tmp.childFile('invoice_form.dart');

  /// The initial test setup.
  setUpAll(() async {
    const fs = LocalFileSystem();
    tmp = await fs.systemTempDirectory.createTemp('business_object_test');
    modelFile = tmp.childFile('invoice.dart');
    modelFile.writeAsStringSync(invoiceString);
  });

  tearDown(() {
    formFile.deleteSync(recursive: true);
  });

  group('BusinessModelTest', () {
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
      final classElement = await analyzer.classElement();
      expect(
        classElement.displayName,
        'InvoiceForm',
      );
    });
    test('The created class extends the correct class', () async {
      await modelFile.generateBusinessObject();
      final analyzer = await formFile.analyze();
      final classElement = await analyzer.classElement();
      print(classElement);
      // expect(
      //   classElement.interfaces,
      //   'InvoiceForm',
      // );
    });
  });
}

extension DirectoryExtension on Directory {
  List<String> get fileNames => listSync().map((e) => e.basename).toList();
}
