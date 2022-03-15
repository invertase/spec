import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'sdk_lookup.dart';
import 'test_protocol.dart';

/// Executes `flutter test` and decode the output.
///
/// Throws a [SdkNotFoundException] if the Flutter SDK is not found.
Stream<TestEvent> flutterTest({
  Map<String, String>? environment,
  List<String>? arguments,
  List<String>? tests,
  // TODO: Typo
  String? workdingDirectory,
  // TODO(rrousselGit) expose a typed interface for CLI parameters
}) =>
    _parseTestJsonOutput(
      () async => Process.start(
        await Sdk.flutter.getDefaultExecutablePath(env: environment),
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

/// Executes `dart test` and decode the output.
///
/// Throws a [SdkNotFoundException] if the Dart SDK is not found.
Stream<TestEvent> dartTest({
  Map<String, String>? environment,
  List<String>? arguments,
  List<String>? tests,
  // TODO: Typo
  String? workdingDirectory,
  // TODO(rrousselGit) expose a typed interface for CLI parameters
}) =>
    _parseTestJsonOutput(
      () async => Process.start(
        await Sdk.dart.getDefaultExecutablePath(env: environment),
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

Stream<TestEvent> _parseTestJsonOutput(
  Future<Process> Function() processCb,
) {
  final controller = StreamController<TestEvent>();
  late StreamSubscription eventSub;
  late Future<Process> processFuture;

  controller.onListen = () async {
    processFuture = processCb();
    final process = await processFuture;

    // TODO what do to with stderr? Since Flutter may send error messages there
    // but tests may print to stderr on purpose

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
        .expand<Object?>((j) {
          try {
            return [json.decode(j)];
          } on FormatException {
            // Flutter may send non-json logs, so we're ignoring those
            return [];
          }
        })
        .cast<Map<Object?, Object?>>()
        .map((json) => TestEvent.fromJson(Map.from(json)));

    eventSub = events.listen(
      controller.add,
      onError: controller.addError,
      onDone: () async {
        controller.add(TestProcessDone(exitCode: await process.exitCode));
        await controller.close();
      },
    );
  };

  controller.onCancel = () async {
    await controller.close();
    (await processFuture).kill();
    await eventSub.cancel();
  };

  return controller.stream;
}
