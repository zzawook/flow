// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppError {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? code, bool isRetryable)
        network,
    required TResult Function(String message, String? code) storage,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message, Object? originalError) unknown,
    required TResult Function(String message) timeout,
    required TResult Function(String message, String? permission) permission,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? code, bool isRetryable)? network,
    TResult? Function(String message, String? code)? storage,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message, Object? originalError)? unknown,
    TResult? Function(String message)? timeout,
    TResult? Function(String message, String? permission)? permission,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? code, bool isRetryable)? network,
    TResult Function(String message, String? code)? storage,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message, Object? originalError)? unknown,
    TResult Function(String message)? timeout,
    TResult Function(String message, String? permission)? permission,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(StorageError value) storage,
    required TResult Function(ValidationError value) validation,
    required TResult Function(AuthError value) auth,
    required TResult Function(BusinessError value) business,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(PermissionError value) permission,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(StorageError value)? storage,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(AuthError value)? auth,
    TResult? Function(BusinessError value)? business,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(PermissionError value)? permission,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(StorageError value)? storage,
    TResult Function(ValidationError value)? validation,
    TResult Function(AuthError value)? auth,
    TResult Function(BusinessError value)? business,
    TResult Function(UnknownError value)? unknown,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(PermissionError value)? permission,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppErrorCopyWith<AppError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppErrorCopyWith<$Res> {
  factory $AppErrorCopyWith(AppError value, $Res Function(AppError) then) =
      _$AppErrorCopyWithImpl<$Res, AppError>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AppErrorCopyWithImpl<$Res, $Val extends AppError>
    implements $AppErrorCopyWith<$Res> {
  _$AppErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$NetworkErrorImplCopyWith(
          _$NetworkErrorImpl value, $Res Function(_$NetworkErrorImpl) then) =
      __$$NetworkErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code, bool isRetryable});
}

/// @nodoc
class __$$NetworkErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$NetworkErrorImpl>
    implements _$$NetworkErrorImplCopyWith<$Res> {
  __$$NetworkErrorImplCopyWithImpl(
      _$NetworkErrorImpl _value, $Res Function(_$NetworkErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
    Object? isRetryable = null,
  }) {
    return _then(_$NetworkErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      isRetryable: null == isRetryable
          ? _value.isRetryable
          : isRetryable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NetworkErrorImpl implements NetworkError {
  const _$NetworkErrorImpl(
      {required this.message, this.code, this.isRetryable = false});

  @override
  final String message;
  @override
  final String? code;
  @override
  @JsonKey()
  final bool isRetryable;

  @override
  String toString() {
    return 'AppError.network(message: $message, code: $code, isRetryable: $isRetryable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.isRetryable, isRetryable) ||
                other.isRetryable == isRetryable));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code, isRetryable);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkErrorImplCopyWith<_$NetworkErrorImpl> get copyWith =>
      __$$NetworkErrorImplCopyWithImpl<_$NetworkErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? code, bool isRetryable)
        network,
    required TResult Function(String message, String? code) storage,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message, Object? originalError) unknown,
    required TResult Function(String message) timeout,
    required TResult Function(String message, String? permission) permission,
  }) {
    return network(message, code, isRetryable);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? code, bool isRetryable)? network,
    TResult? Function(String message, String? code)? storage,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message, Object? originalError)? unknown,
    TResult? Function(String message)? timeout,
    TResult? Function(String message, String? permission)? permission,
  }) {
    return network?.call(message, code, isRetryable);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? code, bool isRetryable)? network,
    TResult Function(String message, String? code)? storage,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message, Object? originalError)? unknown,
    TResult Function(String message)? timeout,
    TResult Function(String message, String? permission)? permission,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message, code, isRetryable);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(StorageError value) storage,
    required TResult Function(ValidationError value) validation,
    required TResult Function(AuthError value) auth,
    required TResult Function(BusinessError value) business,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(PermissionError value) permission,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(StorageError value)? storage,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(AuthError value)? auth,
    TResult? Function(BusinessError value)? business,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(PermissionError value)? permission,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(StorageError value)? storage,
    TResult Function(ValidationError value)? validation,
    TResult Function(AuthError value)? auth,
    TResult Function(BusinessError value)? business,
    TResult Function(UnknownError value)? unknown,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(PermissionError value)? permission,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkError implements AppError {
  const factory NetworkError(
      {required final String message,
      final String? code,
      final bool isRetryable}) = _$NetworkErrorImpl;

  @override
  String get message;
  String? get code;
  bool get isRetryable;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkErrorImplCopyWith<_$NetworkErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$StorageErrorImplCopyWith(
          _$StorageErrorImpl value, $Res Function(_$StorageErrorImpl) then) =
      __$$StorageErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$StorageErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$StorageErrorImpl>
    implements _$$StorageErrorImplCopyWith<$Res> {
  __$$StorageErrorImplCopyWithImpl(
      _$StorageErrorImpl _value, $Res Function(_$StorageErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$StorageErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$StorageErrorImpl implements StorageError {
  const _$StorageErrorImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'AppError.storage(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageErrorImplCopyWith<_$StorageErrorImpl> get copyWith =>
      __$$StorageErrorImplCopyWithImpl<_$StorageErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? code, bool isRetryable)
        network,
    required TResult Function(String message, String? code) storage,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message, Object? originalError) unknown,
    required TResult Function(String message) timeout,
    required TResult Function(String message, String? permission) permission,
  }) {
    return storage(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? code, bool isRetryable)? network,
    TResult? Function(String message, String? code)? storage,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message, Object? originalError)? unknown,
    TResult? Function(String message)? timeout,
    TResult? Function(String message, String? permission)? permission,
  }) {
    return storage?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? code, bool isRetryable)? network,
    TResult Function(String message, String? code)? storage,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message, Object? originalError)? unknown,
    TResult Function(String message)? timeout,
    TResult Function(String message, String? permission)? permission,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(StorageError value) storage,
    required TResult Function(ValidationError value) validation,
    required TResult Function(AuthError value) auth,
    required TResult Function(BusinessError value) business,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(PermissionError value) permission,
  }) {
    return storage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(StorageError value)? storage,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(AuthError value)? auth,
    TResult? Function(BusinessError value)? business,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(PermissionError value)? permission,
  }) {
    return storage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(StorageError value)? storage,
    TResult Function(ValidationError value)? validation,
    TResult Function(AuthError value)? auth,
    TResult Function(BusinessError value)? business,
    TResult Function(UnknownError value)? unknown,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(PermissionError value)? permission,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(this);
    }
    return orElse();
  }
}

