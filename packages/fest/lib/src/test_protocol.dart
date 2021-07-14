import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_protocol.g.dart';
part 'test_protocol.freezed.dart';

enum TestDoneStatus {
  success,

  /// if the test had a TestFailure but no other errors.
  failure,

  /// if the test had an error other than a TestFailure.
  error,
}

/// Imported from https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md
@Freezed(unionKey: 'type', fallbackUnion: 'unknown')
class TestEvent with _$TestEvent {
  factory TestEvent.start({
    required String protocolVersion,
    required int pid,
    required int time,
    String? runnerVersion,
  }) = TestEventStart;

  factory TestEvent.done({
    /// Whether all tests succeeded (or were skipped).
    ///
    /// Will be `null` if the test runner was close before all tests completed
    /// running.
    required bool? success,
    required int time,
  }) = TestEventDone;

  factory TestEvent.allSuites({
    required int count,
    required int time,
  }) = TestEventAllSuites;

  factory TestEvent.suite(Suite suite, {required int time}) = TestEventSuite;

  factory TestEvent.group(Group group, {required int time}) = TestEventGroup;

  factory TestEvent.testStart(Test test, {required int time}) =
      TestEventTestStart;

  factory TestEvent.testDone({
    required int time,
    required int testID,
    required bool hidden,
    required bool skipped,
    required TestDoneStatus result,
  }) = TestEventTestDone;

  factory TestEvent.print({
    required int time,
    required int testID,
    required String messageType,
    required String message,
  }) = TestEventMessage;

  factory TestEvent.error({
    required int time,
    required int testID,
    required String error,
    required String stackTrace,
    required bool isFailure,
  }) = TestEventError;

  factory TestEvent.debug({
    required int time,
    required int suiteID,
    String? observatory,
    String? remoteDebugger,
  }) = TestEventDebug;

  factory TestEvent.unknown({required int time}) = TestEventUnknown;

  factory TestEvent.fromJson(Map<String, Object?> json) =>
      _$TestEventFromJson(json);

  int get time;
}

@freezed
class Test with _$Test {
  factory Test({
    /// An opaque ID for the test.
    required int id,

    /// The name of the test, including prefixes from any containing groups.
    required String name,

    /// The ID of the suite containing this test.
    required int suiteID,

    /// The IDs of groups containing this test, in order from outermost to
    /// innermost.
    required List<int> groupIDs,

    /// The (1-based) line on which the test was defined, or `null`.
    int? line,

    /// The (1-based) column on which the test was defined, or `null`.
    int? column,

    /// The URL for the file in which the test was defined, or `null`.
    String? url,

    /// The (1-based) line in the original test suite from which the test
    /// originated.
    ///
    /// Will only be present if `root_url` is different from `url`.
    int? root_line,

    /// The (1-based) line on in the original test suite from which the test
    /// originated.
    ///
    /// Will only be present if `root_url` is different from `url`.
    int? root_column,

    /// The URL for the original test suite in which the test was defined.
    ///
    /// Will only be present if different from `url`.
    String? root_url,

    /// This field is deprecated and should not be used.
    required Metadata metadata,
  }) = _Test;

  factory Test.fromJson(Map<String, Object?> json) => _$TestFromJson(json);
}

@freezed
class Suite with _$Suite {
  factory Suite({
    /// An opaque ID for the group.
    required int id,

    /// The platform on which the suite is running.
    required String platform,

    /// The path to the suite's file, or `null` if that path is unknown.
    String? path,
  }) = _Suite;

  factory Suite.fromJson(Map<String, Object?> json) => _$SuiteFromJson(json);
}

@freezed
class Group with _$Group {
  factory Group({
    /// An opaque ID for the group.
    required int id,

    /// The name of the group, including prefixes from any containing groups.
    required String name,

    /// The ID of the suite containing this group.
    required int suiteID,

    /// The ID of the group's parent group, unless it's the root group.
    int? parentID,

    /// The number of tests (recursively) within this group.
    required int testCount,

    /// The (1-based) line on which the group was defined, or `null`.
    int? line,

    /// The (1-based) column on which the group was defined, or `null`.
    int? column,

    /// The URL for the file in which the group was defined, or `null`.
    String? url,

    /// This field is deprecated and should not be used.
    required Metadata metadata,
  }) = _Group;

  factory Group.fromJson(Map<String, Object?> json) => _$GroupFromJson(json);
}

@freezed
class Metadata with _$Metadata {
  factory Metadata({
    required bool skip,

    // The reason the tests was skipped, or `null` if it wasn't skipped.
    String? skipReason,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, Object?> json) =>
      _$MetadataFromJson(json);
}
