// This is a generated file - do not edit.
//
// Generated from common/v1/transaction.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $2;
import 'account.pb.dart' as $0;
import 'brief_card.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class TransactionHistoryDetail extends $pb.GeneratedMessage {
  factory TransactionHistoryDetail({
    $fixnum.Int64? id,
    $core.String? transactionReference,
    $0.Account? account,
    $1.BriefCard? card,
    $2.Timestamp? transactionTimestamp,
    $core.double? amount,
    $core.String? transactionType,
    $core.String? description,
    $core.String? transactionStatus,
    $core.String? friendlyDescription,
    $core.String? transactionCategory,
    $core.String? brandName,
    $core.bool? isIncludedInSpendingOrIncome,
    $2.Timestamp? revisedTransactionTimestamp,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (transactionReference != null)
      result.transactionReference = transactionReference;
    if (account != null) result.account = account;
    if (card != null) result.card = card;
    if (transactionTimestamp != null)
      result.transactionTimestamp = transactionTimestamp;
    if (amount != null) result.amount = amount;
    if (transactionType != null) result.transactionType = transactionType;
    if (description != null) result.description = description;
    if (transactionStatus != null) result.transactionStatus = transactionStatus;
    if (friendlyDescription != null)
      result.friendlyDescription = friendlyDescription;
    if (transactionCategory != null)
      result.transactionCategory = transactionCategory;
    if (brandName != null) result.brandName = brandName;
    if (isIncludedInSpendingOrIncome != null)
      result.isIncludedInSpendingOrIncome = isIncludedInSpendingOrIncome;
    if (revisedTransactionTimestamp != null)
      result.revisedTransactionTimestamp = revisedTransactionTimestamp;
    return result;
  }

  TransactionHistoryDetail._();

  factory TransactionHistoryDetail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransactionHistoryDetail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransactionHistoryDetail',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.common.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'transactionReference')
    ..aOM<$0.Account>(3, _omitFieldNames ? '' : 'account',
        subBuilder: $0.Account.create)
    ..aOM<$1.BriefCard>(4, _omitFieldNames ? '' : 'card',
        subBuilder: $1.BriefCard.create)
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'transactionTimestamp',
        subBuilder: $2.Timestamp.create)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..aOS(7, _omitFieldNames ? '' : 'transactionType')
    ..aOS(8, _omitFieldNames ? '' : 'description')
    ..aOS(9, _omitFieldNames ? '' : 'transactionStatus')
    ..aOS(10, _omitFieldNames ? '' : 'friendlyDescription')
    ..aOS(11, _omitFieldNames ? '' : 'transactionCategory')
    ..aOS(12, _omitFieldNames ? '' : 'brandName')
    ..aOB(13, _omitFieldNames ? '' : 'isIncludedInSpendingOrIncome')
    ..aOM<$2.Timestamp>(
        14, _omitFieldNames ? '' : 'revisedTransactionTimestamp',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransactionHistoryDetail clone() =>
      TransactionHistoryDetail()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransactionHistoryDetail copyWith(
          void Function(TransactionHistoryDetail) updates) =>
      super.copyWith((message) => updates(message as TransactionHistoryDetail))
          as TransactionHistoryDetail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransactionHistoryDetail create() => TransactionHistoryDetail._();
  @$core.override
  TransactionHistoryDetail createEmptyInstance() => create();
  static $pb.PbList<TransactionHistoryDetail> createRepeated() =>
      $pb.PbList<TransactionHistoryDetail>();
  @$core.pragma('dart2js:noInline')
  static TransactionHistoryDetail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransactionHistoryDetail>(create);
  static TransactionHistoryDetail? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get transactionReference => $_getSZ(1);
  @$pb.TagNumber(2)
  set transactionReference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTransactionReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransactionReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Account get account => $_getN(2);
  @$pb.TagNumber(3)
  set account($0.Account value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAccount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccount() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Account ensureAccount() => $_ensure(2);

  @$pb.TagNumber(4)
  $1.BriefCard get card => $_getN(3);
  @$pb.TagNumber(4)
  set card($1.BriefCard value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCard() => $_has(3);
  @$pb.TagNumber(4)
  void clearCard() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.BriefCard ensureCard() => $_ensure(3);

  @$pb.TagNumber(5)
  $2.Timestamp get transactionTimestamp => $_getN(4);
  @$pb.TagNumber(5)
  set transactionTimestamp($2.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTransactionTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTransactionTimestamp() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureTransactionTimestamp() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.double get amount => $_getN(5);
  @$pb.TagNumber(6)
  set amount($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get transactionType => $_getSZ(6);
  @$pb.TagNumber(7)
  set transactionType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTransactionType() => $_has(6);
  @$pb.TagNumber(7)
  void clearTransactionType() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get description => $_getSZ(7);
  @$pb.TagNumber(8)
  set description($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDescription() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescription() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get transactionStatus => $_getSZ(8);
  @$pb.TagNumber(9)
  set transactionStatus($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTransactionStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearTransactionStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get friendlyDescription => $_getSZ(9);
  @$pb.TagNumber(10)
  set friendlyDescription($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFriendlyDescription() => $_has(9);
  @$pb.TagNumber(10)
  void clearFriendlyDescription() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get transactionCategory => $_getSZ(10);
  @$pb.TagNumber(11)
  set transactionCategory($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTransactionCategory() => $_has(10);
  @$pb.TagNumber(11)
  void clearTransactionCategory() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get brandName => $_getSZ(11);
  @$pb.TagNumber(12)
  set brandName($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasBrandName() => $_has(11);
  @$pb.TagNumber(12)
  void clearBrandName() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get isIncludedInSpendingOrIncome => $_getBF(12);
  @$pb.TagNumber(13)
  set isIncludedInSpendingOrIncome($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIsIncludedInSpendingOrIncome() => $_has(12);
  @$pb.TagNumber(13)
  void clearIsIncludedInSpendingOrIncome() => $_clearField(13);

  @$pb.TagNumber(14)
  $2.Timestamp get revisedTransactionTimestamp => $_getN(13);
  @$pb.TagNumber(14)
  set revisedTransactionTimestamp($2.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasRevisedTransactionTimestamp() => $_has(13);
  @$pb.TagNumber(14)
  void clearRevisedTransactionTimestamp() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.Timestamp ensureRevisedTransactionTimestamp() => $_ensure(13);
}

class TransactionHistoryList extends $pb.GeneratedMessage {
  factory TransactionHistoryList({
    $2.Timestamp? startTimestamp,
    $2.Timestamp? endTimestamp,
    $core.Iterable<TransactionHistoryDetail>? transactions,
  }) {
    final result = create();
    if (startTimestamp != null) result.startTimestamp = startTimestamp;
    if (endTimestamp != null) result.endTimestamp = endTimestamp;
    if (transactions != null) result.transactions.addAll(transactions);
    return result;
  }

  TransactionHistoryList._();

  factory TransactionHistoryList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransactionHistoryList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransactionHistoryList',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.common.v1'),
      createEmptyInstance: create)
    ..aOM<$2.Timestamp>(1, _omitFieldNames ? '' : 'startTimestamp',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'endTimestamp',
        subBuilder: $2.Timestamp.create)
    ..pc<TransactionHistoryDetail>(
        3, _omitFieldNames ? '' : 'transactions', $pb.PbFieldType.PM,
        subBuilder: TransactionHistoryDetail.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransactionHistoryList clone() =>
      TransactionHistoryList()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransactionHistoryList copyWith(
          void Function(TransactionHistoryList) updates) =>
      super.copyWith((message) => updates(message as TransactionHistoryList))
          as TransactionHistoryList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransactionHistoryList create() => TransactionHistoryList._();
  @$core.override
  TransactionHistoryList createEmptyInstance() => create();
  static $pb.PbList<TransactionHistoryList> createRepeated() =>
      $pb.PbList<TransactionHistoryList>();
  @$core.pragma('dart2js:noInline')
  static TransactionHistoryList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransactionHistoryList>(create);
  static TransactionHistoryList? _defaultInstance;

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

  @$pb.TagNumber(3)
  $pb.PbList<TransactionHistoryDetail> get transactions => $_getList(2);
}

class RecurringTransactionDetail extends $pb.GeneratedMessage {
  factory RecurringTransactionDetail({
    $fixnum.Int64? id,
    $core.String? displayName,
    $core.String? category,
    $core.double? expectedAmount,
    $2.Timestamp? nextTransactionDate,
    $2.Timestamp? lastTransactionDate,
    $fixnum.Int64? intervalDays,
    $fixnum.Int64? occurrenceCount,
    $core.Iterable<$fixnum.Int64>? transactionIds,
    $fixnum.Int64? year,
    $fixnum.Int64? month,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (displayName != null) result.displayName = displayName;
    if (category != null) result.category = category;
    if (expectedAmount != null) result.expectedAmount = expectedAmount;
    if (nextTransactionDate != null)
      result.nextTransactionDate = nextTransactionDate;
    if (lastTransactionDate != null)
      result.lastTransactionDate = lastTransactionDate;
    if (intervalDays != null) result.intervalDays = intervalDays;
    if (occurrenceCount != null) result.occurrenceCount = occurrenceCount;
    if (transactionIds != null) result.transactionIds.addAll(transactionIds);
    if (year != null) result.year = year;
    if (month != null) result.month = month;
    return result;
  }

  RecurringTransactionDetail._();

  factory RecurringTransactionDetail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecurringTransactionDetail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecurringTransactionDetail',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.common.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOS(3, _omitFieldNames ? '' : 'category')
    ..a<$core.double>(
        4, _omitFieldNames ? '' : 'expectedAmount', $pb.PbFieldType.OD)
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'nextTransactionDate',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'lastTransactionDate',
        subBuilder: $2.Timestamp.create)
    ..aInt64(7, _omitFieldNames ? '' : 'intervalDays')
    ..aInt64(8, _omitFieldNames ? '' : 'occurrenceCount')
    ..p<$fixnum.Int64>(
        9, _omitFieldNames ? '' : 'transactionIds', $pb.PbFieldType.K6)
    ..aInt64(10, _omitFieldNames ? '' : 'year')
    ..aInt64(11, _omitFieldNames ? '' : 'month')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecurringTransactionDetail clone() =>
      RecurringTransactionDetail()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecurringTransactionDetail copyWith(
          void Function(RecurringTransactionDetail) updates) =>
      super.copyWith(
              (message) => updates(message as RecurringTransactionDetail))
          as RecurringTransactionDetail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecurringTransactionDetail create() => RecurringTransactionDetail._();
  @$core.override
  RecurringTransactionDetail createEmptyInstance() => create();
  static $pb.PbList<RecurringTransactionDetail> createRepeated() =>
      $pb.PbList<RecurringTransactionDetail>();
  @$core.pragma('dart2js:noInline')
  static RecurringTransactionDetail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecurringTransactionDetail>(create);
  static RecurringTransactionDetail? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get category => $_getSZ(2);
  @$pb.TagNumber(3)
  set category($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get expectedAmount => $_getN(3);
  @$pb.TagNumber(4)
  set expectedAmount($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedAmount() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedAmount() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Timestamp get nextTransactionDate => $_getN(4);
  @$pb.TagNumber(5)
  set nextTransactionDate($2.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNextTransactionDate() => $_has(4);
  @$pb.TagNumber(5)
  void clearNextTransactionDate() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureNextTransactionDate() => $_ensure(4);

  @$pb.TagNumber(6)
  $2.Timestamp get lastTransactionDate => $_getN(5);
  @$pb.TagNumber(6)
  set lastTransactionDate($2.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLastTransactionDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastTransactionDate() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureLastTransactionDate() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get intervalDays => $_getI64(6);
  @$pb.TagNumber(7)
  set intervalDays($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIntervalDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearIntervalDays() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get occurrenceCount => $_getI64(7);
  @$pb.TagNumber(8)
  set occurrenceCount($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOccurrenceCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearOccurrenceCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$fixnum.Int64> get transactionIds => $_getList(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get year => $_getI64(9);
  @$pb.TagNumber(10)
  set year($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasYear() => $_has(9);
  @$pb.TagNumber(10)
  void clearYear() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get month => $_getI64(10);
  @$pb.TagNumber(11)
  set month($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMonth() => $_has(10);
  @$pb.TagNumber(11)
  void clearMonth() => $_clearField(11);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
