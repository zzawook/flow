// This is a generated file - do not edit.
//
// Generated from auth/v1/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use checkUserExistsRequestDescriptor instead')
const CheckUserExistsRequest$json = {
  '1': 'CheckUserExistsRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `CheckUserExistsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkUserExistsRequestDescriptor =
    $convert.base64Decode(
        'ChZDaGVja1VzZXJFeGlzdHNSZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbA==');

@$core.Deprecated('Use checkUserExistsResponseDescriptor instead')
const CheckUserExistsResponse$json = {
  '1': 'CheckUserExistsResponse',
  '2': [
    {'1': 'exists', '3': 1, '4': 1, '5': 8, '10': 'exists'},
  ],
};

/// Descriptor for `CheckUserExistsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkUserExistsResponseDescriptor =
    $convert.base64Decode(
        'ChdDaGVja1VzZXJFeGlzdHNSZXNwb25zZRIWCgZleGlzdHMYASABKAhSBmV4aXN0cw==');

@$core.Deprecated('Use signUpRequestDescriptor instead')
const SignUpRequest$json = {
  '1': 'SignUpRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'phone_number', '3': 3, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'date_of_birth', '3': 4, '4': 1, '5': 9, '10': 'dateOfBirth'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `SignUpRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signUpRequestDescriptor = $convert.base64Decode(
    'Cg1TaWduVXBSZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbBIaCghwYXNzd29yZBgCIAEoCV'
    'IIcGFzc3dvcmQSIQoMcGhvbmVfbnVtYmVyGAMgASgJUgtwaG9uZU51bWJlchIiCg1kYXRlX29m'
    'X2JpcnRoGAQgASgJUgtkYXRlT2ZCaXJ0aBISCgRuYW1lGAUgASgJUgRuYW1l');

@$core.Deprecated('Use signInRequestDescriptor instead')
const SignInRequest$json = {
  '1': 'SignInRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `SignInRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signInRequestDescriptor = $convert.base64Decode(
    'Cg1TaWduSW5SZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbBIaCghwYXNzd29yZBgCIAEoCV'
    'IIcGFzc3dvcmQ=');

@$core.Deprecated('Use signOutRequestDescriptor instead')
const SignOutRequest$json = {
  '1': 'SignOutRequest',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
  ],
};

/// Descriptor for `SignOutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signOutRequestDescriptor = $convert.base64Decode(
    'Cg5TaWduT3V0UmVxdWVzdBIhCgxhY2Nlc3NfdG9rZW4YASABKAlSC2FjY2Vzc1Rva2Vu');

@$core.Deprecated('Use signOutResponseDescriptor instead')
const SignOutResponse$json = {
  '1': 'SignOutResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SignOutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signOutResponseDescriptor = $convert.base64Decode(
    'Cg9TaWduT3V0UmVzcG9uc2USGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2Vzcw==');

@$core.Deprecated('Use accessTokenRefreshRequestDescriptor instead')
const AccessTokenRefreshRequest$json = {
  '1': 'AccessTokenRefreshRequest',
  '2': [
    {'1': 'refresh_token', '3': 1, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

/// Descriptor for `AccessTokenRefreshRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accessTokenRefreshRequestDescriptor =
    $convert.base64Decode(
        'ChlBY2Nlc3NUb2tlblJlZnJlc2hSZXF1ZXN0EiMKDXJlZnJlc2hfdG9rZW4YASABKAlSDHJlZn'
        'Jlc2hUb2tlbg==');

@$core.Deprecated('Use tokenSetDescriptor instead')
const TokenSet$json = {
  '1': 'TokenSet',
  '2': [
    {'1': 'access_token', '3': 1, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'refresh_token', '3': 2, '4': 1, '5': 9, '10': 'refreshToken'},
  ],
};

/// Descriptor for `TokenSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tokenSetDescriptor = $convert.base64Decode(
    'CghUb2tlblNldBIhCgxhY2Nlc3NfdG9rZW4YASABKAlSC2FjY2Vzc1Rva2VuEiMKDXJlZnJlc2'
    'hfdG9rZW4YAiABKAlSDHJlZnJlc2hUb2tlbg==');

@$core.Deprecated('Use sendVerificationEmailRequestDescriptor instead')
const SendVerificationEmailRequest$json = {
  '1': 'SendVerificationEmailRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `SendVerificationEmailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerificationEmailRequestDescriptor =
    $convert.base64Decode(
        'ChxTZW5kVmVyaWZpY2F0aW9uRW1haWxSZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbA==');

@$core.Deprecated('Use sendVerificationEmailResponseDescriptor instead')
const SendVerificationEmailResponse$json = {
  '1': 'SendVerificationEmailResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
  ],
};

/// Descriptor for `SendVerificationEmailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendVerificationEmailResponseDescriptor =
    $convert.base64Decode(
        'Ch1TZW5kVmVyaWZpY2F0aW9uRW1haWxSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZX'
        'Nz');

@$core.Deprecated('Use checkEmailVerifiedRequestDescriptor instead')
const CheckEmailVerifiedRequest$json = {
  '1': 'CheckEmailVerifiedRequest',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
  ],
};

/// Descriptor for `CheckEmailVerifiedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkEmailVerifiedRequestDescriptor =
    $convert.base64Decode(
        'ChlDaGVja0VtYWlsVmVyaWZpZWRSZXF1ZXN0EhQKBWVtYWlsGAEgASgJUgVlbWFpbA==');

@$core.Deprecated('Use checkEmailVerifiedResponseDescriptor instead')
const CheckEmailVerifiedResponse$json = {
  '1': 'CheckEmailVerifiedResponse',
  '2': [
    {'1': 'verified', '3': 1, '4': 1, '5': 8, '10': 'verified'},
  ],
};

/// Descriptor for `CheckEmailVerifiedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkEmailVerifiedResponseDescriptor =
    $convert.base64Decode(
        'ChpDaGVja0VtYWlsVmVyaWZpZWRSZXNwb25zZRIaCgh2ZXJpZmllZBgBIAEoCFIIdmVyaWZpZW'
        'Q=');
