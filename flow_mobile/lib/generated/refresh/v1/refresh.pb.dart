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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/bank.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class GetAllRunningRefreshSessionsRequest extends $pb.GeneratedMessage {
  factory GetAllRunningRefreshSessionsRequest() => create();

  GetAllRunningRefreshSessionsRequest._();

  factory GetAllRunningRefreshSessionsRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAllRunningRefreshSessionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAllRunningRefreshSessionsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllRunningRefreshSessionsRequest clone() =>
      GetAllRunningRefreshSessionsRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllRunningRefreshSessionsRequest copyWith(
          void Function(GetAllRunningRefreshSessionsRequest) updates) =>
      super.copyWith((message) =>
              updates(message as GetAllRunningRefreshSessionsRequest))
          as GetAllRunningRefreshSessionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAllRunningRefreshSessionsRequest create() =>
      GetAllRunningRefreshSessionsRequest._();
  @$core.override
  GetAllRunningRefreshSessionsRequest createEmptyInstance() => create();
  static $pb.PbList<GetAllRunningRefreshSessionsRequest> createRepeated() =>
      $pb.PbList<GetAllRunningRefreshSessionsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAllRunningRefreshSessionsRequest getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetAllRunningRefreshSessionsRequest>(create);
  static GetAllRunningRefreshSessionsRequest? _defaultInstance;
}

class GetAllRunningRefreshSessionsResponse extends $pb.GeneratedMessage {
  factory GetAllRunningRefreshSessionsResponse({
    $core.Iterable<$fixnum.Int64>? institutionIds,
  }) {
    final result = create();
    if (institutionIds != null) result.institutionIds.addAll(institutionIds);
    return result;
  }

  GetAllRunningRefreshSessionsResponse._();

  factory GetAllRunningRefreshSessionsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAllRunningRefreshSessionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAllRunningRefreshSessionsResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..p<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'institutionIds', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllRunningRefreshSessionsResponse clone() =>
      GetAllRunningRefreshSessionsResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAllRunningRefreshSessionsResponse copyWith(
          void Function(GetAllRunningRefreshSessionsResponse) updates) =>
      super.copyWith((message) =>
              updates(message as GetAllRunningRefreshSessionsResponse))
          as GetAllRunningRefreshSessionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAllRunningRefreshSessionsResponse create() =>
      GetAllRunningRefreshSessionsResponse._();
  @$core.override
  GetAllRunningRefreshSessionsResponse createEmptyInstance() => create();
  static $pb.PbList<GetAllRunningRefreshSessionsResponse> createRepeated() =>
      $pb.PbList<GetAllRunningRefreshSessionsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetAllRunningRefreshSessionsResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          GetAllRunningRefreshSessionsResponse>(create);
  static GetAllRunningRefreshSessionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$fixnum.Int64> get institutionIds => $_getList(0);
}

class UpdateLoginMemoForBankRequest extends $pb.GeneratedMessage {
  factory UpdateLoginMemoForBankRequest({
    $fixnum.Int64? institutionId,
    $core.String? loginMemo,
  }) {
    final result = create();
    if (institutionId != null) result.institutionId = institutionId;
    if (loginMemo != null) result.loginMemo = loginMemo;
    return result;
  }

  UpdateLoginMemoForBankRequest._();

  factory UpdateLoginMemoForBankRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateLoginMemoForBankRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateLoginMemoForBankRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'institutionId')
    ..aOS(2, _omitFieldNames ? '' : 'loginMemo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLoginMemoForBankRequest clone() =>
      UpdateLoginMemoForBankRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLoginMemoForBankRequest copyWith(
          void Function(UpdateLoginMemoForBankRequest) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateLoginMemoForBankRequest))
          as UpdateLoginMemoForBankRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateLoginMemoForBankRequest create() =>
      UpdateLoginMemoForBankRequest._();
  @$core.override
  UpdateLoginMemoForBankRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateLoginMemoForBankRequest> createRepeated() =>
      $pb.PbList<UpdateLoginMemoForBankRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateLoginMemoForBankRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateLoginMemoForBankRequest>(create);
  static UpdateLoginMemoForBankRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get institutionId => $_getI64(0);
  @$pb.TagNumber(1)
  set institutionId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstitutionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get loginMemo => $_getSZ(1);
  @$pb.TagNumber(2)
  set loginMemo($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLoginMemo() => $_has(1);
  @$pb.TagNumber(2)
  void clearLoginMemo() => $_clearField(2);
}