abstract class StorageError implements AppError {
  const factory StorageError(
      {required final String message, final String? code}) = _$StorageErrorImpl;

  @override
  String get message;
  String? get code;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageErrorImplCopyWith<_$StorageErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$ValidationErrorImplCopyWith(_$ValidationErrorImpl value,
          $Res Function(_$ValidationErrorImpl) then) =
      __$$ValidationErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? field});
}

/// @nodoc
class __$$ValidationErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$ValidationErrorImpl>
    implements _$$ValidationErrorImplCopyWith<$Res> {
  __$$ValidationErrorImplCopyWithImpl(
      _$ValidationErrorImpl _value, $Res Function(_$ValidationErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? field = freezed,
  }) {
    return _then(_$ValidationErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      field: freezed == field
          ? _value.field
          : field // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ValidationErrorImpl implements ValidationError {
  const _$ValidationErrorImpl({required this.message, this.field});

  @override
  final String message;
  @override
  final String? field;

  @override
  String toString() {
    return 'AppError.validation(message: $message, field: $field)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.field, field) || other.field == field));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, field);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationErrorImplCopyWith<_$ValidationErrorImpl> get copyWith =>
      __$$ValidationErrorImplCopyWithImpl<_$ValidationErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? code, bool isRetryable)
        network,
    required TResult Function(String message, String? code) storage,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message, Object? originalError) unknown,
    required TResult Function(String message) timeout,
    required TResult Function(String message, String? permission) permission,
  }) {
    return validation(message, field);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? code, bool isRetryable)? network,
    TResult? Function(String message, String? code)? storage,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message, Object? originalError)? unknown,
    TResult? Function(String message)? timeout,
    TResult? Function(String message, String? permission)? permission,
  }) {
    return validation?.call(message, field);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? code, bool isRetryable)? network,
    TResult Function(String message, String? code)? storage,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message, Object? originalError)? unknown,
    TResult Function(String message)? timeout,
    TResult Function(String message, String? permission)? permission,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message, field);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(StorageError value) storage,
    required TResult Function(ValidationError value) validation,
    required TResult Function(AuthError value) auth,
    required TResult Function(BusinessError value) business,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(PermissionError value) permission,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(StorageError value)? storage,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(AuthError value)? auth,
    TResult? Function(BusinessError value)? business,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(PermissionError value)? permission,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(StorageError value)? storage,
    TResult Function(ValidationError value)? validation,
    TResult Function(AuthError value)? auth,
    TResult Function(BusinessError value)? business,
    TResult Function(UnknownError value)? unknown,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(PermissionError value)? permission,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationError implements AppError {
  const factory ValidationError(
      {required final String message,
      final String? field}) = _$ValidationErrorImpl;

  @override
  String get message;
  String? get field;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationErrorImplCopyWith<_$ValidationErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$AuthErrorImplCopyWith(
          _$AuthErrorImpl value, $Res Function(_$AuthErrorImpl) then) =
      __$$AuthErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$AuthErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$AuthErrorImpl>
    implements _$$AuthErrorImplCopyWith<$Res> {
  __$$AuthErrorImplCopyWithImpl(
      _$AuthErrorImpl _value, $Res Function(_$AuthErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$AuthErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AuthErrorImpl implements AuthError {
  const _$AuthErrorImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'AppError.auth(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      __$$AuthErrorImplCopyWithImpl<_$AuthErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? code, bool isRetryable)
        network,
    required TResult Function(String message, String? code) storage,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message, Object? originalError) unknown,
    required TResult Function(String message) timeout,
    required TResult Function(String message, String? permission) permission,
  }) {
    return auth(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? code, bool isRetryable)? network,
    TResult? Function(String message, String? code)? storage,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message, Object? originalError)? unknown,
    TResult? Function(String message)? timeout,
    TResult? Function(String message, String? permission)? permission,
  }) {
    return auth?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? code, bool isRetryable)? network,
    TResult Function(String message, String? code)? storage,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message, Object? originalError)? unknown,
    TResult Function(String message)? timeout,
    TResult Function(String message, String? permission)? permission,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(StorageError value) storage,
    required TResult Function(ValidationError value) validation,
    required TResult Function(AuthError value) auth,
    required TResult Function(BusinessError value) business,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(PermissionError value) permission,
  }) {
    return auth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(StorageError value)? storage,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(AuthError value)? auth,
    TResult? Function(BusinessError value)? business,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(PermissionError value)? permission,
  }) {
    return auth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(StorageError value)? storage,
    TResult Function(ValidationError value)? validation,
    TResult Function(AuthError value)? auth,
    TResult Function(BusinessError value)? business,
    TResult Function(UnknownError value)? unknown,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(PermissionError value)? permission,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(this);
    }
    return orElse();
  }
}

