import 'package:business_object/src/generator.dart';
import 'package:dartx/dartx_io.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:test/test.dart';

import 'model/invoice.dart';

void main() {
  late final LocalFileSystem fs;
  late final Directory tmp;
  late final File modelFile;

  late final formFile = tmp.childFile('invoice_form.dart');

  /// The initial test setup.
  setUpAll(() async {
    fs = LocalFileSystem();
    tmp = await fs.systemTempDirectory.createTemp('business_object_test');
    modelFile = tmp.childFile('invoice.dart');
    modelFile.writeAsStringSync(invoiceString);
  });

  tearDown(() {
    formFile.deleteSync();
  });

  group('BusinessModelTest', () {
    test('A new file is created with the name of the model and a _form suffix',
        () async {
      expect(tmp.listSync().map((e) => e.basename), ['invoice.dart']);

      final generator = BusinessFormGenerator();
      await generator.generateModel(modelFile);

      expect(tmp.listSync().map((e) => e.basename),
          ['invoice.dart', 'invoice_form.dart']);
    });
    test('The business object library gets imported', () async {
      final generator = BusinessFormGenerator();
      await generator.generateModel(modelFile);

      //TODO Better test for imports per AST
      expect(formFile.readAsLinesSync().first,
          'import \'package:business_object/business_object.dart\';');
    });
    test('The actual model file gets imported', () async {
      final generator = BusinessFormGenerator();
      await generator.generateModel(modelFile);

      //TODO Better test for imports per AST
      expect(formFile.readAsLinesSync().third, 'import \'invoice.dart\';');
      print(formFile.readAsStringSync());
    });
  });
}
