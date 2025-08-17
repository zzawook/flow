// This is a generated file - do not edit.
//
// Generated from refresh/v1/refresh.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// ── Requests ──
class GetRefreshUrlRequest extends $pb.GeneratedMessage {
  factory GetRefreshUrlRequest({
    $core.String? institutionId,
    $core.String? countryCode,
  }) {
    final result = create();
    if (institutionId != null) result.institutionId = institutionId;
    if (countryCode != null) result.countryCode = countryCode;
    return result;
  }

  GetRefreshUrlRequest._();

  factory GetRefreshUrlRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRefreshUrlRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRefreshUrlRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'institutionId')
    ..aOS(2, _omitFieldNames ? '' : 'countryCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRefreshUrlRequest clone() =>
      GetRefreshUrlRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRefreshUrlRequest copyWith(void Function(GetRefreshUrlRequest) updates) =>
      super.copyWith((message) => updates(message as GetRefreshUrlRequest))
          as GetRefreshUrlRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRefreshUrlRequest create() => GetRefreshUrlRequest._();
  @$core.override
  GetRefreshUrlRequest createEmptyInstance() => create();
  static $pb.PbList<GetRefreshUrlRequest> createRepeated() =>
      $pb.PbList<GetRefreshUrlRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRefreshUrlRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRefreshUrlRequest>(create);
  static GetRefreshUrlRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get institutionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set institutionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstitutionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get countryCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set countryCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCountryCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCountryCode() => $_clearField(2);
}

class GetRelinkUrlRequest extends $pb.GeneratedMessage {
  factory GetRelinkUrlRequest({
    $core.String? institutionId,
    $core.String? countryCode,
  }) {
    final result = create();
    if (institutionId != null) result.institutionId = institutionId;
    if (countryCode != null) result.countryCode = countryCode;
    return result;
  }

  GetRelinkUrlRequest._();

  factory GetRelinkUrlRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRelinkUrlRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRelinkUrlRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'institutionId')
    ..aOS(2, _omitFieldNames ? '' : 'countryCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelinkUrlRequest clone() => GetRelinkUrlRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelinkUrlRequest copyWith(void Function(GetRelinkUrlRequest) updates) =>
      super.copyWith((message) => updates(message as GetRelinkUrlRequest))
          as GetRelinkUrlRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRelinkUrlRequest create() => GetRelinkUrlRequest._();
  @$core.override
  GetRelinkUrlRequest createEmptyInstance() => create();
  static $pb.PbList<GetRelinkUrlRequest> createRepeated() =>
      $pb.PbList<GetRelinkUrlRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRelinkUrlRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRelinkUrlRequest>(create);
  static GetRelinkUrlRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get institutionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set institutionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstitutionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get countryCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set countryCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCountryCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCountryCode() => $_clearField(2);
}

class CanStartRefreshSessionRequest extends $pb.GeneratedMessage {
  factory CanStartRefreshSessionRequest({
    $core.String? institutionId,
  }) {
    final result = create();
    if (institutionId != null) result.institutionId = institutionId;
    return result;
  }

  CanStartRefreshSessionRequest._();

  factory CanStartRefreshSessionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CanStartRefreshSessionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CanStartRefreshSessionRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'institutionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanStartRefreshSessionRequest clone() =>
      CanStartRefreshSessionRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanStartRefreshSessionRequest copyWith(
          void Function(CanStartRefreshSessionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CanStartRefreshSessionRequest))
          as CanStartRefreshSessionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CanStartRefreshSessionRequest create() =>
      CanStartRefreshSessionRequest._();
  @$core.override
  CanStartRefreshSessionRequest createEmptyInstance() => create();
  static $pb.PbList<CanStartRefreshSessionRequest> createRepeated() =>
      $pb.PbList<CanStartRefreshSessionRequest>();
  @$core.pragma('dart2js:noInline')
  static CanStartRefreshSessionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CanStartRefreshSessionRequest>(create);
  static CanStartRefreshSessionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get institutionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set institutionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstitutionId() => $_clearField(1);
}

class CanStartRefreshSessionResponse extends $pb.GeneratedMessage {
  factory CanStartRefreshSessionResponse({
    $core.bool? canStart,
    $core.String? description,
  }) {
    final result = create();
    if (canStart != null) result.canStart = canStart;
    if (description != null) result.description = description;
    return result;
  }

  CanStartRefreshSessionResponse._();

