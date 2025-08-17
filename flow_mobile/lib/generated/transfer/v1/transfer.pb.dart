// This is a generated file - do not edit.
//
// Generated from transfer/v1/transfer.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/bank.pb.dart' as $2;
import '../../google/protobuf/timestamp.pb.dart' as $3;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetRelevantRecepientByAccountNumberRequest extends $pb.GeneratedMessage {
  factory GetRelevantRecepientByAccountNumberRequest({
    $core.String? keyword,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  GetRelevantRecepientByAccountNumberRequest._();

  factory GetRelevantRecepientByAccountNumberRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRelevantRecepientByAccountNumberRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRelevantRecepientByAccountNumberRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.transfer.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelevantRecepientByAccountNumberRequest clone() =>
      GetRelevantRecepientByAccountNumberRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelevantRecepientByAccountNumberRequest copyWith(
          void Function(GetRelevantRecepientByAccountNumberRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetRelevantRecepientByAccountNumberRequest))
          as GetRelevantRecepientByAccountNumberRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRelevantRecepientByAccountNumberRequest create() =>
      GetRelevantRecepientByAccountNumberRequest._();
  @$core.override
  GetRelevantRecepientByAccountNumberRequest createEmptyInstance() => create();
  static $pb.PbList<GetRelevantRecepientByAccountNumberRequest>
      createRepeated() =>
          $pb.PbList<GetRelevantRecepientByAccountNumberRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRelevantRecepientByAccountNumberRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetRelevantRecepientByAccountNumberRequest>(create);
  static GetRelevantRecepientByAccountNumberRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);
}

class GetRelevantRecepientByAccountNumberResponse extends $pb.GeneratedMessage {
  factory GetRelevantRecepientByAccountNumberResponse({
    $core.Iterable<$2.Bank>? banks,
  }) {
    final result = create();
    if (banks != null) result.banks.addAll(banks);
    return result;
  }

  GetRelevantRecepientByAccountNumberResponse._();

  factory GetRelevantRecepientByAccountNumberResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRelevantRecepientByAccountNumberResponse.fromJson(
          $core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRelevantRecepientByAccountNumberResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.transfer.v1'),
      createEmptyInstance: create)
    ..pc<$2.Bank>(1, _omitFieldNames ? '' : 'banks', $pb.PbFieldType.PM,
        subBuilder: $2.Bank.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelevantRecepientByAccountNumberResponse clone() =>
      GetRelevantRecepientByAccountNumberResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelevantRecepientByAccountNumberResponse copyWith(
          void Function(GetRelevantRecepientByAccountNumberResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GetRelevantRecepientByAccountNumberResponse))
          as GetRelevantRecepientByAccountNumberResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRelevantRecepientByAccountNumberResponse create() =>
      GetRelevantRecepientByAccountNumberResponse._();
  @$core.override
  GetRelevantRecepientByAccountNumberResponse createEmptyInstance() => create();
  static $pb.PbList<GetRelevantRecepientByAccountNumberResponse>
      createRepeated() =>
          $pb.PbList<GetRelevantRecepientByAccountNumberResponse>();
  @$core.pragma('dart2js:noInline')
  static GetRelevantRecepientByAccountNumberResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetRelevantRecepientByAccountNumberResponse>(create);
  static GetRelevantRecepientByAccountNumberResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$2.Bank> get banks => $_getList(0);
}

class GetRelevantRecepientByContactRequest extends $pb.GeneratedMessage {
  factory GetRelevantRecepientByContactRequest({
    $core.String? keyword,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  GetRelevantRecepientByContactRequest._();

  factory GetRelevantRecepientByContactRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRelevantRecepientByContactRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRelevantRecepientByContactRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.transfer.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelevantRecepientByContactRequest clone() =>
      GetRelevantRecepientByContactRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelevantRecepientByContactRequest copyWith(
          void Function(GetRelevantRecepientByContactRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetRelevantRecepientByContactRequest))
          as GetRelevantRecepientByContactRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRelevantRecepientByContactRequest create() =>
      GetRelevantRecepientByContactRequest._();
  @$core.override
  GetRelevantRecepientByContactRequest createEmptyInstance() => create();
  static $pb.PbList<GetRelevantRecepientByContactRequest> createRepeated() =>
      $pb.PbList<GetRelevantRecepientByContactRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRelevantRecepientByContactRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetRelevantRecepientByContactRequest>(create);
  static GetRelevantRecepientByContactRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);
}

class GetRelevantRecepientResponse extends $pb.GeneratedMessage {
  factory GetRelevantRecepientResponse({
    $core.Iterable<TransferRecepient>? recipients,
  }) {
    final result = create();
    if (recipients != null) result.recipients.addAll(recipients);
    return result;
  }

  GetRelevantRecepientResponse._();

  factory GetRelevantRecepientResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRelevantRecepientResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRelevantRecepientResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.transfer.v1'),
      createEmptyInstance: create)
    ..pc<TransferRecepient>(
        1, _omitFieldNames ? '' : 'recipients', $pb.PbFieldType.PM,
        subBuilder: TransferRecepient.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelevantRecepientResponse clone() =>
      GetRelevantRecepientResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelevantRecepientResponse copyWith(
          void Function(GetRelevantRecepientResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetRelevantRecepientResponse))
          as GetRelevantRecepientResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRelevantRecepientResponse create() =>
      GetRelevantRecepientResponse._();
  @$core.override
  GetRelevantRecepientResponse createEmptyInstance() => create();
  static $pb.PbList<GetRelevantRecepientResponse> createRepeated() =>
      $pb.PbList<GetRelevantRecepientResponse>();
  @$core.pragma('dart2js:noInline')
  static GetRelevantRecepientResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRelevantRecepientResponse>(create);
  static GetRelevantRecepientResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TransferRecepient> get recipients => $_getList(0);
}

class TransferRecepient extends $pb.GeneratedMessage {
  factory TransferRecepient({
    $core.String? name,
    $core.String? accountNumber,
    $core.String? bankCode,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (accountNumber != null) result.accountNumber = accountNumber;
    if (bankCode != null) result.bankCode = bankCode;
    return result;
  }

  TransferRecepient._();

  factory TransferRecepient.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferRecepient.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferRecepient',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.transfer.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'accountNumber')
    ..aOS(3, _omitFieldNames ? '' : 'bankCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferRecepient clone() => TransferRecepient()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferRecepient copyWith(void Function(TransferRecepient) updates) =>
      super.copyWith((message) => updates(message as TransferRecepient))
          as TransferRecepient;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferRecepient create() => TransferRecepient._();
  @$core.override
  TransferRecepient createEmptyInstance() => create();
  static $pb.PbList<TransferRecepient> createRepeated() =>
      $pb.PbList<TransferRecepient>();
  @$core.pragma('dart2js:noInline')
  static TransferRecepient getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferRecepient>(create);
  static TransferRecepient? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bankCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set bankCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBankCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearBankCode() => $_clearField(3);
}

class TransferRequest extends $pb.GeneratedMessage {
  factory TransferRequest({
    $core.String? senderAccountNumber,
    TransferRecepient? recepient,
    $core.double? amount,
    $core.String? note,
    $3.Timestamp? scheduledAt,
  }) {
    final result = create();
    if (senderAccountNumber != null)
      result.senderAccountNumber = senderAccountNumber;
    if (recepient != null) result.recepient = recepient;
    if (amount != null) result.amount = amount;
    if (note != null) result.note = note;
    if (scheduledAt != null) result.scheduledAt = scheduledAt;
    return result;
  }

  TransferRequest._();

  factory TransferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.transfer.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'senderAccountNumber')
    ..aOM<TransferRecepient>(2, _omitFieldNames ? '' : 'recepient',
        subBuilder: TransferRecepient.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..aOM<$3.Timestamp>(5, _omitFieldNames ? '' : 'scheduledAt',
        subBuilder: $3.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferRequest clone() => TransferRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferRequest copyWith(void Function(TransferRequest) updates) =>
      super.copyWith((message) => updates(message as TransferRequest))
          as TransferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferRequest create() => TransferRequest._();
  @$core.override
  TransferRequest createEmptyInstance() => create();
  static $pb.PbList<TransferRequest> createRepeated() =>
      $pb.PbList<TransferRequest>();
  @$core.pragma('dart2js:noInline')
  static TransferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferRequest>(create);
  static TransferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get senderAccountNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set senderAccountNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSenderAccountNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearSenderAccountNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  TransferRecepient get recepient => $_getN(1);
  @$pb.TagNumber(2)
  set recepient(TransferRecepient value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRecepient() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecepient() => $_clearField(2);
  @$pb.TagNumber(2)
  TransferRecepient ensureRecepient() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);

  @$pb.TagNumber(5)
  $3.Timestamp get scheduledAt => $_getN(4);
  @$pb.TagNumber(5)
  set scheduledAt($3.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasScheduledAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearScheduledAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $3.Timestamp ensureScheduledAt() => $_ensure(4);
}

class TransferResult extends $pb.GeneratedMessage {
  factory TransferResult({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  TransferResult._();

  factory TransferResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferResult',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.transfer.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferResult clone() => TransferResult()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferResult copyWith(void Function(TransferResult) updates) =>
      super.copyWith((message) => updates(message as TransferResult))
          as TransferResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferResult create() => TransferResult._();
  @$core.override
  TransferResult createEmptyInstance() => create();
  static $pb.PbList<TransferResult> createRepeated() =>
      $pb.PbList<TransferResult>();
  @$core.pragma('dart2js:noInline')
  static TransferResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferResult>(create);
  static TransferResult? _defaultInstance;

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

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
