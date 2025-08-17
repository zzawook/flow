// This is a generated file - do not edit.
//
// Generated from common/v1/brief_card.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use cardTypeDescriptor instead')
const CardType$json = {
  '1': 'CardType',
  '2': [
    {'1': 'CARD_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'CREDIT', '2': 1},
    {'1': 'DEBIT', '2': 2},
    {'1': 'PREPAID', '2': 3},
    {'1': 'CORPORATE', '2': 4},
    {'1': 'ATM', '2': 5},
    {'1': 'OTHERS', '2': 6},
  ],
};

/// Descriptor for `CardType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cardTypeDescriptor = $convert.base64Decode(
    'CghDYXJkVHlwZRIZChVDQVJEX1RZUEVfVU5TUEVDSUZJRUQQABIKCgZDUkVESVQQARIJCgVERU'
    'JJVBACEgsKB1BSRVBBSUQQAxINCglDT1JQT1JBVEUQBBIHCgNBVE0QBRIKCgZPVEhFUlMQBg==');

@$core.Deprecated('Use briefCardDescriptor instead')
const BriefCard$json = {
  '1': 'BriefCard',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'card_number', '3': 2, '4': 1, '5': 9, '10': 'cardNumber'},
    {
      '1': 'card_type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.sg.flow.common.v1.CardType',
      '10': 'cardType'
    },
  ],
};

/// Descriptor for `BriefCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List briefCardDescriptor = $convert.base64Decode(
    'CglCcmllZkNhcmQSDgoCaWQYASABKANSAmlkEh8KC2NhcmRfbnVtYmVyGAIgASgJUgpjYXJkTn'
    'VtYmVyEjgKCWNhcmRfdHlwZRgDIAEoDjIbLnNnLmZsb3cuY29tbW9uLnYxLkNhcmRUeXBlUghj'
    'YXJkVHlwZQ==');
