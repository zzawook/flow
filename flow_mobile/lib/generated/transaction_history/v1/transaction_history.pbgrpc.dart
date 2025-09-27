// This is a generated file - do not edit.
//
// Generated from transaction_history/v1/transaction_history.proto.

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
import 'transaction_history.pb.dart' as $0;

export 'transaction_history.pb.dart';

@$pb.GrpcServiceName('sg.flow.transaction.v1.TransactionHistoryService')
class TransactionHistoryServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TransactionHistoryServiceClient(super.channel,
      {super.options, super.interceptors});

  $grpc.ResponseFuture<$1.TransactionHistoryList> getLast30DaysHistoryList(
    $0.GetLast30DaysHistoryListRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLast30DaysHistoryList, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.TransactionHistoryList> getMonthlyTransaction(
    $0.GetMonthlyTransactionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getMonthlyTransaction, request, options: options);
  }

  $grpc.ResponseFuture<$1.TransactionHistoryList> getDailyTransaction(
    $0.GetDailyTransactionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDailyTransaction, request, options: options);
  }

  $grpc.ResponseFuture<$1.TransactionHistoryDetail> getTransactionDetails(
    $0.GetTransactionDetailsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTransactionDetails, request, options: options);
  }

  $grpc.ResponseFuture<$1.TransactionHistoryList> getTransactionWithinRange(
    $0.GetTransactionWithinRangeRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTransactionWithinRange, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.TransactionHistoryList> getProcessedTransaction(
    $0.GetProcessedTransactionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getProcessedTransaction, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.GetRecurringTransactionResponse>
      getRecurringTransaction(
    $0.GetRecurringTransactionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getRecurringTransaction, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.SetTransactionCategoryResponse>
      setTransactionCategory(
    $0.SetTransactionCategoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setTransactionCategory, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.SetTransactionInclusionResponse>
      setTransactionInclusion(
    $0.SetTransactionInclusionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$setTransactionInclusion, request,
        options: options);
  }

  // method descriptors

  static final _$getLast30DaysHistoryList = $grpc.ClientMethod<
          $0.GetLast30DaysHistoryListRequest, $1.TransactionHistoryList>(
      '/sg.flow.transaction.v1.TransactionHistoryService/GetLast30DaysHistoryList',
      ($0.GetLast30DaysHistoryListRequest value) => value.writeToBuffer(),
      $1.TransactionHistoryList.fromBuffer);
  static final _$getMonthlyTransaction = $grpc.ClientMethod<
          $0.GetMonthlyTransactionRequest, $1.TransactionHistoryList>(
      '/sg.flow.transaction.v1.TransactionHistoryService/GetMonthlyTransaction',
      ($0.GetMonthlyTransactionRequest value) => value.writeToBuffer(),
      $1.TransactionHistoryList.fromBuffer);
  static final _$getDailyTransaction = $grpc.ClientMethod<
          $0.GetDailyTransactionRequest, $1.TransactionHistoryList>(
      '/sg.flow.transaction.v1.TransactionHistoryService/GetDailyTransaction',
      ($0.GetDailyTransactionRequest value) => value.writeToBuffer(),
      $1.TransactionHistoryList.fromBuffer);
  static final _$getTransactionDetails = $grpc.ClientMethod<
          $0.GetTransactionDetailsRequest, $1.TransactionHistoryDetail>(
      '/sg.flow.transaction.v1.TransactionHistoryService/GetTransactionDetails',
      ($0.GetTransactionDetailsRequest value) => value.writeToBuffer(),
      $1.TransactionHistoryDetail.fromBuffer);
  static final _$getTransactionWithinRange = $grpc.ClientMethod<
          $0.GetTransactionWithinRangeRequest, $1.TransactionHistoryList>(
      '/sg.flow.transaction.v1.TransactionHistoryService/GetTransactionWithinRange',
      ($0.GetTransactionWithinRangeRequest value) => value.writeToBuffer(),
      $1.TransactionHistoryList.fromBuffer);
  static final _$getProcessedTransaction = $grpc.ClientMethod<
          $0.GetProcessedTransactionRequest, $1.TransactionHistoryList>(
      '/sg.flow.transaction.v1.TransactionHistoryService/GetProcessedTransaction',
      ($0.GetProcessedTransactionRequest value) => value.writeToBuffer(),
      $1.TransactionHistoryList.fromBuffer);
  static final _$getRecurringTransaction = $grpc.ClientMethod<
          $0.GetRecurringTransactionRequest,
          $0.GetRecurringTransactionResponse>(
      '/sg.flow.transaction.v1.TransactionHistoryService/GetRecurringTransaction',
      ($0.GetRecurringTransactionRequest value) => value.writeToBuffer(),
      $0.GetRecurringTransactionResponse.fromBuffer);
  static final _$setTransactionCategory = $grpc.ClientMethod<
          $0.SetTransactionCategoryRequest, $0.SetTransactionCategoryResponse>(
      '/sg.flow.transaction.v1.TransactionHistoryService/SetTransactionCategory',
      ($0.SetTransactionCategoryRequest value) => value.writeToBuffer(),
      $0.SetTransactionCategoryResponse.fromBuffer);
  static final _$setTransactionInclusion = $grpc.ClientMethod<
          $0.SetTransactionInclusionRequest,
          $0.SetTransactionInclusionResponse>(
      '/sg.flow.transaction.v1.TransactionHistoryService/SetTransactionInclusion',
      ($0.SetTransactionInclusionRequest value) => value.writeToBuffer(),
      $0.SetTransactionInclusionResponse.fromBuffer);
}

@$pb.GrpcServiceName('sg.flow.transaction.v1.TransactionHistoryService')
abstract class TransactionHistoryServiceBase extends $grpc.Service {
  $core.String get $name => 'sg.flow.transaction.v1.TransactionHistoryService';

  TransactionHistoryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetLast30DaysHistoryListRequest,
            $1.TransactionHistoryList>(
        'GetLast30DaysHistoryList',
        getLast30DaysHistoryList_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLast30DaysHistoryListRequest.fromBuffer(value),
        ($1.TransactionHistoryList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetMonthlyTransactionRequest,
            $1.TransactionHistoryList>(
        'GetMonthlyTransaction',
        getMonthlyTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetMonthlyTransactionRequest.fromBuffer(value),
        ($1.TransactionHistoryList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDailyTransactionRequest,
            $1.TransactionHistoryList>(
        'GetDailyTransaction',
        getDailyTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetDailyTransactionRequest.fromBuffer(value),
        ($1.TransactionHistoryList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTransactionDetailsRequest,
            $1.TransactionHistoryDetail>(
        'GetTransactionDetails',
        getTransactionDetails_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetTransactionDetailsRequest.fromBuffer(value),
        ($1.TransactionHistoryDetail value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTransactionWithinRangeRequest,
            $1.TransactionHistoryList>(
        'GetTransactionWithinRange',
        getTransactionWithinRange_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetTransactionWithinRangeRequest.fromBuffer(value),
        ($1.TransactionHistoryList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetProcessedTransactionRequest,
            $1.TransactionHistoryList>(
        'GetProcessedTransaction',
        getProcessedTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetProcessedTransactionRequest.fromBuffer(value),
        ($1.TransactionHistoryList value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetRecurringTransactionRequest,
            $0.GetRecurringTransactionResponse>(
        'GetRecurringTransaction',
        getRecurringTransaction_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetRecurringTransactionRequest.fromBuffer(value),
        ($0.GetRecurringTransactionResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetTransactionCategoryRequest,
            $0.SetTransactionCategoryResponse>(
        'SetTransactionCategory',
        setTransactionCategory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetTransactionCategoryRequest.fromBuffer(value),
        ($0.SetTransactionCategoryResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetTransactionInclusionRequest,
            $0.SetTransactionInclusionResponse>(
        'SetTransactionInclusion',
        setTransactionInclusion_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.SetTransactionInclusionRequest.fromBuffer(value),
        ($0.SetTransactionInclusionResponse value) => value.writeToBuffer()));
  }

  $async.Future<$1.TransactionHistoryList> getLast30DaysHistoryList_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetLast30DaysHistoryListRequest> $request) async {
    return getLast30DaysHistoryList($call, await $request);
  }

  $async.Future<$1.TransactionHistoryList> getLast30DaysHistoryList(
      $grpc.ServiceCall call, $0.GetLast30DaysHistoryListRequest request);

  $async.Future<$1.TransactionHistoryList> getMonthlyTransaction_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetMonthlyTransactionRequest> $request) async {
    return getMonthlyTransaction($call, await $request);
  }

  $async.Future<$1.TransactionHistoryList> getMonthlyTransaction(
      $grpc.ServiceCall call, $0.GetMonthlyTransactionRequest request);

  $async.Future<$1.TransactionHistoryList> getDailyTransaction_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDailyTransactionRequest> $request) async {
    return getDailyTransaction($call, await $request);
  }

  $async.Future<$1.TransactionHistoryList> getDailyTransaction(
      $grpc.ServiceCall call, $0.GetDailyTransactionRequest request);

  $async.Future<$1.TransactionHistoryDetail> getTransactionDetails_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetTransactionDetailsRequest> $request) async {
    return getTransactionDetails($call, await $request);
  }

  $async.Future<$1.TransactionHistoryDetail> getTransactionDetails(
      $grpc.ServiceCall call, $0.GetTransactionDetailsRequest request);

  $async.Future<$1.TransactionHistoryList> getTransactionWithinRange_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetTransactionWithinRangeRequest> $request) async {
    return getTransactionWithinRange($call, await $request);
  }

  $async.Future<$1.TransactionHistoryList> getTransactionWithinRange(
      $grpc.ServiceCall call, $0.GetTransactionWithinRangeRequest request);

  $async.Future<$1.TransactionHistoryList> getProcessedTransaction_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetProcessedTransactionRequest> $request) async {
    return getProcessedTransaction($call, await $request);
  }

  $async.Future<$1.TransactionHistoryList> getProcessedTransaction(
      $grpc.ServiceCall call, $0.GetProcessedTransactionRequest request);

  $async.Future<$0.GetRecurringTransactionResponse> getRecurringTransaction_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetRecurringTransactionRequest> $request) async {
    return getRecurringTransaction($call, await $request);
  }

  $async.Future<$0.GetRecurringTransactionResponse> getRecurringTransaction(
      $grpc.ServiceCall call, $0.GetRecurringTransactionRequest request);

  $async.Future<$0.SetTransactionCategoryResponse> setTransactionCategory_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SetTransactionCategoryRequest> $request) async {
    return setTransactionCategory($call, await $request);
  }

  $async.Future<$0.SetTransactionCategoryResponse> setTransactionCategory(
      $grpc.ServiceCall call, $0.SetTransactionCategoryRequest request);

  $async.Future<$0.SetTransactionInclusionResponse> setTransactionInclusion_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.SetTransactionInclusionRequest> $request) async {
    return setTransactionInclusion($call, await $request);
  }

  $async.Future<$0.SetTransactionInclusionResponse> setTransactionInclusion(
      $grpc.ServiceCall call, $0.SetTransactionInclusionRequest request);
}
