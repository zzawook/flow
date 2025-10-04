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
    {'1': 'brand_domain', '3': 13, '4': 1, '5': 9, '10': 'brandDomain'},
    {
      '1': 'is_included_in_spending_or_income',
      '3': 14,
      '4': 1,
      '5': 8,
      '10': 'isIncludedInSpendingOrIncome'
    },
    {
      '1': 'revised_transaction_timestamp',
      '3': 15,
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
    'bmROYW1lEiEKDGJyYW5kX2RvbWFpbhgNIAEoCVILYnJhbmREb21haW4SRwohaXNfaW5jbHVkZW'
    'RfaW5fc3BlbmRpbmdfb3JfaW5jb21lGA4gASgIUhxpc0luY2x1ZGVkSW5TcGVuZGluZ09ySW5j'
    'b21lEl4KHXJldmlzZWRfdHJhbnNhY3Rpb25fdGltZXN0YW1wGA8gASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIbcmV2aXNlZFRyYW5zYWN0aW9uVGltZXN0YW1w');

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

@$core.Deprecated('Use recurringTransactionDetailDescriptor instead')
const RecurringTransactionDetail$json = {
  '1': 'RecurringTransactionDetail',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'category', '3': 3, '4': 1, '5': 9, '10': 'category'},
    {'1': 'expected_amount', '3': 4, '4': 1, '5': 1, '10': 'expectedAmount'},
    {
      '1': 'next_transaction_date',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'nextTransactionDate'
    },
    {
      '1': 'last_transaction_date',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastTransactionDate'
    },
    {'1': 'interval_days', '3': 7, '4': 1, '5': 3, '10': 'intervalDays'},
    {'1': 'occurrence_count', '3': 8, '4': 1, '5': 3, '10': 'occurrenceCount'},
    {'1': 'transaction_ids', '3': 9, '4': 3, '5': 3, '10': 'transactionIds'},
    {'1': 'year', '3': 10, '4': 1, '5': 3, '10': 'year'},
    {'1': 'month', '3': 11, '4': 1, '5': 3, '10': 'month'},
    {'1': 'brand_domain', '3': 12, '4': 1, '5': 9, '10': 'brandDomain'},
    {'1': 'brand_name', '3': 13, '4': 1, '5': 9, '10': 'brandName'},
  ],
};

/// Descriptor for `RecurringTransactionDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recurringTransactionDetailDescriptor = $convert.base64Decode(
    'ChpSZWN1cnJpbmdUcmFuc2FjdGlvbkRldGFpbBIOCgJpZBgBIAEoA1ICaWQSIQoMZGlzcGxheV'
    '9uYW1lGAIgASgJUgtkaXNwbGF5TmFtZRIaCghjYXRlZ29yeRgDIAEoCVIIY2F0ZWdvcnkSJwoP'
    'ZXhwZWN0ZWRfYW1vdW50GAQgASgBUg5leHBlY3RlZEFtb3VudBJOChVuZXh0X3RyYW5zYWN0aW'
    '9uX2RhdGUYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhNuZXh0VHJhbnNhY3Rp'
    'b25EYXRlEk4KFWxhc3RfdHJhbnNhY3Rpb25fZGF0ZRgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSE2xhc3RUcmFuc2FjdGlvbkRhdGUSIwoNaW50ZXJ2YWxfZGF5cxgHIAEoA1IM'
    'aW50ZXJ2YWxEYXlzEikKEG9jY3VycmVuY2VfY291bnQYCCABKANSD29jY3VycmVuY2VDb3VudB'
    'InCg90cmFuc2FjdGlvbl9pZHMYCSADKANSDnRyYW5zYWN0aW9uSWRzEhIKBHllYXIYCiABKANS'
    'BHllYXISFAoFbW9udGgYCyABKANSBW1vbnRoEiEKDGJyYW5kX2RvbWFpbhgMIAEoCVILYnJhbm'
    'REb21haW4SHQoKYnJhbmRfbmFtZRgNIAEoCVIJYnJhbmROYW1l');
