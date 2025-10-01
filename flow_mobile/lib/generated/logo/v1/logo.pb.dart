// This is a generated file - do not edit.
//
// Generated from logo/v1/logo.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetLogoRequest extends $pb.GeneratedMessage {
  factory GetLogoRequest({
    $core.String? brandDomain,
  }) {
    final result = create();
    if (brandDomain != null) result.brandDomain = brandDomain;
    return result;
  }

  GetLogoRequest._();

  factory GetLogoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLogoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLogoRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.logo.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'brandDomain')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLogoRequest clone() => GetLogoRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLogoRequest copyWith(void Function(GetLogoRequest) updates) =>
      super.copyWith((message) => updates(message as GetLogoRequest))
          as GetLogoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLogoRequest create() => GetLogoRequest._();
  @$core.override
  GetLogoRequest createEmptyInstance() => create();
  static $pb.PbList<GetLogoRequest> createRepeated() =>
      $pb.PbList<GetLogoRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLogoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLogoRequest>(create);
  static GetLogoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get brandDomain => $_getSZ(0);
  @$pb.TagNumber(1)
  set brandDomain($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBrandDomain() => $_has(0);
  @$pb.TagNumber(1)
  void clearBrandDomain() => $_clearField(1);
}

class GetLogoResponse extends $pb.GeneratedMessage {
  factory GetLogoResponse({
    $core.bool? success,
    $core.String? logoUrl,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (logoUrl != null) result.logoUrl = logoUrl;
    return result;
  }

  GetLogoResponse._();

  factory GetLogoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLogoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLogoResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.logo.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'logoUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLogoResponse clone() => GetLogoResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLogoResponse copyWith(void Function(GetLogoResponse) updates) =>
      super.copyWith((message) => updates(message as GetLogoResponse))
          as GetLogoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLogoResponse create() => GetLogoResponse._();
  @$core.override
  GetLogoResponse createEmptyInstance() => create();
  static $pb.PbList<GetLogoResponse> createRepeated() =>
      $pb.PbList<GetLogoResponse>();
  @$core.pragma('dart2js:noInline')
  static GetLogoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLogoResponse>(create);
  static GetLogoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get logoUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set logoUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLogoUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearLogoUrl() => $_clearField(2);
}

class UploadLogoRequest extends $pb.GeneratedMessage {
  factory UploadLogoRequest({
    $core.String? brandDomain,
    $core.List<$core.int>? logo,
  }) {
    final result = create();
    if (brandDomain != null) result.brandDomain = brandDomain;
    if (logo != null) result.logo = logo;
    return result;
  }

  UploadLogoRequest._();

  factory UploadLogoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadLogoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadLogoRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.logo.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'brandDomain')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'logo', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadLogoRequest clone() => UploadLogoRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadLogoRequest copyWith(void Function(UploadLogoRequest) updates) =>
      super.copyWith((message) => updates(message as UploadLogoRequest))
          as UploadLogoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadLogoRequest create() => UploadLogoRequest._();
  @$core.override
  UploadLogoRequest createEmptyInstance() => create();
  static $pb.PbList<UploadLogoRequest> createRepeated() =>
      $pb.PbList<UploadLogoRequest>();
  @$core.pragma('dart2js:noInline')
  static UploadLogoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadLogoRequest>(create);
  static UploadLogoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get brandDomain => $_getSZ(0);
  @$pb.TagNumber(1)
  set brandDomain($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBrandDomain() => $_has(0);
  @$pb.TagNumber(1)
  void clearBrandDomain() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get logo => $_getN(1);
  @$pb.TagNumber(2)
  set logo($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLogo() => $_has(1);
  @$pb.TagNumber(2)
  void clearLogo() => $_clearField(2);
}

class UploadLogoResponse extends $pb.GeneratedMessage {
  factory UploadLogoResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  UploadLogoResponse._();

  factory UploadLogoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadLogoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadLogoResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.logo.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadLogoResponse clone() => UploadLogoResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadLogoResponse copyWith(void Function(UploadLogoResponse) updates) =>
      super.copyWith((message) => updates(message as UploadLogoResponse))
          as UploadLogoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadLogoResponse create() => UploadLogoResponse._();
  @$core.override
  UploadLogoResponse createEmptyInstance() => create();
  static $pb.PbList<UploadLogoResponse> createRepeated() =>
      $pb.PbList<UploadLogoResponse>();
  @$core.pragma('dart2js:noInline')
  static UploadLogoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadLogoResponse>(create);
  static UploadLogoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
