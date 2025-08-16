// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) {
  return _BankAccount.fromJson(json);
}

/// @nodoc
mixin _$BankAccount {
  String get accountNumber => throw _privateConstructorUsedError;
  String get accountHolder => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
  Bank get bank => throw _privateConstructorUsedError;
  int get transferCount => throw _privateConstructorUsedError;
  bool get isHidden => throw _privateConstructorUsedError;

  /// Serializes this BankAccount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankAccountCopyWith<BankAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankAccountCopyWith<$Res> {
  factory $BankAccountCopyWith(
          BankAccount value, $Res Function(BankAccount) then) =
      _$BankAccountCopyWithImpl<$Res, BankAccount>;
  @useResult
  $Res call(
      {String accountNumber,
      String accountHolder,
      double balance,
      String accountName,
      @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson) Bank bank,
      int transferCount,
      bool isHidden});

  $BankCopyWith<$Res> get bank;
}

/// @nodoc
class _$BankAccountCopyWithImpl<$Res, $Val extends BankAccount>
    implements $BankAccountCopyWith<$Res> {
  _$BankAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountNumber = null,
    Object? accountHolder = null,
    Object? balance = null,
    Object? accountName = null,
    Object? bank = null,
    Object? transferCount = null,
    Object? isHidden = null,
  }) {
    return _then(_value.copyWith(
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountHolder: null == accountHolder
          ? _value.accountHolder
          : accountHolder // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      bank: null == bank
          ? _value.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as Bank,
      transferCount: null == transferCount
          ? _value.transferCount
          : transferCount // ignore: cast_nullable_to_non_nullable
              as int,
      isHidden: null == isHidden
          ? _value.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BankCopyWith<$Res> get bank {
    return $BankCopyWith<$Res>(_value.bank, (value) {
      return _then(_value.copyWith(bank: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BankAccountImplCopyWith<$Res>
    implements $BankAccountCopyWith<$Res> {
  factory _$$BankAccountImplCopyWith(
          _$BankAccountImpl value, $Res Function(_$BankAccountImpl) then) =
      __$$BankAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String accountNumber,
      String accountHolder,
      double balance,
      String accountName,
      @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson) Bank bank,
      int transferCount,
      bool isHidden});

  @override
  $BankCopyWith<$Res> get bank;
}

/// @nodoc
class __$$BankAccountImplCopyWithImpl<$Res>
    extends _$BankAccountCopyWithImpl<$Res, _$BankAccountImpl>
    implements _$$BankAccountImplCopyWith<$Res> {
  __$$BankAccountImplCopyWithImpl(
      _$BankAccountImpl _value, $Res Function(_$BankAccountImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountNumber = null,
    Object? accountHolder = null,
    Object? balance = null,
    Object? accountName = null,
    Object? bank = null,
    Object? transferCount = null,
    Object? isHidden = null,
  }) {
    return _then(_$BankAccountImpl(
      accountNumber: null == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String,
      accountHolder: null == accountHolder
          ? _value.accountHolder
          : accountHolder // ignore: cast_nullable_to_non_nullable
              as String,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      accountName: null == accountName
          ? _value.accountName
          : accountName // ignore: cast_nullable_to_non_nullable
              as String,
      bank: null == bank
          ? _value.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as Bank,
      transferCount: null == transferCount
          ? _value.transferCount
          : transferCount // ignore: cast_nullable_to_non_nullable
              as int,
      isHidden: null == isHidden
          ? _value.isHidden
          : isHidden // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankAccountImpl extends _BankAccount {
  const _$BankAccountImpl(
      {required this.accountNumber,
      required this.accountHolder,
      this.balance = 0.0,
      required this.accountName,
      @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson) required this.bank,
      required this.transferCount,
      this.isHidden = false})
      : super._();

  factory _$BankAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankAccountImplFromJson(json);

  @override
  final String accountNumber;
  @override
  final String accountHolder;
  @override
  @JsonKey()
  final double balance;
  @override
  final String accountName;
  @override
  @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
  final Bank bank;
  @override
  final int transferCount;
  @override
  @JsonKey()
  final bool isHidden;

  @override
  String toString() {
    return 'BankAccount(accountNumber: $accountNumber, accountHolder: $accountHolder, balance: $balance, accountName: $accountName, bank: $bank, transferCount: $transferCount, isHidden: $isHidden)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankAccountImpl &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.accountHolder, accountHolder) ||
                other.accountHolder == accountHolder) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.bank, bank) || other.bank == bank) &&
            (identical(other.transferCount, transferCount) ||
                other.transferCount == transferCount) &&
            (identical(other.isHidden, isHidden) ||
                other.isHidden == isHidden));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, accountNumber, accountHolder,
      balance, accountName, bank, transferCount, isHidden);

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankAccountImplCopyWith<_$BankAccountImpl> get copyWith =>
      __$$BankAccountImplCopyWithImpl<_$BankAccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankAccountImplToJson(
      this,
    );
  }
}

abstract class _BankAccount extends BankAccount {
  const factory _BankAccount(
      {required final String accountNumber,
      required final String accountHolder,
      final double balance,
      required final String accountName,
      @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
      required final Bank bank,
      required final int transferCount,
      final bool isHidden}) = _$BankAccountImpl;
  const _BankAccount._() : super._();

  factory _BankAccount.fromJson(Map<String, dynamic> json) =
      _$BankAccountImpl.fromJson;

  @override
  String get accountNumber;
  @override
  String get accountHolder;
  @override
  double get balance;
  @override
  String get accountName;
  @override
  @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
  Bank get bank;
  @override
  int get transferCount;
  @override
  bool get isHidden;

  /// Create a copy of BankAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankAccountImplCopyWith<_$BankAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
