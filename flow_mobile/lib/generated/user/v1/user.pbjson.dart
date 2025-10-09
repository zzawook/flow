// This is a generated file - do not edit.
//
// Generated from user/v1/user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use setConstantUserFieldsRequestDescriptor instead')
const SetConstantUserFieldsRequest$json = {
  '1': 'SetConstantUserFieldsRequest',
  '2': [
    {
      '1': 'date_of_birth',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dateOfBirth'
    },
    {'1': 'gender_is_male', '3': 2, '4': 1, '5': 8, '10': 'genderIsMale'},
  ],
};

/// Descriptor for `SetConstantUserFieldsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setConstantUserFieldsRequestDescriptor =
    $convert.base64Decode(
        'ChxTZXRDb25zdGFudFVzZXJGaWVsZHNSZXF1ZXN0Ej4KDWRhdGVfb2ZfYmlydGgYASABKAsyGi'
        '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtkYXRlT2ZCaXJ0aBIkCg5nZW5kZXJfaXNfbWFs'
        'ZRgCIAEoCFIMZ2VuZGVySXNNYWxl');

@$core.Deprecated('Use setConstantUserFieldsResponseDescriptor instead')
const SetConstantUserFieldsResponse$json = {
  '1': 'SetConstantUserFieldsResponse',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SetConstantUserFieldsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setConstantUserFieldsResponseDescriptor =
    $convert.base64Decode(
        'Ch1TZXRDb25zdGFudFVzZXJGaWVsZHNSZXNwb25zZRIYCgdzdWNjZXNzGAEgASgIUgdzdWNjZX'
        'NzEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');

@$core.Deprecated('Use getUserProfileRequestDescriptor instead')
const GetUserProfileRequest$json = {
  '1': 'GetUserProfileRequest',
};

/// Descriptor for `GetUserProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserProfileRequestDescriptor =
    $convert.base64Decode('ChVHZXRVc2VyUHJvZmlsZVJlcXVlc3Q=');

@$core.Deprecated('Use getUserPreferenceJsonRequestDescriptor instead')
const GetUserPreferenceJsonRequest$json = {
  '1': 'GetUserPreferenceJsonRequest',
};

/// Descriptor for `GetUserPreferenceJsonRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserPreferenceJsonRequestDescriptor =
    $convert.base64Decode('ChxHZXRVc2VyUHJlZmVyZW5jZUpzb25SZXF1ZXN0');

@$core.Deprecated('Use getUserPreferenceJsonResponseDescriptor instead')
const GetUserPreferenceJsonResponse$json = {
  '1': 'GetUserPreferenceJsonResponse',
  '2': [
    {'1': 'preference_json', '3': 1, '4': 1, '5': 9, '10': 'preferenceJson'},
  ],
};

/// Descriptor for `GetUserPreferenceJsonResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUserPreferenceJsonResponseDescriptor =
    $convert.base64Decode(
        'Ch1HZXRVc2VyUHJlZmVyZW5jZUpzb25SZXNwb25zZRInCg9wcmVmZXJlbmNlX2pzb24YASABKA'
        'lSDnByZWZlcmVuY2VKc29u');

@$core.Deprecated('Use updateUserProfileRequestDescriptor instead')
const UpdateUserProfileRequest$json = {
  '1': 'UpdateUserProfileRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'name', '17': true},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'email', '17': true},
    {
      '1': 'identification_number',
      '3': 3,
      '4': 1,
      '5': 9,
      '9': 2,
      '10': 'identificationNumber',
      '17': true
    },
    {
      '1': 'phone_number',
      '3': 4,
      '4': 1,
      '5': 9,
      '9': 3,
      '10': 'phoneNumber',
      '17': true
    },
    {
      '1': 'address',
      '3': 5,
      '4': 1,
      '5': 9,
      '9': 4,
      '10': 'address',
      '17': true
    },
  ],
  '8': [
    {'1': '_name'},
    {'1': '_email'},
    {'1': '_identification_number'},
    {'1': '_phone_number'},
    {'1': '_address'},
  ],
};

/// Descriptor for `UpdateUserProfileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateUserProfileRequestDescriptor = $convert.base64Decode(
    'ChhVcGRhdGVVc2VyUHJvZmlsZVJlcXVlc3QSFwoEbmFtZRgBIAEoCUgAUgRuYW1liAEBEhkKBW'
    'VtYWlsGAIgASgJSAFSBWVtYWlsiAEBEjgKFWlkZW50aWZpY2F0aW9uX251bWJlchgDIAEoCUgC'
    'UhRpZGVudGlmaWNhdGlvbk51bWJlcogBARImCgxwaG9uZV9udW1iZXIYBCABKAlIA1ILcGhvbm'
    'VOdW1iZXKIAQESHQoHYWRkcmVzcxgFIAEoCUgEUgdhZGRyZXNziAEBQgcKBV9uYW1lQggKBl9l'
    'bWFpbEIYChZfaWRlbnRpZmljYXRpb25fbnVtYmVyQg8KDV9waG9uZV9udW1iZXJCCgoIX2FkZH'
    'Jlc3M=');

@$core.Deprecated('Use userProfileDescriptor instead')
const UserProfile$json = {
  '1': 'UserProfile',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {
      '1': 'identification_number',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'identificationNumber'
    },
    {'1': 'phone_number', '3': 5, '4': 1, '5': 9, '10': 'phoneNumber'},
    {'1': 'address', '3': 6, '4': 1, '5': 9, '10': 'address'},
    {
      '1': 'date_of_birth',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dateOfBirth'
    },
    {
      '1': 'setting_json',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.StringValue',
      '10': 'settingJson'
    },
  ],
};

/// Descriptor for `UserProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userProfileDescriptor = $convert.base64Decode(
    'CgtVc2VyUHJvZmlsZRIOCgJpZBgBIAEoBVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIUCgVlbW'
    'FpbBgDIAEoCVIFZW1haWwSMwoVaWRlbnRpZmljYXRpb25fbnVtYmVyGAQgASgJUhRpZGVudGlm'
    'aWNhdGlvbk51bWJlchIhCgxwaG9uZV9udW1iZXIYBSABKAlSC3Bob25lTnVtYmVyEhgKB2FkZH'
    'Jlc3MYBiABKAlSB2FkZHJlc3MSPgoNZGF0ZV9vZl9iaXJ0aBgHIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSC2RhdGVPZkJpcnRoEj8KDHNldHRpbmdfanNvbhgIIAEoCzIcLmdvb2'
    'dsZS5wcm90b2J1Zi5TdHJpbmdWYWx1ZVILc2V0dGluZ0pzb24=');
