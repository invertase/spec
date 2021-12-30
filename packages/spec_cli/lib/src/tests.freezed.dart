// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'tests.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$TestStatusTearOff {
  const _$TestStatusTearOff();

  _TestStatusPass pass() {
    return const _TestStatusPass();
  }

  _TestStatusFail fail(String error, {required String stackTrace}) {
    return _TestStatusFail(
      error,
      stackTrace: stackTrace,
    );
  }

  _TestStatusSkip skip({String? skipReason}) {
    return _TestStatusSkip(
      skipReason: skipReason,
    );
  }

  _TestStatusPending pending() {
    return const _TestStatusPending();
  }
}

/// @nodoc
const $TestStatus = _$TestStatusTearOff();

/// @nodoc
mixin _$TestStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() pass,
    required TResult Function(String error, String stackTrace) fail,
    required TResult Function(String? skipReason) skip,
    required TResult Function() pending,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TestStatusPass value) pass,
    required TResult Function(_TestStatusFail value) fail,
    required TResult Function(_TestStatusSkip value) skip,
    required TResult Function(_TestStatusPending value) pending,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TestStatusCopyWith<$Res> {
  factory $TestStatusCopyWith(
          TestStatus value, $Res Function(TestStatus) then) =
      _$TestStatusCopyWithImpl<$Res>;
}

/// @nodoc
class _$TestStatusCopyWithImpl<$Res> implements $TestStatusCopyWith<$Res> {
  _$TestStatusCopyWithImpl(this._value, this._then);

  final TestStatus _value;
  // ignore: unused_field
  final $Res Function(TestStatus) _then;
}

/// @nodoc
abstract class _$TestStatusPassCopyWith<$Res> {
  factory _$TestStatusPassCopyWith(
          _TestStatusPass value, $Res Function(_TestStatusPass) then) =
      __$TestStatusPassCopyWithImpl<$Res>;
}

/// @nodoc
class __$TestStatusPassCopyWithImpl<$Res> extends _$TestStatusCopyWithImpl<$Res>
    implements _$TestStatusPassCopyWith<$Res> {
  __$TestStatusPassCopyWithImpl(
      _TestStatusPass _value, $Res Function(_TestStatusPass) _then)
      : super(_value, (v) => _then(v as _TestStatusPass));

  @override
  _TestStatusPass get _value => super._value as _TestStatusPass;
}

/// @nodoc

class _$_TestStatusPass extends _TestStatusPass {
  const _$_TestStatusPass() : super._();

  @override
  String toString() {
    return 'TestStatus.pass()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _TestStatusPass);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() pass,
    required TResult Function(String error, String stackTrace) fail,
    required TResult Function(String? skipReason) skip,
    required TResult Function() pending,
  }) {
    return pass();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
  }) {
    return pass?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
    required TResult orElse(),
  }) {
    if (pass != null) {
      return pass();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TestStatusPass value) pass,
    required TResult Function(_TestStatusFail value) fail,
    required TResult Function(_TestStatusSkip value) skip,
    required TResult Function(_TestStatusPending value) pending,
  }) {
    return pass(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
  }) {
    return pass?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
    required TResult orElse(),
  }) {
    if (pass != null) {
      return pass(this);
    }
    return orElse();
  }
}

abstract class _TestStatusPass extends TestStatus {
  const factory _TestStatusPass() = _$_TestStatusPass;
  const _TestStatusPass._() : super._();
}

/// @nodoc
abstract class _$TestStatusFailCopyWith<$Res> {
  factory _$TestStatusFailCopyWith(
          _TestStatusFail value, $Res Function(_TestStatusFail) then) =
      __$TestStatusFailCopyWithImpl<$Res>;
  $Res call({String error, String stackTrace});
}

/// @nodoc
class __$TestStatusFailCopyWithImpl<$Res> extends _$TestStatusCopyWithImpl<$Res>
    implements _$TestStatusFailCopyWith<$Res> {
  __$TestStatusFailCopyWithImpl(
      _TestStatusFail _value, $Res Function(_TestStatusFail) _then)
      : super(_value, (v) => _then(v as _TestStatusFail));

  @override
  _TestStatusFail get _value => super._value as _TestStatusFail;

  @override
  $Res call({
    Object? error = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(_TestStatusFail(
      error == freezed
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      stackTrace: stackTrace == freezed
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_TestStatusFail extends _TestStatusFail {
  const _$_TestStatusFail(this.error, {required this.stackTrace}) : super._();

  @override
  final String error;
  @override
  final String stackTrace;

  @override
  String toString() {
    return 'TestStatus.fail(error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestStatusFail &&
            const DeepCollectionEquality().equals(other.error, error) &&
            const DeepCollectionEquality()
                .equals(other.stackTrace, stackTrace));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(error),
      const DeepCollectionEquality().hash(stackTrace));

  @JsonKey(ignore: true)
  @override
  _$TestStatusFailCopyWith<_TestStatusFail> get copyWith =>
      __$TestStatusFailCopyWithImpl<_TestStatusFail>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() pass,
    required TResult Function(String error, String stackTrace) fail,
    required TResult Function(String? skipReason) skip,
    required TResult Function() pending,
  }) {
    return fail(error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
  }) {
    return fail?.call(error, stackTrace);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
    required TResult orElse(),
  }) {
    if (fail != null) {
      return fail(error, stackTrace);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TestStatusPass value) pass,
    required TResult Function(_TestStatusFail value) fail,
    required TResult Function(_TestStatusSkip value) skip,
    required TResult Function(_TestStatusPending value) pending,
  }) {
    return fail(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
  }) {
    return fail?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
    required TResult orElse(),
  }) {
    if (fail != null) {
      return fail(this);
    }
    return orElse();
  }
}