abstract class AuthError implements AppError {
  const factory AuthError({required final String message, final String? code}) =
      _$AuthErrorImpl;

  @override
  String get message;
  String? get code;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthErrorImplCopyWith<_$AuthErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BusinessErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$BusinessErrorImplCopyWith(
          _$BusinessErrorImpl value, $Res Function(_$BusinessErrorImpl) then) =
      __$$BusinessErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$BusinessErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$BusinessErrorImpl>
    implements _$$BusinessErrorImplCopyWith<$Res> {
  __$$BusinessErrorImplCopyWithImpl(
      _$BusinessErrorImpl _value, $Res Function(_$BusinessErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? code = freezed,
  }) {
    return _then(_$BusinessErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BusinessErrorImpl implements BusinessError {
  const _$BusinessErrorImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'AppError.business(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessErrorImplCopyWith<_$BusinessErrorImpl> get copyWith =>
      __$$BusinessErrorImplCopyWithImpl<_$BusinessErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? code, bool isRetryable)
        network,
    required TResult Function(String message, String? code) storage,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message, Object? originalError) unknown,
    required TResult Function(String message) timeout,
    required TResult Function(String message, String? permission) permission,
  }) {
    return business(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? code, bool isRetryable)? network,
    TResult? Function(String message, String? code)? storage,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message, Object? originalError)? unknown,
    TResult? Function(String message)? timeout,
    TResult? Function(String message, String? permission)? permission,
  }) {
    return business?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? code, bool isRetryable)? network,
    TResult Function(String message, String? code)? storage,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message, Object? originalError)? unknown,
    TResult Function(String message)? timeout,
    TResult Function(String message, String? permission)? permission,
    required TResult orElse(),
  }) {
    if (business != null) {
      return business(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(StorageError value) storage,
    required TResult Function(ValidationError value) validation,
    required TResult Function(AuthError value) auth,
    required TResult Function(BusinessError value) business,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(PermissionError value) permission,
  }) {
    return business(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(StorageError value)? storage,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(AuthError value)? auth,
    TResult? Function(BusinessError value)? business,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(PermissionError value)? permission,
  }) {
    return business?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(StorageError value)? storage,
    TResult Function(ValidationError value)? validation,
    TResult Function(AuthError value)? auth,
    TResult Function(BusinessError value)? business,
    TResult Function(UnknownError value)? unknown,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(PermissionError value)? permission,
    required TResult orElse(),
  }) {
    if (business != null) {
      return business(this);
    }
    return orElse();
  }
}

