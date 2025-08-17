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

import 'package:protobuf/protobuf.dart' as $pb;

class CardType extends $pb.ProtobufEnum {
  static const CardType CARD_TYPE_UNSPECIFIED =
      CardType._(0, _omitEnumNames ? '' : 'CARD_TYPE_UNSPECIFIED');
  static const CardType CREDIT = CardType._(1, _omitEnumNames ? '' : 'CREDIT');
  static const CardType DEBIT = CardType._(2, _omitEnumNames ? '' : 'DEBIT');
  static const CardType PREPAID =
      CardType._(3, _omitEnumNames ? '' : 'PREPAID');
  static const CardType CORPORATE =
      CardType._(4, _omitEnumNames ? '' : 'CORPORATE');
  static const CardType ATM = CardType._(5, _omitEnumNames ? '' : 'ATM');
  static const CardType OTHERS = CardType._(6, _omitEnumNames ? '' : 'OTHERS');

  static const $core.List<CardType> values = <CardType>[
    CARD_TYPE_UNSPECIFIED,
    CREDIT,
    DEBIT,
    PREPAID,
    CORPORATE,
    ATM,
    OTHERS,
  ];

  static final $core.List<CardType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static CardType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CardType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
