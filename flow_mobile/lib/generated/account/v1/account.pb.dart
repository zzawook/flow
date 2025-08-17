// This is a generated file - do not edit.
//
// Generated from account/v1/account.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/account.pb.dart' as $1;
import '../../common/v1/bank.pb.dart' as $3;
import '../../common/v1/transaction.pb.dart' as $4;
import '../../google/protobuf/wrappers.pb.dart' as $2;
import 'account.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'account.pbenum.dart';

class GetAccountsRequest extends $pb.GeneratedMessage {
  factory GetAccountsRequest() => create();

  GetAccountsRequest._();

  factory GetAccountsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccountsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccountsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.account.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountsRequest clone() => GetAccountsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountsRequest copyWith(void Function(GetAccountsRequest) updates) =>
      super.copyWith((message) => updates(message as GetAccountsRequest))
          as GetAccountsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccountsRequest create() => GetAccountsRequest._();
  @$core.override
  GetAccountsRequest createEmptyInstance() => create();
  static $pb.PbList<GetAccountsRequest> createRepeated() =>
      $pb.PbList<GetAccountsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAccountsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAccountsRequest>(create);
  static GetAccountsRequest? _defaultInstance;
}

class GetAccountsResponse extends $pb.GeneratedMessage {
  factory GetAccountsResponse({
    $core.Iterable<$1.Account>? accounts,
  }) {
    final result = create();
    if (accounts != null) result.accounts.addAll(accounts);
    return result;
  }

  GetAccountsResponse._();

  factory GetAccountsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccountsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccountsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.account.v1'),
      createEmptyInstance: create)
    ..pc<$1.Account>(1, _omitFieldNames ? '' : 'accounts', $pb.PbFieldType.PM,
        subBuilder: $1.Account.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountsResponse clone() => GetAccountsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountsResponse copyWith(void Function(GetAccountsResponse) updates) =>
      super.copyWith((message) => updates(message as GetAccountsResponse))
          as GetAccountsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccountsResponse create() => GetAccountsResponse._();
  @$core.override
  GetAccountsResponse createEmptyInstance() => create();
  static $pb.PbList<GetAccountsResponse> createRepeated() =>
      $pb.PbList<GetAccountsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetAccountsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAccountsResponse>(create);
  static GetAccountsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Account> get accounts => $_getList(0);
}

class GetAccountsWithTransactionHistoryRequest extends $pb.GeneratedMessage {
  factory GetAccountsWithTransactionHistoryRequest() => create();

  GetAccountsWithTransactionHistoryRequest._();

  factory GetAccountsWithTransactionHistoryRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccountsWithTransactionHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccountsWithTransactionHistoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.account.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountsWithTransactionHistoryRequest clone() =>
      GetAccountsWithTransactionHistoryRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountsWithTransactionHistoryRequest copyWith(
          void Function(GetAccountsWithTransactionHistoryRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetAccountsWithTransactionHistoryRequest))
          as GetAccountsWithTransactionHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccountsWithTransactionHistoryRequest create() =>
      GetAccountsWithTransactionHistoryRequest._();
  @$core.override
  GetAccountsWithTransactionHistoryRequest createEmptyInstance() => create();
  static $pb.PbList<GetAccountsWithTransactionHistoryRequest>
      createRepeated() =>
          $pb.PbList<GetAccountsWithTransactionHistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAccountsWithTransactionHistoryRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetAccountsWithTransactionHistoryRequest>(create);
  static GetAccountsWithTransactionHistoryRequest? _defaultInstance;
}

class GetAccountsWithTransactionHistoryResponse extends $pb.GeneratedMessage {
  factory GetAccountsWithTransactionHistoryResponse({
    $core.Iterable<AccountWithTransactionHistory>? accounts,
  }) {
    final result = create();
    if (accounts != null) result.accounts.addAll(accounts);
    return result;
  }

  GetAccountsWithTransactionHistoryResponse._();

  factory GetAccountsWithTransactionHistoryResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccountsWithTransactionHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccountsWithTransactionHistoryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.account.v1'),
      createEmptyInstance: create)
    ..pc<AccountWithTransactionHistory>(
        1, _omitFieldNames ? '' : 'accounts', $pb.PbFieldType.PM,
        subBuilder: AccountWithTransactionHistory.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountsWithTransactionHistoryResponse clone() =>
      GetAccountsWithTransactionHistoryResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountsWithTransactionHistoryResponse copyWith(
          void Function(GetAccountsWithTransactionHistoryResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GetAccountsWithTransactionHistoryResponse))
          as GetAccountsWithTransactionHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccountsWithTransactionHistoryResponse create() =>
      GetAccountsWithTransactionHistoryResponse._();
  @$core.override
  GetAccountsWithTransactionHistoryResponse createEmptyInstance() => create();
  static $pb.PbList<GetAccountsWithTransactionHistoryResponse>
      createRepeated() =>
          $pb.PbList<GetAccountsWithTransactionHistoryResponse>();
  @$core.pragma('dart2js:noInline')
  static GetAccountsWithTransactionHistoryResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetAccountsWithTransactionHistoryResponse>(create);
  static GetAccountsWithTransactionHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AccountWithTransactionHistory> get accounts => $_getList(0);
}

class GetAccountRequest extends $pb.GeneratedMessage {
  factory GetAccountRequest({
    $fixnum.Int64? accountId,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    return result;
  }

  GetAccountRequest._();

  factory GetAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccountRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.account.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'accountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountRequest clone() => GetAccountRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountRequest copyWith(void Function(GetAccountRequest) updates) =>
      super.copyWith((message) => updates(message as GetAccountRequest))
          as GetAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccountRequest create() => GetAccountRequest._();
  @$core.override
  GetAccountRequest createEmptyInstance() => create();
  static $pb.PbList<GetAccountRequest> createRepeated() =>
      $pb.PbList<GetAccountRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAccountRequest>(create);
  static GetAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get accountId => $_getI64(0);
  @$pb.TagNumber(1)
  set accountId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);
}

