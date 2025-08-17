// This is a generated file - do not edit.
//
// Generated from user/user.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/timestamp.pb.dart' as $0;
import '../google/protobuf/wrappers.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetUserProfileRequest extends $pb.GeneratedMessage {
  factory GetUserProfileRequest() => create();

  GetUserProfileRequest._();

  factory GetUserProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserProfileRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.user.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserProfileRequest clone() =>
      GetUserProfileRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserProfileRequest copyWith(
          void Function(GetUserProfileRequest) updates) =>
      super.copyWith((message) => updates(message as GetUserProfileRequest))
          as GetUserProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserProfileRequest create() => GetUserProfileRequest._();
  @$core.override
  GetUserProfileRequest createEmptyInstance() => create();
  static $pb.PbList<GetUserProfileRequest> createRepeated() =>
      $pb.PbList<GetUserProfileRequest>();
  @$core.pragma('dart2js:noInline')
  static GetUserProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserProfileRequest>(create);
  static GetUserProfileRequest? _defaultInstance;
}

class GetUserPreferenceJsonRequest extends $pb.GeneratedMessage {
  factory GetUserPreferenceJsonRequest() => create();

  GetUserPreferenceJsonRequest._();

  factory GetUserPreferenceJsonRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserPreferenceJsonRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserPreferenceJsonRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.user.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserPreferenceJsonRequest clone() =>
      GetUserPreferenceJsonRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserPreferenceJsonRequest copyWith(
          void Function(GetUserPreferenceJsonRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetUserPreferenceJsonRequest))
          as GetUserPreferenceJsonRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserPreferenceJsonRequest create() =>
      GetUserPreferenceJsonRequest._();
  @$core.override
  GetUserPreferenceJsonRequest createEmptyInstance() => create();
  static $pb.PbList<GetUserPreferenceJsonRequest> createRepeated() =>
      $pb.PbList<GetUserPreferenceJsonRequest>();
  @$core.pragma('dart2js:noInline')
  static GetUserPreferenceJsonRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserPreferenceJsonRequest>(create);
  static GetUserPreferenceJsonRequest? _defaultInstance;
}

class GetUserPreferenceJsonResponse extends $pb.GeneratedMessage {
  factory GetUserPreferenceJsonResponse({
    $core.String? preferenceJson,
  }) {
    final result = create();
    if (preferenceJson != null) result.preferenceJson = preferenceJson;
    return result;
  }

  GetUserPreferenceJsonResponse._();

  factory GetUserPreferenceJsonResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUserPreferenceJsonResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUserPreferenceJsonResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.user.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'preferenceJson')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserPreferenceJsonResponse clone() =>
      GetUserPreferenceJsonResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUserPreferenceJsonResponse copyWith(
          void Function(GetUserPreferenceJsonResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetUserPreferenceJsonResponse))
          as GetUserPreferenceJsonResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUserPreferenceJsonResponse create() =>
      GetUserPreferenceJsonResponse._();
  @$core.override
  GetUserPreferenceJsonResponse createEmptyInstance() => create();
  static $pb.PbList<GetUserPreferenceJsonResponse> createRepeated() =>
      $pb.PbList<GetUserPreferenceJsonResponse>();
  @$core.pragma('dart2js:noInline')
  static GetUserPreferenceJsonResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUserPreferenceJsonResponse>(create);
  static GetUserPreferenceJsonResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get preferenceJson => $_getSZ(0);
  @$pb.TagNumber(1)
  set preferenceJson($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPreferenceJson() => $_has(0);
  @$pb.TagNumber(1)
  void clearPreferenceJson() => $_clearField(1);
}

