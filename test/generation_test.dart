import 'package:business_object/src/generator.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:test/test.dart';

import 'model/invoice.dart';

void main() {
  group('BusinessModelTest', () {
    test('A new file is created with the name of the model and a _form suffix',
        () async {
      final fs = LocalFileSystem();
      final Directory tmp =
          await fs.systemTempDirectory.createTemp('business_object_test');
      final modelFile = tmp.childFile('invoice.dart');
      modelFile.writeAsStringSync(invoiceString);

      expect(tmp.listSync().map((e) => e.basename), ['invoice.dart']);

      final generator = BusinessFormGenerator();
      await generator.generateModel(modelFile);

      expect(tmp.listSync().map((e) => e.basename),
          ['invoice.dart', 'invoice_form.dart']);
      tmp.delete(recursive: true);
    });
  });
}
