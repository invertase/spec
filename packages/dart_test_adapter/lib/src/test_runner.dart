import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'test_protocol.dart';

Stream<List<TestEvent>> flutterTest({
  Map<String, String>? environment,
  List<String>? arguments,
  List<String>? tests,
  String? workdingDirectory,
  // TODO(rrousselGit) expose a typed interface for CLI parameters
}) {
  return _parseTestJsonOutput(
    () => Process.start(
      'flutter',
      [
        'test',
        ...?arguments,
        '--reporter=json',
        '--no-pub',
        '--chain-stack-traces',
        ...?tests,
      ],
      environment: environment,
      workingDirectory: workdingDirectory,
    ),
  );
}

Stream<List<TestEvent>> dartTest({
  Map<String, String>? environment,
  List<String>? arguments,
  List<String>? tests,
  String? workdingDirectory,
  // TODO(rrousselGit) expose a typed interface for CLI parameters
}) {
  return _parseTestJsonOutput(
    () => Process.start(
      'dart',
      [
        // '--packages=${await Isolate.packageConfig}',
        'test',
        ...?arguments,
        '--reporter=json',
        '--chain-stack-traces',
        ...?tests,
      ],
      environment: environment,
      workingDirectory: workdingDirectory,
    ),
  );
}

Stream<List<TestEvent>> _parseTestJsonOutput(
  Future<Process> Function() processCb,
) async* {
  final process = await processCb();

  final events = process.stdout
      .map(utf8.decode)
      // Sometimes a message contains multiple JSON map at once
      // so we split the message in multiple events
      .expand<String>((msg) sync* {
        for (final value in msg.split('\n')) {
          final trimmedValue = value.trim();
          if (trimmedValue.isNotEmpty) yield trimmedValue;
        }
      })
      .map(json.decode)
      .cast<Map<Object?, Object?>>()
      .map((json) => TestEvent.fromJson(Map.from(json)));

  final allEvents = <TestEvent>[];

  try {
    await for (final event in events) {
      allEvents.add(event);
      yield allEvents.toList();
    }
  } finally {
    process.kill();
  }
}
