// This is a generated file - do not edit.
//
// Generated from common/v1/bank.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use bankDescriptor instead')
const Bank$json = {
  '1': 'Bank',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'bank_code', '3': 3, '4': 1, '5': 9, '10': 'bankCode'},
  ],
};

/// Descriptor for `Bank`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bankDescriptor = $convert.base64Decode(
    'CgRCYW5rEg4KAmlkGAEgASgFUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhsKCWJhbmtfY29kZR'
    'gDIAEoCVIIYmFua0NvZGU=');
