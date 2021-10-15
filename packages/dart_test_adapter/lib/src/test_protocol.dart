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

/// This is the root class of the protocol. All root-level objects emitted by the JSON reporter will be subclasses of Event.
///
/// Imported from https://github.com/dart-lang/test/blob/master/pkgs/test/doc/json_reporter.md
@Freezed(unionKey: 'type', fallbackUnion: 'unknown')
class TestEvent with _$TestEvent {
  /// A single start event is emitted before any other events.
  ///
  /// It indicates that the test runner has started running.
  factory TestEvent.start({
    required String protocolVersion,
    required int pid,
    required int time,
    String? runnerVersion,
  }) = TestEventStart;

  /// An event indicating the result of the entire test run.
  ///
  /// This will be the final event emitted by the reporter.
  factory TestEvent.done({
    /// Whether all tests succeeded (or were skipped).
    ///
    /// Will be `null` if the test runner was close before all tests completed
    /// running.
    required bool? success,
    required int time,
  }) = TestEventDone;

  /// A single suite count event is emitted once the test runner knows the total
  /// number of suites that will be loaded over the course of the test run.
  ///
  /// Because this is determined asynchronously, its position relative to other
  /// events (except StartEvent) is not guaranteed.
  factory TestEvent.allSuites({
    required int count,
    required int time,
  }) = TestEventAllSuites;

  /// A suite event is emitted before any GroupEvents for groups in a given test suite.
  ///
  /// This is the only event that contains the full metadata about a suite;
  /// future events will refer to the suite by its opaque ID.
  factory TestEvent.suite(Suite suite, {required int time}) = TestEventSuite;

  /// A group event is emitted before any TestStartEvents for tests in a given group.
  ///
  /// This is the only event that contains the full metadata about a group;
  /// future events will refer to the group by its opaque ID.
  ///
  /// This includes the implicit group at the root of each suite, which has a
  /// null name. However, it does not include implicit groups for the virtual
  /// suites generated to represent loading test files.
  ///
  /// If the group is skipped, a single TestStartEvent will be emitted for a
  /// test within the group, followed by a TestDoneEvent marked as skipped.
  /// The group.metadata field should not be used for determining whether a
  /// group is skipped.
  factory TestEvent.group(Group group, {required int time}) = TestEventGroup;

  /// An event emitted when a test begins running.
  ///
  /// This is the only event that contains the full metadata about a test;
  /// future events will refer to the test by its opaque ID.
  ///
  /// If the test is skipped, its TestDoneEvent will have skipped set to true.
  /// The test.metadata should not be used for determining whether a test is skipped.
  factory TestEvent.testStart(Test test, {required int time}) =
      TestEventTestStart;

  /// An event emitted when a test completes.
  ///
  /// If the test encountered an error, the TestDoneEvent will be emitted after
  /// the corresponding ErrorEvent.
  ///
  /// The hidden attribute indicates that the test's result should be hidden and
  /// not counted towards the total number of tests run for the suite.
  /// This is true for virtual tests created for loading test suites, setUpAll(),
  /// and tearDownAll(). Only successful tests will be hidden.
  ///
  /// Note that it's possible for a test to encounter an error after completing.
  /// In that case, it should be considered to have failed, but no additional
  /// TestDoneEvent will be emitted. If a previously-hidden test encounters an
  /// error after completing, it should be made visible.
  factory TestEvent.testDone({
    required int time,
    required int testID,
    required bool hidden,
    required bool skipped,
    required TestDoneStatus result,
  }) = TestEventTestDone;

  /// A MessageEvent indicates that a test emitted a message that should be
  /// displayed to the user.
  ///
  /// The messageType field indicates the precise type of this message.
  /// Different message types should be visually distinguishable.
  ///
  /// A message of type "print" comes from a user explicitly calling print().
  ///
  /// A message of type "skip" comes from a test, or a section of a test, being
  /// skipped. A skip message shouldn't be considered the authoritative source
  /// that a test was skipped; the TestDoneEvent.skipped field should be used instead.
  factory TestEvent.print({
    required int time,
    required int testID,
    required String messageType,
    required String message,
  }) = TestEventMessage;

  /// A ErrorEvent indicates that a test encountered an uncaught error.
  ///
  /// Note that this may happen even after the test has completed, in which case
  /// it should be considered to have failed.
  ///
  /// If a test is asynchronous, it may encounter multiple errors, which will
  /// result in multiple ErrorEvents.
  factory TestEvent.error({
    required int time,
    required int testID,
    required String error,
    required String stackTrace,
    required bool isFailure,
  }) = TestEventTestError;

  /// A debug event is emitted after (although not necessarily directly after) a SuiteEvent,
  /// and includes information about how to debug that suite.
  ///
  /// It's only emitted if the --debug flag is passed to the test runner.
  ///
  /// Note that the remoteDebugger URL refers to a remote debugger whose protocol
  /// may differ based on the browser the suite is running on. You can tell which
  /// protocol is in use by the Suite.platform field for the suite with the given ID.
  /// Since the same browser instance is used for multiple suites, different
  /// suites may have the same host URL, although only one suite at a time will
  /// be active when --pause-after-load is passed.
  factory TestEvent.debug({
    required int time,
    required int suiteID,
    String? observatory,
    String? remoteDebugger,
  }) = TestEventDebug;

  /// When an event that doesn't match any other type was received.
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
