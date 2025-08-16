// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paynow_recipient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PayNowRecipient _$PayNowRecipientFromJson(Map<String, dynamic> json) {
  return _PayNowRecipient.fromJson(json);
}

/// @nodoc
mixin _$PayNowRecipient {
  String get name => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get idNumber => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
  Bank get bank => throw _privateConstructorUsedError;
  int get transferCount => throw _privateConstructorUsedError;

  /// Serializes this PayNowRecipient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PayNowRecipient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PayNowRecipientCopyWith<PayNowRecipient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayNowRecipientCopyWith<$Res> {
  factory $PayNowRecipientCopyWith(
          PayNowRecipient value, $Res Function(PayNowRecipient) then) =
      _$PayNowRecipientCopyWithImpl<$Res, PayNowRecipient>;
  @useResult
  $Res call(
      {String name,
      String phoneNumber,
      String idNumber,
      @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson) Bank bank,
      int transferCount});

  $BankCopyWith<$Res> get bank;
}

/// @nodoc
class _$PayNowRecipientCopyWithImpl<$Res, $Val extends PayNowRecipient>
    implements $PayNowRecipientCopyWith<$Res> {
  _$PayNowRecipientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PayNowRecipient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? phoneNumber = null,
    Object? idNumber = null,
    Object? bank = null,
    Object? transferCount = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      idNumber: null == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String,
      bank: null == bank
          ? _value.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as Bank,
      transferCount: null == transferCount
          ? _value.transferCount
          : transferCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of PayNowRecipient
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
abstract class _$$PayNowRecipientImplCopyWith<$Res>
    implements $PayNowRecipientCopyWith<$Res> {
  factory _$$PayNowRecipientImplCopyWith(_$PayNowRecipientImpl value,
          $Res Function(_$PayNowRecipientImpl) then) =
      __$$PayNowRecipientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String phoneNumber,
      String idNumber,
      @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson) Bank bank,
      int transferCount});

  @override
  $BankCopyWith<$Res> get bank;
}

/// @nodoc
class __$$PayNowRecipientImplCopyWithImpl<$Res>
    extends _$PayNowRecipientCopyWithImpl<$Res, _$PayNowRecipientImpl>
    implements _$$PayNowRecipientImplCopyWith<$Res> {
  __$$PayNowRecipientImplCopyWithImpl(
      _$PayNowRecipientImpl _value, $Res Function(_$PayNowRecipientImpl) _then)
      : super(_value, _then);

  /// Create a copy of PayNowRecipient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? phoneNumber = null,
    Object? idNumber = null,
    Object? bank = null,
    Object? transferCount = null,
  }) {
    return _then(_$PayNowRecipientImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      idNumber: null == idNumber
          ? _value.idNumber
          : idNumber // ignore: cast_nullable_to_non_nullable
              as String,
      bank: null == bank
          ? _value.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as Bank,
      transferCount: null == transferCount
          ? _value.transferCount
          : transferCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PayNowRecipientImpl implements _PayNowRecipient {
  const _$PayNowRecipientImpl(
      {required this.name,
      required this.phoneNumber,
      required this.idNumber,
      @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson) required this.bank,
      required this.transferCount});

  factory _$PayNowRecipientImpl.fromJson(Map<String, dynamic> json) =>
      _$$PayNowRecipientImplFromJson(json);

  @override
  final String name;
  @override
  final String phoneNumber;
  @override
  final String idNumber;
  @override
  @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
  final Bank bank;
  @override
  final int transferCount;

  @override
  String toString() {
    return 'PayNowRecipient(name: $name, phoneNumber: $phoneNumber, idNumber: $idNumber, bank: $bank, transferCount: $transferCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PayNowRecipientImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.idNumber, idNumber) ||
                other.idNumber == idNumber) &&
            (identical(other.bank, bank) || other.bank == bank) &&
            (identical(other.transferCount, transferCount) ||
                other.transferCount == transferCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, phoneNumber, idNumber, bank, transferCount);

  /// Create a copy of PayNowRecipient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PayNowRecipientImplCopyWith<_$PayNowRecipientImpl> get copyWith =>
      __$$PayNowRecipientImplCopyWithImpl<_$PayNowRecipientImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PayNowRecipientImplToJson(
      this,
    );
  }
}

abstract class _PayNowRecipient implements PayNowRecipient {
  const factory _PayNowRecipient(
      {required final String name,
      required final String phoneNumber,
      required final String idNumber,
      @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
      required final Bank bank,
      required final int transferCount}) = _$PayNowRecipientImpl;

  factory _PayNowRecipient.fromJson(Map<String, dynamic> json) =
      _$PayNowRecipientImpl.fromJson;

  @override
  String get name;
  @override
  String get phoneNumber;
  @override
  String get idNumber;
  @override
  @JsonKey(fromJson: _bankFromJson, toJson: _bankToJson)
  Bank get bank;
  @override
  int get transferCount;

  /// Create a copy of PayNowRecipient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PayNowRecipientImplCopyWith<_$PayNowRecipientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
