// This is a generated file - do not edit.
//
// Generated from common/v1/transaction.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use transactionHistoryDetailDescriptor instead')
const TransactionHistoryDetail$json = {
  '1': 'TransactionHistoryDetail',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {
      '1': 'transaction_reference',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'transactionReference'
    },
    {
      '1': 'account',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.sg.flow.common.v1.Account',
      '10': 'account'
    },
    {
      '1': 'card',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.sg.flow.common.v1.BriefCard',
      '10': 'card'
    },
    {
      '1': 'transaction_timestamp',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'transactionTimestamp'
    },
    {'1': 'amount', '3': 6, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'transaction_type', '3': 7, '4': 1, '5': 9, '10': 'transactionType'},
    {'1': 'description', '3': 8, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'transaction_status',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'transactionStatus'
    },
    {
      '1': 'friendly_description',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'friendlyDescription'
    },
    {
      '1': 'transaction_category',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'transactionCategory'
    },
    {'1': 'brand_name', '3': 12, '4': 1, '5': 9, '10': 'brandName'},
    {
      '1': 'revised_transaction_timestamp',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'revisedTransactionTimestamp'
    },
  ],
};

/// Descriptor for `TransactionHistoryDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionHistoryDetailDescriptor = $convert.base64Decode(
    'ChhUcmFuc2FjdGlvbkhpc3RvcnlEZXRhaWwSDgoCaWQYASABKANSAmlkEjMKFXRyYW5zYWN0aW'
    '9uX3JlZmVyZW5jZRgCIAEoCVIUdHJhbnNhY3Rpb25SZWZlcmVuY2USNAoHYWNjb3VudBgDIAEo'
    'CzIaLnNnLmZsb3cuY29tbW9uLnYxLkFjY291bnRSB2FjY291bnQSMAoEY2FyZBgEIAEoCzIcLn'
    'NnLmZsb3cuY29tbW9uLnYxLkJyaWVmQ2FyZFIEY2FyZBJPChV0cmFuc2FjdGlvbl90aW1lc3Rh'
    'bXAYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhR0cmFuc2FjdGlvblRpbWVzdG'
    'FtcBIWCgZhbW91bnQYBiABKAFSBmFtb3VudBIpChB0cmFuc2FjdGlvbl90eXBlGAcgASgJUg90'
    'cmFuc2FjdGlvblR5cGUSIAoLZGVzY3JpcHRpb24YCCABKAlSC2Rlc2NyaXB0aW9uEi0KEnRyYW'
    '5zYWN0aW9uX3N0YXR1cxgJIAEoCVIRdHJhbnNhY3Rpb25TdGF0dXMSMQoUZnJpZW5kbHlfZGVz'
    'Y3JpcHRpb24YCiABKAlSE2ZyaWVuZGx5RGVzY3JpcHRpb24SMQoUdHJhbnNhY3Rpb25fY2F0ZW'
    'dvcnkYCyABKAlSE3RyYW5zYWN0aW9uQ2F0ZWdvcnkSHQoKYnJhbmRfbmFtZRgMIAEoCVIJYnJh'
    'bmROYW1lEl4KHXJldmlzZWRfdHJhbnNhY3Rpb25fdGltZXN0YW1wGA0gASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIbcmV2aXNlZFRyYW5zYWN0aW9uVGltZXN0YW1w');

@$core.Deprecated('Use transactionHistoryListDescriptor instead')
const TransactionHistoryList$json = {
  '1': 'TransactionHistoryList',
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
    {
      '1': 'transactions',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.common.v1.TransactionHistoryDetail',
      '10': 'transactions'
    },
  ],
};

/// Descriptor for `TransactionHistoryList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transactionHistoryListDescriptor = $convert.base64Decode(
    'ChZUcmFuc2FjdGlvbkhpc3RvcnlMaXN0EkMKD3N0YXJ0X3RpbWVzdGFtcBgBIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDnN0YXJ0VGltZXN0YW1wEj8KDWVuZF90aW1lc3RhbXAY'
    'AiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxlbmRUaW1lc3RhbXASTwoMdHJhbn'
    'NhY3Rpb25zGAMgAygLMisuc2cuZmxvdy5jb21tb24udjEuVHJhbnNhY3Rpb25IaXN0b3J5RGV0'
    'YWlsUgx0cmFuc2FjdGlvbnM=');
