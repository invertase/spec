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
  Future<Process> Function() process,
) {
  final events = process()
      .asStream()
      .asyncExpand((process) => process.stdout)
      .map(utf8.decode)
      // Sometimes a message contains multiple JSON map at once
      // so we split the message in multiple events
      .expand<String>((msg) sync* {
        print(msg);
        for (final value in msg.split('\n')) {
          final trimmedValue = value.trim();
          if (trimmedValue.isNotEmpty) yield trimmedValue;
        }
      })
      .map(json.decode)
      .cast<Map<Object?, Object?>>()
      .map((json) => TestEvent.fromJson(Map.from(json)));

  final allEvents = <TestEvent>[];
  final controller = StreamController<List<TestEvent>>();

  late StreamSubscription sub;
  controller.onListen = () {
    sub = events.listen((event) {
      allEvents.add(event);
      controller.add(allEvents.toList());
    });
  };
  controller.onCancel = () {
    sub.cancel();
    controller.close();
  };

  return controller.stream;
}
