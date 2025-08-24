// This is a generated file - do not edit.
//
// Generated from refresh/v1/refresh.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'refresh.pb.dart' as $0;

export 'refresh.pb.dart';

@$pb.GrpcServiceName('sg.flow.refresh.v1.RefreshService')
class RefreshServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  RefreshServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CanStartRefreshSessionResponse>
      canStartRefreshSession(
    $0.CanStartRefreshSessionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$canStartRefreshSession, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.GetRefreshUrlResponse> getRefreshUrl(
    $0.GetRefreshUrlRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRefreshUrl, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetRelinkUrlResponse> getRelinkUrl(
    $0.GetRelinkUrlRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRelinkUrl, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetInstitutionAuthenticationResultResponse>
      getInstitutionAuthenticationResult(
    $0.GetInstitutionAuthenticationResultRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getInstitutionAuthenticationResult, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.GetDataRetrievalResultResponse>
      getDataRetrievalResult(
    $0.GetDataRetrievalResultRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDataRetrievalResult, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.GetBanksForRefreshResponse> getBanksForRefresh(
    $0.GetBanksForRefreshRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBanksForRefresh, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetBanksForLinkResponse> getBanksForLink(
    $0.GetBanksForLinkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getBanksForLink, request, options: options);
  }

  // method descriptors

  static final _$canStartRefreshSession = $grpc.ClientMethod<
          $0.CanStartRefreshSessionRequest, $0.CanStartRefreshSessionResponse>(
      '/sg.flow.refresh.v1.RefreshService/CanStartRefreshSession',
      ($0.CanStartRefreshSessionRequest value) => value.writeToBuffer(),
      $0.CanStartRefreshSessionResponse.fromBuffer);
  static final _$getRefreshUrl =
      $grpc.ClientMethod<$0.GetRefreshUrlRequest, $0.GetRefreshUrlResponse>(
          '/sg.flow.refresh.v1.RefreshService/GetRefreshUrl',
          ($0.GetRefreshUrlRequest value) => value.writeToBuffer(),
          $0.GetRefreshUrlResponse.fromBuffer);
  static final _$getRelinkUrl =
      $grpc.ClientMethod<$0.GetRelinkUrlRequest, $0.GetRelinkUrlResponse>(
          '/sg.flow.refresh.v1.RefreshService/GetRelinkUrl',
          ($0.GetRelinkUrlRequest value) => value.writeToBuffer(),
          $0.GetRelinkUrlResponse.fromBuffer);
  static final _$getInstitutionAuthenticationResult = $grpc.ClientMethod<
          $0.GetInstitutionAuthenticationResultRequest,
          $0.GetInstitutionAuthenticationResultResponse>(
      '/sg.flow.refresh.v1.RefreshService/GetInstitutionAuthenticationResult',
      ($0.GetInstitutionAuthenticationResultRequest value) =>
          value.writeToBuffer(),
      $0.GetInstitutionAuthenticationResultResponse.fromBuffer);
  static final _$getDataRetrievalResult = $grpc.ClientMethod<
          $0.GetDataRetrievalResultRequest, $0.GetDataRetrievalResultResponse>(
      '/sg.flow.refresh.v1.RefreshService/GetDataRetrievalResult',
      ($0.GetDataRetrievalResultRequest value) => value.writeToBuffer(),
      $0.GetDataRetrievalResultResponse.fromBuffer);
  static final _$getBanksForRefresh = $grpc.ClientMethod<
          $0.GetBanksForRefreshRequest, $0.GetBanksForRefreshResponse>(
      '/sg.flow.refresh.v1.RefreshService/GetBanksForRefresh',
      ($0.GetBanksForRefreshRequest value) => value.writeToBuffer(),
      $0.GetBanksForRefreshResponse.fromBuffer);
  static final _$getBanksForLink =
      $grpc.ClientMethod<$0.GetBanksForLinkRequest, $0.GetBanksForLinkResponse>(
          '/sg.flow.refresh.v1.RefreshService/GetBanksForLink',
          ($0.GetBanksForLinkRequest value) => value.writeToBuffer(),
          $0.GetBanksForLinkResponse.fromBuffer);
}

@$pb.GrpcServiceName('sg.flow.refresh.v1.RefreshService')
abstract class RefreshServiceBase extends $grpc.Service {
  $core.String get $name => 'sg.flow.refresh.v1.RefreshService';

  RefreshServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CanStartRefreshSessionRequest,
            $0.CanStartRefreshSessionResponse>(
        'CanStartRefreshSession',
        canStartRefreshSession_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CanStartRefreshSessionRequest.fromBuffer(value),
        ($0.CanStartRefreshSessionResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetRefreshUrlRequest, $0.GetRefreshUrlResponse>(
            'GetRefreshUrl',
            getRefreshUrl_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetRefreshUrlRequest.fromBuffer(value),
            ($0.GetRefreshUrlResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetRelinkUrlRequest, $0.GetRelinkUrlResponse>(
            'GetRelinkUrl',
            getRelinkUrl_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetRelinkUrlRequest.fromBuffer(value),
            ($0.GetRelinkUrlResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetInstitutionAuthenticationResultRequest,
            $0.GetInstitutionAuthenticationResultResponse>(
        'GetInstitutionAuthenticationResult',
        getInstitutionAuthenticationResult_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetInstitutionAuthenticationResultRequest.fromBuffer(value),
        ($0.GetInstitutionAuthenticationResultResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDataRetrievalResultRequest,
            $0.GetDataRetrievalResultResponse>(
        'GetDataRetrievalResult',
        getDataRetrievalResult_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetDataRetrievalResultRequest.fromBuffer(value),
        ($0.GetDataRetrievalResultResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetBanksForRefreshRequest,
            $0.GetBanksForRefreshResponse>(
        'GetBanksForRefresh',
        getBanksForRefresh_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetBanksForRefreshRequest.fromBuffer(value),
        ($0.GetBanksForRefreshResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetBanksForLinkRequest,
            $0.GetBanksForLinkResponse>(
        'GetBanksForLink',
        getBanksForLink_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetBanksForLinkRequest.fromBuffer(value),
        ($0.GetBanksForLinkResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CanStartRefreshSessionResponse> canStartRefreshSession_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CanStartRefreshSessionRequest> $request) async {
    return canStartRefreshSession($call, await $request);
  }

  $async.Future<$0.CanStartRefreshSessionResponse> canStartRefreshSession(
      $grpc.ServiceCall call, $0.CanStartRefreshSessionRequest request);

  $async.Future<$0.GetRefreshUrlResponse> getRefreshUrl_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRefreshUrlRequest> $request) async {
    return getRefreshUrl($call, await $request);
  }

  $async.Future<$0.GetRefreshUrlResponse> getRefreshUrl(
      $grpc.ServiceCall call, $0.GetRefreshUrlRequest request);

  $async.Future<$0.GetRelinkUrlResponse> getRelinkUrl_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRelinkUrlRequest> $request) async {
    return getRelinkUrl($call, await $request);
  }

  $async.Future<$0.GetRelinkUrlResponse> getRelinkUrl(
      $grpc.ServiceCall call, $0.GetRelinkUrlRequest request);

  $async.Future<$0.GetInstitutionAuthenticationResultResponse>
      getInstitutionAuthenticationResult_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.GetInstitutionAuthenticationResultRequest>
              $request) async {
    return getInstitutionAuthenticationResult($call, await $request);
  }

  $async.Future<$0.GetInstitutionAuthenticationResultResponse>
      getInstitutionAuthenticationResult($grpc.ServiceCall call,
          $0.GetInstitutionAuthenticationResultRequest request);

  $async.Future<$0.GetDataRetrievalResultResponse> getDataRetrievalResult_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDataRetrievalResultRequest> $request) async {
    return getDataRetrievalResult($call, await $request);
  }

  $async.Future<$0.GetDataRetrievalResultResponse> getDataRetrievalResult(
      $grpc.ServiceCall call, $0.GetDataRetrievalResultRequest request);

  $async.Future<$0.GetBanksForRefreshResponse> getBanksForRefresh_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetBanksForRefreshRequest> $request) async {
    return getBanksForRefresh($call, await $request);
  }

  $async.Future<$0.GetBanksForRefreshResponse> getBanksForRefresh(
      $grpc.ServiceCall call, $0.GetBanksForRefreshRequest request);

  $async.Future<$0.GetBanksForLinkResponse> getBanksForLink_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetBanksForLinkRequest> $request) async {
    return getBanksForLink($call, await $request);
  }

  $async.Future<$0.GetBanksForLinkResponse> getBanksForLink(
      $grpc.ServiceCall call, $0.GetBanksForLinkRequest request);
}
