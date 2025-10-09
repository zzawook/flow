// This is a generated file - do not edit.
//
// Generated from auth/v1/auth.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CheckUserExistsRequest extends $pb.GeneratedMessage {
  factory CheckUserExistsRequest({
    $core.String? email,
  }) {
    final result = create();
    if (email != null) result.email = email;
    return result;
  }

  CheckUserExistsRequest._();

  factory CheckUserExistsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckUserExistsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckUserExistsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckUserExistsRequest clone() =>
      CheckUserExistsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckUserExistsRequest copyWith(
          void Function(CheckUserExistsRequest) updates) =>
      super.copyWith((message) => updates(message as CheckUserExistsRequest))
          as CheckUserExistsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckUserExistsRequest create() => CheckUserExistsRequest._();
  @$core.override
  CheckUserExistsRequest createEmptyInstance() => create();
  static $pb.PbList<CheckUserExistsRequest> createRepeated() =>
      $pb.PbList<CheckUserExistsRequest>();
  @$core.pragma('dart2js:noInline')
  static CheckUserExistsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckUserExistsRequest>(create);
  static CheckUserExistsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);
}

class CheckUserExistsResponse extends $pb.GeneratedMessage {
  factory CheckUserExistsResponse({
    $core.bool? exists,
  }) {
    final result = create();
    if (exists != null) result.exists = exists;
    return result;
  }

  CheckUserExistsResponse._();

  factory CheckUserExistsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckUserExistsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckUserExistsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'exists')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckUserExistsResponse clone() =>
      CheckUserExistsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckUserExistsResponse copyWith(
          void Function(CheckUserExistsResponse) updates) =>
      super.copyWith((message) => updates(message as CheckUserExistsResponse))
          as CheckUserExistsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckUserExistsResponse create() => CheckUserExistsResponse._();
  @$core.override
  CheckUserExistsResponse createEmptyInstance() => create();
  static $pb.PbList<CheckUserExistsResponse> createRepeated() =>
      $pb.PbList<CheckUserExistsResponse>();
  @$core.pragma('dart2js:noInline')
  static CheckUserExistsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckUserExistsResponse>(create);
  static CheckUserExistsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get exists => $_getBF(0);
  @$pb.TagNumber(1)
  set exists($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExists() => $_has(0);
  @$pb.TagNumber(1)
  void clearExists() => $_clearField(1);
}

class SignUpRequest extends $pb.GeneratedMessage {
  factory SignUpRequest({
    $core.String? email,
    $core.String? password,
    $core.String? name,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (password != null) result.password = password;
    if (name != null) result.name = name;
    return result;
  }

  SignUpRequest._();

  factory SignUpRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignUpRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignUpRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignUpRequest clone() => SignUpRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignUpRequest copyWith(void Function(SignUpRequest) updates) =>
      super.copyWith((message) => updates(message as SignUpRequest))
          as SignUpRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignUpRequest create() => SignUpRequest._();
  @$core.override
  SignUpRequest createEmptyInstance() => create();
  static $pb.PbList<SignUpRequest> createRepeated() =>
      $pb.PbList<SignUpRequest>();
  @$core.pragma('dart2js:noInline')
  static SignUpRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignUpRequest>(create);
  static SignUpRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
}

class SignInRequest extends $pb.GeneratedMessage {
  factory SignInRequest({
    $core.String? email,
    $core.String? password,
  }) {
    final result = create();
    if (email != null) result.email = email;
    if (password != null) result.password = password;
    return result;
  }

  SignInRequest._();

  factory SignInRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignInRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignInRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignInRequest clone() => SignInRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignInRequest copyWith(void Function(SignInRequest) updates) =>
      super.copyWith((message) => updates(message as SignInRequest))
          as SignInRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignInRequest create() => SignInRequest._();
  @$core.override
  SignInRequest createEmptyInstance() => create();
  static $pb.PbList<SignInRequest> createRepeated() =>
      $pb.PbList<SignInRequest>();
  @$core.pragma('dart2js:noInline')
  static SignInRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignInRequest>(create);
  static SignInRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => $_clearField(2);
}

class SignOutRequest extends $pb.GeneratedMessage {
  factory SignOutRequest({
    $core.String? accessToken,
  }) {
    final result = create();
    if (accessToken != null) result.accessToken = accessToken;
    return result;
  }

