import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:cli_util/cli_logging.dart';
import 'package:fest/src/test_protocol.dart';
import 'package:path/path.dart';
import 'package:riverpod/riverpod.dart';
import 'package:collection/collection.dart';

Future<void> festCommandRunner(List<String> args) async {
  final parser = ArgParser();
  parser.addFlag(
    'watch',
    abbr: 'w',
    defaultsTo: false,
    negatable: false,
    help: 'Listens to changes in the project and '
        'run tests whenever something changed',
  );

  final result = parser.parse(args);

  return fest(
    watch: result['watch'] as bool,
  );
}

final workingDirectoryProvider = Provider((ref) => Directory.current);

final _allFilesProvider = StreamProvider<Map<String, File>>((ref) async* {
  final dir = ref.watch(workingDirectoryProvider);

  final initialFiles = await dir
      .list(recursive: true)
      .where((e) => e is File)
      .cast<File>()
      .toList();

  var files = <String, File>{
    for (final file in initialFiles) file.path: file,
  };

  yield files;

  await for (final event in dir.watch(recursive: true)) {
    if (event.type & FileSystemEvent.delete > 0) {
      files = {...files}..remove(event.path);
    }
    if (event.type & FileSystemEvent.create > 0) {
      if (!FileSystemEntity.isFileSync(event.path)) continue;

      files = {...files, event.path: File(event.path)};
    }
    yield files;
  }
});

Future<void> fest({bool watch = false, Logger? logger}) async {
  logger ??= Logger.standard();

  // if (watch) {
  //   logger.stdout('Starting fest in watch mode');
  // }

  // final container = ProviderContainer();

  // container.listen<AsyncValue<Map<String, File>>>(_allFilesProvider, (files) {
  //   if (files.data == null) print('files ${files}');

  //   print('files changed ${files.data!.value}');
  // });

  final events = ReactiveWrapper(_startTest());

  events.messages().listen((e) {
    print(e.message);
  });

  events.testStart().listen((event) async {
    final suite = await events
        .suites()
        .firstWhere((e) => e.suite.id == event.test.suiteID)
        .then((e) => e.suite);

    // If we have no information on which test was executed, this is the loading phase event.
    if (event.test.line == null &&
        event.test.column == null &&
        event.test.root_column == null &&
        event.test.root_line == null) {
      return;
    }

    // final suite = await suitesStream.
    print(
        'RUN: ${suite.path} ${event.test.line}:${event.test.column}: ${event.test.name}');

    final testDone =
        await events.testDone().firstWhere((e) => e.testID == event.test.id);

    String statusLabel;

    switch (testDone.result) {
      case TestDoneStatus.success:
        statusLabel = 'DONE';
        break;
      case TestDoneStatus.error:
        statusLabel = 'ERROR';
        break;
      case TestDoneStatus.failure:
        statusLabel = 'FAILURE';
        break;
    }

    final timeDiff = Duration(milliseconds: testDone.time) -
        Duration(milliseconds: event.time);

    print(
      '$statusLabel in ${timeDiff.inSeconds} seconds and ${timeDiff.inMilliseconds} ms',
    );

    if (testDone.result != TestDoneStatus.success) {
      final testError =
          await events.testError().firstWhere((e) => e.testID == event.test.id);

      print(testError.error);
      print(testError.stackTrace);
    }

    print('');
  });

  await events.start();

  final done = await events.done();

  print('');

  if (done.success == false) {
    exit(-1);
  }
}

Stream<TestEvent> _startTest() async* {
  final testProcess = await Process.start(
    'dart',
    ['test', '-r', 'json', '--concurrency=1'],
    environment: {
      'FEST': 'true',
    },
  );

  yield* testProcess.stdout
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

extension on Stream<TestEvent> {
  Stream<T> whereIs<T>() {
    return where((event) => event is T).cast<T>();
  }

  Future<T> firstWhereIs<T>() {
    return firstWhere((event) => event is T).then((v) => v as T);
  }
}

/// Wraps a Stream to allow accessing elements previously emitted and
/// yet-to-be-emitted events at the same time.
///
/// This is useful for things such as finding a specific event, which could
/// already be emitted, but may not be yet.
class ReactiveWrapper<Event> {
  ReactiveWrapper(Stream<Event> stream) : _stream = stream.asBroadcastStream() {
    // _stream.listen(print);
    _stream.listen(_events.add);
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
    final events = _events.where((e) => e is T).cast<T>().toList();
    for (final event in events) yield event;

    yield* _stream.where((e) => e is T).cast<T>();
  }

  Future<void> close() {
    return _subscription.cancel();
  }
}

extension on ReactiveWrapper<TestEvent> {
  Stream<TestEventSuite> suites() => whereIs<TestEventSuite>();

  FutureOr<TestEventStart> start() => firstWhereIs<TestEventStart>();
  FutureOr<TestEventDone> done() => firstWhereIs<TestEventDone>();

  Stream<TestEventTestStart> testStart() => whereIs<TestEventTestStart>();
  Stream<TestEventTestDone> testDone() => whereIs<TestEventTestDone>();
  Stream<TestEventError> testError() => whereIs<TestEventError>();

  Stream<TestEventMessage> messages() => whereIs<TestEventMessage>();
}
