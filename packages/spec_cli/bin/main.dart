import 'dart:async';
import 'dart:io';

import 'package:spec_cli/src/command_runner.dart';

Future<void> main(List<String> args) async {
  final exitCode = await festCommandRunner(args);

  exit(exitCode);
}
