// This is a generated file - do not edit.
//
// Generated from transaction_history/transaction_history.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../common/v1/transaction.pb.dart' as $1;
import '../google/protobuf/timestamp.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetLast30DaysHistoryListRequest extends $pb.GeneratedMessage {
  factory GetLast30DaysHistoryListRequest() => create();

  GetLast30DaysHistoryListRequest._();

  factory GetLast30DaysHistoryListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLast30DaysHistoryListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLast30DaysHistoryListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLast30DaysHistoryListRequest clone() =>
      GetLast30DaysHistoryListRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLast30DaysHistoryListRequest copyWith(
          void Function(GetLast30DaysHistoryListRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetLast30DaysHistoryListRequest))
          as GetLast30DaysHistoryListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLast30DaysHistoryListRequest create() =>
      GetLast30DaysHistoryListRequest._();
  @$core.override
  GetLast30DaysHistoryListRequest createEmptyInstance() => create();
  static $pb.PbList<GetLast30DaysHistoryListRequest> createRepeated() =>
      $pb.PbList<GetLast30DaysHistoryListRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLast30DaysHistoryListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLast30DaysHistoryListRequest>(
          create);
  static GetLast30DaysHistoryListRequest? _defaultInstance;
}

class GetMonthlyTransactionRequest extends $pb.GeneratedMessage {
  factory GetMonthlyTransactionRequest({
    $core.int? year,
    $core.int? month,
  }) {
    final result = create();
    if (year != null) result.year = year;
    if (month != null) result.month = month;
    return result;
  }

  GetMonthlyTransactionRequest._();

