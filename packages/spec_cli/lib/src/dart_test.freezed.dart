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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TestEventsState {
  bool get isInterrupted => throw _privateConstructorUsedError;
  List<Packaged<TestEvent>> get events => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TestEventsStateCopyWith<TestEventsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestEventsStateCopyWith<$Res> {
  factory $TestEventsStateCopyWith(
          TestEventsState value, $Res Function(TestEventsState) then) =
      _$TestEventsStateCopyWithImpl<$Res, TestEventsState>;
  @useResult
  $Res call({bool isInterrupted, List<Packaged<TestEvent>> events});
}

/// @nodoc
class _$TestEventsStateCopyWithImpl<$Res, $Val extends TestEventsState>
    implements $TestEventsStateCopyWith<$Res> {
  _$TestEventsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isInterrupted = null,
    Object? events = null,
  }) {
    return _then(_value.copyWith(
      isInterrupted: null == isInterrupted
          ? _value.isInterrupted
          : isInterrupted // ignore: cast_nullable_to_non_nullable
              as bool,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Packaged<TestEvent>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TestEventsStateCopyWith<$Res>
    implements $TestEventsStateCopyWith<$Res> {
  factory _$$_TestEventsStateCopyWith(
          _$_TestEventsState value, $Res Function(_$_TestEventsState) then) =
      __$$_TestEventsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isInterrupted, List<Packaged<TestEvent>> events});
}

/// @nodoc
class __$$_TestEventsStateCopyWithImpl<$Res>
    extends _$TestEventsStateCopyWithImpl<$Res, _$_TestEventsState>
    implements _$$_TestEventsStateCopyWith<$Res> {
  __$$_TestEventsStateCopyWithImpl(
      _$_TestEventsState _value, $Res Function(_$_TestEventsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isInterrupted = null,
    Object? events = null,
  }) {
    return _then(_$_TestEventsState(
      isInterrupted: null == isInterrupted
          ? _value.isInterrupted
          : isInterrupted // ignore: cast_nullable_to_non_nullable
              as bool,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Packaged<TestEvent>>,
    ));
  }
}

/// @nodoc

class _$_TestEventsState implements _TestEventsState {
  const _$_TestEventsState(
      {required this.isInterrupted,
      required final List<Packaged<TestEvent>> events})
      : _events = events;

  @override
  final bool isInterrupted;
  final List<Packaged<TestEvent>> _events;
  @override
  List<Packaged<TestEvent>> get events {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  String toString() {
    return 'TestEventsState(isInterrupted: $isInterrupted, events: $events)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TestEventsState &&
            (identical(other.isInterrupted, isInterrupted) ||
                other.isInterrupted == isInterrupted) &&
            const DeepCollectionEquality().equals(other._events, _events));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isInterrupted, const DeepCollectionEquality().hash(_events));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TestEventsStateCopyWith<_$_TestEventsState> get copyWith =>
      __$$_TestEventsStateCopyWithImpl<_$_TestEventsState>(this, _$identity);
}

abstract class _TestEventsState implements TestEventsState {
  const factory _TestEventsState(
      {required final bool isInterrupted,
      required final List<Packaged<TestEvent>> events}) = _$_TestEventsState;

  @override
  bool get isInterrupted;
  @override
  List<Packaged<TestEvent>> get events;
  @override
  @JsonKey(ignore: true)
  _$$_TestEventsStateCopyWith<_$_TestEventsState> get copyWith =>
      throw _privateConstructorUsedError;
}