abstract class BusinessError implements AppError {
  const factory BusinessError(
      {required final String message,
      final String? code}) = _$BusinessErrorImpl;

  @override
  String get message;
  String? get code;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessErrorImplCopyWith<_$BusinessErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$UnknownErrorImplCopyWith(
          _$UnknownErrorImpl value, $Res Function(_$UnknownErrorImpl) then) =
      __$$UnknownErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? originalError});
}

/// @nodoc
class __$$UnknownErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$UnknownErrorImpl>
    implements _$$UnknownErrorImplCopyWith<$Res> {
  __$$UnknownErrorImplCopyWithImpl(
      _$UnknownErrorImpl _value, $Res Function(_$UnknownErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
  }) {
    return _then(_$UnknownErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError:
          freezed == originalError ? _value.originalError : originalError,
    ));
  }
}

/// @nodoc

class _$UnknownErrorImpl implements UnknownError {
  const _$UnknownErrorImpl({required this.message, this.originalError});

  @override
  final String message;
  @override
  final Object? originalError;

  @override
  String toString() {
    return 'AppError.unknown(message: $message, originalError: $originalError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, const DeepCollectionEquality().hash(originalError));

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      __$$UnknownErrorImplCopyWithImpl<_$UnknownErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? code, bool isRetryable)
        network,
    required TResult Function(String message, String? code) storage,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message, Object? originalError) unknown,
    required TResult Function(String message) timeout,
    required TResult Function(String message, String? permission) permission,
  }) {
    return unknown(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? code, bool isRetryable)? network,
    TResult? Function(String message, String? code)? storage,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message, Object? originalError)? unknown,
    TResult? Function(String message)? timeout,
    TResult? Function(String message, String? permission)? permission,
  }) {
    return unknown?.call(message, originalError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? code, bool isRetryable)? network,
    TResult Function(String message, String? code)? storage,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message, Object? originalError)? unknown,
    TResult Function(String message)? timeout,
    TResult Function(String message, String? permission)? permission,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, originalError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(StorageError value) storage,
    required TResult Function(ValidationError value) validation,
    required TResult Function(AuthError value) auth,
    required TResult Function(BusinessError value) business,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(PermissionError value) permission,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(StorageError value)? storage,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(AuthError value)? auth,
    TResult? Function(BusinessError value)? business,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(PermissionError value)? permission,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(StorageError value)? storage,
    TResult Function(ValidationError value)? validation,
    TResult Function(AuthError value)? auth,
    TResult Function(BusinessError value)? business,
    TResult Function(UnknownError value)? unknown,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(PermissionError value)? permission,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownError implements AppError {
  const factory UnknownError(
      {required final String message,
      final Object? originalError}) = _$UnknownErrorImpl;

  @override
  String get message;
  Object? get originalError;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimeoutErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$TimeoutErrorImplCopyWith(
          _$TimeoutErrorImpl value, $Res Function(_$TimeoutErrorImpl) then) =
      __$$TimeoutErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$TimeoutErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$TimeoutErrorImpl>
    implements _$$TimeoutErrorImplCopyWith<$Res> {
  __$$TimeoutErrorImplCopyWithImpl(
      _$TimeoutErrorImpl _value, $Res Function(_$TimeoutErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$TimeoutErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TimeoutErrorImpl implements TimeoutError {
  const _$TimeoutErrorImpl({this.message = 'Operation timed out'});

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'AppError.timeout(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeoutErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeoutErrorImplCopyWith<_$TimeoutErrorImpl> get copyWith =>
      __$$TimeoutErrorImplCopyWithImpl<_$TimeoutErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? code, bool isRetryable)
        network,
    required TResult Function(String message, String? code) storage,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message, Object? originalError) unknown,
    required TResult Function(String message) timeout,
    required TResult Function(String message, String? permission) permission,
  }) {
    return timeout(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? code, bool isRetryable)? network,
    TResult? Function(String message, String? code)? storage,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message, Object? originalError)? unknown,
    TResult? Function(String message)? timeout,
    TResult? Function(String message, String? permission)? permission,
  }) {
    return timeout?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? code, bool isRetryable)? network,
    TResult Function(String message, String? code)? storage,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message, Object? originalError)? unknown,
    TResult Function(String message)? timeout,
    TResult Function(String message, String? permission)? permission,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(StorageError value) storage,
    required TResult Function(ValidationError value) validation,
    required TResult Function(AuthError value) auth,
    required TResult Function(BusinessError value) business,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(PermissionError value) permission,
  }) {
    return timeout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(StorageError value)? storage,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(AuthError value)? auth,
    TResult? Function(BusinessError value)? business,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(PermissionError value)? permission,
  }) {
    return timeout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(StorageError value)? storage,
    TResult Function(ValidationError value)? validation,
    TResult Function(AuthError value)? auth,
    TResult Function(BusinessError value)? business,
    TResult Function(UnknownError value)? unknown,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(PermissionError value)? permission,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout(this);
    }
    return orElse();
  }
}