class GetAccountWithTransactionHistoryRequest extends $pb.GeneratedMessage {
  factory GetAccountWithTransactionHistoryRequest({
    $fixnum.Int64? accountId,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    return result;
  }

  GetAccountWithTransactionHistoryRequest._();

  factory GetAccountWithTransactionHistoryRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccountWithTransactionHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccountWithTransactionHistoryRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.account.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'accountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountWithTransactionHistoryRequest clone() =>
      GetAccountWithTransactionHistoryRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountWithTransactionHistoryRequest copyWith(
          void Function(GetAccountWithTransactionHistoryRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetAccountWithTransactionHistoryRequest))
          as GetAccountWithTransactionHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccountWithTransactionHistoryRequest create() =>
      GetAccountWithTransactionHistoryRequest._();
  @$core.override
  GetAccountWithTransactionHistoryRequest createEmptyInstance() => create();
  static $pb.PbList<GetAccountWithTransactionHistoryRequest> createRepeated() =>
      $pb.PbList<GetAccountWithTransactionHistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAccountWithTransactionHistoryRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetAccountWithTransactionHistoryRequest>(create);
  static GetAccountWithTransactionHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get accountId => $_getI64(0);
  @$pb.TagNumber(1)
  set accountId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);
}

class AccountWithTransactionHistory extends $pb.GeneratedMessage {
  factory AccountWithTransactionHistory({
    $fixnum.Int64? id,
    $core.String? accountNumber,
    $core.double? balance,
    $core.String? accountName,
    AccountType? accountType,
    $2.DoubleValue? interestRatePerAnnum,
    $3.Bank? bank,
    $core.Iterable<$4.TransactionHistoryDetail>?
        recentTransactionHistoryDetails,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (accountNumber != null) result.accountNumber = accountNumber;
    if (balance != null) result.balance = balance;
    if (accountName != null) result.accountName = accountName;
    if (accountType != null) result.accountType = accountType;
    if (interestRatePerAnnum != null)
      result.interestRatePerAnnum = interestRatePerAnnum;
    if (bank != null) result.bank = bank;
    if (recentTransactionHistoryDetails != null)
      result.recentTransactionHistoryDetails
          .addAll(recentTransactionHistoryDetails);
    return result;
  }

  AccountWithTransactionHistory._();

  factory AccountWithTransactionHistory.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccountWithTransactionHistory.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccountWithTransactionHistory',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.account.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'accountNumber')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'balance', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'accountName')
    ..e<AccountType>(
        5, _omitFieldNames ? '' : 'accountType', $pb.PbFieldType.OE,
        defaultOrMaker: AccountType.ACCOUNT_TYPE_UNSPECIFIED,
        valueOf: AccountType.valueOf,
        enumValues: AccountType.values)
    ..aOM<$2.DoubleValue>(6, _omitFieldNames ? '' : 'interestRatePerAnnum',
        subBuilder: $2.DoubleValue.create)
    ..aOM<$3.Bank>(7, _omitFieldNames ? '' : 'bank', subBuilder: $3.Bank.create)
    ..pc<$4.TransactionHistoryDetail>(
        8,
        _omitFieldNames ? '' : 'recentTransactionHistoryDetails',
        $pb.PbFieldType.PM,
        subBuilder: $4.TransactionHistoryDetail.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountWithTransactionHistory clone() =>
      AccountWithTransactionHistory()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccountWithTransactionHistory copyWith(
          void Function(AccountWithTransactionHistory) updates) =>
      super.copyWith(
              (message) => updates(message as AccountWithTransactionHistory))
          as AccountWithTransactionHistory;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccountWithTransactionHistory create() =>
      AccountWithTransactionHistory._();
  @$core.override
  AccountWithTransactionHistory createEmptyInstance() => create();
  static $pb.PbList<AccountWithTransactionHistory> createRepeated() =>
      $pb.PbList<AccountWithTransactionHistory>();
  @$core.pragma('dart2js:noInline')
  static AccountWithTransactionHistory getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccountWithTransactionHistory>(create);
  static AccountWithTransactionHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get balance => $_getN(2);
  @$pb.TagNumber(3)
  set balance($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearBalance() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get accountName => $_getSZ(3);
  @$pb.TagNumber(4)
  set accountName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccountName() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccountName() => $_clearField(4);

  @$pb.TagNumber(5)
  AccountType get accountType => $_getN(4);
  @$pb.TagNumber(5)
  set accountType(AccountType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAccountType() => $_has(4);
  @$pb.TagNumber(5)
  void clearAccountType() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.DoubleValue get interestRatePerAnnum => $_getN(5);
  @$pb.TagNumber(6)
  set interestRatePerAnnum($2.DoubleValue value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasInterestRatePerAnnum() => $_has(5);
  @$pb.TagNumber(6)
  void clearInterestRatePerAnnum() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.DoubleValue ensureInterestRatePerAnnum() => $_ensure(5);

  @$pb.TagNumber(7)
  $3.Bank get bank => $_getN(6);
  @$pb.TagNumber(7)
  set bank($3.Bank value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasBank() => $_has(6);
  @$pb.TagNumber(7)
  void clearBank() => $_clearField(7);
  @$pb.TagNumber(7)
  $3.Bank ensureBank() => $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbList<$4.TransactionHistoryDetail> get recentTransactionHistoryDetails =>
      $_getList(7);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
