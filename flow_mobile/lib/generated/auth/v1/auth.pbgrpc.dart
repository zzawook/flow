// This is a generated file - do not edit.
//
// Generated from auth/v1/auth.proto.

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

import 'auth.pb.dart' as $0;

export 'auth.pb.dart';

@$pb.GrpcServiceName('sg.flow.auth.v1.AuthService')
class AuthServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AuthServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.CheckUserExistsResponse> checkUserExists(
    $0.CheckUserExistsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkUserExists, request, options: options);
  }

  $grpc.ResponseFuture<$0.TokenSet> signUp(
    $0.SignUpRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$signUp, request, options: options);
  }

  $grpc.ResponseFuture<$0.TokenSet> signIn(
    $0.SignInRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$signIn, request, options: options);
  }

  $grpc.ResponseFuture<$0.SignOutResponse> signOut(
    $0.SignOutRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$signOut, request, options: options);
  }

  $grpc.ResponseFuture<$0.TokenSet> getAccessTokenByRefreshToken(
    $0.AccessTokenRefreshRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAccessTokenByRefreshToken, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.SendVerificationEmailResponse> sendVerificationEmail(
    $0.SendVerificationEmailRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendVerificationEmail, request, options: options);
  }

  $grpc.ResponseFuture<$0.CheckEmailVerifiedResponse> checkEmailVerified(
    $0.CheckEmailVerifiedRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$checkEmailVerified, request, options: options);
  }

  // method descriptors

  static final _$checkUserExists =
      $grpc.ClientMethod<$0.CheckUserExistsRequest, $0.CheckUserExistsResponse>(
          '/sg.flow.auth.v1.AuthService/CheckUserExists',
          ($0.CheckUserExistsRequest value) => value.writeToBuffer(),
          $0.CheckUserExistsResponse.fromBuffer);
  static final _$signUp = $grpc.ClientMethod<$0.SignUpRequest, $0.TokenSet>(
      '/sg.flow.auth.v1.AuthService/SignUp',
      ($0.SignUpRequest value) => value.writeToBuffer(),
      $0.TokenSet.fromBuffer);
  static final _$signIn = $grpc.ClientMethod<$0.SignInRequest, $0.TokenSet>(
      '/sg.flow.auth.v1.AuthService/SignIn',
      ($0.SignInRequest value) => value.writeToBuffer(),
      $0.TokenSet.fromBuffer);
  static final _$signOut =
      $grpc.ClientMethod<$0.SignOutRequest, $0.SignOutResponse>(
          '/sg.flow.auth.v1.AuthService/SignOut',
          ($0.SignOutRequest value) => value.writeToBuffer(),
          $0.SignOutResponse.fromBuffer);
  static final _$getAccessTokenByRefreshToken =
      $grpc.ClientMethod<$0.AccessTokenRefreshRequest, $0.TokenSet>(
          '/sg.flow.auth.v1.AuthService/GetAccessTokenByRefreshToken',
          ($0.AccessTokenRefreshRequest value) => value.writeToBuffer(),
          $0.TokenSet.fromBuffer);
  static final _$sendVerificationEmail = $grpc.ClientMethod<
          $0.SendVerificationEmailRequest, $0.SendVerificationEmailResponse>(
      '/sg.flow.auth.v1.AuthService/SendVerificationEmail',
      ($0.SendVerificationEmailRequest value) => value.writeToBuffer(),
      $0.SendVerificationEmailResponse.fromBuffer);
  static final _$checkEmailVerified = $grpc.ClientMethod<
          $0.CheckEmailVerifiedRequest, $0.CheckEmailVerifiedResponse>(
      '/sg.flow.auth.v1.AuthService/CheckEmailVerified',
      ($0.CheckEmailVerifiedRequest value) => value.writeToBuffer(),
      $0.CheckEmailVerifiedResponse.fromBuffer);
}

@$pb.GrpcServiceName('sg.flow.auth.v1.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'sg.flow.auth.v1.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CheckUserExistsRequest,
            $0.CheckUserExistsResponse>(
        'CheckUserExists',
        checkUserExists_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CheckUserExistsRequest.fromBuffer(value),
        ($0.CheckUserExistsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SignUpRequest, $0.TokenSet>(
        'SignUp',
        signUp_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SignUpRequest.fromBuffer(value),
        ($0.TokenSet value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SignInRequest, $0.TokenSet>(
        'SignIn',
        signIn_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SignInRequest.fromBuffer(value),
        ($0.TokenSet value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SignOutRequest, $0.SignOutResponse>(
        'SignOut',
        signOut_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SignOutRequest.fromBuffer(value),
        ($0.SignOutResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AccessTokenRefreshRequest, $0.TokenSet>(
        'GetAccessTokenByRefreshToken',
        getAccessTokenByRefreshToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AccessTokenRefreshRequest.fromBuffer(value),
        ($0.TokenSet value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SendVerificationEmailRequest,
            $0.SendVerificationEmailResponse>(
        'SendVerificationEmail',
        sendVerificationEmail_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SendVerificationEmailRequest.fromBuffer(value),
        ($0.SendVerificationEmailResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CheckEmailVerifiedRequest,
            $0.CheckEmailVerifiedResponse>(
        'CheckEmailVerified',
        checkEmailVerified_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CheckEmailVerifiedRequest.fromBuffer(value),
        ($0.CheckEmailVerifiedResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.CheckUserExistsResponse> checkUserExists_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CheckUserExistsRequest> $request) async {
    return checkUserExists($call, await $request);
  }

  $async.Future<$0.CheckUserExistsResponse> checkUserExists(
      $grpc.ServiceCall call, $0.CheckUserExistsRequest request);

  $async.Future<$0.TokenSet> signUp_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SignUpRequest> $request) async {
    return signUp($call, await $request);
  }

  $async.Future<$0.TokenSet> signUp(
      $grpc.ServiceCall call, $0.SignUpRequest request);

  $async.Future<$0.TokenSet> signIn_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SignInRequest> $request) async {
    return signIn($call, await $request);
  }

  $async.Future<$0.TokenSet> signIn(
      $grpc.ServiceCall call, $0.SignInRequest request);

  $async.Future<$0.SignOutResponse> signOut_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SignOutRequest> $request) async {
    return signOut($call, await $request);
  }

  $async.Future<$0.SignOutResponse> signOut(
      $grpc.ServiceCall call, $0.SignOutRequest request);

  $async.Future<$0.TokenSet> getAccessTokenByRefreshToken_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AccessTokenRefreshRequest> $request) async {
    return getAccessTokenByRefreshToken($call, await $request);
  }

  $async.Future<$0.TokenSet> getAccessTokenByRefreshToken(
      $grpc.ServiceCall call, $0.AccessTokenRefreshRequest request);

  $async.Future<$0.SendVerificationEmailResponse> sendVerificationEmail_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SendVerificationEmailRequest> $request) async {
    return sendVerificationEmail($call, await $request);
  }

  $async.Future<$0.SendVerificationEmailResponse> sendVerificationEmail(
      $grpc.ServiceCall call, $0.SendVerificationEmailRequest request);

  $async.Future<$0.CheckEmailVerifiedResponse> checkEmailVerified_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CheckEmailVerifiedRequest> $request) async {
    return checkEmailVerified($call, await $request);
  }

  $async.Future<$0.CheckEmailVerifiedResponse> checkEmailVerified(
      $grpc.ServiceCall call, $0.CheckEmailVerifiedRequest request);
}