abstract class TimeoutError implements AppError {
  const factory TimeoutError({final String message}) = _$TimeoutErrorImpl;

  @override
  String get message;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeoutErrorImplCopyWith<_$TimeoutErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PermissionErrorImplCopyWith<$Res>
    implements $AppErrorCopyWith<$Res> {
  factory _$$PermissionErrorImplCopyWith(_$PermissionErrorImpl value,
          $Res Function(_$PermissionErrorImpl) then) =
      __$$PermissionErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? permission});
}

/// @nodoc
class __$$PermissionErrorImplCopyWithImpl<$Res>
    extends _$AppErrorCopyWithImpl<$Res, _$PermissionErrorImpl>
    implements _$$PermissionErrorImplCopyWith<$Res> {
  __$$PermissionErrorImplCopyWithImpl(
      _$PermissionErrorImpl _value, $Res Function(_$PermissionErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? permission = freezed,
  }) {
    return _then(_$PermissionErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      permission: freezed == permission
          ? _value.permission
          : permission // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PermissionErrorImpl implements PermissionError {
  const _$PermissionErrorImpl({required this.message, this.permission});

  @override
  final String message;
  @override
  final String? permission;

  @override
  String toString() {
    return 'AppError.permission(message: $message, permission: $permission)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.permission, permission) ||
                other.permission == permission));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, permission);

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionErrorImplCopyWith<_$PermissionErrorImpl> get copyWith =>
      __$$PermissionErrorImplCopyWithImpl<_$PermissionErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, String? code, bool isRetryable)
        network,
    required TResult Function(String message, String? code) storage,
    required TResult Function(String message, String? field) validation,
    required TResult Function(String message, String? code) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message, Object? originalError) unknown,
    required TResult Function(String message) timeout,
    required TResult Function(String message, String? permission) permission,
  }) {
    return permission(message, this.permission);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, String? code, bool isRetryable)? network,
    TResult? Function(String message, String? code)? storage,
    TResult? Function(String message, String? field)? validation,
    TResult? Function(String message, String? code)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message, Object? originalError)? unknown,
    TResult? Function(String message)? timeout,
    TResult? Function(String message, String? permission)? permission,
  }) {
    return permission?.call(message, this.permission);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, String? code, bool isRetryable)? network,
    TResult Function(String message, String? code)? storage,
    TResult Function(String message, String? field)? validation,
    TResult Function(String message, String? code)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message, Object? originalError)? unknown,
    TResult Function(String message)? timeout,
    TResult Function(String message, String? permission)? permission,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(message, this.permission);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(StorageError value) storage,
    required TResult Function(ValidationError value) validation,
    required TResult Function(AuthError value) auth,
    required TResult Function(BusinessError value) business,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(PermissionError value) permission,
  }) {
    return permission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(StorageError value)? storage,
    TResult? Function(ValidationError value)? validation,
    TResult? Function(AuthError value)? auth,
    TResult? Function(BusinessError value)? business,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(PermissionError value)? permission,
  }) {
    return permission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(StorageError value)? storage,
    TResult Function(ValidationError value)? validation,
    TResult Function(AuthError value)? auth,
    TResult Function(BusinessError value)? business,
    TResult Function(UnknownError value)? unknown,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(PermissionError value)? permission,
    required TResult orElse(),
  }) {
    if (permission != null) {
      return permission(this);
    }
    return orElse();
  }
}

abstract class PermissionError implements AppError {
  const factory PermissionError(
      {required final String message,
      final String? permission}) = _$PermissionErrorImpl;

  @override
  String get message;
  String? get permission;

  /// Create a copy of AppError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PermissionErrorImplCopyWith<_$PermissionErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
