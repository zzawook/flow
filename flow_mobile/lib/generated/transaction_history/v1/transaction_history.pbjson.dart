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

@$core.Deprecated('Use getProcessedTransactionRequestDescriptor instead')
const GetProcessedTransactionRequest$json = {
  '1': 'GetProcessedTransactionRequest',
  '2': [
    {'1': 'transaction_ids', '3': 1, '4': 3, '5': 9, '10': 'transactionIds'},
  ],
};

/// Descriptor for `GetProcessedTransactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProcessedTransactionRequestDescriptor =
    $convert.base64Decode(
        'Ch5HZXRQcm9jZXNzZWRUcmFuc2FjdGlvblJlcXVlc3QSJwoPdHJhbnNhY3Rpb25faWRzGAEgAy'
        'gJUg50cmFuc2FjdGlvbklkcw==');

@$core.Deprecated('Use getRecurringTransactionRequestDescriptor instead')
const GetRecurringTransactionRequest$json = {
  '1': 'GetRecurringTransactionRequest',
};

/// Descriptor for `GetRecurringTransactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecurringTransactionRequestDescriptor =
    $convert.base64Decode('Ch5HZXRSZWN1cnJpbmdUcmFuc2FjdGlvblJlcXVlc3Q=');

@$core.Deprecated('Use getRecurringTransactionResponseDescriptor instead')
const GetRecurringTransactionResponse$json = {
  '1': 'GetRecurringTransactionResponse',
  '2': [
    {
      '1': 'recurring_transactions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.common.v1.RecurringTransactionDetail',
      '10': 'recurringTransactions'
    },
    {
      '1': 'last_updated',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastUpdated'
    },
  ],
};

/// Descriptor for `GetRecurringTransactionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecurringTransactionResponseDescriptor =
    $convert.base64Decode(
        'Ch9HZXRSZWN1cnJpbmdUcmFuc2FjdGlvblJlc3BvbnNlEmQKFnJlY3VycmluZ190cmFuc2FjdG'
        'lvbnMYASADKAsyLS5zZy5mbG93LmNvbW1vbi52MS5SZWN1cnJpbmdUcmFuc2FjdGlvbkRldGFp'
        'bFIVcmVjdXJyaW5nVHJhbnNhY3Rpb25zEj0KDGxhc3RfdXBkYXRlZBgCIAEoCzIaLmdvb2dsZS'
        '5wcm90b2J1Zi5UaW1lc3RhbXBSC2xhc3RVcGRhdGVk');

@$core.Deprecated('Use setTransactionCategoryRequestDescriptor instead')
const SetTransactionCategoryRequest$json = {
  '1': 'SetTransactionCategoryRequest',
  '2': [
    {'1': 'transaction_id', '3': 1, '4': 1, '5': 9, '10': 'transactionId'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
  ],
};

/// Descriptor for `SetTransactionCategoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTransactionCategoryRequestDescriptor =
    $convert.base64Decode(
        'Ch1TZXRUcmFuc2FjdGlvbkNhdGVnb3J5UmVxdWVzdBIlCg50cmFuc2FjdGlvbl9pZBgBIAEoCV'
        'INdHJhbnNhY3Rpb25JZBIaCghjYXRlZ29yeRgCIAEoCVIIY2F0ZWdvcnk=');

@$core.Deprecated('Use setTransactionCategoryResponseDescriptor instead')
const SetTransactionCategoryResponse$json = {
  '1': 'SetTransactionCategoryResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SetTransactionCategoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTransactionCategoryResponseDescriptor =
    $convert.base64Decode(
        'Ch5TZXRUcmFuc2FjdGlvbkNhdGVnb3J5UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2'
        'VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');