abstract class _TestStatusFail extends TestStatus {
  const factory _TestStatusFail(String error, {required String stackTrace}) =
      _$_TestStatusFail;
  const _TestStatusFail._() : super._();

  String get error;
  String get stackTrace;
  @JsonKey(ignore: true)
  _$TestStatusFailCopyWith<_TestStatusFail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$TestStatusSkipCopyWith<$Res> {
  factory _$TestStatusSkipCopyWith(
          _TestStatusSkip value, $Res Function(_TestStatusSkip) then) =
      __$TestStatusSkipCopyWithImpl<$Res>;
  $Res call({String? skipReason});
}

/// @nodoc
class __$TestStatusSkipCopyWithImpl<$Res> extends _$TestStatusCopyWithImpl<$Res>
    implements _$TestStatusSkipCopyWith<$Res> {
  __$TestStatusSkipCopyWithImpl(
      _TestStatusSkip _value, $Res Function(_TestStatusSkip) _then)
      : super(_value, (v) => _then(v as _TestStatusSkip));

  @override
  _TestStatusSkip get _value => super._value as _TestStatusSkip;

  @override
  $Res call({
    Object? skipReason = freezed,
  }) {
    return _then(_TestStatusSkip(
      skipReason: skipReason == freezed
          ? _value.skipReason
          : skipReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_TestStatusSkip extends _TestStatusSkip {
  const _$_TestStatusSkip({this.skipReason}) : super._();

  @override
  final String? skipReason;

  @override
  String toString() {
    return 'TestStatus.skip(skipReason: $skipReason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TestStatusSkip &&
            const DeepCollectionEquality()
                .equals(other.skipReason, skipReason));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(skipReason));

  @JsonKey(ignore: true)
  @override
  _$TestStatusSkipCopyWith<_TestStatusSkip> get copyWith =>
      __$TestStatusSkipCopyWithImpl<_TestStatusSkip>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() pass,
    required TResult Function(String error, String stackTrace) fail,
    required TResult Function(String? skipReason) skip,
    required TResult Function() pending,
  }) {
    return skip(skipReason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
  }) {
    return skip?.call(skipReason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
    required TResult orElse(),
  }) {
    if (skip != null) {
      return skip(skipReason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TestStatusPass value) pass,
    required TResult Function(_TestStatusFail value) fail,
    required TResult Function(_TestStatusSkip value) skip,
    required TResult Function(_TestStatusPending value) pending,
  }) {
    return skip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
  }) {
    return skip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
    required TResult orElse(),
  }) {
    if (skip != null) {
      return skip(this);
    }
    return orElse();
  }
}

abstract class _TestStatusSkip extends TestStatus {
  const factory _TestStatusSkip({String? skipReason}) = _$_TestStatusSkip;
  const _TestStatusSkip._() : super._();

  String? get skipReason;
  @JsonKey(ignore: true)
  _$TestStatusSkipCopyWith<_TestStatusSkip> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$TestStatusPendingCopyWith<$Res> {
  factory _$TestStatusPendingCopyWith(
          _TestStatusPending value, $Res Function(_TestStatusPending) then) =
      __$TestStatusPendingCopyWithImpl<$Res>;
}

/// @nodoc
class __$TestStatusPendingCopyWithImpl<$Res>
    extends _$TestStatusCopyWithImpl<$Res>
    implements _$TestStatusPendingCopyWith<$Res> {
  __$TestStatusPendingCopyWithImpl(
      _TestStatusPending _value, $Res Function(_TestStatusPending) _then)
      : super(_value, (v) => _then(v as _TestStatusPending));

  @override
  _TestStatusPending get _value => super._value as _TestStatusPending;
}

/// @nodoc

class _$_TestStatusPending extends _TestStatusPending {
  const _$_TestStatusPending() : super._();

  @override
  String toString() {
    return 'TestStatus.pending()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _TestStatusPending);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() pass,
    required TResult Function(String error, String stackTrace) fail,
    required TResult Function(String? skipReason) skip,
    required TResult Function() pending,
  }) {
    return pending();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
  }) {
    return pending?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? pass,
    TResult Function(String error, String stackTrace)? fail,
    TResult Function(String? skipReason)? skip,
    TResult Function()? pending,
    required TResult orElse(),
  }) {
    if (pending != null) {
      return pending();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_TestStatusPass value) pass,
    required TResult Function(_TestStatusFail value) fail,
    required TResult Function(_TestStatusSkip value) skip,
    required TResult Function(_TestStatusPending value) pending,
  }) {
    return pending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
  }) {
    return pending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_TestStatusPass value)? pass,
    TResult Function(_TestStatusFail value)? fail,
    TResult Function(_TestStatusSkip value)? skip,
    TResult Function(_TestStatusPending value)? pending,
    required TResult orElse(),
  }) {
    if (pending != null) {
      return pending(this);
    }
    return orElse();
  }
}

abstract class _TestStatusPending extends TestStatus {
  const factory _TestStatusPending() = _$_TestStatusPending;
  const _TestStatusPending._() : super._();
}
