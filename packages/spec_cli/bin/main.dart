import 'dart:async';

import 'package:spec_cli/src/command_runner.dart';
import 'package:spec_cli/src/container.dart';

Future<void> main(List<String> args) async {
  await festCommandRunner(args);
}