  SignOutRequest._();

  factory SignOutRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignOutRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignOutRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accessToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOutRequest clone() => SignOutRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOutRequest copyWith(void Function(SignOutRequest) updates) =>
      super.copyWith((message) => updates(message as SignOutRequest))
          as SignOutRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignOutRequest create() => SignOutRequest._();
  @$core.override
  SignOutRequest createEmptyInstance() => create();
  static $pb.PbList<SignOutRequest> createRepeated() =>
      $pb.PbList<SignOutRequest>();
  @$core.pragma('dart2js:noInline')
  static SignOutRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignOutRequest>(create);
  static SignOutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accessToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set accessToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccessToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccessToken() => $_clearField(1);
}

class SignOutResponse extends $pb.GeneratedMessage {
  factory SignOutResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  SignOutResponse._();

  factory SignOutResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignOutResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignOutResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOutResponse clone() => SignOutResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOutResponse copyWith(void Function(SignOutResponse) updates) =>
      super.copyWith((message) => updates(message as SignOutResponse))
          as SignOutResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignOutResponse create() => SignOutResponse._();
  @$core.override
  SignOutResponse createEmptyInstance() => create();
  static $pb.PbList<SignOutResponse> createRepeated() =>
      $pb.PbList<SignOutResponse>();
  @$core.pragma('dart2js:noInline')
  static SignOutResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignOutResponse>(create);
  static SignOutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class AccessTokenRefreshRequest extends $pb.GeneratedMessage {
  factory AccessTokenRefreshRequest({
    $core.String? refreshToken,
  }) {
    final result = create();
    if (refreshToken != null) result.refreshToken = refreshToken;
    return result;
  }

  AccessTokenRefreshRequest._();

  factory AccessTokenRefreshRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AccessTokenRefreshRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AccessTokenRefreshRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'refreshToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccessTokenRefreshRequest clone() =>
      AccessTokenRefreshRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AccessTokenRefreshRequest copyWith(
          void Function(AccessTokenRefreshRequest) updates) =>
      super.copyWith((message) => updates(message as AccessTokenRefreshRequest))
          as AccessTokenRefreshRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AccessTokenRefreshRequest create() => AccessTokenRefreshRequest._();
  @$core.override
  AccessTokenRefreshRequest createEmptyInstance() => create();
  static $pb.PbList<AccessTokenRefreshRequest> createRepeated() =>
      $pb.PbList<AccessTokenRefreshRequest>();
  @$core.pragma('dart2js:noInline')
  static AccessTokenRefreshRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AccessTokenRefreshRequest>(create);
  static AccessTokenRefreshRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get refreshToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set refreshToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRefreshToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefreshToken() => $_clearField(1);
}

class TokenSet extends $pb.GeneratedMessage {
  factory TokenSet({
    $core.String? accessToken,
    $core.String? refreshToken,
  }) {
    final result = create();
    if (accessToken != null) result.accessToken = accessToken;
    if (refreshToken != null) result.refreshToken = refreshToken;
    return result;
  }

  TokenSet._();

  factory TokenSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TokenSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TokenSet',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accessToken')
    ..aOS(2, _omitFieldNames ? '' : 'refreshToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TokenSet clone() => TokenSet()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TokenSet copyWith(void Function(TokenSet) updates) =>
      super.copyWith((message) => updates(message as TokenSet)) as TokenSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TokenSet create() => TokenSet._();
  @$core.override
  TokenSet createEmptyInstance() => create();
  static $pb.PbList<TokenSet> createRepeated() => $pb.PbList<TokenSet>();
  @$core.pragma('dart2js:noInline')
  static TokenSet getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TokenSet>(create);
  static TokenSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accessToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set accessToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccessToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccessToken() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get refreshToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set refreshToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRefreshToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearRefreshToken() => $_clearField(2);
}

class SendVerificationEmailRequest extends $pb.GeneratedMessage {
  factory SendVerificationEmailRequest({
    $core.String? email,
  }) {
    final result = create();
    if (email != null) result.email = email;
    return result;
  }

