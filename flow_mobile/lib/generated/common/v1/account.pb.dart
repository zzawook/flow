// This is a generated file - do not edit.
//
// Generated from common/v1/account.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'bank.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Account extends $pb.GeneratedMessage {
  factory Account({
    $fixnum.Int64? id,
    $core.double? balance,
    $core.String? accountName,
    $core.String? accountNumber,
    $core.String? accountType,
    $0.Bank? bank,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (balance != null) result.balance = balance;
    if (accountName != null) result.accountName = accountName;
    if (accountNumber != null) result.accountNumber = accountNumber;
    if (accountType != null) result.accountType = accountType;
    if (bank != null) result.bank = bank;
    return result;
  }

  Account._();

  factory Account.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Account.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Account',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.common.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'balance', $pb.PbFieldType.OD)
    ..aOS(3, _omitFieldNames ? '' : 'accountName')
    ..aOS(4, _omitFieldNames ? '' : 'accountNumber')
    ..aOS(5, _omitFieldNames ? '' : 'accountType')
    ..aOM<$0.Bank>(6, _omitFieldNames ? '' : 'bank', subBuilder: $0.Bank.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Account clone() => Account()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Account copyWith(void Function(Account) updates) =>
      super.copyWith((message) => updates(message as Account)) as Account;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Account create() => Account._();
  @$core.override
  Account createEmptyInstance() => create();
  static $pb.PbList<Account> createRepeated() => $pb.PbList<Account>();
  @$core.pragma('dart2js:noInline')
  static Account getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Account>(create);
  static Account? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get balance => $_getN(1);
  @$pb.TagNumber(2)
  set balance($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBalance() => $_has(1);
  @$pb.TagNumber(2)
  void clearBalance() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get accountName => $_getSZ(2);
  @$pb.TagNumber(3)
  set accountName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAccountName() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get accountNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set accountNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccountNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccountNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get accountType => $_getSZ(4);
  @$pb.TagNumber(5)
  set accountType($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAccountType() => $_has(4);
  @$pb.TagNumber(5)
  void clearAccountType() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Bank get bank => $_getN(5);
  @$pb.TagNumber(6)
  set bank($0.Bank value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBank() => $_has(5);
  @$pb.TagNumber(6)
  void clearBank() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Bank ensureBank() => $_ensure(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
