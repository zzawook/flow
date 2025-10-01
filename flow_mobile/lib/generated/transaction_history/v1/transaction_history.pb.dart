// This is a generated file - do not edit.
//
// Generated from transaction_history/v1/transaction_history.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/transaction.pb.dart' as $1;
import '../../google/protobuf/timestamp.pb.dart' as $2;

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
    $2.Timestamp? startTimestamp,
    $2.Timestamp? endTimestamp,
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
    ..aOM<$2.Timestamp>(1, _omitFieldNames ? '' : 'startTimestamp',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'endTimestamp',
        subBuilder: $2.Timestamp.create)
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
  $2.Timestamp get startTimestamp => $_getN(0);
  @$pb.TagNumber(1)
  set startTimestamp($2.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStartTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTimestamp() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Timestamp ensureStartTimestamp() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.Timestamp get endTimestamp => $_getN(1);
  @$pb.TagNumber(2)
  set endTimestamp($2.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureEndTimestamp() => $_ensure(1);
}

class GetProcessedTransactionRequest extends $pb.GeneratedMessage {
  factory GetProcessedTransactionRequest({
    $core.Iterable<$core.String>? transactionIds,
  }) {
    final result = create();
    if (transactionIds != null) result.transactionIds.addAll(transactionIds);
    return result;
  }

  GetProcessedTransactionRequest._();

  factory GetProcessedTransactionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetProcessedTransactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetProcessedTransactionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'transactionIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProcessedTransactionRequest clone() =>
      GetProcessedTransactionRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetProcessedTransactionRequest copyWith(
          void Function(GetProcessedTransactionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetProcessedTransactionRequest))
          as GetProcessedTransactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetProcessedTransactionRequest create() =>
      GetProcessedTransactionRequest._();
  @$core.override
  GetProcessedTransactionRequest createEmptyInstance() => create();
  static $pb.PbList<GetProcessedTransactionRequest> createRepeated() =>
      $pb.PbList<GetProcessedTransactionRequest>();
  @$core.pragma('dart2js:noInline')
  static GetProcessedTransactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetProcessedTransactionRequest>(create);
  static GetProcessedTransactionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get transactionIds => $_getList(0);
}

class GetRecurringTransactionRequest extends $pb.GeneratedMessage {
  factory GetRecurringTransactionRequest() => create();

  GetRecurringTransactionRequest._();

  factory GetRecurringTransactionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecurringTransactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecurringTransactionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecurringTransactionRequest clone() =>
      GetRecurringTransactionRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecurringTransactionRequest copyWith(
          void Function(GetRecurringTransactionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetRecurringTransactionRequest))
          as GetRecurringTransactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecurringTransactionRequest create() =>
      GetRecurringTransactionRequest._();
  @$core.override
  GetRecurringTransactionRequest createEmptyInstance() => create();
  static $pb.PbList<GetRecurringTransactionRequest> createRepeated() =>
      $pb.PbList<GetRecurringTransactionRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRecurringTransactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecurringTransactionRequest>(create);
  static GetRecurringTransactionRequest? _defaultInstance;
}

class GetRecurringTransactionResponse extends $pb.GeneratedMessage {
  factory GetRecurringTransactionResponse({
    $core.Iterable<$1.RecurringTransactionDetail>? recurringTransactions,
    $2.Timestamp? lastUpdated,
  }) {
    final result = create();
    if (recurringTransactions != null)
      result.recurringTransactions.addAll(recurringTransactions);
    if (lastUpdated != null) result.lastUpdated = lastUpdated;
    return result;
  }

  GetRecurringTransactionResponse._();

  factory GetRecurringTransactionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecurringTransactionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecurringTransactionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..pc<$1.RecurringTransactionDetail>(
        1, _omitFieldNames ? '' : 'recurringTransactions', $pb.PbFieldType.PM,
        subBuilder: $1.RecurringTransactionDetail.create)
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'lastUpdated',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecurringTransactionResponse clone() =>
      GetRecurringTransactionResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecurringTransactionResponse copyWith(
          void Function(GetRecurringTransactionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetRecurringTransactionResponse))
          as GetRecurringTransactionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecurringTransactionResponse create() =>
      GetRecurringTransactionResponse._();
  @$core.override
  GetRecurringTransactionResponse createEmptyInstance() => create();
  static $pb.PbList<GetRecurringTransactionResponse> createRepeated() =>
      $pb.PbList<GetRecurringTransactionResponse>();
  @$core.pragma('dart2js:noInline')
  static GetRecurringTransactionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecurringTransactionResponse>(
          create);
  static GetRecurringTransactionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.RecurringTransactionDetail> get recurringTransactions =>
      $_getList(0);

  @$pb.TagNumber(2)
  $2.Timestamp get lastUpdated => $_getN(1);
  @$pb.TagNumber(2)
  set lastUpdated($2.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLastUpdated() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastUpdated() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureLastUpdated() => $_ensure(1);
}

class SetTransactionCategoryRequest extends $pb.GeneratedMessage {
  factory SetTransactionCategoryRequest({
    $core.String? transactionId,
    $core.String? category,
  }) {
    final result = create();
    if (transactionId != null) result.transactionId = transactionId;
    if (category != null) result.category = category;
    return result;
  }

  SetTransactionCategoryRequest._();

  factory SetTransactionCategoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTransactionCategoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTransactionCategoryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transactionId')
    ..aOS(2, _omitFieldNames ? '' : 'category')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTransactionCategoryRequest clone() =>
      SetTransactionCategoryRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTransactionCategoryRequest copyWith(
          void Function(SetTransactionCategoryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetTransactionCategoryRequest))
          as SetTransactionCategoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTransactionCategoryRequest create() =>
      SetTransactionCategoryRequest._();
  @$core.override
  SetTransactionCategoryRequest createEmptyInstance() => create();
  static $pb.PbList<SetTransactionCategoryRequest> createRepeated() =>
      $pb.PbList<SetTransactionCategoryRequest>();
  @$core.pragma('dart2js:noInline')
  static SetTransactionCategoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTransactionCategoryRequest>(create);
  static SetTransactionCategoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transactionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transactionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransactionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransactionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get category => $_getSZ(1);
  @$pb.TagNumber(2)
  set category($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);
}

class SetTransactionCategoryResponse extends $pb.GeneratedMessage {
  factory SetTransactionCategoryResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  SetTransactionCategoryResponse._();

  factory SetTransactionCategoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTransactionCategoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTransactionCategoryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTransactionCategoryResponse clone() =>
      SetTransactionCategoryResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTransactionCategoryResponse copyWith(
          void Function(SetTransactionCategoryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetTransactionCategoryResponse))
          as SetTransactionCategoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTransactionCategoryResponse create() =>
      SetTransactionCategoryResponse._();
  @$core.override
  SetTransactionCategoryResponse createEmptyInstance() => create();
  static $pb.PbList<SetTransactionCategoryResponse> createRepeated() =>
      $pb.PbList<SetTransactionCategoryResponse>();
  @$core.pragma('dart2js:noInline')
  static SetTransactionCategoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTransactionCategoryResponse>(create);
  static SetTransactionCategoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class SetTransactionInclusionRequest extends $pb.GeneratedMessage {
  factory SetTransactionInclusionRequest({
    $core.String? transactionId,
    $core.bool? includeInSpendingOrIncome,
  }) {
    final result = create();
    if (transactionId != null) result.transactionId = transactionId;
    if (includeInSpendingOrIncome != null)
      result.includeInSpendingOrIncome = includeInSpendingOrIncome;
    return result;
  }

  SetTransactionInclusionRequest._();

  factory SetTransactionInclusionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTransactionInclusionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTransactionInclusionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transactionId')
    ..aOB(2, _omitFieldNames ? '' : 'includeInSpendingOrIncome')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTransactionInclusionRequest clone() =>
      SetTransactionInclusionRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTransactionInclusionRequest copyWith(
          void Function(SetTransactionInclusionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetTransactionInclusionRequest))
          as SetTransactionInclusionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTransactionInclusionRequest create() =>
      SetTransactionInclusionRequest._();
  @$core.override
  SetTransactionInclusionRequest createEmptyInstance() => create();
  static $pb.PbList<SetTransactionInclusionRequest> createRepeated() =>
      $pb.PbList<SetTransactionInclusionRequest>();
  @$core.pragma('dart2js:noInline')
  static SetTransactionInclusionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTransactionInclusionRequest>(create);
  static SetTransactionInclusionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transactionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transactionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransactionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransactionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get includeInSpendingOrIncome => $_getBF(1);
  @$pb.TagNumber(2)
  set includeInSpendingOrIncome($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncludeInSpendingOrIncome() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncludeInSpendingOrIncome() => $_clearField(2);
}

class SetTransactionInclusionResponse extends $pb.GeneratedMessage {
  factory SetTransactionInclusionResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  SetTransactionInclusionResponse._();

  factory SetTransactionInclusionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetTransactionInclusionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetTransactionInclusionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTransactionInclusionResponse clone() =>
      SetTransactionInclusionResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetTransactionInclusionResponse copyWith(
          void Function(SetTransactionInclusionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetTransactionInclusionResponse))
          as SetTransactionInclusionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetTransactionInclusionResponse create() =>
      SetTransactionInclusionResponse._();
  @$core.override
  SetTransactionInclusionResponse createEmptyInstance() => create();
  static $pb.PbList<SetTransactionInclusionResponse> createRepeated() =>
      $pb.PbList<SetTransactionInclusionResponse>();
  @$core.pragma('dart2js:noInline')
  static SetTransactionInclusionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetTransactionInclusionResponse>(
          create);
  static SetTransactionInclusionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class GetTransactionForAccountRequest extends $pb.GeneratedMessage {
  factory GetTransactionForAccountRequest({
    $core.String? accountNumber,
    $core.String? bankId,
    $core.String? oldestTransactionId,
    $fixnum.Int64? limit,
  }) {
    final result = create();
    if (accountNumber != null) result.accountNumber = accountNumber;
    if (bankId != null) result.bankId = bankId;
    if (oldestTransactionId != null)
      result.oldestTransactionId = oldestTransactionId;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetTransactionForAccountRequest._();

  factory GetTransactionForAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTransactionForAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTransactionForAccountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'sg.flow.transaction.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountNumber')
    ..aOS(2, _omitFieldNames ? '' : 'bankId')
    ..aOS(3, _omitFieldNames ? '' : 'oldestTransactionId')
    ..aInt64(4, _omitFieldNames ? '' : 'limit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionForAccountRequest clone() =>
      GetTransactionForAccountRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransactionForAccountRequest copyWith(
          void Function(GetTransactionForAccountRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetTransactionForAccountRequest))
          as GetTransactionForAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTransactionForAccountRequest create() =>
      GetTransactionForAccountRequest._();
  @$core.override
  GetTransactionForAccountRequest createEmptyInstance() => create();
  static $pb.PbList<GetTransactionForAccountRequest> createRepeated() =>
      $pb.PbList<GetTransactionForAccountRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTransactionForAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTransactionForAccountRequest>(
          create);
  static GetTransactionForAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bankId => $_getSZ(1);
  @$pb.TagNumber(2)
  set bankId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBankId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBankId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get oldestTransactionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set oldestTransactionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOldestTransactionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOldestTransactionId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get limit => $_getI64(3);
  @$pb.TagNumber(4)
  set limit($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearLimit() => $_clearField(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