class UpdateLoginMemoForBankResponse extends $pb.GeneratedMessage {
  factory UpdateLoginMemoForBankResponse({
    $core.bool? success,
  }) {
    final result = create();
    if (success != null) result.success = success;
    return result;
  }

  UpdateLoginMemoForBankResponse._();

  factory UpdateLoginMemoForBankResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateLoginMemoForBankResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateLoginMemoForBankResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'success')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLoginMemoForBankResponse clone() =>
      UpdateLoginMemoForBankResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateLoginMemoForBankResponse copyWith(
          void Function(UpdateLoginMemoForBankResponse) updates) =>
      super.copyWith(
              (message) => updates(message as UpdateLoginMemoForBankResponse))
          as UpdateLoginMemoForBankResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateLoginMemoForBankResponse create() =>
      UpdateLoginMemoForBankResponse._();
  @$core.override
  UpdateLoginMemoForBankResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateLoginMemoForBankResponse> createRepeated() =>
      $pb.PbList<UpdateLoginMemoForBankResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateLoginMemoForBankResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateLoginMemoForBankResponse>(create);
  static UpdateLoginMemoForBankResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get success => $_getBF(0);
  @$pb.TagNumber(1)
  set success($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearSuccess() => $_clearField(1);
}

class GetLoginMemoForBankRequest extends $pb.GeneratedMessage {
  factory GetLoginMemoForBankRequest({
    $fixnum.Int64? institutionId,
  }) {
    final result = create();
    if (institutionId != null) result.institutionId = institutionId;
    return result;
  }

  GetLoginMemoForBankRequest._();

  factory GetLoginMemoForBankRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLoginMemoForBankRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLoginMemoForBankRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'institutionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLoginMemoForBankRequest clone() =>
      GetLoginMemoForBankRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLoginMemoForBankRequest copyWith(
          void Function(GetLoginMemoForBankRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetLoginMemoForBankRequest))
          as GetLoginMemoForBankRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLoginMemoForBankRequest create() => GetLoginMemoForBankRequest._();
  @$core.override
  GetLoginMemoForBankRequest createEmptyInstance() => create();
  static $pb.PbList<GetLoginMemoForBankRequest> createRepeated() =>
      $pb.PbList<GetLoginMemoForBankRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLoginMemoForBankRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLoginMemoForBankRequest>(create);
  static GetLoginMemoForBankRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get institutionId => $_getI64(0);
  @$pb.TagNumber(1)
  set institutionId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInstitutionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstitutionId() => $_clearField(1);
}

class GetLoginMemoForBankResponse extends $pb.GeneratedMessage {
  factory GetLoginMemoForBankResponse({
    $core.String? loginMemo,
  }) {
    final result = create();
    if (loginMemo != null) result.loginMemo = loginMemo;
    return result;
  }

  GetLoginMemoForBankResponse._();

  factory GetLoginMemoForBankResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLoginMemoForBankResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLoginMemoForBankResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'loginMemo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLoginMemoForBankResponse clone() =>
      GetLoginMemoForBankResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLoginMemoForBankResponse copyWith(
          void Function(GetLoginMemoForBankResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetLoginMemoForBankResponse))
          as GetLoginMemoForBankResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLoginMemoForBankResponse create() =>
      GetLoginMemoForBankResponse._();
  @$core.override
  GetLoginMemoForBankResponse createEmptyInstance() => create();
  static $pb.PbList<GetLoginMemoForBankResponse> createRepeated() =>
      $pb.PbList<GetLoginMemoForBankResponse>();
  @$core.pragma('dart2js:noInline')
  static GetLoginMemoForBankResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLoginMemoForBankResponse>(create);
  static GetLoginMemoForBankResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get loginMemo => $_getSZ(0);
  @$pb.TagNumber(1)
  set loginMemo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLoginMemo() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoginMemo() => $_clearField(1);
}

class CanLinkBankRequest extends $pb.GeneratedMessage {
  factory CanLinkBankRequest() => create();

  CanLinkBankRequest._();

