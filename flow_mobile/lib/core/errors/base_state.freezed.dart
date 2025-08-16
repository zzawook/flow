// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AsyncState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(T value) data,
    required TResult Function(AppError error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(T value)? data,
    TResult? Function(AppError error)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(T value)? data,
    TResult Function(AppError error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AsyncLoading<T> value) loading,
    required TResult Function(AsyncData<T> value) data,
    required TResult Function(AsyncError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AsyncLoading<T> value)? loading,
    TResult? Function(AsyncData<T> value)? data,
    TResult? Function(AsyncError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AsyncLoading<T> value)? loading,
    TResult Function(AsyncData<T> value)? data,
    TResult Function(AsyncError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsyncStateCopyWith<T, $Res> {
  factory $AsyncStateCopyWith(
          AsyncState<T> value, $Res Function(AsyncState<T>) then) =
      _$AsyncStateCopyWithImpl<T, $Res, AsyncState<T>>;
}

/// @nodoc
class _$AsyncStateCopyWithImpl<T, $Res, $Val extends AsyncState<T>>
    implements $AsyncStateCopyWith<T, $Res> {
  _$AsyncStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AsyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$AsyncLoadingImplCopyWith<T, $Res> {
  factory _$$AsyncLoadingImplCopyWith(_$AsyncLoadingImpl<T> value,
          $Res Function(_$AsyncLoadingImpl<T>) then) =
      __$$AsyncLoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$AsyncLoadingImplCopyWithImpl<T, $Res>
    extends _$AsyncStateCopyWithImpl<T, $Res, _$AsyncLoadingImpl<T>>
    implements _$$AsyncLoadingImplCopyWith<T, $Res> {
  __$$AsyncLoadingImplCopyWithImpl(
      _$AsyncLoadingImpl<T> _value, $Res Function(_$AsyncLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of AsyncState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$AsyncLoadingImpl<T> extends AsyncLoading<T> {
  const _$AsyncLoadingImpl() : super._();

  @override
  String toString() {
    return 'AsyncState<$T>.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AsyncLoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(T value) data,
    required TResult Function(AppError error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(T value)? data,
    TResult? Function(AppError error)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(T value)? data,
    TResult Function(AppError error)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AsyncLoading<T> value) loading,
    required TResult Function(AsyncData<T> value) data,
    required TResult Function(AsyncError<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AsyncLoading<T> value)? loading,
    TResult? Function(AsyncData<T> value)? data,
    TResult? Function(AsyncError<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AsyncLoading<T> value)? loading,
    TResult Function(AsyncData<T> value)? data,
    TResult Function(AsyncError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AsyncLoading<T> extends AsyncState<T> {
  const factory AsyncLoading() = _$AsyncLoadingImpl<T>;
  const AsyncLoading._() : super._();
}

/// @nodoc
abstract class _$$AsyncDataImplCopyWith<T, $Res> {
  factory _$$AsyncDataImplCopyWith(
          _$AsyncDataImpl<T> value, $Res Function(_$AsyncDataImpl<T>) then) =
      __$$AsyncDataImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T value});
}

/// @nodoc
class __$$AsyncDataImplCopyWithImpl<T, $Res>
    extends _$AsyncStateCopyWithImpl<T, $Res, _$AsyncDataImpl<T>>
    implements _$$AsyncDataImplCopyWith<T, $Res> {
  __$$AsyncDataImplCopyWithImpl(
      _$AsyncDataImpl<T> _value, $Res Function(_$AsyncDataImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of AsyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(_$AsyncDataImpl<T>(
      freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$AsyncDataImpl<T> extends AsyncData<T> {
  const _$AsyncDataImpl(this.value) : super._();

  @override
  final T value;

  @override
  String toString() {
    return 'AsyncState<$T>.data(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AsyncDataImpl<T> &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(value));

  /// Create a copy of AsyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AsyncDataImplCopyWith<T, _$AsyncDataImpl<T>> get copyWith =>
      __$$AsyncDataImplCopyWithImpl<T, _$AsyncDataImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(T value) data,
    required TResult Function(AppError error) error,
  }) {
    return data(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(T value)? data,
    TResult? Function(AppError error)? error,
  }) {
    return data?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(T value)? data,
    TResult Function(AppError error)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AsyncLoading<T> value) loading,
    required TResult Function(AsyncData<T> value) data,
    required TResult Function(AsyncError<T> value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AsyncLoading<T> value)? loading,
    TResult? Function(AsyncData<T> value)? data,
    TResult? Function(AsyncError<T> value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AsyncLoading<T> value)? loading,
    TResult Function(AsyncData<T> value)? data,
    TResult Function(AsyncError<T> value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class AsyncData<T> extends AsyncState<T> {
  const factory AsyncData(final T value) = _$AsyncDataImpl<T>;
  const AsyncData._() : super._();

  T get value;

  /// Create a copy of AsyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AsyncDataImplCopyWith<T, _$AsyncDataImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AsyncErrorImplCopyWith<T, $Res> {
  factory _$$AsyncErrorImplCopyWith(
          _$AsyncErrorImpl<T> value, $Res Function(_$AsyncErrorImpl<T>) then) =
      __$$AsyncErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({AppError error});

  $AppErrorCopyWith<$Res> get error;
}

/// @nodoc
class __$$AsyncErrorImplCopyWithImpl<T, $Res>
    extends _$AsyncStateCopyWithImpl<T, $Res, _$AsyncErrorImpl<T>>
    implements _$$AsyncErrorImplCopyWith<T, $Res> {
  __$$AsyncErrorImplCopyWithImpl(
      _$AsyncErrorImpl<T> _value, $Res Function(_$AsyncErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of AsyncState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$AsyncErrorImpl<T>(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as AppError,
    ));
  }

  /// Create a copy of AsyncState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppErrorCopyWith<$Res> get error {
    return $AppErrorCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc

class _$AsyncErrorImpl<T> extends AsyncError<T> {
  const _$AsyncErrorImpl(this.error) : super._();

  @override
  final AppError error;

  @override
  String toString() {
    return 'AsyncState<$T>.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AsyncErrorImpl<T> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of AsyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AsyncErrorImplCopyWith<T, _$AsyncErrorImpl<T>> get copyWith =>
      __$$AsyncErrorImplCopyWithImpl<T, _$AsyncErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(T value) data,
    required TResult Function(AppError error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(T value)? data,
    TResult? Function(AppError error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(T value)? data,
    TResult Function(AppError error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AsyncLoading<T> value) loading,
    required TResult Function(AsyncData<T> value) data,
    required TResult Function(AsyncError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AsyncLoading<T> value)? loading,
    TResult? Function(AsyncData<T> value)? data,
    TResult? Function(AsyncError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AsyncLoading<T> value)? loading,
    TResult Function(AsyncData<T> value)? data,
    TResult Function(AsyncError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AsyncError<T> extends AsyncState<T> {
  const factory AsyncError(final AppError error) = _$AsyncErrorImpl<T>;
  const AsyncError._() : super._();

  AppError get error;

  /// Create a copy of AsyncState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AsyncErrorImplCopyWith<T, _$AsyncErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
