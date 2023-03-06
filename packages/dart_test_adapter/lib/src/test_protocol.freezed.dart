// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'test_protocol.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TestEvent _$TestEventFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'start':
      return TestEventStart.fromJson(json);
    case 'done':
      return TestEventDone.fromJson(json);
    case 'allSuites':
      return TestEventAllSuites.fromJson(json);
    case 'suite':
      return TestEventSuite.fromJson(json);
    case 'group':
      return TestEventGroup.fromJson(json);
    case 'testStart':
      return TestEventTestStart.fromJson(json);
    case 'testDone':
      return TestEventTestDone.fromJson(json);
    case 'print':
      return TestEventMessage.fromJson(json);
    case 'error':
      return TestEventTestError.fromJson(json);
    case 'debug':
      return TestEventDebug.fromJson(json);
    case 'processDone':
      return TestProcessDone.fromJson(json);

    default:
      return TestEventUnknown.fromJson(json);
  }
}

/// @nodoc
mixin _$TestEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestEventCopyWith<$Res> {
  factory $TestEventCopyWith(TestEvent value, $Res Function(TestEvent) then) =
      _$TestEventCopyWithImpl<$Res, TestEvent>;
}

/// @nodoc
class _$TestEventCopyWithImpl<$Res, $Val extends TestEvent>
    implements $TestEventCopyWith<$Res> {
  _$TestEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$TestEventStartCopyWith<$Res> {
  factory _$$TestEventStartCopyWith(
          _$TestEventStart value, $Res Function(_$TestEventStart) then) =
      __$$TestEventStartCopyWithImpl<$Res>;
  @useResult
  $Res call({String protocolVersion, int pid, int time, String? runnerVersion});
}

/// @nodoc
class __$$TestEventStartCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventStart>
    implements _$$TestEventStartCopyWith<$Res> {
  __$$TestEventStartCopyWithImpl(
      _$TestEventStart _value, $Res Function(_$TestEventStart) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? protocolVersion = null,
    Object? pid = null,
    Object? time = null,
    Object? runnerVersion = freezed,
  }) {
    return _then(_$TestEventStart(
      protocolVersion: null == protocolVersion
          ? _value.protocolVersion
          : protocolVersion // ignore: cast_nullable_to_non_nullable
              as String,
      pid: null == pid
          ? _value.pid
          : pid // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      runnerVersion: freezed == runnerVersion
          ? _value.runnerVersion
          : runnerVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventStart implements TestEventStart {
  _$TestEventStart(
      {required this.protocolVersion,
      required this.pid,
      required this.time,
      this.runnerVersion,
      final String? $type})
      : $type = $type ?? 'start';

  factory _$TestEventStart.fromJson(Map<String, dynamic> json) =>
      _$$TestEventStartFromJson(json);

  @override
  final String protocolVersion;
  @override
  final int pid;
  @override
  final int time;
  @override
  final String? runnerVersion;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.start(protocolVersion: $protocolVersion, pid: $pid, time: $time, runnerVersion: $runnerVersion)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventStart &&
            (identical(other.protocolVersion, protocolVersion) ||
                other.protocolVersion == protocolVersion) &&
            (identical(other.pid, pid) || other.pid == pid) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.runnerVersion, runnerVersion) ||
                other.runnerVersion == runnerVersion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, protocolVersion, pid, time, runnerVersion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventStartCopyWith<_$TestEventStart> get copyWith =>
      __$$TestEventStartCopyWithImpl<_$TestEventStart>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return start(protocolVersion, pid, time, runnerVersion);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return start?.call(protocolVersion, pid, time, runnerVersion);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (start != null) {
      return start(protocolVersion, pid, time, runnerVersion);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return start(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return start?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (start != null) {
      return start(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventStartToJson(
      this,
    );
  }
}

abstract class TestEventStart implements TestEvent {
  factory TestEventStart(
      {required final String protocolVersion,
      required final int pid,
      required final int time,
      final String? runnerVersion}) = _$TestEventStart;

  factory TestEventStart.fromJson(Map<String, dynamic> json) =
      _$TestEventStart.fromJson;

  String get protocolVersion;
  int get pid;
  int get time;
  String? get runnerVersion;
  @JsonKey(ignore: true)
  _$$TestEventStartCopyWith<_$TestEventStart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventDoneCopyWith<$Res> {
  factory _$$TestEventDoneCopyWith(
          _$TestEventDone value, $Res Function(_$TestEventDone) then) =
      __$$TestEventDoneCopyWithImpl<$Res>;
  @useResult
  $Res call({bool? success, int time});
}

/// @nodoc
class __$$TestEventDoneCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventDone>
    implements _$$TestEventDoneCopyWith<$Res> {
  __$$TestEventDoneCopyWithImpl(
      _$TestEventDone _value, $Res Function(_$TestEventDone) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? time = null,
  }) {
    return _then(_$TestEventDone(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventDone implements TestEventDone {
  _$TestEventDone(
      {required this.success, required this.time, final String? $type})
      : $type = $type ?? 'done';

  factory _$TestEventDone.fromJson(Map<String, dynamic> json) =>
      _$$TestEventDoneFromJson(json);

  /// Whether all tests succeeded (or were skipped).
  ///
  /// Will be `null` if the test runner was close before all tests completed
  /// running.
  @override
  final bool? success;
  @override
  final int time;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.done(success: $success, time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventDone &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, success, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventDoneCopyWith<_$TestEventDone> get copyWith =>
      __$$TestEventDoneCopyWithImpl<_$TestEventDone>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return done(success, time);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return done?.call(success, time);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(success, time);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return done(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return done?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (done != null) {
      return done(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventDoneToJson(
      this,
    );
  }
}

abstract class TestEventDone implements TestEvent {
  factory TestEventDone(
      {required final bool? success,
      required final int time}) = _$TestEventDone;

  factory TestEventDone.fromJson(Map<String, dynamic> json) =
      _$TestEventDone.fromJson;

  /// Whether all tests succeeded (or were skipped).
  ///
  /// Will be `null` if the test runner was close before all tests completed
  /// running.
  bool? get success;
  int get time;
  @JsonKey(ignore: true)
  _$$TestEventDoneCopyWith<_$TestEventDone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventAllSuitesCopyWith<$Res> {
  factory _$$TestEventAllSuitesCopyWith(_$TestEventAllSuites value,
          $Res Function(_$TestEventAllSuites) then) =
      __$$TestEventAllSuitesCopyWithImpl<$Res>;
  @useResult
  $Res call({int count, int time});
}

/// @nodoc
class __$$TestEventAllSuitesCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventAllSuites>
    implements _$$TestEventAllSuitesCopyWith<$Res> {
  __$$TestEventAllSuitesCopyWithImpl(
      _$TestEventAllSuites _value, $Res Function(_$TestEventAllSuites) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? time = null,
  }) {
    return _then(_$TestEventAllSuites(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventAllSuites implements TestEventAllSuites {
  _$TestEventAllSuites(
      {required this.count, required this.time, final String? $type})
      : $type = $type ?? 'allSuites';

  factory _$TestEventAllSuites.fromJson(Map<String, dynamic> json) =>
      _$$TestEventAllSuitesFromJson(json);

  @override
  final int count;
  @override
  final int time;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.allSuites(count: $count, time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventAllSuites &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, count, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventAllSuitesCopyWith<_$TestEventAllSuites> get copyWith =>
      __$$TestEventAllSuitesCopyWithImpl<_$TestEventAllSuites>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return allSuites(count, time);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return allSuites?.call(count, time);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (allSuites != null) {
      return allSuites(count, time);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return allSuites(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return allSuites?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (allSuites != null) {
      return allSuites(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventAllSuitesToJson(
      this,
    );
  }
}

abstract class TestEventAllSuites implements TestEvent {
  factory TestEventAllSuites(
      {required final int count,
      required final int time}) = _$TestEventAllSuites;

  factory TestEventAllSuites.fromJson(Map<String, dynamic> json) =
      _$TestEventAllSuites.fromJson;

  int get count;
  int get time;
  @JsonKey(ignore: true)
  _$$TestEventAllSuitesCopyWith<_$TestEventAllSuites> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventSuiteCopyWith<$Res> {
  factory _$$TestEventSuiteCopyWith(
          _$TestEventSuite value, $Res Function(_$TestEventSuite) then) =
      __$$TestEventSuiteCopyWithImpl<$Res>;
  @useResult
  $Res call({Suite suite, int time});

  $SuiteCopyWith<$Res> get suite;
}

/// @nodoc
class __$$TestEventSuiteCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventSuite>
    implements _$$TestEventSuiteCopyWith<$Res> {
  __$$TestEventSuiteCopyWithImpl(
      _$TestEventSuite _value, $Res Function(_$TestEventSuite) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suite = null,
    Object? time = null,
  }) {
    return _then(_$TestEventSuite(
      null == suite
          ? _value.suite
          : suite // ignore: cast_nullable_to_non_nullable
              as Suite,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $SuiteCopyWith<$Res> get suite {
    return $SuiteCopyWith<$Res>(_value.suite, (value) {
      return _then(_value.copyWith(suite: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventSuite implements TestEventSuite {
  _$TestEventSuite(this.suite, {required this.time, final String? $type})
      : $type = $type ?? 'suite';

  factory _$TestEventSuite.fromJson(Map<String, dynamic> json) =>
      _$$TestEventSuiteFromJson(json);

  @override
  final Suite suite;
  @override
  final int time;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.suite(suite: $suite, time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventSuite &&
            (identical(other.suite, suite) || other.suite == suite) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, suite, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventSuiteCopyWith<_$TestEventSuite> get copyWith =>
      __$$TestEventSuiteCopyWithImpl<_$TestEventSuite>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return suite(this.suite, time);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return suite?.call(this.suite, time);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (suite != null) {
      return suite(this.suite, time);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return suite(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return suite?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (suite != null) {
      return suite(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventSuiteToJson(
      this,
    );
  }
}

abstract class TestEventSuite implements TestEvent {
  factory TestEventSuite(final Suite suite, {required final int time}) =
      _$TestEventSuite;

  factory TestEventSuite.fromJson(Map<String, dynamic> json) =
      _$TestEventSuite.fromJson;

  Suite get suite;
  int get time;
  @JsonKey(ignore: true)
  _$$TestEventSuiteCopyWith<_$TestEventSuite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventGroupCopyWith<$Res> {
  factory _$$TestEventGroupCopyWith(
          _$TestEventGroup value, $Res Function(_$TestEventGroup) then) =
      __$$TestEventGroupCopyWithImpl<$Res>;
  @useResult
  $Res call({Group group, int time});

  $GroupCopyWith<$Res> get group;
}

/// @nodoc
class __$$TestEventGroupCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventGroup>
    implements _$$TestEventGroupCopyWith<$Res> {
  __$$TestEventGroupCopyWithImpl(
      _$TestEventGroup _value, $Res Function(_$TestEventGroup) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = null,
    Object? time = null,
  }) {
    return _then(_$TestEventGroup(
      null == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $GroupCopyWith<$Res> get group {
    return $GroupCopyWith<$Res>(_value.group, (value) {
      return _then(_value.copyWith(group: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventGroup implements TestEventGroup {
  _$TestEventGroup(this.group, {required this.time, final String? $type})
      : $type = $type ?? 'group';

  factory _$TestEventGroup.fromJson(Map<String, dynamic> json) =>
      _$$TestEventGroupFromJson(json);

  @override
  final Group group;
  @override
  final int time;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.group(group: $group, time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventGroup &&
            (identical(other.group, group) || other.group == group) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, group, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventGroupCopyWith<_$TestEventGroup> get copyWith =>
      __$$TestEventGroupCopyWithImpl<_$TestEventGroup>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return group(this.group, time);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return group?.call(this.group, time);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (group != null) {
      return group(this.group, time);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return group(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return group?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (group != null) {
      return group(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventGroupToJson(
      this,
    );
  }
}

abstract class TestEventGroup implements TestEvent {
  factory TestEventGroup(final Group group, {required final int time}) =
      _$TestEventGroup;

  factory TestEventGroup.fromJson(Map<String, dynamic> json) =
      _$TestEventGroup.fromJson;

  Group get group;
  int get time;
  @JsonKey(ignore: true)
  _$$TestEventGroupCopyWith<_$TestEventGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventTestStartCopyWith<$Res> {
  factory _$$TestEventTestStartCopyWith(_$TestEventTestStart value,
          $Res Function(_$TestEventTestStart) then) =
      __$$TestEventTestStartCopyWithImpl<$Res>;
  @useResult
  $Res call({Test test, int time});

  $TestCopyWith<$Res> get test;
}

/// @nodoc
class __$$TestEventTestStartCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventTestStart>
    implements _$$TestEventTestStartCopyWith<$Res> {
  __$$TestEventTestStartCopyWithImpl(
      _$TestEventTestStart _value, $Res Function(_$TestEventTestStart) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? test = null,
    Object? time = null,
  }) {
    return _then(_$TestEventTestStart(
      null == test
          ? _value.test
          : test // ignore: cast_nullable_to_non_nullable
              as Test,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TestCopyWith<$Res> get test {
    return $TestCopyWith<$Res>(_value.test, (value) {
      return _then(_value.copyWith(test: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventTestStart implements TestEventTestStart {
  _$TestEventTestStart(this.test, {required this.time, final String? $type})
      : $type = $type ?? 'testStart';

  factory _$TestEventTestStart.fromJson(Map<String, dynamic> json) =>
      _$$TestEventTestStartFromJson(json);

  @override
  final Test test;
  @override
  final int time;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.testStart(test: $test, time: $time)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventTestStart &&
            (identical(other.test, test) || other.test == test) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, test, time);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventTestStartCopyWith<_$TestEventTestStart> get copyWith =>
      __$$TestEventTestStartCopyWithImpl<_$TestEventTestStart>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return testStart(test, time);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return testStart?.call(test, time);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (testStart != null) {
      return testStart(test, time);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return testStart(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return testStart?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (testStart != null) {
      return testStart(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventTestStartToJson(
      this,
    );
  }
}

abstract class TestEventTestStart implements TestEvent {
  factory TestEventTestStart(final Test test, {required final int time}) =
      _$TestEventTestStart;

  factory TestEventTestStart.fromJson(Map<String, dynamic> json) =
      _$TestEventTestStart.fromJson;

  Test get test;
  int get time;
  @JsonKey(ignore: true)
  _$$TestEventTestStartCopyWith<_$TestEventTestStart> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventTestDoneCopyWith<$Res> {
  factory _$$TestEventTestDoneCopyWith(
          _$TestEventTestDone value, $Res Function(_$TestEventTestDone) then) =
      __$$TestEventTestDoneCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int time, int testID, bool hidden, bool skipped, TestDoneStatus result});
}

/// @nodoc
class __$$TestEventTestDoneCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventTestDone>
    implements _$$TestEventTestDoneCopyWith<$Res> {
  __$$TestEventTestDoneCopyWithImpl(
      _$TestEventTestDone _value, $Res Function(_$TestEventTestDone) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? testID = null,
    Object? hidden = null,
    Object? skipped = null,
    Object? result = null,
  }) {
    return _then(_$TestEventTestDone(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      testID: null == testID
          ? _value.testID
          : testID // ignore: cast_nullable_to_non_nullable
              as int,
      hidden: null == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool,
      skipped: null == skipped
          ? _value.skipped
          : skipped // ignore: cast_nullable_to_non_nullable
              as bool,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as TestDoneStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventTestDone implements TestEventTestDone {
  _$TestEventTestDone(
      {required this.time,
      required this.testID,
      required this.hidden,
      required this.skipped,
      required this.result,
      final String? $type})
      : $type = $type ?? 'testDone';

  factory _$TestEventTestDone.fromJson(Map<String, dynamic> json) =>
      _$$TestEventTestDoneFromJson(json);

  @override
  final int time;
  @override
  final int testID;
  @override
  final bool hidden;
  @override
  final bool skipped;
  @override
  final TestDoneStatus result;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.testDone(time: $time, testID: $testID, hidden: $hidden, skipped: $skipped, result: $result)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventTestDone &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.testID, testID) || other.testID == testID) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.skipped, skipped) || other.skipped == skipped) &&
            (identical(other.result, result) || other.result == result));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, time, testID, hidden, skipped, result);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventTestDoneCopyWith<_$TestEventTestDone> get copyWith =>
      __$$TestEventTestDoneCopyWithImpl<_$TestEventTestDone>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return testDone(time, testID, hidden, skipped, result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return testDone?.call(time, testID, hidden, skipped, result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (testDone != null) {
      return testDone(time, testID, hidden, skipped, result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return testDone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return testDone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (testDone != null) {
      return testDone(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventTestDoneToJson(
      this,
    );
  }
}

abstract class TestEventTestDone implements TestEvent {
  factory TestEventTestDone(
      {required final int time,
      required final int testID,
      required final bool hidden,
      required final bool skipped,
      required final TestDoneStatus result}) = _$TestEventTestDone;

  factory TestEventTestDone.fromJson(Map<String, dynamic> json) =
      _$TestEventTestDone.fromJson;

  int get time;
  int get testID;
  bool get hidden;
  bool get skipped;
  TestDoneStatus get result;
  @JsonKey(ignore: true)
  _$$TestEventTestDoneCopyWith<_$TestEventTestDone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventMessageCopyWith<$Res> {
  factory _$$TestEventMessageCopyWith(
          _$TestEventMessage value, $Res Function(_$TestEventMessage) then) =
      __$$TestEventMessageCopyWithImpl<$Res>;
  @useResult
  $Res call({int time, int testID, String messageType, String message});
}

/// @nodoc
class __$$TestEventMessageCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventMessage>
    implements _$$TestEventMessageCopyWith<$Res> {
  __$$TestEventMessageCopyWithImpl(
      _$TestEventMessage _value, $Res Function(_$TestEventMessage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? testID = null,
    Object? messageType = null,
    Object? message = null,
  }) {
    return _then(_$TestEventMessage(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      testID: null == testID
          ? _value.testID
          : testID // ignore: cast_nullable_to_non_nullable
              as int,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventMessage implements TestEventMessage {
  _$TestEventMessage(
      {required this.time,
      required this.testID,
      required this.messageType,
      required this.message,
      final String? $type})
      : $type = $type ?? 'print';

  factory _$TestEventMessage.fromJson(Map<String, dynamic> json) =>
      _$$TestEventMessageFromJson(json);

  @override
  final int time;
  @override
  final int testID;
  @override
  final String messageType;
  @override
  final String message;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.print(time: $time, testID: $testID, messageType: $messageType, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventMessage &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.testID, testID) || other.testID == testID) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, time, testID, messageType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventMessageCopyWith<_$TestEventMessage> get copyWith =>
      __$$TestEventMessageCopyWithImpl<_$TestEventMessage>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return print(time, testID, messageType, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return print?.call(time, testID, messageType, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (print != null) {
      return print(time, testID, messageType, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return print(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return print?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (print != null) {
      return print(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventMessageToJson(
      this,
    );
  }
}

abstract class TestEventMessage implements TestEvent {
  factory TestEventMessage(
      {required final int time,
      required final int testID,
      required final String messageType,
      required final String message}) = _$TestEventMessage;

  factory TestEventMessage.fromJson(Map<String, dynamic> json) =
      _$TestEventMessage.fromJson;

  int get time;
  int get testID;
  String get messageType;
  String get message;
  @JsonKey(ignore: true)
  _$$TestEventMessageCopyWith<_$TestEventMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventTestErrorCopyWith<$Res> {
  factory _$$TestEventTestErrorCopyWith(_$TestEventTestError value,
          $Res Function(_$TestEventTestError) then) =
      __$$TestEventTestErrorCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int time, int testID, String error, String stackTrace, bool isFailure});
}

/// @nodoc
class __$$TestEventTestErrorCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventTestError>
    implements _$$TestEventTestErrorCopyWith<$Res> {
  __$$TestEventTestErrorCopyWithImpl(
      _$TestEventTestError _value, $Res Function(_$TestEventTestError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? testID = null,
    Object? error = null,
    Object? stackTrace = null,
    Object? isFailure = null,
  }) {
    return _then(_$TestEventTestError(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      testID: null == testID
          ? _value.testID
          : testID // ignore: cast_nullable_to_non_nullable
              as int,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      stackTrace: null == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as String,
      isFailure: null == isFailure
          ? _value.isFailure
          : isFailure // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventTestError implements TestEventTestError {
  _$TestEventTestError(
      {required this.time,
      required this.testID,
      required this.error,
      required this.stackTrace,
      required this.isFailure,
      final String? $type})
      : $type = $type ?? 'error';

  factory _$TestEventTestError.fromJson(Map<String, dynamic> json) =>
      _$$TestEventTestErrorFromJson(json);

  @override
  final int time;
  @override
  final int testID;
  @override
  final String error;
  @override
  final String stackTrace;
  @override
  final bool isFailure;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.error(time: $time, testID: $testID, error: $error, stackTrace: $stackTrace, isFailure: $isFailure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventTestError &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.testID, testID) || other.testID == testID) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            (identical(other.isFailure, isFailure) ||
                other.isFailure == isFailure));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, time, testID, error, stackTrace, isFailure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventTestErrorCopyWith<_$TestEventTestError> get copyWith =>
      __$$TestEventTestErrorCopyWithImpl<_$TestEventTestError>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return error(time, testID, this.error, stackTrace, isFailure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return error?.call(time, testID, this.error, stackTrace, isFailure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(time, testID, this.error, stackTrace, isFailure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventTestErrorToJson(
      this,
    );
  }
}

abstract class TestEventTestError implements TestEvent {
  factory TestEventTestError(
      {required final int time,
      required final int testID,
      required final String error,
      required final String stackTrace,
      required final bool isFailure}) = _$TestEventTestError;

  factory TestEventTestError.fromJson(Map<String, dynamic> json) =
      _$TestEventTestError.fromJson;

  int get time;
  int get testID;
  String get error;
  String get stackTrace;
  bool get isFailure;
  @JsonKey(ignore: true)
  _$$TestEventTestErrorCopyWith<_$TestEventTestError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventDebugCopyWith<$Res> {
  factory _$$TestEventDebugCopyWith(
          _$TestEventDebug value, $Res Function(_$TestEventDebug) then) =
      __$$TestEventDebugCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int time, int suiteID, String? observatory, String? remoteDebugger});
}

/// @nodoc
class __$$TestEventDebugCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventDebug>
    implements _$$TestEventDebugCopyWith<$Res> {
  __$$TestEventDebugCopyWithImpl(
      _$TestEventDebug _value, $Res Function(_$TestEventDebug) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? suiteID = null,
    Object? observatory = freezed,
    Object? remoteDebugger = freezed,
  }) {
    return _then(_$TestEventDebug(
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      suiteID: null == suiteID
          ? _value.suiteID
          : suiteID // ignore: cast_nullable_to_non_nullable
              as int,
      observatory: freezed == observatory
          ? _value.observatory
          : observatory // ignore: cast_nullable_to_non_nullable
              as String?,
      remoteDebugger: freezed == remoteDebugger
          ? _value.remoteDebugger
          : remoteDebugger // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestEventDebug implements TestEventDebug {
  _$TestEventDebug(
      {required this.time,
      required this.suiteID,
      this.observatory,
      this.remoteDebugger,
      final String? $type})
      : $type = $type ?? 'debug';

  factory _$TestEventDebug.fromJson(Map<String, dynamic> json) =>
      _$$TestEventDebugFromJson(json);

  @override
  final int time;
  @override
  final int suiteID;
  @override
  final String? observatory;
  @override
  final String? remoteDebugger;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.debug(time: $time, suiteID: $suiteID, observatory: $observatory, remoteDebugger: $remoteDebugger)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestEventDebug &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.suiteID, suiteID) || other.suiteID == suiteID) &&
            (identical(other.observatory, observatory) ||
                other.observatory == observatory) &&
            (identical(other.remoteDebugger, remoteDebugger) ||
                other.remoteDebugger == remoteDebugger));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, time, suiteID, observatory, remoteDebugger);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestEventDebugCopyWith<_$TestEventDebug> get copyWith =>
      __$$TestEventDebugCopyWithImpl<_$TestEventDebug>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return debug(time, suiteID, observatory, remoteDebugger);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return debug?.call(time, suiteID, observatory, remoteDebugger);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (debug != null) {
      return debug(time, suiteID, observatory, remoteDebugger);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return debug(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return debug?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (debug != null) {
      return debug(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventDebugToJson(
      this,
    );
  }
}

abstract class TestEventDebug implements TestEvent {
  factory TestEventDebug(
      {required final int time,
      required final int suiteID,
      final String? observatory,
      final String? remoteDebugger}) = _$TestEventDebug;

  factory TestEventDebug.fromJson(Map<String, dynamic> json) =
      _$TestEventDebug.fromJson;

  int get time;
  int get suiteID;
  String? get observatory;
  String? get remoteDebugger;
  @JsonKey(ignore: true)
  _$$TestEventDebugCopyWith<_$TestEventDebug> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestProcessDoneCopyWith<$Res> {
  factory _$$TestProcessDoneCopyWith(
          _$TestProcessDone value, $Res Function(_$TestProcessDone) then) =
      __$$TestProcessDoneCopyWithImpl<$Res>;
  @useResult
  $Res call({int exitCode});
}

/// @nodoc
class __$$TestProcessDoneCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestProcessDone>
    implements _$$TestProcessDoneCopyWith<$Res> {
  __$$TestProcessDoneCopyWithImpl(
      _$TestProcessDone _value, $Res Function(_$TestProcessDone) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exitCode = null,
  }) {
    return _then(_$TestProcessDone(
      exitCode: null == exitCode
          ? _value.exitCode
          : exitCode // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TestProcessDone implements TestProcessDone {
  _$TestProcessDone({required this.exitCode, final String? $type})
      : $type = $type ?? 'processDone';

  factory _$TestProcessDone.fromJson(Map<String, dynamic> json) =>
      _$$TestProcessDoneFromJson(json);

  @override
  final int exitCode;

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.processDone(exitCode: $exitCode)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TestProcessDone &&
            (identical(other.exitCode, exitCode) ||
                other.exitCode == exitCode));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, exitCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TestProcessDoneCopyWith<_$TestProcessDone> get copyWith =>
      __$$TestProcessDoneCopyWithImpl<_$TestProcessDone>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return processDone(exitCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return processDone?.call(exitCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (processDone != null) {
      return processDone(exitCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return processDone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return processDone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (processDone != null) {
      return processDone(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestProcessDoneToJson(
      this,
    );
  }
}

abstract class TestProcessDone implements TestEvent {
  factory TestProcessDone({required final int exitCode}) = _$TestProcessDone;

  factory TestProcessDone.fromJson(Map<String, dynamic> json) =
      _$TestProcessDone.fromJson;

  int get exitCode;
  @JsonKey(ignore: true)
  _$$TestProcessDoneCopyWith<_$TestProcessDone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TestEventUnknownCopyWith<$Res> {
  factory _$$TestEventUnknownCopyWith(
          _$TestEventUnknown value, $Res Function(_$TestEventUnknown) then) =
      __$$TestEventUnknownCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TestEventUnknownCopyWithImpl<$Res>
    extends _$TestEventCopyWithImpl<$Res, _$TestEventUnknown>
    implements _$$TestEventUnknownCopyWith<$Res> {
  __$$TestEventUnknownCopyWithImpl(
      _$TestEventUnknown _value, $Res Function(_$TestEventUnknown) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$TestEventUnknown implements TestEventUnknown {
  _$TestEventUnknown({final String? $type}) : $type = $type ?? 'unknown';

  factory _$TestEventUnknown.fromJson(Map<String, dynamic> json) =>
      _$$TestEventUnknownFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'TestEvent.unknown()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TestEventUnknown);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)
        start,
    required TResult Function(bool? success, int time) done,
    required TResult Function(int count, int time) allSuites,
    required TResult Function(Suite suite, int time) suite,
    required TResult Function(Group group, int time) group,
    required TResult Function(Test test, int time) testStart,
    required TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)
        testDone,
    required TResult Function(
            int time, int testID, String messageType, String message)
        print,
    required TResult Function(int time, int testID, String error,
            String stackTrace, bool isFailure)
        error,
    required TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)
        debug,
    required TResult Function(int exitCode) processDone,
    required TResult Function() unknown,
  }) {
    return unknown();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult? Function(bool? success, int time)? done,
    TResult? Function(int count, int time)? allSuites,
    TResult? Function(Suite suite, int time)? suite,
    TResult? Function(Group group, int time)? group,
    TResult? Function(Test test, int time)? testStart,
    TResult? Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult? Function(int time, int testID, String messageType, String message)?
        print,
    TResult? Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult? Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult? Function(int exitCode)? processDone,
    TResult? Function()? unknown,
  }) {
    return unknown?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            String protocolVersion, int pid, int time, String? runnerVersion)?
        start,
    TResult Function(bool? success, int time)? done,
    TResult Function(int count, int time)? allSuites,
    TResult Function(Suite suite, int time)? suite,
    TResult Function(Group group, int time)? group,
    TResult Function(Test test, int time)? testStart,
    TResult Function(int time, int testID, bool hidden, bool skipped,
            TestDoneStatus result)?
        testDone,
    TResult Function(int time, int testID, String messageType, String message)?
        print,
    TResult Function(int time, int testID, String error, String stackTrace,
            bool isFailure)?
        error,
    TResult Function(
            int time, int suiteID, String? observatory, String? remoteDebugger)?
        debug,
    TResult Function(int exitCode)? processDone,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TestEventStart value) start,
    required TResult Function(TestEventDone value) done,
    required TResult Function(TestEventAllSuites value) allSuites,
    required TResult Function(TestEventSuite value) suite,
    required TResult Function(TestEventGroup value) group,
    required TResult Function(TestEventTestStart value) testStart,
    required TResult Function(TestEventTestDone value) testDone,
    required TResult Function(TestEventMessage value) print,
    required TResult Function(TestEventTestError value) error,
    required TResult Function(TestEventDebug value) debug,
    required TResult Function(TestProcessDone value) processDone,
    required TResult Function(TestEventUnknown value) unknown,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TestEventStart value)? start,
    TResult? Function(TestEventDone value)? done,
    TResult? Function(TestEventAllSuites value)? allSuites,
    TResult? Function(TestEventSuite value)? suite,
    TResult? Function(TestEventGroup value)? group,
    TResult? Function(TestEventTestStart value)? testStart,
    TResult? Function(TestEventTestDone value)? testDone,
    TResult? Function(TestEventMessage value)? print,
    TResult? Function(TestEventTestError value)? error,
    TResult? Function(TestEventDebug value)? debug,
    TResult? Function(TestProcessDone value)? processDone,
    TResult? Function(TestEventUnknown value)? unknown,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TestEventStart value)? start,
    TResult Function(TestEventDone value)? done,
    TResult Function(TestEventAllSuites value)? allSuites,
    TResult Function(TestEventSuite value)? suite,
    TResult Function(TestEventGroup value)? group,
    TResult Function(TestEventTestStart value)? testStart,
    TResult Function(TestEventTestDone value)? testDone,
    TResult Function(TestEventMessage value)? print,
    TResult Function(TestEventTestError value)? error,
    TResult Function(TestEventDebug value)? debug,
    TResult Function(TestProcessDone value)? processDone,
    TResult Function(TestEventUnknown value)? unknown,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$TestEventUnknownToJson(
      this,
    );
  }
}

abstract class TestEventUnknown implements TestEvent {
  factory TestEventUnknown() = _$TestEventUnknown;

  factory TestEventUnknown.fromJson(Map<String, dynamic> json) =
      _$TestEventUnknown.fromJson;
}

Test _$TestFromJson(Map<String, dynamic> json) {
  return _Test.fromJson(json);
}

/// @nodoc
mixin _$Test {
  /// An opaque ID for the test.
  int get id => throw _privateConstructorUsedError;

  /// The name of the test, including prefixes from any containing groups.
  String get name => throw _privateConstructorUsedError;

  /// The ID of the suite containing this test.
  int get suiteID => throw _privateConstructorUsedError;

  /// The IDs of groups containing this test, in order from outermost to
  /// innermost.
  List<int> get groupIDs => throw _privateConstructorUsedError;

  /// The (1-based) line on which the test was defined, or `null`.
  int? get line => throw _privateConstructorUsedError;

  /// The (1-based) column on which the test was defined, or `null`.
  int? get column => throw _privateConstructorUsedError;

  /// The URL for the file in which the test was defined, or `null`.
  String? get url => throw _privateConstructorUsedError;

  /// The (1-based) line in the original test suite from which the test
  /// originated.
  ///
  /// Will only be present if `root_url` is different from `url`.
  @JsonKey(name: 'root_line')
  int? get rootLine => throw _privateConstructorUsedError;

  /// The (1-based) line on in the original test suite from which the test
  /// originated.
  ///
  /// Will only be present if `root_url` is different from `url`.
  @JsonKey(name: 'root_column')
  int? get rootColumn => throw _privateConstructorUsedError;

  /// The URL for the original test suite in which the test was defined.
  ///
  /// Will only be present if different from `url`.
  @JsonKey(name: 'root_url')
  String? get rootUrl => throw _privateConstructorUsedError;

  /// Metadatas about a test
  Metadata get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TestCopyWith<Test> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestCopyWith<$Res> {
  factory $TestCopyWith(Test value, $Res Function(Test) then) =
      _$TestCopyWithImpl<$Res, Test>;
  @useResult
  $Res call(
      {int id,
      String name,
      int suiteID,
      List<int> groupIDs,
      int? line,
      int? column,
      String? url,
      @JsonKey(name: 'root_line') int? rootLine,
      @JsonKey(name: 'root_column') int? rootColumn,
      @JsonKey(name: 'root_url') String? rootUrl,
      Metadata metadata});

  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$TestCopyWithImpl<$Res, $Val extends Test>
    implements $TestCopyWith<$Res> {
  _$TestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? suiteID = null,
    Object? groupIDs = null,
    Object? line = freezed,
    Object? column = freezed,
    Object? url = freezed,
    Object? rootLine = freezed,
    Object? rootColumn = freezed,
    Object? rootUrl = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      suiteID: null == suiteID
          ? _value.suiteID
          : suiteID // ignore: cast_nullable_to_non_nullable
              as int,
      groupIDs: null == groupIDs
          ? _value.groupIDs
          : groupIDs // ignore: cast_nullable_to_non_nullable
              as List<int>,
      line: freezed == line
          ? _value.line
          : line // ignore: cast_nullable_to_non_nullable
              as int?,
      column: freezed == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      rootLine: freezed == rootLine
          ? _value.rootLine
          : rootLine // ignore: cast_nullable_to_non_nullable
              as int?,
      rootColumn: freezed == rootColumn
          ? _value.rootColumn
          : rootColumn // ignore: cast_nullable_to_non_nullable
              as int?,
      rootUrl: freezed == rootUrl
          ? _value.rootUrl
          : rootUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MetadataCopyWith<$Res> get metadata {
    return $MetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_TestCopyWith<$Res> implements $TestCopyWith<$Res> {
  factory _$$_TestCopyWith(_$_Test value, $Res Function(_$_Test) then) =
      __$$_TestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int suiteID,
      List<int> groupIDs,
      int? line,
      int? column,
      String? url,
      @JsonKey(name: 'root_line') int? rootLine,
      @JsonKey(name: 'root_column') int? rootColumn,
      @JsonKey(name: 'root_url') String? rootUrl,
      Metadata metadata});

  @override
  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$_TestCopyWithImpl<$Res> extends _$TestCopyWithImpl<$Res, _$_Test>
    implements _$$_TestCopyWith<$Res> {
  __$$_TestCopyWithImpl(_$_Test _value, $Res Function(_$_Test) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? suiteID = null,
    Object? groupIDs = null,
    Object? line = freezed,
    Object? column = freezed,
    Object? url = freezed,
    Object? rootLine = freezed,
    Object? rootColumn = freezed,
    Object? rootUrl = freezed,
    Object? metadata = null,
  }) {
    return _then(_$_Test(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      suiteID: null == suiteID
          ? _value.suiteID
          : suiteID // ignore: cast_nullable_to_non_nullable
              as int,
      groupIDs: null == groupIDs
          ? _value._groupIDs
          : groupIDs // ignore: cast_nullable_to_non_nullable
              as List<int>,
      line: freezed == line
          ? _value.line
          : line // ignore: cast_nullable_to_non_nullable
              as int?,
      column: freezed == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      rootLine: freezed == rootLine
          ? _value.rootLine
          : rootLine // ignore: cast_nullable_to_non_nullable
              as int?,
      rootColumn: freezed == rootColumn
          ? _value.rootColumn
          : rootColumn // ignore: cast_nullable_to_non_nullable
              as int?,
      rootUrl: freezed == rootUrl
          ? _value.rootUrl
          : rootUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Test implements _Test {
  _$_Test(
      {required this.id,
      required this.name,
      required this.suiteID,
      required final List<int> groupIDs,
      this.line,
      this.column,
      this.url,
      @JsonKey(name: 'root_line') this.rootLine,
      @JsonKey(name: 'root_column') this.rootColumn,
      @JsonKey(name: 'root_url') this.rootUrl,
      required this.metadata})
      : _groupIDs = groupIDs;

  factory _$_Test.fromJson(Map<String, dynamic> json) => _$$_TestFromJson(json);

  /// An opaque ID for the test.
  @override
  final int id;

  /// The name of the test, including prefixes from any containing groups.
  @override
  final String name;

  /// The ID of the suite containing this test.
  @override
  final int suiteID;

  /// The IDs of groups containing this test, in order from outermost to
  /// innermost.
  final List<int> _groupIDs;

  /// The IDs of groups containing this test, in order from outermost to
  /// innermost.
  @override
  List<int> get groupIDs {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupIDs);
  }

  /// The (1-based) line on which the test was defined, or `null`.
  @override
  final int? line;

  /// The (1-based) column on which the test was defined, or `null`.
  @override
  final int? column;

  /// The URL for the file in which the test was defined, or `null`.
  @override
  final String? url;

  /// The (1-based) line in the original test suite from which the test
  /// originated.
  ///
  /// Will only be present if `root_url` is different from `url`.
  @override
  @JsonKey(name: 'root_line')
  final int? rootLine;

  /// The (1-based) line on in the original test suite from which the test
  /// originated.
  ///
  /// Will only be present if `root_url` is different from `url`.
  @override
  @JsonKey(name: 'root_column')
  final int? rootColumn;

  /// The URL for the original test suite in which the test was defined.
  ///
  /// Will only be present if different from `url`.
  @override
  @JsonKey(name: 'root_url')
  final String? rootUrl;

  /// Metadatas about a test
  @override
  final Metadata metadata;

  @override
  String toString() {
    return 'Test(id: $id, name: $name, suiteID: $suiteID, groupIDs: $groupIDs, line: $line, column: $column, url: $url, rootLine: $rootLine, rootColumn: $rootColumn, rootUrl: $rootUrl, metadata: $metadata)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Test &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.suiteID, suiteID) || other.suiteID == suiteID) &&
            const DeepCollectionEquality().equals(other._groupIDs, _groupIDs) &&
            (identical(other.line, line) || other.line == line) &&
            (identical(other.column, column) || other.column == column) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.rootLine, rootLine) ||
                other.rootLine == rootLine) &&
            (identical(other.rootColumn, rootColumn) ||
                other.rootColumn == rootColumn) &&
            (identical(other.rootUrl, rootUrl) || other.rootUrl == rootUrl) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      suiteID,
      const DeepCollectionEquality().hash(_groupIDs),
      line,
      column,
      url,
      rootLine,
      rootColumn,
      rootUrl,
      metadata);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TestCopyWith<_$_Test> get copyWith =>
      __$$_TestCopyWithImpl<_$_Test>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TestToJson(
      this,
    );
  }
}

abstract class _Test implements Test {
  factory _Test(
      {required final int id,
      required final String name,
      required final int suiteID,
      required final List<int> groupIDs,
      final int? line,
      final int? column,
      final String? url,
      @JsonKey(name: 'root_line') final int? rootLine,
      @JsonKey(name: 'root_column') final int? rootColumn,
      @JsonKey(name: 'root_url') final String? rootUrl,
      required final Metadata metadata}) = _$_Test;

  factory _Test.fromJson(Map<String, dynamic> json) = _$_Test.fromJson;

  @override

  /// An opaque ID for the test.
  int get id;
  @override

  /// The name of the test, including prefixes from any containing groups.
  String get name;
  @override

  /// The ID of the suite containing this test.
  int get suiteID;
  @override

  /// The IDs of groups containing this test, in order from outermost to
  /// innermost.
  List<int> get groupIDs;
  @override

  /// The (1-based) line on which the test was defined, or `null`.
  int? get line;
  @override

  /// The (1-based) column on which the test was defined, or `null`.
  int? get column;
  @override

  /// The URL for the file in which the test was defined, or `null`.
  String? get url;
  @override

  /// The (1-based) line in the original test suite from which the test
  /// originated.
  ///
  /// Will only be present if `root_url` is different from `url`.
  @JsonKey(name: 'root_line')
  int? get rootLine;
  @override

  /// The (1-based) line on in the original test suite from which the test
  /// originated.
  ///
  /// Will only be present if `root_url` is different from `url`.
  @JsonKey(name: 'root_column')
  int? get rootColumn;
  @override

  /// The URL for the original test suite in which the test was defined.
  ///
  /// Will only be present if different from `url`.
  @JsonKey(name: 'root_url')
  String? get rootUrl;
  @override

  /// Metadatas about a test
  Metadata get metadata;
  @override
  @JsonKey(ignore: true)
  _$$_TestCopyWith<_$_Test> get copyWith => throw _privateConstructorUsedError;
}

Suite _$SuiteFromJson(Map<String, dynamic> json) {
  return _Suite.fromJson(json);
}

/// @nodoc
mixin _$Suite {
  /// An opaque ID for the group.
  int get id => throw _privateConstructorUsedError;

  /// The platform on which the suite is running.
  String get platform => throw _privateConstructorUsedError;

  /// The path to the suite's file, or `null` if that path is unknown.
  String? get path => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuiteCopyWith<Suite> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuiteCopyWith<$Res> {
  factory $SuiteCopyWith(Suite value, $Res Function(Suite) then) =
      _$SuiteCopyWithImpl<$Res, Suite>;
  @useResult
  $Res call({int id, String platform, String? path});
}

/// @nodoc
class _$SuiteCopyWithImpl<$Res, $Val extends Suite>
    implements $SuiteCopyWith<$Res> {
  _$SuiteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? platform = null,
    Object? path = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SuiteCopyWith<$Res> implements $SuiteCopyWith<$Res> {
  factory _$$_SuiteCopyWith(_$_Suite value, $Res Function(_$_Suite) then) =
      __$$_SuiteCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String platform, String? path});
}

/// @nodoc
class __$$_SuiteCopyWithImpl<$Res> extends _$SuiteCopyWithImpl<$Res, _$_Suite>
    implements _$$_SuiteCopyWith<$Res> {
  __$$_SuiteCopyWithImpl(_$_Suite _value, $Res Function(_$_Suite) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? platform = null,
    Object? path = freezed,
  }) {
    return _then(_$_Suite(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      path: freezed == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Suite implements _Suite {
  _$_Suite({required this.id, required this.platform, this.path});

  factory _$_Suite.fromJson(Map<String, dynamic> json) =>
      _$$_SuiteFromJson(json);

  /// An opaque ID for the group.
  @override
  final int id;

  /// The platform on which the suite is running.
  @override
  final String platform;

  /// The path to the suite's file, or `null` if that path is unknown.
  @override
  final String? path;

  @override
  String toString() {
    return 'Suite(id: $id, platform: $platform, path: $path)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Suite &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.path, path) || other.path == path));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, platform, path);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SuiteCopyWith<_$_Suite> get copyWith =>
      __$$_SuiteCopyWithImpl<_$_Suite>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SuiteToJson(
      this,
    );
  }
}

abstract class _Suite implements Suite {
  factory _Suite(
      {required final int id,
      required final String platform,
      final String? path}) = _$_Suite;

  factory _Suite.fromJson(Map<String, dynamic> json) = _$_Suite.fromJson;

  @override

  /// An opaque ID for the group.
  int get id;
  @override

  /// The platform on which the suite is running.
  String get platform;
  @override

  /// The path to the suite's file, or `null` if that path is unknown.
  String? get path;
  @override
  @JsonKey(ignore: true)
  _$$_SuiteCopyWith<_$_Suite> get copyWith =>
      throw _privateConstructorUsedError;
}

Group _$GroupFromJson(Map<String, dynamic> json) {
  return _Group.fromJson(json);
}

/// @nodoc
mixin _$Group {
  /// An opaque ID for the group.
  int get id => throw _privateConstructorUsedError;

  /// The name of the group, including prefixes from any containing groups.
  String get name => throw _privateConstructorUsedError;

  /// The ID of the suite containing this group.
  int get suiteID => throw _privateConstructorUsedError;

  /// The ID of the group's parent group, unless it's the root group.
  int? get parentID => throw _privateConstructorUsedError;

  /// The number of tests (recursively) within this group.
  int get testCount => throw _privateConstructorUsedError;

  /// The (1-based) line on which the group was defined, or `null`.
  int? get line => throw _privateConstructorUsedError;

  /// The (1-based) column on which the group was defined, or `null`.
  int? get column => throw _privateConstructorUsedError;

  /// The URL for the file in which the group was defined, or `null`.
  String? get url => throw _privateConstructorUsedError;

  /// This field is deprecated and should not be used.
  Metadata get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupCopyWith<Group> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) then) =
      _$GroupCopyWithImpl<$Res, Group>;
  @useResult
  $Res call(
      {int id,
      String name,
      int suiteID,
      int? parentID,
      int testCount,
      int? line,
      int? column,
      String? url,
      Metadata metadata});

  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$GroupCopyWithImpl<$Res, $Val extends Group>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? suiteID = null,
    Object? parentID = freezed,
    Object? testCount = null,
    Object? line = freezed,
    Object? column = freezed,
    Object? url = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      suiteID: null == suiteID
          ? _value.suiteID
          : suiteID // ignore: cast_nullable_to_non_nullable
              as int,
      parentID: freezed == parentID
          ? _value.parentID
          : parentID // ignore: cast_nullable_to_non_nullable
              as int?,
      testCount: null == testCount
          ? _value.testCount
          : testCount // ignore: cast_nullable_to_non_nullable
              as int,
      line: freezed == line
          ? _value.line
          : line // ignore: cast_nullable_to_non_nullable
              as int?,
      column: freezed == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MetadataCopyWith<$Res> get metadata {
    return $MetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_GroupCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$$_GroupCopyWith(_$_Group value, $Res Function(_$_Group) then) =
      __$$_GroupCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      int suiteID,
      int? parentID,
      int testCount,
      int? line,
      int? column,
      String? url,
      Metadata metadata});

  @override
  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$_GroupCopyWithImpl<$Res> extends _$GroupCopyWithImpl<$Res, _$_Group>
    implements _$$_GroupCopyWith<$Res> {
  __$$_GroupCopyWithImpl(_$_Group _value, $Res Function(_$_Group) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? suiteID = null,
    Object? parentID = freezed,
    Object? testCount = null,
    Object? line = freezed,
    Object? column = freezed,
    Object? url = freezed,
    Object? metadata = null,
  }) {
    return _then(_$_Group(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      suiteID: null == suiteID
          ? _value.suiteID
          : suiteID // ignore: cast_nullable_to_non_nullable
              as int,
      parentID: freezed == parentID
          ? _value.parentID
          : parentID // ignore: cast_nullable_to_non_nullable
              as int?,
      testCount: null == testCount
          ? _value.testCount
          : testCount // ignore: cast_nullable_to_non_nullable
              as int,
      line: freezed == line
          ? _value.line
          : line // ignore: cast_nullable_to_non_nullable
              as int?,
      column: freezed == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Group implements _Group {
  _$_Group(
      {required this.id,
      required this.name,
      required this.suiteID,
      this.parentID,
      required this.testCount,
      this.line,
      this.column,
      this.url,
      required this.metadata});

  factory _$_Group.fromJson(Map<String, dynamic> json) =>
      _$$_GroupFromJson(json);

  /// An opaque ID for the group.
  @override
  final int id;

  /// The name of the group, including prefixes from any containing groups.
  @override
  final String name;

  /// The ID of the suite containing this group.
  @override
  final int suiteID;

  /// The ID of the group's parent group, unless it's the root group.
  @override
  final int? parentID;

  /// The number of tests (recursively) within this group.
  @override
  final int testCount;

  /// The (1-based) line on which the group was defined, or `null`.
  @override
  final int? line;

  /// The (1-based) column on which the group was defined, or `null`.
  @override
  final int? column;

  /// The URL for the file in which the group was defined, or `null`.
  @override
  final String? url;

  /// This field is deprecated and should not be used.
  @override
  final Metadata metadata;

  @override
  String toString() {
    return 'Group(id: $id, name: $name, suiteID: $suiteID, parentID: $parentID, testCount: $testCount, line: $line, column: $column, url: $url, metadata: $metadata)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Group &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.suiteID, suiteID) || other.suiteID == suiteID) &&
            (identical(other.parentID, parentID) ||
                other.parentID == parentID) &&
            (identical(other.testCount, testCount) ||
                other.testCount == testCount) &&
            (identical(other.line, line) || other.line == line) &&
            (identical(other.column, column) || other.column == column) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, suiteID, parentID,
      testCount, line, column, url, metadata);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GroupCopyWith<_$_Group> get copyWith =>
      __$$_GroupCopyWithImpl<_$_Group>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GroupToJson(
      this,
    );
  }
}

abstract class _Group implements Group {
  factory _Group(
      {required final int id,
      required final String name,
      required final int suiteID,
      final int? parentID,
      required final int testCount,
      final int? line,
      final int? column,
      final String? url,
      required final Metadata metadata}) = _$_Group;

  factory _Group.fromJson(Map<String, dynamic> json) = _$_Group.fromJson;

  @override

  /// An opaque ID for the group.
  int get id;
  @override

  /// The name of the group, including prefixes from any containing groups.
  String get name;
  @override

  /// The ID of the suite containing this group.
  int get suiteID;
  @override

  /// The ID of the group's parent group, unless it's the root group.
  int? get parentID;
  @override

  /// The number of tests (recursively) within this group.
  int get testCount;
  @override

  /// The (1-based) line on which the group was defined, or `null`.
  int? get line;
  @override

  /// The (1-based) column on which the group was defined, or `null`.
  int? get column;
  @override

  /// The URL for the file in which the group was defined, or `null`.
  String? get url;
  @override

  /// This field is deprecated and should not be used.
  Metadata get metadata;
  @override
  @JsonKey(ignore: true)
  _$$_GroupCopyWith<_$_Group> get copyWith =>
      throw _privateConstructorUsedError;
}

Metadata _$MetadataFromJson(Map<String, dynamic> json) {
  return _Metadata.fromJson(json);
}

/// @nodoc
mixin _$Metadata {
  /// Whether the test was skipped
  bool get skip =>
      throw _privateConstructorUsedError; // The reason the tests was skipped, or `null` if it wasn't skipped.
  String? get skipReason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MetadataCopyWith<Metadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataCopyWith<$Res> {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) then) =
      _$MetadataCopyWithImpl<$Res, Metadata>;
  @useResult
  $Res call({bool skip, String? skipReason});
}

/// @nodoc
class _$MetadataCopyWithImpl<$Res, $Val extends Metadata>
    implements $MetadataCopyWith<$Res> {
  _$MetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skip = null,
    Object? skipReason = freezed,
  }) {
    return _then(_value.copyWith(
      skip: null == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as bool,
      skipReason: freezed == skipReason
          ? _value.skipReason
          : skipReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MetadataCopyWith<$Res> implements $MetadataCopyWith<$Res> {
  factory _$$_MetadataCopyWith(
          _$_Metadata value, $Res Function(_$_Metadata) then) =
      __$$_MetadataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool skip, String? skipReason});
}

/// @nodoc
class __$$_MetadataCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$_Metadata>
    implements _$$_MetadataCopyWith<$Res> {
  __$$_MetadataCopyWithImpl(
      _$_Metadata _value, $Res Function(_$_Metadata) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skip = null,
    Object? skipReason = freezed,
  }) {
    return _then(_$_Metadata(
      skip: null == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as bool,
      skipReason: freezed == skipReason
          ? _value.skipReason
          : skipReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Metadata implements _Metadata {
  _$_Metadata({required this.skip, this.skipReason});

  factory _$_Metadata.fromJson(Map<String, dynamic> json) =>
      _$$_MetadataFromJson(json);

  /// Whether the test was skipped
  @override
  final bool skip;
// The reason the tests was skipped, or `null` if it wasn't skipped.
  @override
  final String? skipReason;

  @override
  String toString() {
    return 'Metadata(skip: $skip, skipReason: $skipReason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Metadata &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.skipReason, skipReason) ||
                other.skipReason == skipReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, skip, skipReason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MetadataCopyWith<_$_Metadata> get copyWith =>
      __$$_MetadataCopyWithImpl<_$_Metadata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MetadataToJson(
      this,
    );
  }
}

abstract class _Metadata implements Metadata {
  factory _Metadata({required final bool skip, final String? skipReason}) =
      _$_Metadata;

  factory _Metadata.fromJson(Map<String, dynamic> json) = _$_Metadata.fromJson;

  @override

  /// Whether the test was skipped
  bool get skip;
  @override // The reason the tests was skipped, or `null` if it wasn't skipped.
  String? get skipReason;
  @override
  @JsonKey(ignore: true)
  _$$_MetadataCopyWith<_$_Metadata> get copyWith =>
      throw _privateConstructorUsedError;
}
