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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
    TResult? Function()? pass,
    TResult? Function(String error, String stackTrace)? fail,
    TResult? Function(String? skipReason)? skip,
    TResult? Function()? pending,
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
    TResult? Function(_TestStatusPass value)? pass,
    TResult? Function(_TestStatusFail value)? fail,
    TResult? Function(_TestStatusSkip value)? skip,
    TResult? Function(_TestStatusPending value)? pending,
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
      _$TestStatusCopyWithImpl<$Res, TestStatus>;
}

/// @nodoc
class _$TestStatusCopyWithImpl<$Res, $Val extends TestStatus>
    implements $TestStatusCopyWith<$Res> {
  _$TestStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_TestStatusPassCopyWith<$Res> {
  factory _$$_TestStatusPassCopyWith(
          _$_TestStatusPass value, $Res Function(_$_TestStatusPass) then) =
      __$$_TestStatusPassCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_TestStatusPassCopyWithImpl<$Res>
    extends _$TestStatusCopyWithImpl<$Res, _$_TestStatusPass>
    implements _$$_TestStatusPassCopyWith<$Res> {
  __$$_TestStatusPassCopyWithImpl(
      _$_TestStatusPass _value, $Res Function(_$_TestStatusPass) _then)
      : super(_value, _then);
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
        (other.runtimeType == runtimeType && other is _$_TestStatusPass);
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
    TResult? Function()? pass,
    TResult? Function(String error, String stackTrace)? fail,
    TResult? Function(String? skipReason)? skip,
    TResult? Function()? pending,
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
    TResult? Function(_TestStatusPass value)? pass,
    TResult? Function(_TestStatusFail value)? fail,
    TResult? Function(_TestStatusSkip value)? skip,
    TResult? Function(_TestStatusPending value)? pending,
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
abstract class _$$_TestStatusFailCopyWith<$Res> {
  factory _$$_TestStatusFailCopyWith(
          _$_TestStatusFail value, $Res Function(_$_TestStatusFail) then) =
      __$$_TestStatusFailCopyWithImpl<$Res>;
  @useResult
  $Res call({String error, String stackTrace});
}

/// @nodoc
class __$$_TestStatusFailCopyWithImpl<$Res>
    extends _$TestStatusCopyWithImpl<$Res, _$_TestStatusFail>
    implements _$$_TestStatusFailCopyWith<$Res> {
  __$$_TestStatusFailCopyWithImpl(
      _$_TestStatusFail _value, $Res Function(_$_TestStatusFail) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? stackTrace = null,
  }) {
    return _then(_$_TestStatusFail(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      stackTrace: null == stackTrace
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
            other is _$_TestStatusFail &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error, stackTrace);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TestStatusFailCopyWith<_$_TestStatusFail> get copyWith =>
      __$$_TestStatusFailCopyWithImpl<_$_TestStatusFail>(this, _$identity);

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
    TResult? Function()? pass,
    TResult? Function(String error, String stackTrace)? fail,
    TResult? Function(String? skipReason)? skip,
    TResult? Function()? pending,
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
    TResult? Function(_TestStatusPass value)? pass,
    TResult? Function(_TestStatusFail value)? fail,
    TResult? Function(_TestStatusSkip value)? skip,
    TResult? Function(_TestStatusPending value)? pending,
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
  const factory _TestStatusFail(final String error,
      {required final String stackTrace}) = _$_TestStatusFail;
  const _TestStatusFail._() : super._();

  String get error;
  String get stackTrace;
  @JsonKey(ignore: true)
  _$$_TestStatusFailCopyWith<_$_TestStatusFail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_TestStatusSkipCopyWith<$Res> {
  factory _$$_TestStatusSkipCopyWith(
          _$_TestStatusSkip value, $Res Function(_$_TestStatusSkip) then) =
      __$$_TestStatusSkipCopyWithImpl<$Res>;
  @useResult
  $Res call({String? skipReason});
}

/// @nodoc
class __$$_TestStatusSkipCopyWithImpl<$Res>
    extends _$TestStatusCopyWithImpl<$Res, _$_TestStatusSkip>
    implements _$$_TestStatusSkipCopyWith<$Res> {
  __$$_TestStatusSkipCopyWithImpl(
      _$_TestStatusSkip _value, $Res Function(_$_TestStatusSkip) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? skipReason = freezed,
  }) {
    return _then(_$_TestStatusSkip(
      skipReason: freezed == skipReason
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
            other is _$_TestStatusSkip &&
            (identical(other.skipReason, skipReason) ||
                other.skipReason == skipReason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, skipReason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TestStatusSkipCopyWith<_$_TestStatusSkip> get copyWith =>
      __$$_TestStatusSkipCopyWithImpl<_$_TestStatusSkip>(this, _$identity);

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
    TResult? Function()? pass,
    TResult? Function(String error, String stackTrace)? fail,
    TResult? Function(String? skipReason)? skip,
    TResult? Function()? pending,
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
    TResult? Function(_TestStatusPass value)? pass,
    TResult? Function(_TestStatusFail value)? fail,
    TResult? Function(_TestStatusSkip value)? skip,
    TResult? Function(_TestStatusPending value)? pending,
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
  const factory _TestStatusSkip({final String? skipReason}) = _$_TestStatusSkip;
  const _TestStatusSkip._() : super._();

  String? get skipReason;
  @JsonKey(ignore: true)
  _$$_TestStatusSkipCopyWith<_$_TestStatusSkip> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$_TestStatusPendingCopyWith<$Res> {
  factory _$$_TestStatusPendingCopyWith(_$_TestStatusPending value,
          $Res Function(_$_TestStatusPending) then) =
      __$$_TestStatusPendingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_TestStatusPendingCopyWithImpl<$Res>
    extends _$TestStatusCopyWithImpl<$Res, _$_TestStatusPending>
    implements _$$_TestStatusPendingCopyWith<$Res> {
  __$$_TestStatusPendingCopyWithImpl(
      _$_TestStatusPending _value, $Res Function(_$_TestStatusPending) _then)
      : super(_value, _then);
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
        (other.runtimeType == runtimeType && other is _$_TestStatusPending);
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
    TResult? Function()? pass,
    TResult? Function(String error, String stackTrace)? fail,
    TResult? Function(String? skipReason)? skip,
    TResult? Function()? pending,
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
    TResult? Function(_TestStatusPass value)? pass,
    TResult? Function(_TestStatusFail value)? fail,
    TResult? Function(_TestStatusSkip value)? skip,
    TResult? Function(_TestStatusPending value)? pending,
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
