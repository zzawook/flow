// This is a generated file - do not edit.
//
// Generated from common/v1/account.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use accountDescriptor instead')
const Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'balance', '3': 2, '4': 1, '5': 1, '10': 'balance'},
    {'1': 'account_name', '3': 3, '4': 1, '5': 9, '10': 'accountName'},
    {'1': 'account_number', '3': 4, '4': 1, '5': 9, '10': 'accountNumber'},
    {'1': 'account_type', '3': 5, '4': 1, '5': 9, '10': 'accountType'},
    {
      '1': 'bank',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.sg.flow.common.v1.Bank',
      '10': 'bank'
    },
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode(
    'CgdBY2NvdW50Eg4KAmlkGAEgASgDUgJpZBIYCgdiYWxhbmNlGAIgASgBUgdiYWxhbmNlEiEKDG'
    'FjY291bnRfbmFtZRgDIAEoCVILYWNjb3VudE5hbWUSJQoOYWNjb3VudF9udW1iZXIYBCABKAlS'
    'DWFjY291bnROdW1iZXISIQoMYWNjb3VudF90eXBlGAUgASgJUgthY2NvdW50VHlwZRIrCgRiYW'
    '5rGAYgASgLMhcuc2cuZmxvdy5jb21tb24udjEuQmFua1IEYmFuaw==');
