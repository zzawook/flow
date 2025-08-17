// This is a generated file - do not edit.
//
// Generated from transfer/v1/transfer.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated(
    'Use getRelevantRecepientByAccountNumberRequestDescriptor instead')
const GetRelevantRecepientByAccountNumberRequest$json = {
  '1': 'GetRelevantRecepientByAccountNumberRequest',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
  ],
};

/// Descriptor for `GetRelevantRecepientByAccountNumberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    getRelevantRecepientByAccountNumberRequestDescriptor =
    $convert.base64Decode(
        'CipHZXRSZWxldmFudFJlY2VwaWVudEJ5QWNjb3VudE51bWJlclJlcXVlc3QSGAoHa2V5d29yZB'
        'gBIAEoCVIHa2V5d29yZA==');

@$core.Deprecated(
    'Use getRelevantRecepientByAccountNumberResponseDescriptor instead')
const GetRelevantRecepientByAccountNumberResponse$json = {
  '1': 'GetRelevantRecepientByAccountNumberResponse',
  '2': [
    {
      '1': 'banks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.common.v1.Bank',
      '10': 'banks'
    },
  ],
};

/// Descriptor for `GetRelevantRecepientByAccountNumberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    getRelevantRecepientByAccountNumberResponseDescriptor =
    $convert.base64Decode(
        'CitHZXRSZWxldmFudFJlY2VwaWVudEJ5QWNjb3VudE51bWJlclJlc3BvbnNlEi0KBWJhbmtzGA'
        'EgAygLMhcuc2cuZmxvdy5jb21tb24udjEuQmFua1IFYmFua3M=');

@$core.Deprecated('Use getRelevantRecepientByContactRequestDescriptor instead')
const GetRelevantRecepientByContactRequest$json = {
  '1': 'GetRelevantRecepientByContactRequest',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
  ],
};

/// Descriptor for `GetRelevantRecepientByContactRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRelevantRecepientByContactRequestDescriptor =
    $convert.base64Decode(
        'CiRHZXRSZWxldmFudFJlY2VwaWVudEJ5Q29udGFjdFJlcXVlc3QSGAoHa2V5d29yZBgBIAEoCV'
        'IHa2V5d29yZA==');

@$core.Deprecated('Use getRelevantRecepientResponseDescriptor instead')
const GetRelevantRecepientResponse$json = {
  '1': 'GetRelevantRecepientResponse',
  '2': [
    {
      '1': 'recipients',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.sg.flow.transfer.v1.TransferRecepient',
      '10': 'recipients'
    },
  ],
};

/// Descriptor for `GetRelevantRecepientResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRelevantRecepientResponseDescriptor =
    $convert.base64Decode(
        'ChxHZXRSZWxldmFudFJlY2VwaWVudFJlc3BvbnNlEkYKCnJlY2lwaWVudHMYASADKAsyJi5zZy'
        '5mbG93LnRyYW5zZmVyLnYxLlRyYW5zZmVyUmVjZXBpZW50UgpyZWNpcGllbnRz');

@$core.Deprecated('Use transferRecepientDescriptor instead')
const TransferRecepient$json = {
  '1': 'TransferRecepient',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'account_number', '3': 2, '4': 1, '5': 9, '10': 'accountNumber'},
    {'1': 'bank_code', '3': 3, '4': 1, '5': 9, '10': 'bankCode'},
  ],
};

/// Descriptor for `TransferRecepient`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferRecepientDescriptor = $convert.base64Decode(
    'ChFUcmFuc2ZlclJlY2VwaWVudBISCgRuYW1lGAEgASgJUgRuYW1lEiUKDmFjY291bnRfbnVtYm'
    'VyGAIgASgJUg1hY2NvdW50TnVtYmVyEhsKCWJhbmtfY29kZRgDIAEoCVIIYmFua0NvZGU=');

@$core.Deprecated('Use transferRequestDescriptor instead')
const TransferRequest$json = {
  '1': 'TransferRequest',
  '2': [
    {
      '1': 'sender_account_number',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'senderAccountNumber'
    },
    {
      '1': 'recepient',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.sg.flow.transfer.v1.TransferRecepient',
      '10': 'recepient'
    },
    {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'scheduled_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledAt'
    },
  ],
};

/// Descriptor for `TransferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferRequestDescriptor = $convert.base64Decode(
    'Cg9UcmFuc2ZlclJlcXVlc3QSMgoVc2VuZGVyX2FjY291bnRfbnVtYmVyGAEgASgJUhNzZW5kZX'
    'JBY2NvdW50TnVtYmVyEkQKCXJlY2VwaWVudBgCIAEoCzImLnNnLmZsb3cudHJhbnNmZXIudjEu'
    'VHJhbnNmZXJSZWNlcGllbnRSCXJlY2VwaWVudBIWCgZhbW91bnQYAyABKAFSBmFtb3VudBISCg'
    'Rub3RlGAQgASgJUgRub3RlEj0KDHNjaGVkdWxlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSC3NjaGVkdWxlZEF0');

@$core.Deprecated('Use transferResultDescriptor instead')
const TransferResult$json = {
  '1': 'TransferResult',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `TransferResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferResultDescriptor = $convert.base64Decode(
    'Cg5UcmFuc2ZlclJlc3VsdBIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZXNzEhgKB21lc3NhZ2UYAi'
    'ABKAlSB21lc3NhZ2U=');
