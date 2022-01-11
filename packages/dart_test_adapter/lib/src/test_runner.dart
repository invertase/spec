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
) {
  final controller = StreamController<List<TestEvent>>();
  late StreamSubscription errSub;
  late StreamSubscription eventSub;
  late Future<Process> processFuture;

  controller.onListen = () async {
    processFuture = processCb();
    final process = await processFuture;

    errSub = process.stderr.map(utf8.decode).listen((err) {
      controller.addError(err);
    });

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
        .expand((j) {
          try {
            return [json.decode(j)];
          } on FormatException {
            // Flutter may send non-json logs, so we're ignoring those
            return [];
          }
        })
        .cast<Map<Object?, Object?>>()
        .map((json) => TestEvent.fromJson(Map.from(json)));

    var allEvents = const <TestEvent>[];

    eventSub = events.listen(
      (event) {
        allEvents = [...allEvents, event];
        controller.add(allEvents);
      },
      onError: controller.addError,
    );
  };

  controller.onCancel = () async {
    (await processFuture).kill();
    errSub.cancel();
    eventSub.cancel();
  };

  return controller.stream;
}
