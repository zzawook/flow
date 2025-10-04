// This is a generated file - do not edit.
//
// Generated from common/v1/card.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use cardDescriptor instead')
const Card$json = {
  '1': 'Card',
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
    {'1': 'card_name', '3': 4, '4': 1, '5': 9, '10': 'cardName'},
    {
      '1': 'bank',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.sg.flow.common.v1.Bank',
      '10': 'bank'
    },
    {'1': 'balance', '3': 6, '4': 1, '5': 1, '10': 'balance'},
  ],
};

/// Descriptor for `Card`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardDescriptor = $convert.base64Decode(
    'CgRDYXJkEg4KAmlkGAEgASgDUgJpZBIfCgtjYXJkX251bWJlchgCIAEoCVIKY2FyZE51bWJlch'
    'I4CgljYXJkX3R5cGUYAyABKA4yGy5zZy5mbG93LmNvbW1vbi52MS5DYXJkVHlwZVIIY2FyZFR5'
    'cGUSGwoJY2FyZF9uYW1lGAQgASgJUghjYXJkTmFtZRIrCgRiYW5rGAUgASgLMhcuc2cuZmxvdy'
    '5jb21tb24udjEuQmFua1IEYmFuaxIYCgdiYWxhbmNlGAYgASgBUgdiYWxhbmNl');