  SendVerificationEmailRequest._();

  factory SendVerificationEmailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendVerificationEmailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendVerificationEmailRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationEmailRequest clone() =>
      SendVerificationEmailRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationEmailRequest copyWith(
          void Function(SendVerificationEmailRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SendVerificationEmailRequest))
          as SendVerificationEmailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerificationEmailRequest create() =>
      SendVerificationEmailRequest._();
  @$core.override
  SendVerificationEmailRequest createEmptyInstance() => create();
  static $pb.PbList<SendVerificationEmailRequest> createRepeated() =>
      $pb.PbList<SendVerificationEmailRequest>();
  @$core.pragma('dart2js:noInline')
  static SendVerificationEmailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendVerificationEmailRequest>(create);
  static SendVerificationEmailRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);
}

class SendVerificationEmailResponse extends $pb.GeneratedMessage {
  factory SendVerificationEmailResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  SendVerificationEmailResponse._();

  factory SendVerificationEmailResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SendVerificationEmailResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SendVerificationEmailResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationEmailResponse clone() =>
      SendVerificationEmailResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SendVerificationEmailResponse copyWith(
          void Function(SendVerificationEmailResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SendVerificationEmailResponse))
          as SendVerificationEmailResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendVerificationEmailResponse create() =>
      SendVerificationEmailResponse._();
  @$core.override
  SendVerificationEmailResponse createEmptyInstance() => create();
  static $pb.PbList<SendVerificationEmailResponse> createRepeated() =>
      $pb.PbList<SendVerificationEmailResponse>();
  @$core.pragma('dart2js:noInline')
  static SendVerificationEmailResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SendVerificationEmailResponse>(create);
  static SendVerificationEmailResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class CheckEmailVerifiedRequest extends $pb.GeneratedMessage {
  factory CheckEmailVerifiedRequest({
    $core.String? email,
  }) {
    final result = create();
    if (email != null) result.email = email;
    return result;
  }

  CheckEmailVerifiedRequest._();

  factory CheckEmailVerifiedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckEmailVerifiedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckEmailVerifiedRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckEmailVerifiedRequest clone() =>
      CheckEmailVerifiedRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckEmailVerifiedRequest copyWith(
          void Function(CheckEmailVerifiedRequest) updates) =>
      super.copyWith((message) => updates(message as CheckEmailVerifiedRequest))
          as CheckEmailVerifiedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckEmailVerifiedRequest create() => CheckEmailVerifiedRequest._();
  @$core.override
  CheckEmailVerifiedRequest createEmptyInstance() => create();
  static $pb.PbList<CheckEmailVerifiedRequest> createRepeated() =>
      $pb.PbList<CheckEmailVerifiedRequest>();
  @$core.pragma('dart2js:noInline')
  static CheckEmailVerifiedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckEmailVerifiedRequest>(create);
  static CheckEmailVerifiedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => $_clearField(1);
}

class CheckEmailVerifiedResponse extends $pb.GeneratedMessage {
  factory CheckEmailVerifiedResponse({
    $core.bool? verified,
  }) {
    final result = create();
    if (verified != null) result.verified = verified;
    return result;
  }

  CheckEmailVerifiedResponse._();

  factory CheckEmailVerifiedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckEmailVerifiedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckEmailVerifiedResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.auth.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'verified')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckEmailVerifiedResponse clone() =>
      CheckEmailVerifiedResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckEmailVerifiedResponse copyWith(
          void Function(CheckEmailVerifiedResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CheckEmailVerifiedResponse))
          as CheckEmailVerifiedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckEmailVerifiedResponse create() => CheckEmailVerifiedResponse._();
  @$core.override
  CheckEmailVerifiedResponse createEmptyInstance() => create();
  static $pb.PbList<CheckEmailVerifiedResponse> createRepeated() =>
      $pb.PbList<CheckEmailVerifiedResponse>();
  @$core.pragma('dart2js:noInline')
  static CheckEmailVerifiedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckEmailVerifiedResponse>(create);
  static CheckEmailVerifiedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get verified => $_getBF(0);
  @$pb.TagNumber(1)
  set verified($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVerified() => $_has(0);
  @$pb.TagNumber(1)
  void clearVerified() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
