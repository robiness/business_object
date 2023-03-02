import 'dart:io';

import 'package:args/args.dart';
import 'package:business_object/src/generator.dart';
import 'package:dartx/dartx_io.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser();
  parser.addOption(
    'file',
    abbr: 'f',
    help: 'The file to generate the business form data for',
  );

  final currentDir = Directory('${Directory.current.path}/lib/src/models');
  for (final file in currentDir.listSync()) {
    if (file is File && file.extension == '.dart') {
      await file.generateBusinessObject();
    }
  }
}
