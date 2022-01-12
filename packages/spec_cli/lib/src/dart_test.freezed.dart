// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'dart_test.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TestEventsStateTearOff {
  const _$TestEventsStateTearOff();

  _TestEventsState call(
      {required bool isInterrupted, required List<TestEvent> events}) {
    return _TestEventsState(
      isInterrupted: isInterrupted,
      events: events,
    );
  }
}

/// @nodoc
const $TestEventsState = _$TestEventsStateTearOff();

/// @nodoc
mixin _$TestEventsState {
  bool get isInterrupted => throw _privateConstructorUsedError;
  List<TestEvent> get events => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TestEventsStateCopyWith<TestEventsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestEventsStateCopyWith<$Res> {
  factory $TestEventsStateCopyWith(
          TestEventsState value, $Res Function(TestEventsState) then) =
      _$TestEventsStateCopyWithImpl<$Res>;
  $Res call({bool isInterrupted, List<TestEvent> events});
}

/// @nodoc
class _$TestEventsStateCopyWithImpl<$Res>
    implements $TestEventsStateCopyWith<$Res> {
  _$TestEventsStateCopyWithImpl(this._value, this._then);

  final TestEventsState _value;
  // ignore: unused_field
  final $Res Function(TestEventsState) _then;

  @override
  $Res call({
    Object? isInterrupted = freezed,
    Object? events = freezed,
  }) {
    return _then(_value.copyWith(
      isInterrupted: isInterrupted == freezed
          ? _value.isInterrupted
          : isInterrupted // ignore: cast_nullable_to_non_nullable
              as bool,
      events: events == freezed
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<TestEvent>,
    ));
  }
}

/// @nodoc
abstract class _$TestEventsStateCopyWith<$Res>
    implements $TestEventsStateCopyWith<$Res> {
  factory _$TestEventsStateCopyWith(
          _TestEventsState value, $Res Function(_TestEventsState) then) =
      __$TestEventsStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isInterrupted, List<TestEvent> events});
}

/// @nodoc
class __$TestEventsStateCopyWithImpl<$Res>
    extends _$TestEventsStateCopyWithImpl<$Res>
    implements _$TestEventsStateCopyWith<$Res> {
  __$TestEventsStateCopyWithImpl(
      _TestEventsState _value, $Res Function(_TestEventsState) _then)
      : super(_value, (v) => _then(v as _TestEventsState));

  @override
  _TestEventsState get _value => super._value as _TestEventsState;

  @override
  $Res call({
    Object? isInterrupted = freezed,
    Object? events = freezed,
  }) {
    return _then(_TestEventsState(
      isInterrupted: isInterrupted == freezed
          ? _value.isInterrupted
          : isInterrupted // ignore: cast_nullable_to_non_nullable
              as bool,
      events: events == freezed
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<TestEvent>,
    ));
  }
}

/// @nodoc

class _$_TestEventsState implements _TestEventsState {
  const _$_TestEventsState({required this.isInterrupted, required this.events});

  @override
  final bool isInterrupted;
  @override
  final List<TestEvent> events;

  @override
  String toString() {
    return 'TestEventsState(isInterrupted: $isInterrupted, events: $events)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestEventsState &&
            const DeepCollectionEquality()
                .equals(other.isInterrupted, isInterrupted) &&
            const DeepCollectionEquality().equals(other.events, events));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isInterrupted),
      const DeepCollectionEquality().hash(events));

  @JsonKey(ignore: true)
  @override
  _$TestEventsStateCopyWith<_TestEventsState> get copyWith =>
      __$TestEventsStateCopyWithImpl<_TestEventsState>(this, _$identity);
}

abstract class _TestEventsState implements TestEventsState {
  const factory _TestEventsState(
      {required bool isInterrupted,
      required List<TestEvent> events}) = _$_TestEventsState;

  @override
  bool get isInterrupted;
  @override
  List<TestEvent> get events;
  @override
  @JsonKey(ignore: true)
  _$TestEventsStateCopyWith<_TestEventsState> get copyWith =>
      throw _privateConstructorUsedError;
}
