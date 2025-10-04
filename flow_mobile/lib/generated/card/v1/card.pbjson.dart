// This is a generated file - do not edit.
//
// Generated from card/v1/card.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getCardsRequestDescriptor instead')
const GetCardsRequest$json = {
  '1': 'GetCardsRequest',
};

/// Descriptor for `GetCardsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCardsRequestDescriptor =
    $convert.base64Decode('Cg9HZXRDYXJkc1JlcXVlc3Q=');

@$core.Deprecated('Use getCardsResponseDescriptor instead')
const GetCardsResponse$json = {
  '1': 'GetCardsResponse',
  '2': [
    {
      '1': 'cards',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.common.v1.Card',
      '10': 'cards'
    },
  ],
};

/// Descriptor for `GetCardsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCardsResponseDescriptor = $convert.base64Decode(
    'ChBHZXRDYXJkc1Jlc3BvbnNlEi0KBWNhcmRzGAEgAygLMhcuc2cuZmxvdy5jb21tb24udjEuQ2'
    'FyZFIFY2FyZHM=');

@$core.Deprecated('Use getCardTransactionsRequestDescriptor instead')
const GetCardTransactionsRequest$json = {
  '1': 'GetCardTransactionsRequest',
  '2': [
    {'1': 'card_number', '3': 1, '4': 1, '5': 9, '10': 'cardNumber'},
    {
      '1': 'oldest_transaction_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'oldestTransactionId'
    },
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `GetCardTransactionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCardTransactionsRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRDYXJkVHJhbnNhY3Rpb25zUmVxdWVzdBIfCgtjYXJkX251bWJlchgBIAEoCVIKY2FyZE'
        '51bWJlchIyChVvbGRlc3RfdHJhbnNhY3Rpb25faWQYAiABKAlSE29sZGVzdFRyYW5zYWN0aW9u'
        'SWQSFAoFbGltaXQYAyABKAVSBWxpbWl0');
