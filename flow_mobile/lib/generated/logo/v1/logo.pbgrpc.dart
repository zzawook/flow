// This is a generated file - do not edit.
//
// Generated from logo/v1/logo.proto.

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

import 'logo.pb.dart' as $0;

export 'logo.pb.dart';

@$pb.GrpcServiceName('sg.flow.logo.v1.LogoService')
class LogoServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  LogoServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetLogoResponse> getLogo(
    $0.GetLogoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLogo, request, options: options);
  }

  $grpc.ResponseFuture<$0.UploadLogoResponse> uploadLogo(
    $0.UploadLogoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$uploadLogo, request, options: options);
  }

  // method descriptors

  static final _$getLogo =
      $grpc.ClientMethod<$0.GetLogoRequest, $0.GetLogoResponse>(
          '/sg.flow.logo.v1.LogoService/GetLogo',
          ($0.GetLogoRequest value) => value.writeToBuffer(),
          $0.GetLogoResponse.fromBuffer);
  static final _$uploadLogo =
      $grpc.ClientMethod<$0.UploadLogoRequest, $0.UploadLogoResponse>(
          '/sg.flow.logo.v1.LogoService/UploadLogo',
          ($0.UploadLogoRequest value) => value.writeToBuffer(),
          $0.UploadLogoResponse.fromBuffer);
}

@$pb.GrpcServiceName('sg.flow.logo.v1.LogoService')
abstract class LogoServiceBase extends $grpc.Service {
  $core.String get $name => 'sg.flow.logo.v1.LogoService';

  LogoServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetLogoRequest, $0.GetLogoResponse>(
        'GetLogo',
        getLogo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetLogoRequest.fromBuffer(value),
        ($0.GetLogoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UploadLogoRequest, $0.UploadLogoResponse>(
        'UploadLogo',
        uploadLogo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.UploadLogoRequest.fromBuffer(value),
        ($0.UploadLogoResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetLogoResponse> getLogo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetLogoRequest> $request) async {
    return getLogo($call, await $request);
  }

  $async.Future<$0.GetLogoResponse> getLogo(
      $grpc.ServiceCall call, $0.GetLogoRequest request);

  $async.Future<$0.UploadLogoResponse> uploadLogo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UploadLogoRequest> $request) async {
    return uploadLogo($call, await $request);
  }

  $async.Future<$0.UploadLogoResponse> uploadLogo(
      $grpc.ServiceCall call, $0.UploadLogoRequest request);
}
