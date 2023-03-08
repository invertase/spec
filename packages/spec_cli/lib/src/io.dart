import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:riverpod/riverpod.dart';

import 'dart_test.dart';

final $workingDirectory = Provider((ref) => Directory.current);

final $fileChange = StreamProvider<void>((ref) {
  // TODO observe flutter assets
  final controller = StreamController<void>();
  ref.onDispose(controller.close);

  final dir = ref.watch($workingDirectory);
  final libChange = Directory(join(dir.path, 'lib')).watch(recursive: true);
  final testChange = Directory(join(dir.path, 'test'))
      .watch(recursive: true)
      .where((event) => event.path.endsWith('.dart'));

  final libSub = libChange.listen((event) => controller.add(null));
  ref.onDispose(libSub.cancel);

  final testSub = testChange.listen((event) => controller.add(null));
  ref.onDispose(testSub.cancel);

  return controller.stream;
}, dependencies: [$workingDirectory]);

final $sigint = StreamProvider<void>((ref) => ProcessSignal.sigint.watch());
final $sigterm = StreamProvider<void>((ref) => ProcessSignal.sigterm.watch());

final $didPressQ = StateProvider<bool>((ref) => false);

final $isEarlyAbort = Provider<bool>((ref) {
  return ref.watch($sigint) is AsyncData ||
      ref.watch($sigterm) is AsyncData ||
      // During watch mode, pressing `q` quits early
      (ref.watch($isWatchMode) && ref.watch($didPressQ));
}, dependencies: [
  $sigint,
  $sigterm,
  $isWatchMode,
  $didPressQ,
]);

final $startTime = StateProvider<DateTime>((ref) => DateTime(0));
