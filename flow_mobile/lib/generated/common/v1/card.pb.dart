// This is a generated file - do not edit.
//
// Generated from common/v1/card.proto.

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
import 'brief_card.pbenum.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Card extends $pb.GeneratedMessage {
  factory Card({
    $fixnum.Int64? id,
    $core.String? cardNumber,
    $1.CardType? cardType,
    $core.String? cardName,
    $0.Bank? bank,
    $core.double? balance,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (cardNumber != null) result.cardNumber = cardNumber;
    if (cardType != null) result.cardType = cardType;
    if (cardName != null) result.cardName = cardName;
    if (bank != null) result.bank = bank;
    if (balance != null) result.balance = balance;
    return result;
  }

  Card._();

  factory Card.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Card.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Card',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.common.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'cardNumber')
    ..e<$1.CardType>(3, _omitFieldNames ? '' : 'cardType', $pb.PbFieldType.OE,
        defaultOrMaker: $1.CardType.CARD_TYPE_UNSPECIFIED,
        valueOf: $1.CardType.valueOf,
        enumValues: $1.CardType.values)
    ..aOS(4, _omitFieldNames ? '' : 'cardName')
    ..aOM<$0.Bank>(5, _omitFieldNames ? '' : 'bank', subBuilder: $0.Bank.create)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'balance', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Card clone() => Card()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Card copyWith(void Function(Card) updates) =>
      super.copyWith((message) => updates(message as Card)) as Card;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Card create() => Card._();
  @$core.override
  Card createEmptyInstance() => create();
  static $pb.PbList<Card> createRepeated() => $pb.PbList<Card>();
  @$core.pragma('dart2js:noInline')
  static Card getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Card>(create);
  static Card? _defaultInstance;

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
  $1.CardType get cardType => $_getN(2);
  @$pb.TagNumber(3)
  set cardType($1.CardType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCardType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCardType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cardName => $_getSZ(3);
  @$pb.TagNumber(4)
  set cardName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCardName() => $_has(3);
  @$pb.TagNumber(4)
  void clearCardName() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Bank get bank => $_getN(4);
  @$pb.TagNumber(5)
  set bank($0.Bank value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBank() => $_has(4);
  @$pb.TagNumber(5)
  void clearBank() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Bank ensureBank() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.double get balance => $_getN(5);
  @$pb.TagNumber(6)
  set balance($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBalance() => $_has(5);
  @$pb.TagNumber(6)
  void clearBalance() => $_clearField(6);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