class UpdateUserProfileRequest extends $pb.GeneratedMessage {
  factory UpdateUserProfileRequest({
    $core.String? name,
    $core.String? email,
    $core.String? identificationNumber,
    $core.String? phoneNumber,
    $core.String? address,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (email != null) result.email = email;
    if (identificationNumber != null)
      result.identificationNumber = identificationNumber;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (address != null) result.address = address;
    return result;
  }

  UpdateUserProfileRequest._();

  factory UpdateUserProfileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserProfileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserProfileRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.user.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'identificationNumber')
    ..aOS(4, _omitFieldNames ? '' : 'phoneNumber')
    ..aOS(5, _omitFieldNames ? '' : 'address')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserProfileRequest clone() =>
      UpdateUserProfileRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserProfileRequest copyWith(
          void Function(UpdateUserProfileRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateUserProfileRequest))
          as UpdateUserProfileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserProfileRequest create() => UpdateUserProfileRequest._();
  @$core.override
  UpdateUserProfileRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateUserProfileRequest> createRepeated() =>
      $pb.PbList<UpdateUserProfileRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateUserProfileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserProfileRequest>(create);
  static UpdateUserProfileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get identificationNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set identificationNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIdentificationNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearIdentificationNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get phoneNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set phoneNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPhoneNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearPhoneNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get address => $_getSZ(4);
  @$pb.TagNumber(5)
  set address($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAddress() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddress() => $_clearField(5);
}

class UserProfile extends $pb.GeneratedMessage {
  factory UserProfile({
    $core.int? id,
    $core.String? name,
    $core.String? email,
    $core.String? identificationNumber,
    $core.String? phoneNumber,
    $core.String? address,
    $0.Timestamp? dateOfBirth,
    $1.StringValue? settingJson,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (email != null) result.email = email;
    if (identificationNumber != null)
      result.identificationNumber = identificationNumber;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    if (address != null) result.address = address;
    if (dateOfBirth != null) result.dateOfBirth = dateOfBirth;
    if (settingJson != null) result.settingJson = settingJson;
    return result;
  }

  UserProfile._();

  factory UserProfile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserProfile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserProfile',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.user.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aOS(4, _omitFieldNames ? '' : 'identificationNumber')
    ..aOS(5, _omitFieldNames ? '' : 'phoneNumber')
    ..aOS(6, _omitFieldNames ? '' : 'address')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'dateOfBirth',
        subBuilder: $0.Timestamp.create)
    ..aOM<$1.StringValue>(8, _omitFieldNames ? '' : 'settingJson',
        subBuilder: $1.StringValue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserProfile clone() => UserProfile()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserProfile copyWith(void Function(UserProfile) updates) =>
      super.copyWith((message) => updates(message as UserProfile))
          as UserProfile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserProfile create() => UserProfile._();
  @$core.override
  UserProfile createEmptyInstance() => create();
  static $pb.PbList<UserProfile> createRepeated() => $pb.PbList<UserProfile>();
  @$core.pragma('dart2js:noInline')
  static UserProfile getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserProfile>(create);
  static UserProfile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get identificationNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set identificationNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIdentificationNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearIdentificationNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get phoneNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set phoneNumber($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPhoneNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhoneNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get address => $_getSZ(5);
  @$pb.TagNumber(6)
  set address($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAddress() => $_has(5);
  @$pb.TagNumber(6)
  void clearAddress() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get dateOfBirth => $_getN(6);
  @$pb.TagNumber(7)
  set dateOfBirth($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDateOfBirth() => $_has(6);
  @$pb.TagNumber(7)
  void clearDateOfBirth() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureDateOfBirth() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.StringValue get settingJson => $_getN(7);
  @$pb.TagNumber(8)
  set settingJson($1.StringValue value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSettingJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearSettingJson() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.StringValue ensureSettingJson() => $_ensure(7);
}

class UserServiceApi {
  final $pb.RpcClient _client;

  UserServiceApi(this._client);

  $async.Future<UserProfile> getUserProfile(
          $pb.ClientContext? ctx, GetUserProfileRequest request) =>
      _client.invoke<UserProfile>(
          ctx, 'UserService', 'GetUserProfile', request, UserProfile());
  $async.Future<GetUserPreferenceJsonResponse> getUserPreferenceJson(
          $pb.ClientContext? ctx, GetUserPreferenceJsonRequest request) =>
      _client.invoke<GetUserPreferenceJsonResponse>(ctx, 'UserService',
          'GetUserPreferenceJson', request, GetUserPreferenceJsonResponse());
  $async.Future<UserProfile> updateUserProfile(
          $pb.ClientContext? ctx, UpdateUserProfileRequest request) =>
      _client.invoke<UserProfile>(
          ctx, 'UserService', 'UpdateUserProfile', request, UserProfile());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
