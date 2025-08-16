// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransferStateModel {
  BankAccount get fromAccount => throw _privateConstructorUsedError;
  TransferReceivable get receiving => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get remarks => throw _privateConstructorUsedError;
  String get network => throw _privateConstructorUsedError;

  /// Create a copy of TransferStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferStateModelCopyWith<TransferStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferStateModelCopyWith<$Res> {
  factory $TransferStateModelCopyWith(
          TransferStateModel value, $Res Function(TransferStateModel) then) =
      _$TransferStateModelCopyWithImpl<$Res, TransferStateModel>;
  @useResult
  $Res call(
      {BankAccount fromAccount,
      TransferReceivable receiving,
      int amount,
      String remarks,
      String network});

  $BankAccountCopyWith<$Res> get fromAccount;
}

/// @nodoc
class _$TransferStateModelCopyWithImpl<$Res, $Val extends TransferStateModel>
    implements $TransferStateModelCopyWith<$Res> {
  _$TransferStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromAccount = null,
    Object? receiving = null,
    Object? amount = null,
    Object? remarks = null,
    Object? network = null,
  }) {
    return _then(_value.copyWith(
      fromAccount: null == fromAccount
          ? _value.fromAccount
          : fromAccount // ignore: cast_nullable_to_non_nullable
              as BankAccount,
      receiving: null == receiving
          ? _value.receiving
          : receiving // ignore: cast_nullable_to_non_nullable
              as TransferReceivable,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      remarks: null == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of TransferStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BankAccountCopyWith<$Res> get fromAccount {
    return $BankAccountCopyWith<$Res>(_value.fromAccount, (value) {
      return _then(_value.copyWith(fromAccount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransferStateModelImplCopyWith<$Res>
    implements $TransferStateModelCopyWith<$Res> {
  factory _$$TransferStateModelImplCopyWith(_$TransferStateModelImpl value,
          $Res Function(_$TransferStateModelImpl) then) =
      __$$TransferStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BankAccount fromAccount,
      TransferReceivable receiving,
      int amount,
      String remarks,
      String network});

  @override
  $BankAccountCopyWith<$Res> get fromAccount;
}

/// @nodoc
class __$$TransferStateModelImplCopyWithImpl<$Res>
    extends _$TransferStateModelCopyWithImpl<$Res, _$TransferStateModelImpl>
    implements _$$TransferStateModelImplCopyWith<$Res> {
  __$$TransferStateModelImplCopyWithImpl(_$TransferStateModelImpl _value,
      $Res Function(_$TransferStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromAccount = null,
    Object? receiving = null,
    Object? amount = null,
    Object? remarks = null,
    Object? network = null,
  }) {
    return _then(_$TransferStateModelImpl(
      fromAccount: null == fromAccount
          ? _value.fromAccount
          : fromAccount // ignore: cast_nullable_to_non_nullable
              as BankAccount,
      receiving: null == receiving
          ? _value.receiving
          : receiving // ignore: cast_nullable_to_non_nullable
              as TransferReceivable,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      remarks: null == remarks
          ? _value.remarks
          : remarks // ignore: cast_nullable_to_non_nullable
              as String,
      network: null == network
          ? _value.network
          : network // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TransferStateModelImpl implements _TransferStateModel {
  const _$TransferStateModelImpl(
      {required this.fromAccount,
      required this.receiving,
      this.amount = 0,
      this.remarks = '',
      this.network = 'PAYNOW'});

  @override
  final BankAccount fromAccount;
  @override
  final TransferReceivable receiving;
  @override
  @JsonKey()
  final int amount;
  @override
  @JsonKey()
  final String remarks;
  @override
  @JsonKey()
  final String network;

  @override
  String toString() {
    return 'TransferStateModel(fromAccount: $fromAccount, receiving: $receiving, amount: $amount, remarks: $remarks, network: $network)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferStateModelImpl &&
            (identical(other.fromAccount, fromAccount) ||
                other.fromAccount == fromAccount) &&
            (identical(other.receiving, receiving) ||
                other.receiving == receiving) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.remarks, remarks) || other.remarks == remarks) &&
            (identical(other.network, network) || other.network == network));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, fromAccount, receiving, amount, remarks, network);

  /// Create a copy of TransferStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferStateModelImplCopyWith<_$TransferStateModelImpl> get copyWith =>
      __$$TransferStateModelImplCopyWithImpl<_$TransferStateModelImpl>(
          this, _$identity);
}

abstract class _TransferStateModel implements TransferStateModel {
  const factory _TransferStateModel(
      {required final BankAccount fromAccount,
      required final TransferReceivable receiving,
      final int amount,
      final String remarks,
      final String network}) = _$TransferStateModelImpl;

  @override
  BankAccount get fromAccount;
  @override
  TransferReceivable get receiving;
  @override
  int get amount;
  @override
  String get remarks;
  @override
  String get network;

  /// Create a copy of TransferStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferStateModelImplCopyWith<_$TransferStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
