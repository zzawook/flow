// This is a generated file - do not edit.
//
// Generated from transfer/v1/transfer.proto.

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

import '../../google/protobuf/empty.pb.dart' as $1;
import 'transfer.pb.dart' as $0;

export 'transfer.pb.dart';

@$pb.GrpcServiceName('sg.flow.transfer.v1.TransferService')
class TransferServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TransferServiceClient(super.channel, {super.options, super.interceptors});

  /// GET /send/getRelevantRecepient/accountNumber
  $grpc.ResponseFuture<$0.GetRelevantRecepientByAccountNumberResponse>
      getRelevantRecepientByAccountNumber(
    $0.GetRelevantRecepientByAccountNumberRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRelevantRecepientByAccountNumber, request,
        options: options);
  }

  /// GET /send/getRelevantRecepient/contact
  $grpc.ResponseFuture<$0.TransferRecepient> getRelevantRecepientByContact(
    $0.GetRelevantRecepientByContactRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRelevantRecepientByContact, request,
        options: options);
  }

  /// GET /send/getRelevantRecepient
  $grpc.ResponseFuture<$0.GetRelevantRecepientResponse> getRelevantRecepient(
    $1.Empty request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRelevantRecepient, request, options: options);
  }

  /// POST /send/sendTransaction
  $grpc.ResponseFuture<$0.TransferResult> sendTransaction(
    $0.TransferRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$sendTransaction, request, options: options);
  }

  // method descriptors

  static final _$getRelevantRecepientByAccountNumber = $grpc.ClientMethod<
          $0.GetRelevantRecepientByAccountNumberRequest,
          $0.GetRelevantRecepientByAccountNumberResponse>(
      '/sg.flow.transfer.v1.TransferService/GetRelevantRecepientByAccountNumber',
      ($0.GetRelevantRecepientByAccountNumberRequest value) =>
          value.writeToBuffer(),
      $0.GetRelevantRecepientByAccountNumberResponse.fromBuffer);
  static final _$getRelevantRecepientByContact = $grpc.ClientMethod<
          $0.GetRelevantRecepientByContactRequest, $0.TransferRecepient>(
      '/sg.flow.transfer.v1.TransferService/GetRelevantRecepientByContact',
      ($0.GetRelevantRecepientByContactRequest value) => value.writeToBuffer(),
      $0.TransferRecepient.fromBuffer);
  static final _$getRelevantRecepient =
      $grpc.ClientMethod<$1.Empty, $0.GetRelevantRecepientResponse>(
          '/sg.flow.transfer.v1.TransferService/GetRelevantRecepient',
          ($1.Empty value) => value.writeToBuffer(),
          $0.GetRelevantRecepientResponse.fromBuffer);
  static final _$sendTransaction =
      $grpc.ClientMethod<$0.TransferRequest, $0.TransferResult>(
          '/sg.flow.transfer.v1.TransferService/SendTransaction',
          ($0.TransferRequest value) => value.writeToBuffer(),
          $0.TransferResult.fromBuffer);
}

@$pb.GrpcServiceName('sg.flow.transfer.v1.TransferService')
abstract class TransferServiceBase extends $grpc.Service {
  $core.String get $name => 'sg.flow.transfer.v1.TransferService';

  TransferServiceBase() {
    $addMethod($grpc.ServiceMethod<
            $0.GetRelevantRecepientByAccountNumberRequest,
            $0.GetRelevantRecepientByAccountNumberResponse>(
        'GetRelevantRecepientByAccountNumber',
        getRelevantRecepientByAccountNumber_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRelevantRecepientByAccountNumberRequest.fromBuffer(value),
        ($0.GetRelevantRecepientByAccountNumberResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRelevantRecepientByContactRequest,
            $0.TransferRecepient>(
        'GetRelevantRecepientByContact',
        getRelevantRecepientByContact_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRelevantRecepientByContactRequest.fromBuffer(value),
        ($0.TransferRecepient value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $0.GetRelevantRecepientResponse>(
        'GetRelevantRecepient',
        getRelevantRecepient_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($0.GetRelevantRecepientResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TransferRequest, $0.TransferResult>(
        'SendTransaction',
        sendTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TransferRequest.fromBuffer(value),
        ($0.TransferResult value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetRelevantRecepientByAccountNumberResponse>
      getRelevantRecepientByAccountNumber_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.GetRelevantRecepientByAccountNumberRequest>
              $request) async {
    return getRelevantRecepientByAccountNumber($call, await $request);
  }

  $async.Future<$0.GetRelevantRecepientByAccountNumberResponse>
      getRelevantRecepientByAccountNumber($grpc.ServiceCall call,
          $0.GetRelevantRecepientByAccountNumberRequest request);

  $async.Future<$0.TransferRecepient> getRelevantRecepientByContact_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRelevantRecepientByContactRequest> $request) async {
    return getRelevantRecepientByContact($call, await $request);
  }

  $async.Future<$0.TransferRecepient> getRelevantRecepientByContact(
      $grpc.ServiceCall call, $0.GetRelevantRecepientByContactRequest request);

  $async.Future<$0.GetRelevantRecepientResponse> getRelevantRecepient_Pre(
      $grpc.ServiceCall $call, $async.Future<$1.Empty> $request) async {
    return getRelevantRecepient($call, await $request);
  }

  $async.Future<$0.GetRelevantRecepientResponse> getRelevantRecepient(
      $grpc.ServiceCall call, $1.Empty request);

  $async.Future<$0.TransferResult> sendTransaction_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TransferRequest> $request) async {
    return sendTransaction($call, await $request);
  }

  $async.Future<$0.TransferResult> sendTransaction(
      $grpc.ServiceCall call, $0.TransferRequest request);
}
