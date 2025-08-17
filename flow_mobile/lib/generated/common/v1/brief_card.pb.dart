// This is a generated file - do not edit.
//
// Generated from common/v1/brief_card.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'brief_card.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'brief_card.pbenum.dart';

class BriefCard extends $pb.GeneratedMessage {
  factory BriefCard({
    $fixnum.Int64? id,
    $core.String? cardNumber,
    CardType? cardType,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (cardNumber != null) result.cardNumber = cardNumber;
    if (cardType != null) result.cardType = cardType;
    return result;
  }

  BriefCard._();

  factory BriefCard.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BriefCard.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BriefCard',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.common.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'cardNumber')
    ..e<CardType>(3, _omitFieldNames ? '' : 'cardType', $pb.PbFieldType.OE,
        defaultOrMaker: CardType.CARD_TYPE_UNSPECIFIED,
        valueOf: CardType.valueOf,
        enumValues: CardType.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BriefCard clone() => BriefCard()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BriefCard copyWith(void Function(BriefCard) updates) =>
      super.copyWith((message) => updates(message as BriefCard)) as BriefCard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BriefCard create() => BriefCard._();
  @$core.override
  BriefCard createEmptyInstance() => create();
  static $pb.PbList<BriefCard> createRepeated() => $pb.PbList<BriefCard>();
  @$core.pragma('dart2js:noInline')
  static BriefCard getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BriefCard>(create);
  static BriefCard? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get cardNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set cardNumber($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCardNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  CardType get cardType => $_getN(2);
  @$pb.TagNumber(3)
  set cardType(CardType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCardType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardType() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
