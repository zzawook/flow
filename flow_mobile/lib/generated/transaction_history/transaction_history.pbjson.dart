// This is a generated file - do not edit.
//
// Generated from transaction_history/transaction_history.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../common/v1/bank.pbjson.dart' as $3;
import '../common/v1/brief_account.pbjson.dart' as $2;
import '../common/v1/brief_card.pbjson.dart' as $4;
import '../common/v1/transaction.pbjson.dart' as $1;
import '../google/protobuf/timestamp.pbjson.dart' as $0;

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

const $core.Map<$core.String, $core.dynamic>
    TransactionHistoryServiceBase$json = {
  '1': 'TransactionHistoryService',
  '2': [
    {
      '1': 'GetLast30DaysHistoryList',
      '2': '.sg.flow.transaction.v1.GetLast30DaysHistoryListRequest',
      '3': '.sg.flow.common.v1.TransactionHistoryList'
    },
    {
      '1': 'GetMonthlyTransaction',
      '2': '.sg.flow.transaction.v1.GetMonthlyTransactionRequest',
      '3': '.sg.flow.common.v1.TransactionHistoryList'
    },
    {
      '1': 'GetDailyTransaction',
      '2': '.sg.flow.transaction.v1.GetDailyTransactionRequest',
      '3': '.sg.flow.common.v1.TransactionHistoryList'
    },
    {
      '1': 'GetTransactionDetails',
      '2': '.sg.flow.transaction.v1.GetTransactionDetailsRequest',
      '3': '.sg.flow.common.v1.TransactionHistoryDetail'
    },
    {
      '1': 'GetTransactionWithinRange',
      '2': '.sg.flow.transaction.v1.GetTransactionWithinRangeRequest',
      '3': '.sg.flow.common.v1.TransactionHistoryList'
    },
  ],
};

@$core.Deprecated('Use transactionHistoryServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TransactionHistoryServiceBase$messageJson = {
  '.sg.flow.transaction.v1.GetLast30DaysHistoryListRequest':
      GetLast30DaysHistoryListRequest$json,
  '.sg.flow.common.v1.TransactionHistoryList': $1.TransactionHistoryList$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.sg.flow.common.v1.TransactionHistoryDetail':
      $1.TransactionHistoryDetail$json,
  '.sg.flow.common.v1.Account': $2.Account$json,
  '.sg.flow.common.v1.Bank': $3.Bank$json,
  '.sg.flow.common.v1.BriefCard': $4.BriefCard$json,
  '.sg.flow.transaction.v1.GetMonthlyTransactionRequest':
      GetMonthlyTransactionRequest$json,
  '.sg.flow.transaction.v1.GetDailyTransactionRequest':
      GetDailyTransactionRequest$json,
  '.sg.flow.transaction.v1.GetTransactionDetailsRequest':
      GetTransactionDetailsRequest$json,
  '.sg.flow.transaction.v1.GetTransactionWithinRangeRequest':
      GetTransactionWithinRangeRequest$json,
};

/// Descriptor for `TransactionHistoryService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List transactionHistoryServiceDescriptor = $convert.base64Decode(
    'ChlUcmFuc2FjdGlvbkhpc3RvcnlTZXJ2aWNlEn4KGEdldExhc3QzMERheXNIaXN0b3J5TGlzdB'
    'I3LnNnLmZsb3cudHJhbnNhY3Rpb24udjEuR2V0TGFzdDMwRGF5c0hpc3RvcnlMaXN0UmVxdWVz'
    'dBopLnNnLmZsb3cuY29tbW9uLnYxLlRyYW5zYWN0aW9uSGlzdG9yeUxpc3QSeAoVR2V0TW9udG'
    'hseVRyYW5zYWN0aW9uEjQuc2cuZmxvdy50cmFuc2FjdGlvbi52MS5HZXRNb250aGx5VHJhbnNh'
    'Y3Rpb25SZXF1ZXN0Gikuc2cuZmxvdy5jb21tb24udjEuVHJhbnNhY3Rpb25IaXN0b3J5TGlzdB'
    'J0ChNHZXREYWlseVRyYW5zYWN0aW9uEjIuc2cuZmxvdy50cmFuc2FjdGlvbi52MS5HZXREYWls'
    'eVRyYW5zYWN0aW9uUmVxdWVzdBopLnNnLmZsb3cuY29tbW9uLnYxLlRyYW5zYWN0aW9uSGlzdG'
    '9yeUxpc3QSegoVR2V0VHJhbnNhY3Rpb25EZXRhaWxzEjQuc2cuZmxvdy50cmFuc2FjdGlvbi52'
    'MS5HZXRUcmFuc2FjdGlvbkRldGFpbHNSZXF1ZXN0Gisuc2cuZmxvdy5jb21tb24udjEuVHJhbn'
    'NhY3Rpb25IaXN0b3J5RGV0YWlsEoABChlHZXRUcmFuc2FjdGlvbldpdGhpblJhbmdlEjguc2cu'
    'Zmxvdy50cmFuc2FjdGlvbi52MS5HZXRUcmFuc2FjdGlvbldpdGhpblJhbmdlUmVxdWVzdBopLn'
    'NnLmZsb3cuY29tbW9uLnYxLlRyYW5zYWN0aW9uSGlzdG9yeUxpc3Q=');
