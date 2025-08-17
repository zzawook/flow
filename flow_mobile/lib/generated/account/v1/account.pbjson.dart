// This is a generated file - do not edit.
//
// Generated from account/v1/account.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use accountTypeDescriptor instead')
const AccountType$json = {
  '1': 'AccountType',
  '2': [
    {'1': 'ACCOUNT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SAVINGS', '2': 1},
    {'1': 'CURRENT', '2': 2},
    {'1': 'FIXED_DEPOSIT', '2': 3},
    {'1': 'FOREIGN_CURRENCY', '2': 4},
    {'1': 'OTHERS', '2': 5},
  ],
};

/// Descriptor for `AccountType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List accountTypeDescriptor = $convert.base64Decode(
    'CgtBY2NvdW50VHlwZRIcChhBQ0NPVU5UX1RZUEVfVU5TUEVDSUZJRUQQABILCgdTQVZJTkdTEA'
    'ESCwoHQ1VSUkVOVBACEhEKDUZJWEVEX0RFUE9TSVQQAxIUChBGT1JFSUdOX0NVUlJFTkNZEAQS'
    'CgoGT1RIRVJTEAU=');

@$core.Deprecated('Use getAccountsRequestDescriptor instead')
const GetAccountsRequest$json = {
  '1': 'GetAccountsRequest',
};

/// Descriptor for `GetAccountsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccountsRequestDescriptor =
    $convert.base64Decode('ChJHZXRBY2NvdW50c1JlcXVlc3Q=');

@$core.Deprecated('Use getAccountsResponseDescriptor instead')
const GetAccountsResponse$json = {
  '1': 'GetAccountsResponse',
  '2': [
    {
      '1': 'accounts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.common.v1.Account',
      '10': 'accounts'
    },
  ],
};

/// Descriptor for `GetAccountsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccountsResponseDescriptor = $convert.base64Decode(
    'ChNHZXRBY2NvdW50c1Jlc3BvbnNlEjYKCGFjY291bnRzGAEgAygLMhouc2cuZmxvdy5jb21tb2'
    '4udjEuQWNjb3VudFIIYWNjb3VudHM=');

@$core.Deprecated(
    'Use getAccountsWithTransactionHistoryRequestDescriptor instead')
const GetAccountsWithTransactionHistoryRequest$json = {
  '1': 'GetAccountsWithTransactionHistoryRequest',
};

/// Descriptor for `GetAccountsWithTransactionHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccountsWithTransactionHistoryRequestDescriptor =
    $convert.base64Decode(
        'CihHZXRBY2NvdW50c1dpdGhUcmFuc2FjdGlvbkhpc3RvcnlSZXF1ZXN0');

@$core.Deprecated(
    'Use getAccountsWithTransactionHistoryResponseDescriptor instead')
const GetAccountsWithTransactionHistoryResponse$json = {
  '1': 'GetAccountsWithTransactionHistoryResponse',
  '2': [
    {
      '1': 'accounts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.account.v1.AccountWithTransactionHistory',
      '10': 'accounts'
    },
  ],
};

/// Descriptor for `GetAccountsWithTransactionHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    getAccountsWithTransactionHistoryResponseDescriptor = $convert.base64Decode(
        'CilHZXRBY2NvdW50c1dpdGhUcmFuc2FjdGlvbkhpc3RvcnlSZXNwb25zZRJNCghhY2NvdW50cx'
        'gBIAMoCzIxLnNnLmZsb3cuYWNjb3VudC52MS5BY2NvdW50V2l0aFRyYW5zYWN0aW9uSGlzdG9y'
        'eVIIYWNjb3VudHM=');

@$core.Deprecated('Use getAccountRequestDescriptor instead')
const GetAccountRequest$json = {
  '1': 'GetAccountRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 3, '10': 'accountId'},
  ],
};

/// Descriptor for `GetAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccountRequestDescriptor = $convert.base64Decode(
    'ChFHZXRBY2NvdW50UmVxdWVzdBIdCgphY2NvdW50X2lkGAEgASgDUglhY2NvdW50SWQ=');

@$core
    .Deprecated('Use getAccountWithTransactionHistoryRequestDescriptor instead')
const GetAccountWithTransactionHistoryRequest$json = {
  '1': 'GetAccountWithTransactionHistoryRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 3, '10': 'accountId'},
  ],
};

/// Descriptor for `GetAccountWithTransactionHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccountWithTransactionHistoryRequestDescriptor =
    $convert.base64Decode(
        'CidHZXRBY2NvdW50V2l0aFRyYW5zYWN0aW9uSGlzdG9yeVJlcXVlc3QSHQoKYWNjb3VudF9pZB'
        'gBIAEoA1IJYWNjb3VudElk');

@$core.Deprecated('Use accountWithTransactionHistoryDescriptor instead')
const AccountWithTransactionHistory$json = {
  '1': 'AccountWithTransactionHistory',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'account_number', '3': 2, '4': 1, '5': 9, '10': 'accountNumber'},
    {'1': 'balance', '3': 3, '4': 1, '5': 1, '10': 'balance'},
    {'1': 'account_name', '3': 4, '4': 1, '5': 9, '10': 'accountName'},
    {
      '1': 'account_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.sg.flow.account.v1.AccountType',
      '10': 'accountType'
    },
    {
      '1': 'interest_rate_per_annum',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.DoubleValue',
      '10': 'interestRatePerAnnum'
    },
    {
      '1': 'bank',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.sg.flow.common.v1.Bank',
      '10': 'bank'
    },
    {
      '1': 'recent_transaction_history_details',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.common.v1.TransactionHistoryDetail',
      '10': 'recentTransactionHistoryDetails'
    },
  ],
};

/// Descriptor for `AccountWithTransactionHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountWithTransactionHistoryDescriptor = $convert.base64Decode(
    'Ch1BY2NvdW50V2l0aFRyYW5zYWN0aW9uSGlzdG9yeRIOCgJpZBgBIAEoA1ICaWQSJQoOYWNjb3'
    'VudF9udW1iZXIYAiABKAlSDWFjY291bnROdW1iZXISGAoHYmFsYW5jZRgDIAEoAVIHYmFsYW5j'
    'ZRIhCgxhY2NvdW50X25hbWUYBCABKAlSC2FjY291bnROYW1lEkIKDGFjY291bnRfdHlwZRgFIA'
    'EoDjIfLnNnLmZsb3cuYWNjb3VudC52MS5BY2NvdW50VHlwZVILYWNjb3VudFR5cGUSUwoXaW50'
    'ZXJlc3RfcmF0ZV9wZXJfYW5udW0YBiABKAsyHC5nb29nbGUucHJvdG9idWYuRG91YmxlVmFsdW'
    'VSFGludGVyZXN0UmF0ZVBlckFubnVtEisKBGJhbmsYByABKAsyFy5zZy5mbG93LmNvbW1vbi52'
    'MS5CYW5rUgRiYW5rEngKInJlY2VudF90cmFuc2FjdGlvbl9oaXN0b3J5X2RldGFpbHMYCCADKA'
    'syKy5zZy5mbG93LmNvbW1vbi52MS5UcmFuc2FjdGlvbkhpc3RvcnlEZXRhaWxSH3JlY2VudFRy'
    'YW5zYWN0aW9uSGlzdG9yeURldGFpbHM=');