  factory CanStartRefreshSessionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CanStartRefreshSessionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CanStartRefreshSessionResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'canStart')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanStartRefreshSessionResponse clone() =>
      CanStartRefreshSessionResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanStartRefreshSessionResponse copyWith(
          void Function(CanStartRefreshSessionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CanStartRefreshSessionResponse))
          as CanStartRefreshSessionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CanStartRefreshSessionResponse create() =>
      CanStartRefreshSessionResponse._();
  @$core.override
  CanStartRefreshSessionResponse createEmptyInstance() => create();
  static $pb.PbList<CanStartRefreshSessionResponse> createRepeated() =>
      $pb.PbList<CanStartRefreshSessionResponse>();
  @$core.pragma('dart2js:noInline')
  static CanStartRefreshSessionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CanStartRefreshSessionResponse>(create);
  static CanStartRefreshSessionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get canStart => $_getBF(0);
  @$pb.TagNumber(1)
  set canStart($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCanStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearCanStart() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);
}

class GetRefreshUrlResponse extends $pb.GeneratedMessage {
  factory GetRefreshUrlResponse({
    $core.String? refreshUrl,
  }) {
    final result = create();
    if (refreshUrl != null) result.refreshUrl = refreshUrl;
    return result;
  }

  GetRefreshUrlResponse._();

  factory GetRefreshUrlResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRefreshUrlResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRefreshUrlResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'refreshUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRefreshUrlResponse clone() =>
      GetRefreshUrlResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRefreshUrlResponse copyWith(
          void Function(GetRefreshUrlResponse) updates) =>
      super.copyWith((message) => updates(message as GetRefreshUrlResponse))
          as GetRefreshUrlResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRefreshUrlResponse create() => GetRefreshUrlResponse._();
  @$core.override
  GetRefreshUrlResponse createEmptyInstance() => create();
  static $pb.PbList<GetRefreshUrlResponse> createRepeated() =>
      $pb.PbList<GetRefreshUrlResponse>();
  @$core.pragma('dart2js:noInline')
  static GetRefreshUrlResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRefreshUrlResponse>(create);
  static GetRefreshUrlResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get refreshUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set refreshUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRefreshUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefreshUrl() => $_clearField(1);
}

class GetRelinkUrlResponse extends $pb.GeneratedMessage {
  factory GetRelinkUrlResponse({
    $core.String? relinkUrl,
  }) {
    final result = create();
    if (relinkUrl != null) result.relinkUrl = relinkUrl;
    return result;
  }

  GetRelinkUrlResponse._();

  factory GetRelinkUrlResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRelinkUrlResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRelinkUrlResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'relinkUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelinkUrlResponse clone() =>
      GetRelinkUrlResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRelinkUrlResponse copyWith(void Function(GetRelinkUrlResponse) updates) =>
      super.copyWith((message) => updates(message as GetRelinkUrlResponse))
          as GetRelinkUrlResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRelinkUrlResponse create() => GetRelinkUrlResponse._();
  @$core.override
  GetRelinkUrlResponse createEmptyInstance() => create();
  static $pb.PbList<GetRelinkUrlResponse> createRepeated() =>
      $pb.PbList<GetRelinkUrlResponse>();
  @$core.pragma('dart2js:noInline')
  static GetRelinkUrlResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRelinkUrlResponse>(create);
  static GetRelinkUrlResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get relinkUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set relinkUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRelinkUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearRelinkUrl() => $_clearField(1);
}

class GetInstitutionAuthenticationResultRequest extends $pb.GeneratedMessage {
  factory GetInstitutionAuthenticationResultRequest({
    $core.String? institutionId,
    $core.String? state,
  }) {
    final result = create();
    if (institutionId != null) result.institutionId = institutionId;
    if (state != null) result.state = state;
    return result;
  }

  GetInstitutionAuthenticationResultRequest._();

  factory GetInstitutionAuthenticationResultRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetInstitutionAuthenticationResultRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInstitutionAuthenticationResultRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'institutionId')
    ..aOS(2, _omitFieldNames ? '' : 'state')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstitutionAuthenticationResultRequest clone() =>
      GetInstitutionAuthenticationResultRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstitutionAuthenticationResultRequest copyWith(
          void Function(GetInstitutionAuthenticationResultRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetInstitutionAuthenticationResultRequest))
          as GetInstitutionAuthenticationResultRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetInstitutionAuthenticationResultRequest create() =>
      GetInstitutionAuthenticationResultRequest._();
  @$core.override
  GetInstitutionAuthenticationResultRequest createEmptyInstance() => create();
  static $pb.PbList<GetInstitutionAuthenticationResultRequest>
      createRepeated() =>
          $pb.PbList<GetInstitutionAuthenticationResultRequest>();
  @$core.pragma('dart2js:noInline')
  static GetInstitutionAuthenticationResultRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetInstitutionAuthenticationResultRequest>(create);
  static GetInstitutionAuthenticationResultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get institutionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set institutionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstitutionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get state => $_getSZ(1);
  @$pb.TagNumber(2)
  set state($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);
}

class GetInstitutionAuthenticationResultResponse extends $pb.GeneratedMessage {
  factory GetInstitutionAuthenticationResultResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  GetInstitutionAuthenticationResultResponse._();

  factory GetInstitutionAuthenticationResultResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetInstitutionAuthenticationResultResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInstitutionAuthenticationResultResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstitutionAuthenticationResultResponse clone() =>
      GetInstitutionAuthenticationResultResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInstitutionAuthenticationResultResponse copyWith(
          void Function(GetInstitutionAuthenticationResultResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GetInstitutionAuthenticationResultResponse))
          as GetInstitutionAuthenticationResultResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetInstitutionAuthenticationResultResponse create() =>
      GetInstitutionAuthenticationResultResponse._();
  @$core.override
  GetInstitutionAuthenticationResultResponse createEmptyInstance() => create();
  static $pb.PbList<GetInstitutionAuthenticationResultResponse>
      createRepeated() =>
          $pb.PbList<GetInstitutionAuthenticationResultResponse>();
  @$core.pragma('dart2js:noInline')
  static GetInstitutionAuthenticationResultResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetInstitutionAuthenticationResultResponse>(create);
  static GetInstitutionAuthenticationResultResponse? _defaultInstance;

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

class GetDataRetrievalResultRequest extends $pb.GeneratedMessage {
  factory GetDataRetrievalResultRequest({
    $core.String? institutionId,
  }) {
    final result = create();
    if (institutionId != null) result.institutionId = institutionId;
    return result;
  }

  GetDataRetrievalResultRequest._();

  factory GetDataRetrievalResultRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDataRetrievalResultRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDataRetrievalResultRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'institutionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDataRetrievalResultRequest clone() =>
      GetDataRetrievalResultRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDataRetrievalResultRequest copyWith(
          void Function(GetDataRetrievalResultRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDataRetrievalResultRequest))
          as GetDataRetrievalResultRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDataRetrievalResultRequest create() =>
      GetDataRetrievalResultRequest._();
  @$core.override
  GetDataRetrievalResultRequest createEmptyInstance() => create();
  static $pb.PbList<GetDataRetrievalResultRequest> createRepeated() =>
      $pb.PbList<GetDataRetrievalResultRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDataRetrievalResultRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDataRetrievalResultRequest>(create);
  static GetDataRetrievalResultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get institutionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set institutionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstitutionId() => $_clearField(1);
}

class GetDataRetrievalResultResponse extends $pb.GeneratedMessage {
  factory GetDataRetrievalResultResponse({
    $core.bool? success,
    $core.String? message,
  }) {
    final result = create();
    if (success != null) result.success = success;
    if (message != null) result.message = message;
    return result;
  }

  GetDataRetrievalResultResponse._();

  factory GetDataRetrievalResultResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDataRetrievalResultResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDataRetrievalResultResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDataRetrievalResultResponse clone() =>
      GetDataRetrievalResultResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDataRetrievalResultResponse copyWith(
          void Function(GetDataRetrievalResultResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetDataRetrievalResultResponse))
          as GetDataRetrievalResultResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDataRetrievalResultResponse create() =>
      GetDataRetrievalResultResponse._();
  @$core.override
  GetDataRetrievalResultResponse createEmptyInstance() => create();
  static $pb.PbList<GetDataRetrievalResultResponse> createRepeated() =>
      $pb.PbList<GetDataRetrievalResultResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDataRetrievalResultResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDataRetrievalResultResponse>(create);
  static GetDataRetrievalResultResponse? _defaultInstance;

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
