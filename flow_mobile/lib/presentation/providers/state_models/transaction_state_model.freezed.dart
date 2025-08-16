// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransactionStateModel {
  List<Transaction> get transactions => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  AppError? get error => throw _privateConstructorUsedError;

  /// Create a copy of TransactionStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionStateModelCopyWith<TransactionStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionStateModelCopyWith<$Res> {
  factory $TransactionStateModelCopyWith(TransactionStateModel value,
          $Res Function(TransactionStateModel) then) =
      _$TransactionStateModelCopyWithImpl<$Res, TransactionStateModel>;
  @useResult
  $Res call({List<Transaction> transactions, bool isLoading, AppError? error});

  $AppErrorCopyWith<$Res>? get error;
}

/// @nodoc
class _$TransactionStateModelCopyWithImpl<$Res,
        $Val extends TransactionStateModel>
    implements $TransactionStateModelCopyWith<$Res> {
  _$TransactionStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      transactions: null == transactions
          ? _value.transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as AppError?,
    ) as $Val);
  }

  /// Create a copy of TransactionStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppErrorCopyWith<$Res>? get error {
    if (_value.error == null) {
      return null;
    }

    return $AppErrorCopyWith<$Res>(_value.error!, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionStateModelImplCopyWith<$Res>
    implements $TransactionStateModelCopyWith<$Res> {
  factory _$$TransactionStateModelImplCopyWith(
          _$TransactionStateModelImpl value,
          $Res Function(_$TransactionStateModelImpl) then) =
      __$$TransactionStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Transaction> transactions, bool isLoading, AppError? error});

  @override
  $AppErrorCopyWith<$Res>? get error;
}

/// @nodoc
class __$$TransactionStateModelImplCopyWithImpl<$Res>
    extends _$TransactionStateModelCopyWithImpl<$Res,
        _$TransactionStateModelImpl>
    implements _$$TransactionStateModelImplCopyWith<$Res> {
  __$$TransactionStateModelImplCopyWithImpl(_$TransactionStateModelImpl _value,
      $Res Function(_$TransactionStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transactions = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$TransactionStateModelImpl(
      transactions: null == transactions
          ? _value._transactions
          : transactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as AppError?,
    ));
  }
}

/// @nodoc

class _$TransactionStateModelImpl extends _TransactionStateModel {
  const _$TransactionStateModelImpl(
      {final List<Transaction> transactions = const [],
      this.isLoading = false,
      this.error})
      : _transactions = transactions,
        super._();

  final List<Transaction> _transactions;
  @override
  @JsonKey()
  List<Transaction> get transactions {
    if (_transactions is EqualUnmodifiableListView) return _transactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactions);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final AppError? error;

  @override
  String toString() {
    return 'TransactionStateModel(transactions: $transactions, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionStateModelImpl &&
            const DeepCollectionEquality()
                .equals(other._transactions, _transactions) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_transactions), isLoading, error);

  /// Create a copy of TransactionStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionStateModelImplCopyWith<_$TransactionStateModelImpl>
      get copyWith => __$$TransactionStateModelImplCopyWithImpl<
          _$TransactionStateModelImpl>(this, _$identity);
}

abstract class _TransactionStateModel extends TransactionStateModel {
  const factory _TransactionStateModel(
      {final List<Transaction> transactions,
      final bool isLoading,
      final AppError? error}) = _$TransactionStateModelImpl;
  const _TransactionStateModel._() : super._();

  @override
  List<Transaction> get transactions;
  @override
  bool get isLoading;
  @override
  AppError? get error;

  /// Create a copy of TransactionStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionStateModelImplCopyWith<_$TransactionStateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
