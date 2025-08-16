// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loading_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LoadingState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(AppError error) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(AppError error)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(AppError error)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadingInitial<T> value) initial,
    required TResult Function(LoadingInProgress<T> value) loading,
    required TResult Function(LoadingSuccess<T> value) success,
    required TResult Function(LoadingError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingInitial<T> value)? initial,
    TResult? Function(LoadingInProgress<T> value)? loading,
    TResult? Function(LoadingSuccess<T> value)? success,
    TResult? Function(LoadingError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingInitial<T> value)? initial,
    TResult Function(LoadingInProgress<T> value)? loading,
    TResult Function(LoadingSuccess<T> value)? success,
    TResult Function(LoadingError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoadingStateCopyWith<T, $Res> {
  factory $LoadingStateCopyWith(
          LoadingState<T> value, $Res Function(LoadingState<T>) then) =
      _$LoadingStateCopyWithImpl<T, $Res, LoadingState<T>>;
}

/// @nodoc
class _$LoadingStateCopyWithImpl<T, $Res, $Val extends LoadingState<T>>
    implements $LoadingStateCopyWith<T, $Res> {
  _$LoadingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadingInitialImplCopyWith<T, $Res> {
  factory _$$LoadingInitialImplCopyWith(_$LoadingInitialImpl<T> value,
          $Res Function(_$LoadingInitialImpl<T>) then) =
      __$$LoadingInitialImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingInitialImplCopyWithImpl<T, $Res>
    extends _$LoadingStateCopyWithImpl<T, $Res, _$LoadingInitialImpl<T>>
    implements _$$LoadingInitialImplCopyWith<T, $Res> {
  __$$LoadingInitialImplCopyWithImpl(_$LoadingInitialImpl<T> _value,
      $Res Function(_$LoadingInitialImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingInitialImpl<T> implements LoadingInitial<T> {
  const _$LoadingInitialImpl();

  @override
  String toString() {
    return 'LoadingState<$T>.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingInitialImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(AppError error) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(AppError error)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(AppError error)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadingInitial<T> value) initial,
    required TResult Function(LoadingInProgress<T> value) loading,
    required TResult Function(LoadingSuccess<T> value) success,
    required TResult Function(LoadingError<T> value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingInitial<T> value)? initial,
    TResult? Function(LoadingInProgress<T> value)? loading,
    TResult? Function(LoadingSuccess<T> value)? success,
    TResult? Function(LoadingError<T> value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingInitial<T> value)? initial,
    TResult Function(LoadingInProgress<T> value)? loading,
    TResult Function(LoadingSuccess<T> value)? success,
    TResult Function(LoadingError<T> value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class LoadingInitial<T> implements LoadingState<T> {
  const factory LoadingInitial() = _$LoadingInitialImpl<T>;
}

/// @nodoc
abstract class _$$LoadingInProgressImplCopyWith<T, $Res> {
  factory _$$LoadingInProgressImplCopyWith(_$LoadingInProgressImpl<T> value,
          $Res Function(_$LoadingInProgressImpl<T>) then) =
      __$$LoadingInProgressImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingInProgressImplCopyWithImpl<T, $Res>
    extends _$LoadingStateCopyWithImpl<T, $Res, _$LoadingInProgressImpl<T>>
    implements _$$LoadingInProgressImplCopyWith<T, $Res> {
  __$$LoadingInProgressImplCopyWithImpl(_$LoadingInProgressImpl<T> _value,
      $Res Function(_$LoadingInProgressImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingInProgressImpl<T> implements LoadingInProgress<T> {
  const _$LoadingInProgressImpl();

  @override
  String toString() {
    return 'LoadingState<$T>.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadingInProgressImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(AppError error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(AppError error)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
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
    required TResult Function(LoadingInitial<T> value) initial,
    required TResult Function(LoadingInProgress<T> value) loading,
    required TResult Function(LoadingSuccess<T> value) success,
    required TResult Function(LoadingError<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingInitial<T> value)? initial,
    TResult? Function(LoadingInProgress<T> value)? loading,
    TResult? Function(LoadingSuccess<T> value)? success,
    TResult? Function(LoadingError<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingInitial<T> value)? initial,
    TResult Function(LoadingInProgress<T> value)? loading,
    TResult Function(LoadingSuccess<T> value)? success,
    TResult Function(LoadingError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LoadingInProgress<T> implements LoadingState<T> {
  const factory LoadingInProgress() = _$LoadingInProgressImpl<T>;
}

/// @nodoc
abstract class _$$LoadingSuccessImplCopyWith<T, $Res> {
  factory _$$LoadingSuccessImplCopyWith(_$LoadingSuccessImpl<T> value,
          $Res Function(_$LoadingSuccessImpl<T>) then) =
      __$$LoadingSuccessImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({T data});
}

/// @nodoc
class __$$LoadingSuccessImplCopyWithImpl<T, $Res>
    extends _$LoadingStateCopyWithImpl<T, $Res, _$LoadingSuccessImpl<T>>
    implements _$$LoadingSuccessImplCopyWith<T, $Res> {
  __$$LoadingSuccessImplCopyWithImpl(_$LoadingSuccessImpl<T> _value,
      $Res Function(_$LoadingSuccessImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$LoadingSuccessImpl<T>(
      freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$LoadingSuccessImpl<T> implements LoadingSuccess<T> {
  const _$LoadingSuccessImpl(this.data);

  @override
  final T data;

  @override
  String toString() {
    return 'LoadingState<$T>.success(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadingSuccessImpl<T> &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(data));

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadingSuccessImplCopyWith<T, _$LoadingSuccessImpl<T>> get copyWith =>
      __$$LoadingSuccessImplCopyWithImpl<T, _$LoadingSuccessImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(AppError error) error,
  }) {
    return success(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(AppError error)? error,
  }) {
    return success?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
    TResult Function(AppError error)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadingInitial<T> value) initial,
    required TResult Function(LoadingInProgress<T> value) loading,
    required TResult Function(LoadingSuccess<T> value) success,
    required TResult Function(LoadingError<T> value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingInitial<T> value)? initial,
    TResult? Function(LoadingInProgress<T> value)? loading,
    TResult? Function(LoadingSuccess<T> value)? success,
    TResult? Function(LoadingError<T> value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingInitial<T> value)? initial,
    TResult Function(LoadingInProgress<T> value)? loading,
    TResult Function(LoadingSuccess<T> value)? success,
    TResult Function(LoadingError<T> value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class LoadingSuccess<T> implements LoadingState<T> {
  const factory LoadingSuccess(final T data) = _$LoadingSuccessImpl<T>;

  T get data;

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadingSuccessImplCopyWith<T, _$LoadingSuccessImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingErrorImplCopyWith<T, $Res> {
  factory _$$LoadingErrorImplCopyWith(_$LoadingErrorImpl<T> value,
          $Res Function(_$LoadingErrorImpl<T>) then) =
      __$$LoadingErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({AppError error});

  $AppErrorCopyWith<$Res> get error;
}

/// @nodoc
class __$$LoadingErrorImplCopyWithImpl<T, $Res>
    extends _$LoadingStateCopyWithImpl<T, $Res, _$LoadingErrorImpl<T>>
    implements _$$LoadingErrorImplCopyWith<T, $Res> {
  __$$LoadingErrorImplCopyWithImpl(
      _$LoadingErrorImpl<T> _value, $Res Function(_$LoadingErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$LoadingErrorImpl<T>(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as AppError,
    ));
  }

  /// Create a copy of LoadingState
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

class _$LoadingErrorImpl<T> implements LoadingError<T> {
  const _$LoadingErrorImpl(this.error);

  @override
  final AppError error;

  @override
  String toString() {
    return 'LoadingState<$T>.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadingErrorImpl<T> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadingErrorImplCopyWith<T, _$LoadingErrorImpl<T>> get copyWith =>
      __$$LoadingErrorImplCopyWithImpl<T, _$LoadingErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(T data) success,
    required TResult Function(AppError error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(T data)? success,
    TResult? Function(AppError error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(T data)? success,
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
    required TResult Function(LoadingInitial<T> value) initial,
    required TResult Function(LoadingInProgress<T> value) loading,
    required TResult Function(LoadingSuccess<T> value) success,
    required TResult Function(LoadingError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadingInitial<T> value)? initial,
    TResult? Function(LoadingInProgress<T> value)? loading,
    TResult? Function(LoadingSuccess<T> value)? success,
    TResult? Function(LoadingError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadingInitial<T> value)? initial,
    TResult Function(LoadingInProgress<T> value)? loading,
    TResult Function(LoadingSuccess<T> value)? success,
    TResult Function(LoadingError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LoadingError<T> implements LoadingState<T> {
  const factory LoadingError(final AppError error) = _$LoadingErrorImpl<T>;

  AppError get error;

  /// Create a copy of LoadingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadingErrorImplCopyWith<T, _$LoadingErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
