// This is a generated file - do not edit.
//
// Generated from user/v1/user.proto.

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

import 'user.pb.dart' as $0;

export 'user.pb.dart';

@$pb.GrpcServiceName('sg.flow.user.v1.UserService')
class UserServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  UserServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.UserProfile> getUserProfile(
    $0.GetUserProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetUserPreferenceJsonResponse> getUserPreferenceJson(
    $0.GetUserPreferenceJsonRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getUserPreferenceJson, request, options: options);
  }

  $grpc.ResponseFuture<$0.UserProfile> updateUserProfile(
    $0.UpdateUserProfileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateUserProfile, request, options: options);
  }

  $grpc.ResponseFuture<$0.SetConstantUserFieldsResponse> setConstantUserFields(
    $0.SetConstantUserFieldsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setConstantUserFields, request, options: options);
  }

  // method descriptors

  static final _$getUserProfile =
      $grpc.ClientMethod<$0.GetUserProfileRequest, $0.UserProfile>(
          '/sg.flow.user.v1.UserService/GetUserProfile',
          ($0.GetUserProfileRequest value) => value.writeToBuffer(),
          $0.UserProfile.fromBuffer);
  static final _$getUserPreferenceJson = $grpc.ClientMethod<
          $0.GetUserPreferenceJsonRequest, $0.GetUserPreferenceJsonResponse>(
      '/sg.flow.user.v1.UserService/GetUserPreferenceJson',
      ($0.GetUserPreferenceJsonRequest value) => value.writeToBuffer(),
      $0.GetUserPreferenceJsonResponse.fromBuffer);
  static final _$updateUserProfile =
      $grpc.ClientMethod<$0.UpdateUserProfileRequest, $0.UserProfile>(
          '/sg.flow.user.v1.UserService/UpdateUserProfile',
          ($0.UpdateUserProfileRequest value) => value.writeToBuffer(),
          $0.UserProfile.fromBuffer);
  static final _$setConstantUserFields = $grpc.ClientMethod<
          $0.SetConstantUserFieldsRequest, $0.SetConstantUserFieldsResponse>(
      '/sg.flow.user.v1.UserService/SetConstantUserFields',
      ($0.SetConstantUserFieldsRequest value) => value.writeToBuffer(),
      $0.SetConstantUserFieldsResponse.fromBuffer);
}

@$pb.GrpcServiceName('sg.flow.user.v1.UserService')
abstract class UserServiceBase extends $grpc.Service {
  $core.String get $name => 'sg.flow.user.v1.UserService';

  UserServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetUserProfileRequest, $0.UserProfile>(
        'GetUserProfile',
        getUserProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetUserProfileRequest.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetUserPreferenceJsonRequest,
            $0.GetUserPreferenceJsonResponse>(
        'GetUserPreferenceJson',
        getUserPreferenceJson_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetUserPreferenceJsonRequest.fromBuffer(value),
        ($0.GetUserPreferenceJsonResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateUserProfileRequest, $0.UserProfile>(
        'UpdateUserProfile',
        updateUserProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateUserProfileRequest.fromBuffer(value),
        ($0.UserProfile value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetConstantUserFieldsRequest,
            $0.SetConstantUserFieldsResponse>(
        'SetConstantUserFields',
        setConstantUserFields_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetConstantUserFieldsRequest.fromBuffer(value),
        ($0.SetConstantUserFieldsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.UserProfile> getUserProfile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetUserProfileRequest> $request) async {
    return getUserProfile($call, await $request);
  }

  $async.Future<$0.UserProfile> getUserProfile(
      $grpc.ServiceCall call, $0.GetUserProfileRequest request);

  $async.Future<$0.GetUserPreferenceJsonResponse> getUserPreferenceJson_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetUserPreferenceJsonRequest> $request) async {
    return getUserPreferenceJson($call, await $request);
  }

  $async.Future<$0.GetUserPreferenceJsonResponse> getUserPreferenceJson(
      $grpc.ServiceCall call, $0.GetUserPreferenceJsonRequest request);

  $async.Future<$0.UserProfile> updateUserProfile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateUserProfileRequest> $request) async {
    return updateUserProfile($call, await $request);
  }

  $async.Future<$0.UserProfile> updateUserProfile(
      $grpc.ServiceCall call, $0.UpdateUserProfileRequest request);

  $async.Future<$0.SetConstantUserFieldsResponse> setConstantUserFields_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SetConstantUserFieldsRequest> $request) async {
    return setConstantUserFields($call, await $request);
  }

  $async.Future<$0.SetConstantUserFieldsResponse> setConstantUserFields(
      $grpc.ServiceCall call, $0.SetConstantUserFieldsRequest request);
}
