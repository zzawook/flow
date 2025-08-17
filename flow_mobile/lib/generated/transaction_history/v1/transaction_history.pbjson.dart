// This is a generated file - do not edit.
//
// Generated from transaction_history/v1/transaction_history.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getLast30DaysHistoryListRequestDescriptor instead')
const GetLast30DaysHistoryListRequest$json = {
  '1': 'GetLast30DaysHistoryListRequest',
};

/// Descriptor for `GetLast30DaysHistoryListRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLast30DaysHistoryListRequestDescriptor =
    $convert.base64Decode('Ch9HZXRMYXN0MzBEYXlzSGlzdG9yeUxpc3RSZXF1ZXN0');

@$core.Deprecated('Use getMonthlyTransactionRequestDescriptor instead')
const GetMonthlyTransactionRequest$json = {
  '1': 'GetMonthlyTransactionRequest',
  '2': [
    {'1': 'year', '3': 1, '4': 1, '5': 5, '10': 'year'},
    {'1': 'month', '3': 2, '4': 1, '5': 5, '10': 'month'},
  ],
};

/// Descriptor for `GetMonthlyTransactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMonthlyTransactionRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRNb250aGx5VHJhbnNhY3Rpb25SZXF1ZXN0EhIKBHllYXIYASABKAVSBHllYXISFAoFbW'
        '9udGgYAiABKAVSBW1vbnRo');

@$core.Deprecated('Use getDailyTransactionRequestDescriptor instead')
const GetDailyTransactionRequest$json = {
  '1': 'GetDailyTransactionRequest',
  '2': [
    {'1': 'year', '3': 1, '4': 1, '5': 5, '10': 'year'},
    {'1': 'month', '3': 2, '4': 1, '5': 5, '10': 'month'},
    {'1': 'day', '3': 3, '4': 1, '5': 5, '10': 'day'},
  ],
};

/// Descriptor for `GetDailyTransactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDailyTransactionRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXREYWlseVRyYW5zYWN0aW9uUmVxdWVzdBISCgR5ZWFyGAEgASgFUgR5ZWFyEhQKBW1vbn'
        'RoGAIgASgFUgVtb250aBIQCgNkYXkYAyABKAVSA2RheQ==');

@$core.Deprecated('Use getTransactionDetailsRequestDescriptor instead')
const GetTransactionDetailsRequest$json = {
  '1': 'GetTransactionDetailsRequest',
  '2': [
    {'1': 'transaction_id', '3': 1, '4': 1, '5': 9, '10': 'transactionId'},
  ],
};

/// Descriptor for `GetTransactionDetailsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTransactionDetailsRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRUcmFuc2FjdGlvbkRldGFpbHNSZXF1ZXN0EiUKDnRyYW5zYWN0aW9uX2lkGAEgASgJUg'
        '10cmFuc2FjdGlvbklk');

@$core.Deprecated('Use getTransactionWithinRangeRequestDescriptor instead')
const GetTransactionWithinRangeRequest$json = {
  '1': 'GetTransactionWithinRangeRequest',
  '2': [
    {
      '1': 'start_timestamp',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startTimestamp'
    },
    {
      '1': 'end_timestamp',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endTimestamp'
    },
  ],
};

/// Descriptor for `GetTransactionWithinRangeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTransactionWithinRangeRequestDescriptor =
    $convert.base64Decode(
        'CiBHZXRUcmFuc2FjdGlvbldpdGhpblJhbmdlUmVxdWVzdBJDCg9zdGFydF90aW1lc3RhbXAYAS'
        'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg5zdGFydFRpbWVzdGFtcBI/Cg1lbmRf'
        'dGltZXN0YW1wGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMZW5kVGltZXN0YW'
        '1w');
