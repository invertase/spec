import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'test_protocol.dart';

enum WebRenderer {
  auto,
  canvaskit,
  html,
}

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

// /// Wraps a Stream to allow accessing elements previously emitted and
// /// yet-to-be-emitted events at the same time.
// ///
// /// This is useful for things such as finding a specific event, which could
// /// already be emitted, but may not be yet.
// class _ReactiveWrapper<Event> {
//   _ReactiveWrapper(Stream<Event> stream)
//       : _stream = stream.asBroadcastStream() {
//     _subscription = _stream.listen(_events.add);
//   }

//   final _events = <Event>[];
//   final Stream<Event> _stream;
//   late final StreamSubscription<Event> _subscription;

//   FutureOr<T> firstWhereIs<T>() {
//     final value = _events.firstWhereOrNull((e) => e is T) as T?;

//     if (value != null) return value;

//     return _stream.firstWhere((e) => e is T).then((e) => e as T);
//   }

//   Stream<T> whereIs<T>() async* {
//     final events = _events.whereType<T>().toList();
//     for (final event in events) yield event;

//     yield* _stream.where((e) => e is T).cast<T>();
//   }

//   Future<void> close() {
//     return _subscription.cancel();
//   }
// }

// class TestResult {
//   TestResult._(this._processFuture, this._events);

//   final Future<Process> _processFuture;
//   final _ReactiveWrapper<TestEvent> _events;

//   Stream<TestEvent> all() => _events.whereIs<TestEvent>();

//   FutureOr<TestEventStart> start() => _events.firstWhereIs<TestEventStart>();
//   FutureOr<TestEventDone> done() => _events.firstWhereIs<TestEventDone>();

//   Future<TestEventAllSuites> allSuites() =>
//       _events.whereIs<TestEventAllSuites>().first;

//   Stream<TestEventSuite> suites() => _events.whereIs<TestEventSuite>();

//   Stream<TestEventGroup> groups() => _events.whereIs<TestEventGroup>();

//   Stream<TestEventMessage> messages() => _events.whereIs<TestEventMessage>();

//   Stream<TestEventTestStart> testStart() =>
//       _events.whereIs<TestEventTestStart>();

//   Stream<TestEventTestDone> testDone() => _events.whereIs<TestEventTestDone>();

//   Stream<TestEventTestError> testError() =>
//       _events.whereIs<TestEventTestError>();

//   Future<void> dispose() async {
//     _events.close();
//     (await _processFuture).kill();
//   }
// }
