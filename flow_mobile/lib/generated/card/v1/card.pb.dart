// This is a generated file - do not edit.
//
// Generated from card/v1/card.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/card.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// ── Requests ──
class GetCardsRequest extends $pb.GeneratedMessage {
  factory GetCardsRequest() => create();

  GetCardsRequest._();

  factory GetCardsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCardsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCardsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.card.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCardsRequest clone() => GetCardsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCardsRequest copyWith(void Function(GetCardsRequest) updates) =>
      super.copyWith((message) => updates(message as GetCardsRequest))
          as GetCardsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCardsRequest create() => GetCardsRequest._();
  @$core.override
  GetCardsRequest createEmptyInstance() => create();
  static $pb.PbList<GetCardsRequest> createRepeated() =>
      $pb.PbList<GetCardsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCardsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCardsRequest>(create);
  static GetCardsRequest? _defaultInstance;
}

class GetCardsResponse extends $pb.GeneratedMessage {
  factory GetCardsResponse({
    $core.Iterable<$2.Card>? cards,
  }) {
    final result = create();
    if (cards != null) result.cards.addAll(cards);
    return result;
  }

  GetCardsResponse._();

  factory GetCardsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCardsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCardsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.card.v1'),
      createEmptyInstance: create)
    ..pc<$2.Card>(1, _omitFieldNames ? '' : 'cards', $pb.PbFieldType.PM,
        subBuilder: $2.Card.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCardsResponse clone() => GetCardsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCardsResponse copyWith(void Function(GetCardsResponse) updates) =>
      super.copyWith((message) => updates(message as GetCardsResponse))
          as GetCardsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCardsResponse create() => GetCardsResponse._();
  @$core.override
  GetCardsResponse createEmptyInstance() => create();
  static $pb.PbList<GetCardsResponse> createRepeated() =>
      $pb.PbList<GetCardsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCardsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCardsResponse>(create);
  static GetCardsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$2.Card> get cards => $_getList(0);
}

class GetCardTransactionsRequest extends $pb.GeneratedMessage {
  factory GetCardTransactionsRequest({
    $core.String? cardNumber,
    $core.String? oldestTransactionId,
    $core.int? limit,
  }) {
    final result = create();
    if (cardNumber != null) result.cardNumber = cardNumber;
    if (oldestTransactionId != null)
      result.oldestTransactionId = oldestTransactionId;
    if (limit != null) result.limit = limit;
    return result;
  }

  GetCardTransactionsRequest._();

  factory GetCardTransactionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCardTransactionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCardTransactionsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.card.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cardNumber')
    ..aOS(2, _omitFieldNames ? '' : 'oldestTransactionId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCardTransactionsRequest clone() =>
      GetCardTransactionsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCardTransactionsRequest copyWith(
          void Function(GetCardTransactionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetCardTransactionsRequest))
          as GetCardTransactionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCardTransactionsRequest create() => GetCardTransactionsRequest._();
  @$core.override
  GetCardTransactionsRequest createEmptyInstance() => create();
  static $pb.PbList<GetCardTransactionsRequest> createRepeated() =>
      $pb.PbList<GetCardTransactionsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCardTransactionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCardTransactionsRequest>(create);
  static GetCardTransactionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cardNumber => $_getSZ(0);
  @$pb.TagNumber(1)
  set cardNumber($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCardNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearCardNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get oldestTransactionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set oldestTransactionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOldestTransactionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOldestTransactionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
