import 'dart:io';

import 'package:riverpod/riverpod.dart';

final $workingDirectory = Provider((ref) => Directory.current);

final $fileChange = StreamProvider<void>((ref) {
  final dir = ref.watch($workingDirectory);

  return dir
      .watch(recursive: true)
      .where((e) => !e.path.contains('/.dart_tool/'));
}, dependencies: [$workingDirectory]);

final $sigint = StreamProvider<void>((ref) => ProcessSignal.sigint.watch());
final $sigterm = StreamProvider<void>((ref) => ProcessSignal.sigterm.watch());

final $isEarlyAbort = Provider<bool>((ref) {
  return ref.watch($sigint) is AsyncData || ref.watch($sigterm) is AsyncData;
}, dependencies: [$sigint, $sigterm]);

final $startTime = Provider<DateTime>((ref) => throw UnimplementedError());
