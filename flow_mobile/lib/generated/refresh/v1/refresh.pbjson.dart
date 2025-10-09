// This is a generated file - do not edit.
//
// Generated from refresh/v1/refresh.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use canLinkBankRequestDescriptor instead')
const CanLinkBankRequest$json = {
  '1': 'CanLinkBankRequest',
};

/// Descriptor for `CanLinkBankRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List canLinkBankRequestDescriptor =
    $convert.base64Decode('ChJDYW5MaW5rQmFua1JlcXVlc3Q=');

@$core.Deprecated('Use canLinkBankResponseDescriptor instead')
const CanLinkBankResponse$json = {
  '1': 'CanLinkBankResponse',
  '2': [
    {'1': 'can_link', '3': 1, '4': 1, '5': 8, '10': 'canLink'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `CanLinkBankResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List canLinkBankResponseDescriptor = $convert.base64Decode(
    'ChNDYW5MaW5rQmFua1Jlc3BvbnNlEhkKCGNhbl9saW5rGAEgASgIUgdjYW5MaW5rEhgKB21lc3'
    'NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use getRefreshUrlRequestDescriptor instead')
const GetRefreshUrlRequest$json = {
  '1': 'GetRefreshUrlRequest',
  '2': [
    {'1': 'institution_id', '3': 1, '4': 1, '5': 3, '10': 'institutionId'},
    {
      '1': 'country_code',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'countryCode',
      '17': true
    },
  ],
  '8': [
    {'1': '_country_code'},
  ],
};

/// Descriptor for `GetRefreshUrlRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRefreshUrlRequestDescriptor = $convert.base64Decode(
    'ChRHZXRSZWZyZXNoVXJsUmVxdWVzdBIlCg5pbnN0aXR1dGlvbl9pZBgBIAEoA1INaW5zdGl0dX'
    'Rpb25JZBImCgxjb3VudHJ5X2NvZGUYAiABKAlIAFILY291bnRyeUNvZGWIAQFCDwoNX2NvdW50'
    'cnlfY29kZQ==');

@$core.Deprecated('Use getRelinkUrlRequestDescriptor instead')
const GetRelinkUrlRequest$json = {
  '1': 'GetRelinkUrlRequest',
  '2': [
    {'1': 'institution_id', '3': 1, '4': 1, '5': 3, '10': 'institutionId'},
    {
      '1': 'country_code',
      '3': 2,
      '4': 1,
      '5': 9,
      '9': 0,
      '10': 'countryCode',
      '17': true
    },
  ],
  '8': [
    {'1': '_country_code'},
  ],
};

/// Descriptor for `GetRelinkUrlRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRelinkUrlRequestDescriptor = $convert.base64Decode(
    'ChNHZXRSZWxpbmtVcmxSZXF1ZXN0EiUKDmluc3RpdHV0aW9uX2lkGAEgASgDUg1pbnN0aXR1dG'
    'lvbklkEiYKDGNvdW50cnlfY29kZRgCIAEoCUgAUgtjb3VudHJ5Q29kZYgBAUIPCg1fY291bnRy'
    'eV9jb2Rl');

@$core.Deprecated('Use canStartRefreshSessionRequestDescriptor instead')
const CanStartRefreshSessionRequest$json = {
  '1': 'CanStartRefreshSessionRequest',
  '2': [
    {'1': 'institution_id', '3': 1, '4': 1, '5': 3, '10': 'institutionId'},
  ],
};

/// Descriptor for `CanStartRefreshSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List canStartRefreshSessionRequestDescriptor =
    $convert.base64Decode(
        'Ch1DYW5TdGFydFJlZnJlc2hTZXNzaW9uUmVxdWVzdBIlCg5pbnN0aXR1dGlvbl9pZBgBIAEoA1'
        'INaW5zdGl0dXRpb25JZA==');

@$core.Deprecated('Use canStartRefreshSessionResponseDescriptor instead')
const CanStartRefreshSessionResponse$json = {
  '1': 'CanStartRefreshSessionResponse',
  '2': [
    {'1': 'can_start', '3': 1, '4': 1, '5': 8, '10': 'canStart'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `CanStartRefreshSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List canStartRefreshSessionResponseDescriptor =
    $convert.base64Decode(
        'Ch5DYW5TdGFydFJlZnJlc2hTZXNzaW9uUmVzcG9uc2USGwoJY2FuX3N0YXJ0GAEgASgIUghjYW'
        '5TdGFydBIgCgtkZXNjcmlwdGlvbhgCIAEoCVILZGVzY3JpcHRpb24=');

@$core.Deprecated('Use getRefreshUrlResponseDescriptor instead')
const GetRefreshUrlResponse$json = {
  '1': 'GetRefreshUrlResponse',
  '2': [
    {'1': 'refresh_url', '3': 1, '4': 1, '5': 9, '10': 'refreshUrl'},
  ],
};

/// Descriptor for `GetRefreshUrlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRefreshUrlResponseDescriptor = $convert.base64Decode(
    'ChVHZXRSZWZyZXNoVXJsUmVzcG9uc2USHwoLcmVmcmVzaF91cmwYASABKAlSCnJlZnJlc2hVcm'
    'w=');

@$core.Deprecated('Use getRelinkUrlResponseDescriptor instead')
const GetRelinkUrlResponse$json = {
  '1': 'GetRelinkUrlResponse',
  '2': [
    {'1': 'relink_url', '3': 1, '4': 1, '5': 9, '10': 'relinkUrl'},
  ],
};

/// Descriptor for `GetRelinkUrlResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRelinkUrlResponseDescriptor = $convert.base64Decode(
    'ChRHZXRSZWxpbmtVcmxSZXNwb25zZRIdCgpyZWxpbmtfdXJsGAEgASgJUglyZWxpbmtVcmw=');

@$core.Deprecated(
    'Use getInstitutionAuthenticationResultRequestDescriptor instead')
const GetInstitutionAuthenticationResultRequest$json = {
  '1': 'GetInstitutionAuthenticationResultRequest',
  '2': [
    {'1': 'institution_id', '3': 1, '4': 1, '5': 3, '10': 'institutionId'},
    {'1': 'state', '3': 2, '4': 1, '5': 9, '10': 'state'},
  ],
};

/// Descriptor for `GetInstitutionAuthenticationResultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    getInstitutionAuthenticationResultRequestDescriptor = $convert.base64Decode(
        'CilHZXRJbnN0aXR1dGlvbkF1dGhlbnRpY2F0aW9uUmVzdWx0UmVxdWVzdBIlCg5pbnN0aXR1dG'
        'lvbl9pZBgBIAEoA1INaW5zdGl0dXRpb25JZBIUCgVzdGF0ZRgCIAEoCVIFc3RhdGU=');

@$core.Deprecated(
    'Use getInstitutionAuthenticationResultResponseDescriptor instead')
const GetInstitutionAuthenticationResultResponse$json = {
  '1': 'GetInstitutionAuthenticationResultResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `GetInstitutionAuthenticationResultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List
    getInstitutionAuthenticationResultResponseDescriptor =
    $convert.base64Decode(
        'CipHZXRJbnN0aXR1dGlvbkF1dGhlbnRpY2F0aW9uUmVzdWx0UmVzcG9uc2USGAoHc3VjY2Vzcx'
        'gBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use getDataRetrievalResultRequestDescriptor instead')
const GetDataRetrievalResultRequest$json = {
  '1': 'GetDataRetrievalResultRequest',
  '2': [
    {'1': 'institution_id', '3': 1, '4': 1, '5': 3, '10': 'institutionId'},
  ],
};

/// Descriptor for `GetDataRetrievalResultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDataRetrievalResultRequestDescriptor =
    $convert.base64Decode(
        'Ch1HZXREYXRhUmV0cmlldmFsUmVzdWx0UmVxdWVzdBIlCg5pbnN0aXR1dGlvbl9pZBgBIAEoA1'
        'INaW5zdGl0dXRpb25JZA==');

@$core.Deprecated('Use getDataRetrievalResultResponseDescriptor instead')
const GetDataRetrievalResultResponse$json = {
  '1': 'GetDataRetrievalResultResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `GetDataRetrievalResultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDataRetrievalResultResponseDescriptor =
    $convert.base64Decode(
        'Ch5HZXREYXRhUmV0cmlldmFsUmVzdWx0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2'
        'VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use getBanksForRefreshRequestDescriptor instead')
const GetBanksForRefreshRequest$json = {
  '1': 'GetBanksForRefreshRequest',
  '2': [
    {'1': 'country_code', '3': 1, '4': 1, '5': 9, '10': 'countryCode'},
  ],
};

/// Descriptor for `GetBanksForRefreshRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBanksForRefreshRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRCYW5rc0ZvclJlZnJlc2hSZXF1ZXN0EiEKDGNvdW50cnlfY29kZRgBIAEoCVILY291bn'
        'RyeUNvZGU=');

@$core.Deprecated('Use getBanksForLinkRequestDescriptor instead')
const GetBanksForLinkRequest$json = {
  '1': 'GetBanksForLinkRequest',
  '2': [
    {'1': 'country_code', '3': 1, '4': 1, '5': 9, '10': 'countryCode'},
  ],
};

/// Descriptor for `GetBanksForLinkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBanksForLinkRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRCYW5rc0ZvckxpbmtSZXF1ZXN0EiEKDGNvdW50cnlfY29kZRgBIAEoCVILY291bnRyeU'
        'NvZGU=');

@$core.Deprecated('Use getBanksForRefreshResponseDescriptor instead')
const GetBanksForRefreshResponse$json = {
  '1': 'GetBanksForRefreshResponse',
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

/// Descriptor for `GetBanksForRefreshResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBanksForRefreshResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRCYW5rc0ZvclJlZnJlc2hSZXNwb25zZRItCgViYW5rcxgBIAMoCzIXLnNnLmZsb3cuY2'
        '9tbW9uLnYxLkJhbmtSBWJhbmtz');

@$core.Deprecated('Use getBanksForLinkResponseDescriptor instead')
const GetBanksForLinkResponse$json = {
  '1': 'GetBanksForLinkResponse',
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

/// Descriptor for `GetBanksForLinkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBanksForLinkResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRCYW5rc0ZvckxpbmtSZXNwb25zZRItCgViYW5rcxgBIAMoCzIXLnNnLmZsb3cuY29tbW'
        '9uLnYxLkJhbmtSBWJhbmtz');
