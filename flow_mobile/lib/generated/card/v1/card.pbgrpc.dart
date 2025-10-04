// This is a generated file - do not edit.
//
// Generated from card/v1/card.proto.

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

import '../../common/v1/transaction.pb.dart' as $1;
import 'card.pb.dart' as $0;

export 'card.pb.dart';

@$pb.GrpcServiceName('sg.flow.card.v1.CardService')
class CardServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  CardServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetCardsResponse> getCards(
    $0.GetCardsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCards, request, options: options);
  }

  $grpc.ResponseFuture<$1.TransactionHistoryList> getCardTransactions(
    $0.GetCardTransactionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getCardTransactions, request, options: options);
  }

  // method descriptors

  static final _$getCards =
      $grpc.ClientMethod<$0.GetCardsRequest, $0.GetCardsResponse>(
          '/sg.flow.card.v1.CardService/GetCards',
          ($0.GetCardsRequest value) => value.writeToBuffer(),
          $0.GetCardsResponse.fromBuffer);
  static final _$getCardTransactions = $grpc.ClientMethod<
          $0.GetCardTransactionsRequest, $1.TransactionHistoryList>(
      '/sg.flow.card.v1.CardService/GetCardTransactions',
      ($0.GetCardTransactionsRequest value) => value.writeToBuffer(),
      $1.TransactionHistoryList.fromBuffer);
}

@$pb.GrpcServiceName('sg.flow.card.v1.CardService')
abstract class CardServiceBase extends $grpc.Service {
  $core.String get $name => 'sg.flow.card.v1.CardService';

  CardServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetCardsRequest, $0.GetCardsResponse>(
        'GetCards',
        getCards_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetCardsRequest.fromBuffer(value),
        ($0.GetCardsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCardTransactionsRequest,
            $1.TransactionHistoryList>(
        'GetCardTransactions',
        getCardTransactions_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetCardTransactionsRequest.fromBuffer(value),
        ($1.TransactionHistoryList value) => value.writeToBuffer()));
  }

  $async.Future<$0.GetCardsResponse> getCards_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetCardsRequest> $request) async {
    return getCards($call, await $request);
  }

  $async.Future<$0.GetCardsResponse> getCards(
      $grpc.ServiceCall call, $0.GetCardsRequest request);

  $async.Future<$1.TransactionHistoryList> getCardTransactions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetCardTransactionsRequest> $request) async {
    return getCardTransactions($call, await $request);
  }

  $async.Future<$1.TransactionHistoryList> getCardTransactions(
      $grpc.ServiceCall call, $0.GetCardTransactionsRequest request);
}
