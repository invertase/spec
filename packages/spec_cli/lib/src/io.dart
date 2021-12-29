import 'dart:io';

import 'package:riverpod/riverpod.dart';

final $workingDirectory = Provider((ref) => Directory.current);

final $fileChange = StreamProvider<void>((ref) {
  final dir = ref.watch($workingDirectory);

  return dir
      .watch(recursive: true)
      .where((e) => !e.path.contains('/.dart_tool/'));
}, dependencies: [$workingDirectory]);
