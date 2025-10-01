// This is a generated file - do not edit.
//
// Generated from logo/v1/logo.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use getLogoRequestDescriptor instead')
const GetLogoRequest$json = {
  '1': 'GetLogoRequest',
  '2': [
    {'1': 'brand_domain', '3': 1, '4': 1, '5': 9, '10': 'brandDomain'},
  ],
};

/// Descriptor for `GetLogoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLogoRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRMb2dvUmVxdWVzdBIhCgxicmFuZF9kb21haW4YASABKAlSC2JyYW5kRG9tYWlu');

@$core.Deprecated('Use getLogoResponseDescriptor instead')
const GetLogoResponse$json = {
  '1': 'GetLogoResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'logo_url', '3': 2, '4': 1, '5': 9, '10': 'logoUrl'},
  ],
};

/// Descriptor for `GetLogoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLogoResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRMb2dvUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIZCghsb2dvX3VybB'
    'gCIAEoCVIHbG9nb1VybA==');

@$core.Deprecated('Use uploadLogoRequestDescriptor instead')
const UploadLogoRequest$json = {
  '1': 'UploadLogoRequest',
  '2': [
    {'1': 'brand_domain', '3': 1, '4': 1, '5': 9, '10': 'brandDomain'},
    {'1': 'logo', '3': 2, '4': 1, '5': 12, '10': 'logo'},
  ],
};

/// Descriptor for `UploadLogoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadLogoRequestDescriptor = $convert.base64Decode(
    'ChFVcGxvYWRMb2dvUmVxdWVzdBIhCgxicmFuZF9kb21haW4YASABKAlSC2JyYW5kRG9tYWluEh'
    'IKBGxvZ28YAiABKAxSBGxvZ28=');

@$core.Deprecated('Use uploadLogoResponseDescriptor instead')
const UploadLogoResponse$json = {
  '1': 'UploadLogoResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `UploadLogoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadLogoResponseDescriptor = $convert.base64Decode(
    'ChJVcGxvYWRMb2dvUmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYW'
    'dlGAIgASgJUgdtZXNzYWdl');
