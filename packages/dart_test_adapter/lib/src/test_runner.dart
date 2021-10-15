import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/src/iterable_extensions.dart';

import 'test_protocol.dart';

TestResult flutterTest({
  Map<String, String>? environment,
}) {
  final testProcess = Process.start(
    'flutter',
    ['test', '--reporter=json', '--no-pub'],
    environment: environment,
  );

  return _parseTestJsonOutput(testProcess);
}

TestResult dartTest({
  Map<String, String>? environment,
}) {
  final testProcess = Process.start(
    'dart',
    ['test', '--reporter=json'],
    environment: environment,
  );

  return _parseTestJsonOutput(testProcess);
}

TestResult _parseTestJsonOutput(Future<Process> processFuture) {
  Stream<TestEvent> getEventStream() async* {
    final process = await processFuture;

    yield* process.stdout
        .map(utf8.decode)
        // Sometimes a message contains multiple JSON map at once
        // so we split the message in multiple events
        .asyncExpand((msg) async* {
          for (final value in msg.split('\n')) {
            if (value.trim().isNotEmpty) yield value;
          }
        })
        .map(json.decode)
        .cast<Map<Object?, Object?>>()
        .map((json) => TestEvent.fromJson(Map.from(json)));
  }

  return TestResult._(
    _ReactiveWrapper(getEventStream()),
  );
}

// extension on Stream<TestEvent> {
//   Stream<T> whereIs<T>() {
//     return where((event) => event is T).cast<T>();
//   }

//   Future<T> firstWhereIs<T>() {
//     return firstWhere((event) => event is T).then((v) => v as T);
//   }
// }

/// Wraps a Stream to allow accessing elements previously emitted and
/// yet-to-be-emitted events at the same time.
///
/// This is useful for things such as finding a specific event, which could
/// already be emitted, but may not be yet.
class _ReactiveWrapper<Event> {
  _ReactiveWrapper(Stream<Event> stream)
      : _stream = stream.asBroadcastStream() {
    _subscription = _stream.listen(_events.add);
  }

  final _events = <Event>[];
  final Stream<Event> _stream;
  late final StreamSubscription<Event> _subscription;

  FutureOr<T> firstWhereIs<T>() {
    final value = _events.firstWhereOrNull((e) => e is T) as T?;

    if (value != null) return value;

    return _stream.firstWhere((e) => e is T).then((e) => e as T);
  }

  Stream<T> whereIs<T>() async* {
    final events = _events.whereType<T>().toList();
    for (final event in events) yield event;

    yield* _stream.where((e) => e is T).cast<T>();
  }

  Future<void> close() {
    return _subscription.cancel();
  }
}

class TestResult {
  TestResult._(this._events);

  final _ReactiveWrapper<TestEvent> _events;

  Stream<TestEvent> all() => _events.whereIs<TestEvent>();

  FutureOr<TestEventStart> start() => _events.firstWhereIs<TestEventStart>();
  FutureOr<TestEventDone> done() => _events.firstWhereIs<TestEventDone>();

  Future<TestEventAllSuites> allSuites() =>
      _events.whereIs<TestEventAllSuites>().first;

  Stream<TestEventSuite> suites() => _events.whereIs<TestEventSuite>();

  Stream<TestEventGroup> groups() => _events.whereIs<TestEventGroup>();

  Stream<TestEventTestStart> testStart() =>
      _events.whereIs<TestEventTestStart>();

  Stream<TestEventTestDone> testDone() => _events.whereIs<TestEventTestDone>();

  Stream<TestEventTestError> testError() =>
      _events.whereIs<TestEventTestError>();
}
