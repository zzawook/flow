// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  String get name => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _bankAccountFromJson, toJson: _bankAccountToJson)
  BankAccount get bankAccount => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {String name,
      double amount,
      @JsonKey(fromJson: _bankAccountFromJson, toJson: _bankAccountToJson)
      BankAccount bankAccount,
      String category,
      DateTime date,
      String method,
      String note});

  $BankAccountCopyWith<$Res> get bankAccount;
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? bankAccount = null,
    Object? category = null,
    Object? date = null,
    Object? method = null,
    Object? note = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      bankAccount: null == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as BankAccount,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BankAccountCopyWith<$Res> get bankAccount {
    return $BankAccountCopyWith<$Res>(_value.bankAccount, (value) {
      return _then(_value.copyWith(bankAccount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      double amount,
      @JsonKey(fromJson: _bankAccountFromJson, toJson: _bankAccountToJson)
      BankAccount bankAccount,
      String category,
      DateTime date,
      String method,
      String note});

  @override
  $BankAccountCopyWith<$Res> get bankAccount;
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? amount = null,
    Object? bankAccount = null,
    Object? category = null,
    Object? date = null,
    Object? method = null,
    Object? note = null,
  }) {
    return _then(_$TransactionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      bankAccount: null == bankAccount
          ? _value.bankAccount
          : bankAccount // ignore: cast_nullable_to_non_nullable
              as BankAccount,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      method: null == method
          ? _value.method
          : method // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionImpl implements _Transaction {
  const _$TransactionImpl(
      {required this.name,
      required this.amount,
      @JsonKey(fromJson: _bankAccountFromJson, toJson: _bankAccountToJson)
      required this.bankAccount,
      required this.category,
      required this.date,
      required this.method,
      required this.note});

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final String name;
  @override
  final double amount;
  @override
  @JsonKey(fromJson: _bankAccountFromJson, toJson: _bankAccountToJson)
  final BankAccount bankAccount;
  @override
  final String category;
  @override
  final DateTime date;
  @override
  final String method;
  @override
  final String note;

  @override
  String toString() {
    return 'Transaction(name: $name, amount: $amount, bankAccount: $bankAccount, category: $category, date: $date, method: $method, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.bankAccount, bankAccount) ||
                other.bankAccount == bankAccount) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, amount, bankAccount, category, date, method, note);

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction implements Transaction {
  const factory _Transaction(
      {required final String name,
      required final double amount,
      @JsonKey(fromJson: _bankAccountFromJson, toJson: _bankAccountToJson)
      required final BankAccount bankAccount,
      required final String category,
      required final DateTime date,
      required final String method,
      required final String note}) = _$TransactionImpl;

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  String get name;
  @override
  double get amount;
  @override
  @JsonKey(fromJson: _bankAccountFromJson, toJson: _bankAccountToJson)
  BankAccount get bankAccount;
  @override
  String get category;
  @override
  DateTime get date;
  @override
  String get method;
  @override
  String get note;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