  factory GetMonthlyTransactionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMonthlyTransactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMonthlyTransactionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'year', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'month', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyTransactionRequest clone() =>
      GetMonthlyTransactionRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMonthlyTransactionRequest copyWith(
          void Function(GetMonthlyTransactionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetMonthlyTransactionRequest))
          as GetMonthlyTransactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMonthlyTransactionRequest create() =>
      GetMonthlyTransactionRequest._();
  @$core.override
  GetMonthlyTransactionRequest createEmptyInstance() => create();
  static $pb.PbList<GetMonthlyTransactionRequest> createRepeated() =>
      $pb.PbList<GetMonthlyTransactionRequest>();
  @$core.pragma('dart2js:noInline')
  static GetMonthlyTransactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMonthlyTransactionRequest>(create);
  static GetMonthlyTransactionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get year => $_getIZ(0);
  @$pb.TagNumber(1)
  set year($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasYear() => $_has(0);
  @$pb.TagNumber(1)
  void clearYear() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get month => $_getIZ(1);
  @$pb.TagNumber(2)
  set month($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMonth() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonth() => $_clearField(2);
}

class GetDailyTransactionRequest extends $pb.GeneratedMessage {
  factory GetDailyTransactionRequest({
    $core.int? year,
    $core.int? month,
    $core.int? day,
  }) {
    final result = create();
    if (year != null) result.year = year;
    if (month != null) result.month = month;
    if (day != null) result.day = day;
    return result;
  }

  GetDailyTransactionRequest._();

  factory GetDailyTransactionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDailyTransactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDailyTransactionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'year', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'month', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'day', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyTransactionRequest clone() =>
      GetDailyTransactionRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDailyTransactionRequest copyWith(
          void Function(GetDailyTransactionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDailyTransactionRequest))
          as GetDailyTransactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDailyTransactionRequest create() => GetDailyTransactionRequest._();
  @$core.override
  GetDailyTransactionRequest createEmptyInstance() => create();
  static $pb.PbList<GetDailyTransactionRequest> createRepeated() =>
      $pb.PbList<GetDailyTransactionRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDailyTransactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDailyTransactionRequest>(create);
  static GetDailyTransactionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get year => $_getIZ(0);
  @$pb.TagNumber(1)
  set year($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasYear() => $_has(0);
  @$pb.TagNumber(1)
  void clearYear() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get month => $_getIZ(1);
  @$pb.TagNumber(2)
  set month($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMonth() => $_has(1);
  @$pb.TagNumber(2)
  void clearMonth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get day => $_getIZ(2);
  @$pb.TagNumber(3)
  set day($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDay() => $_clearField(3);
}

class GetTransactionDetailsRequest extends $pb.GeneratedMessage {
  factory GetTransactionDetailsRequest({
    $core.String? transactionId,
  }) {
    final result = create();
    if (transactionId != null) result.transactionId = transactionId;
    return result;
  }

  GetTransactionDetailsRequest._();

  factory GetTransactionDetailsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTransactionDetailsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTransactionDetailsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transactionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionDetailsRequest clone() =>
      GetTransactionDetailsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionDetailsRequest copyWith(
          void Function(GetTransactionDetailsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetTransactionDetailsRequest))
          as GetTransactionDetailsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTransactionDetailsRequest create() =>
      GetTransactionDetailsRequest._();
  @$core.override
  GetTransactionDetailsRequest createEmptyInstance() => create();
  static $pb.PbList<GetTransactionDetailsRequest> createRepeated() =>
      $pb.PbList<GetTransactionDetailsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTransactionDetailsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTransactionDetailsRequest>(create);
  static GetTransactionDetailsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transactionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transactionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransactionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransactionId() => $_clearField(1);
}

class GetTransactionWithinRangeRequest extends $pb.GeneratedMessage {
  factory GetTransactionWithinRangeRequest({
    $0.Timestamp? startTimestamp,
    $0.Timestamp? endTimestamp,
  }) {
    final result = create();
    if (startTimestamp != null) result.startTimestamp = startTimestamp;
    if (endTimestamp != null) result.endTimestamp = endTimestamp;
    return result;
  }

  GetTransactionWithinRangeRequest._();

  factory GetTransactionWithinRangeRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTransactionWithinRangeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTransactionWithinRangeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'startTimestamp',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'endTimestamp',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionWithinRangeRequest clone() =>
      GetTransactionWithinRangeRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionWithinRangeRequest copyWith(
          void Function(GetTransactionWithinRangeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetTransactionWithinRangeRequest))
          as GetTransactionWithinRangeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTransactionWithinRangeRequest create() =>
      GetTransactionWithinRangeRequest._();
  @$core.override
  GetTransactionWithinRangeRequest createEmptyInstance() => create();
  static $pb.PbList<GetTransactionWithinRangeRequest> createRepeated() =>
      $pb.PbList<GetTransactionWithinRangeRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTransactionWithinRangeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTransactionWithinRangeRequest>(
          create);
  static GetTransactionWithinRangeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get startTimestamp => $_getN(0);
  @$pb.TagNumber(1)
  set startTimestamp($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStartTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTimestamp() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureStartTimestamp() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get endTimestamp => $_getN(1);
  @$pb.TagNumber(2)
  set endTimestamp($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEndTimestamp() => $_ensure(1);
}

class TransactionHistoryServiceApi {
  final $pb.RpcClient _client;

  TransactionHistoryServiceApi(this._client);

  $async.Future<$1.TransactionHistoryList> getLast30DaysHistoryList(
          $pb.ClientContext? ctx, GetLast30DaysHistoryListRequest request) =>
      _client.invoke<$1.TransactionHistoryList>(
          ctx,
          'TransactionHistoryService',
          'GetLast30DaysHistoryList',
          request,
          $1.TransactionHistoryList());
  $async.Future<$1.TransactionHistoryList> getMonthlyTransaction(
          $pb.ClientContext? ctx, GetMonthlyTransactionRequest request) =>
      _client.invoke<$1.TransactionHistoryList>(
          ctx,
          'TransactionHistoryService',
          'GetMonthlyTransaction',
          request,
          $1.TransactionHistoryList());
  $async.Future<$1.TransactionHistoryList> getDailyTransaction(
          $pb.ClientContext? ctx, GetDailyTransactionRequest request) =>
      _client.invoke<$1.TransactionHistoryList>(
          ctx,
          'TransactionHistoryService',
          'GetDailyTransaction',
          request,
          $1.TransactionHistoryList());
  $async.Future<$1.TransactionHistoryDetail> getTransactionDetails(
          $pb.ClientContext? ctx, GetTransactionDetailsRequest request) =>
      _client.invoke<$1.TransactionHistoryDetail>(
          ctx,
          'TransactionHistoryService',
          'GetTransactionDetails',
          request,
          $1.TransactionHistoryDetail());
  $async.Future<$1.TransactionHistoryList> getTransactionWithinRange(
          $pb.ClientContext? ctx, GetTransactionWithinRangeRequest request) =>
      _client.invoke<$1.TransactionHistoryList>(
          ctx,
          'TransactionHistoryService',
          'GetTransactionWithinRange',
          request,
          $1.TransactionHistoryList());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
