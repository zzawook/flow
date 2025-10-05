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

@$core.Deprecated('Use dailyAssetDescriptor instead')
const DailyAsset$json = {
  '1': 'DailyAsset',
  '2': [
    {
      '1': 'asset_date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assetDate'
    },
    {'1': 'total_asset_value', '3': 2, '4': 1, '5': 1, '10': 'totalAssetValue'},
    {'1': 'account_count', '3': 3, '4': 1, '5': 5, '10': 'accountCount'},
    {
      '1': 'calculated_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'calculatedAt'
    },
  ],
};

/// Descriptor for `DailyAsset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dailyAssetDescriptor = $convert.base64Decode(
    'CgpEYWlseUFzc2V0EjkKCmFzc2V0X2RhdGUYASABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUglhc3NldERhdGUSKgoRdG90YWxfYXNzZXRfdmFsdWUYAiABKAFSD3RvdGFsQXNzZXRW'
    'YWx1ZRIjCg1hY2NvdW50X2NvdW50GAMgASgFUgxhY2NvdW50Q291bnQSPwoNY2FsY3VsYXRlZF'
    '9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGNhbGN1bGF0ZWRBdA==');

@$core.Deprecated('Use getDailyAssetsRequestDescriptor instead')
const GetDailyAssetsRequest$json = {
  '1': 'GetDailyAssetsRequest',
  '2': [
    {
      '1': 'start_date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startDate'
    },
    {
      '1': 'end_date',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endDate'
    },
  ],
};

/// Descriptor for `GetDailyAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDailyAssetsRequestDescriptor = $convert.base64Decode(
    'ChVHZXREYWlseUFzc2V0c1JlcXVlc3QSOQoKc3RhcnRfZGF0ZRgBIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0RGF0ZRI1CghlbmRfZGF0ZRgCIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSB2VuZERhdGU=');

@$core.Deprecated('Use getDailyAssetsResponseDescriptor instead')
const GetDailyAssetsResponse$json = {
  '1': 'GetDailyAssetsResponse',
  '2': [
    {
      '1': 'daily_assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.account.v1.DailyAsset',
      '10': 'dailyAssets'
    },
  ],
};

/// Descriptor for `GetDailyAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDailyAssetsResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXREYWlseUFzc2V0c1Jlc3BvbnNlEkEKDGRhaWx5X2Fzc2V0cxgBIAMoCzIeLnNnLmZsb3'
        'cuYWNjb3VudC52MS5EYWlseUFzc2V0UgtkYWlseUFzc2V0cw==');

@$core.Deprecated('Use getLast7DaysAssetsRequestDescriptor instead')
const GetLast7DaysAssetsRequest$json = {
  '1': 'GetLast7DaysAssetsRequest',
};

/// Descriptor for `GetLast7DaysAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLast7DaysAssetsRequestDescriptor =
    $convert.base64Decode('ChlHZXRMYXN0N0RheXNBc3NldHNSZXF1ZXN0');

@$core.Deprecated('Use getLast7DaysAssetsResponseDescriptor instead')
const GetLast7DaysAssetsResponse$json = {
  '1': 'GetLast7DaysAssetsResponse',
  '2': [
    {
      '1': 'daily_assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.account.v1.DailyAsset',
      '10': 'dailyAssets'
    },
  ],
};

/// Descriptor for `GetLast7DaysAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLast7DaysAssetsResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRMYXN0N0RheXNBc3NldHNSZXNwb25zZRJBCgxkYWlseV9hc3NldHMYASADKAsyHi5zZy'
        '5mbG93LmFjY291bnQudjEuRGFpbHlBc3NldFILZGFpbHlBc3NldHM=');

@$core.Deprecated('Use getLast6MonthsEndOfMonthAssetsRequestDescriptor instead')
const GetLast6MonthsEndOfMonthAssetsRequest$json = {
  '1': 'GetLast6MonthsEndOfMonthAssetsRequest',
};

/// Descriptor for `GetLast6MonthsEndOfMonthAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLast6MonthsEndOfMonthAssetsRequestDescriptor =
    $convert
        .base64Decode('CiVHZXRMYXN0Nk1vbnRoc0VuZE9mTW9udGhBc3NldHNSZXF1ZXN0');

@$core
    .Deprecated('Use getLast6MonthsEndOfMonthAssetsResponseDescriptor instead')
const GetLast6MonthsEndOfMonthAssetsResponse$json = {
  '1': 'GetLast6MonthsEndOfMonthAssetsResponse',
  '2': [
    {
      '1': 'daily_assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.account.v1.DailyAsset',
      '10': 'dailyAssets'
    },
  ],
};

/// Descriptor for `GetLast6MonthsEndOfMonthAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLast6MonthsEndOfMonthAssetsResponseDescriptor =
    $convert.base64Decode(
        'CiZHZXRMYXN0Nk1vbnRoc0VuZE9mTW9udGhBc3NldHNSZXNwb25zZRJBCgxkYWlseV9hc3NldH'
        'MYASADKAsyHi5zZy5mbG93LmFjY291bnQudjEuRGFpbHlBc3NldFILZGFpbHlBc3NldHM=');
