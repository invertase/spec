import 'dart:async';
import 'dart:io';

import 'package:spec_cli/src/command_runner.dart';

Future<void> main(List<String> args) async {
  final exitCode = await specCommandRunner(args);

  exit(exitCode);
}