  factory CanLinkBankRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CanLinkBankRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CanLinkBankRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanLinkBankRequest clone() => CanLinkBankRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanLinkBankRequest copyWith(void Function(CanLinkBankRequest) updates) =>
      super.copyWith((message) => updates(message as CanLinkBankRequest))
          as CanLinkBankRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CanLinkBankRequest create() => CanLinkBankRequest._();
  @$core.override
  CanLinkBankRequest createEmptyInstance() => create();
  static $pb.PbList<CanLinkBankRequest> createRepeated() =>
      $pb.PbList<CanLinkBankRequest>();
  @$core.pragma('dart2js:noInline')
  static CanLinkBankRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CanLinkBankRequest>(create);
  static CanLinkBankRequest? _defaultInstance;
}

class CanLinkBankResponse extends $pb.GeneratedMessage {
  factory CanLinkBankResponse({
    $core.bool? canLink,
    $core.String? message,
  }) {
    final result = create();
    if (canLink != null) result.canLink = canLink;
    if (message != null) result.message = message;
    return result;
  }

  CanLinkBankResponse._();

  factory CanLinkBankResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CanLinkBankResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CanLinkBankResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'canLink')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanLinkBankResponse clone() => CanLinkBankResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CanLinkBankResponse copyWith(void Function(CanLinkBankResponse) updates) =>
      super.copyWith((message) => updates(message as CanLinkBankResponse))
          as CanLinkBankResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CanLinkBankResponse create() => CanLinkBankResponse._();
  @$core.override
  CanLinkBankResponse createEmptyInstance() => create();
  static $pb.PbList<CanLinkBankResponse> createRepeated() =>
      $pb.PbList<CanLinkBankResponse>();
  @$core.pragma('dart2js:noInline')
  static CanLinkBankResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CanLinkBankResponse>(create);
  static CanLinkBankResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get canLink => $_getBF(0);
  @$pb.TagNumber(1)
  set canLink($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCanLink() => $_has(0);
  @$pb.TagNumber(1)
  void clearCanLink() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class GetRefreshUrlRequest extends $pb.GeneratedMessage {
  factory GetRefreshUrlRequest({
    $fixnum.Int64? institutionId,
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
    ..aInt64(1, _omitFieldNames ? '' : 'institutionId')
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
  $fixnum.Int64 get institutionId => $_getI64(0);
  @$pb.TagNumber(1)
  set institutionId($fixnum.Int64 value) => $_setInt64(0, value);
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
    $fixnum.Int64? institutionId,
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
    ..aInt64(1, _omitFieldNames ? '' : 'institutionId')
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
  $fixnum.Int64 get institutionId => $_getI64(0);
  @$pb.TagNumber(1)
  set institutionId($fixnum.Int64 value) => $_setInt64(0, value);
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
    $fixnum.Int64? institutionId,
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
    ..aInt64(1, _omitFieldNames ? '' : 'institutionId')
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
  $fixnum.Int64 get institutionId => $_getI64(0);
  @$pb.TagNumber(1)
  set institutionId($fixnum.Int64 value) => $_setInt64(0, value);
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
    $fixnum.Int64? institutionId,
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
    ..aInt64(1, _omitFieldNames ? '' : 'institutionId')
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
  $fixnum.Int64 get institutionId => $_getI64(0);
  @$pb.TagNumber(1)
  set institutionId($fixnum.Int64 value) => $_setInt64(0, value);
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
    $fixnum.Int64? institutionId,
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
    ..aInt64(1, _omitFieldNames ? '' : 'institutionId')
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
  $fixnum.Int64 get institutionId => $_getI64(0);
  @$pb.TagNumber(1)
  set institutionId($fixnum.Int64 value) => $_setInt64(0, value);
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

class GetBanksForRefreshRequest extends $pb.GeneratedMessage {
  factory GetBanksForRefreshRequest({
    $core.String? countryCode,
  }) {
    final result = create();
    if (countryCode != null) result.countryCode = countryCode;
    return result;
  }

  GetBanksForRefreshRequest._();

  factory GetBanksForRefreshRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBanksForRefreshRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBanksForRefreshRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'countryCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBanksForRefreshRequest clone() =>
      GetBanksForRefreshRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBanksForRefreshRequest copyWith(
          void Function(GetBanksForRefreshRequest) updates) =>
      super.copyWith((message) => updates(message as GetBanksForRefreshRequest))
          as GetBanksForRefreshRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBanksForRefreshRequest create() => GetBanksForRefreshRequest._();
  @$core.override
  GetBanksForRefreshRequest createEmptyInstance() => create();
  static $pb.PbList<GetBanksForRefreshRequest> createRepeated() =>
      $pb.PbList<GetBanksForRefreshRequest>();
  @$core.pragma('dart2js:noInline')
  static GetBanksForRefreshRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBanksForRefreshRequest>(create);
  static GetBanksForRefreshRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get countryCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set countryCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountryCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountryCode() => $_clearField(1);
}

class GetBanksForLinkRequest extends $pb.GeneratedMessage {
  factory GetBanksForLinkRequest({
    $core.String? countryCode,
  }) {
    final result = create();
    if (countryCode != null) result.countryCode = countryCode;
    return result;
  }

  GetBanksForLinkRequest._();

  factory GetBanksForLinkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBanksForLinkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBanksForLinkRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'countryCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBanksForLinkRequest clone() =>
      GetBanksForLinkRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBanksForLinkRequest copyWith(
          void Function(GetBanksForLinkRequest) updates) =>
      super.copyWith((message) => updates(message as GetBanksForLinkRequest))
          as GetBanksForLinkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBanksForLinkRequest create() => GetBanksForLinkRequest._();
  @$core.override
  GetBanksForLinkRequest createEmptyInstance() => create();
  static $pb.PbList<GetBanksForLinkRequest> createRepeated() =>
      $pb.PbList<GetBanksForLinkRequest>();
  @$core.pragma('dart2js:noInline')
  static GetBanksForLinkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBanksForLinkRequest>(create);
  static GetBanksForLinkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get countryCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set countryCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountryCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountryCode() => $_clearField(1);
}

class GetBanksForRefreshResponse extends $pb.GeneratedMessage {
  factory GetBanksForRefreshResponse({
    $core.Iterable<$1.Bank>? banks,
  }) {
    final result = create();
    if (banks != null) result.banks.addAll(banks);
    return result;
  }

  GetBanksForRefreshResponse._();

  factory GetBanksForRefreshResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBanksForRefreshResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBanksForRefreshResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..pc<$1.Bank>(1, _omitFieldNames ? '' : 'banks', $pb.PbFieldType.PM,
        subBuilder: $1.Bank.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBanksForRefreshResponse clone() =>
      GetBanksForRefreshResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBanksForRefreshResponse copyWith(
          void Function(GetBanksForRefreshResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetBanksForRefreshResponse))
          as GetBanksForRefreshResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBanksForRefreshResponse create() => GetBanksForRefreshResponse._();
  @$core.override
  GetBanksForRefreshResponse createEmptyInstance() => create();
  static $pb.PbList<GetBanksForRefreshResponse> createRepeated() =>
      $pb.PbList<GetBanksForRefreshResponse>();
  @$core.pragma('dart2js:noInline')
  static GetBanksForRefreshResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBanksForRefreshResponse>(create);
  static GetBanksForRefreshResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Bank> get banks => $_getList(0);
}

class GetBanksForLinkResponse extends $pb.GeneratedMessage {
  factory GetBanksForLinkResponse({
    $core.Iterable<$1.Bank>? banks,
  }) {
    final result = create();
    if (banks != null) result.banks.addAll(banks);
    return result;
  }

  GetBanksForLinkResponse._();

  factory GetBanksForLinkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBanksForLinkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBanksForLinkResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.refresh.v1'),
      createEmptyInstance: create)
    ..pc<$1.Bank>(1, _omitFieldNames ? '' : 'banks', $pb.PbFieldType.PM,
        subBuilder: $1.Bank.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBanksForLinkResponse clone() =>
      GetBanksForLinkResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBanksForLinkResponse copyWith(
          void Function(GetBanksForLinkResponse) updates) =>
      super.copyWith((message) => updates(message as GetBanksForLinkResponse))
          as GetBanksForLinkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBanksForLinkResponse create() => GetBanksForLinkResponse._();
  @$core.override
  GetBanksForLinkResponse createEmptyInstance() => create();
  static $pb.PbList<GetBanksForLinkResponse> createRepeated() =>
      $pb.PbList<GetBanksForLinkResponse>();
  @$core.pragma('dart2js:noInline')
  static GetBanksForLinkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBanksForLinkResponse>(create);
  static GetBanksForLinkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Bank> get banks => $_getList(0);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
