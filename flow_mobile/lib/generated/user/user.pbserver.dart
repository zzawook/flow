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

import 'user.pb.dart' as $2;
import 'user.pbjson.dart';

export 'user.pb.dart';

abstract class UserServiceBase extends $pb.GeneratedService {
  $async.Future<$2.UserProfile> getUserProfile(
      $pb.ServerContext ctx, $2.GetUserProfileRequest request);
  $async.Future<$2.GetUserPreferenceJsonResponse> getUserPreferenceJson(
      $pb.ServerContext ctx, $2.GetUserPreferenceJsonRequest request);
  $async.Future<$2.UserProfile> updateUserProfile(
      $pb.ServerContext ctx, $2.UpdateUserProfileRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetUserProfile':
        return $2.GetUserProfileRequest();
      case 'GetUserPreferenceJson':
        return $2.GetUserPreferenceJsonRequest();
      case 'UpdateUserProfile':
        return $2.UpdateUserProfileRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetUserProfile':
        return getUserProfile(ctx, request as $2.GetUserProfileRequest);
      case 'GetUserPreferenceJson':
        return getUserPreferenceJson(
            ctx, request as $2.GetUserPreferenceJsonRequest);
      case 'UpdateUserProfile':
        return updateUserProfile(ctx, request as $2.UpdateUserProfileRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => UserServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => UserServiceBase$messageJson;
}
