// This is a generated file - do not edit.
//
// Generated from account/v1/account.proto.

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

import '../../common/v1/account.pb.dart' as $1;
import 'account.pb.dart' as $0;

export 'account.pb.dart';

@$pb.GrpcServiceName('sg.flow.account.v1.AccountService')
class AccountServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  AccountServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.GetAccountsResponse> getAccounts(
    $0.GetAccountsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAccounts, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetAccountsWithTransactionHistoryResponse>
      getAccountsWithTransactionHistory(
    $0.GetAccountsWithTransactionHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAccountsWithTransactionHistory, request,
        options: options);
  }

  $grpc.ResponseFuture<$1.Account> getAccount(
    $0.GetAccountRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAccount, request, options: options);
  }

  $grpc.ResponseFuture<$0.AccountWithTransactionHistory>
      getAccountWithTransactionHistory(
    $0.GetAccountWithTransactionHistoryRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getAccountWithTransactionHistory, request,
        options: options);
  }

  $grpc.ResponseFuture<$0.GetDailyAssetsResponse> getDailyAssets(
    $0.GetDailyAssetsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDailyAssets, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetLast7DaysAssetsResponse> getLast7DaysAssets(
    $0.GetLast7DaysAssetsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLast7DaysAssets, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetLast6MonthsEndOfMonthAssetsResponse>
      getLast6MonthsEndOfMonthAssets(
    $0.GetLast6MonthsEndOfMonthAssetsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getLast6MonthsEndOfMonthAssets, request,
        options: options);
  }

  // method descriptors

  static final _$getAccounts =
      $grpc.ClientMethod<$0.GetAccountsRequest, $0.GetAccountsResponse>(
          '/sg.flow.account.v1.AccountService/GetAccounts',
          ($0.GetAccountsRequest value) => value.writeToBuffer(),
          $0.GetAccountsResponse.fromBuffer);
  static final _$getAccountsWithTransactionHistory = $grpc.ClientMethod<
          $0.GetAccountsWithTransactionHistoryRequest,
          $0.GetAccountsWithTransactionHistoryResponse>(
      '/sg.flow.account.v1.AccountService/GetAccountsWithTransactionHistory',
      ($0.GetAccountsWithTransactionHistoryRequest value) =>
          value.writeToBuffer(),
      $0.GetAccountsWithTransactionHistoryResponse.fromBuffer);
  static final _$getAccount =
      $grpc.ClientMethod<$0.GetAccountRequest, $1.Account>(
          '/sg.flow.account.v1.AccountService/GetAccount',
          ($0.GetAccountRequest value) => value.writeToBuffer(),
          $1.Account.fromBuffer);
  static final _$getAccountWithTransactionHistory = $grpc.ClientMethod<
          $0.GetAccountWithTransactionHistoryRequest,
          $0.AccountWithTransactionHistory>(
      '/sg.flow.account.v1.AccountService/GetAccountWithTransactionHistory',
      ($0.GetAccountWithTransactionHistoryRequest value) =>
          value.writeToBuffer(),
      $0.AccountWithTransactionHistory.fromBuffer);
  static final _$getDailyAssets =
      $grpc.ClientMethod<$0.GetDailyAssetsRequest, $0.GetDailyAssetsResponse>(
          '/sg.flow.account.v1.AccountService/GetDailyAssets',
          ($0.GetDailyAssetsRequest value) => value.writeToBuffer(),
          $0.GetDailyAssetsResponse.fromBuffer);
  static final _$getLast7DaysAssets = $grpc.ClientMethod<
          $0.GetLast7DaysAssetsRequest, $0.GetLast7DaysAssetsResponse>(
      '/sg.flow.account.v1.AccountService/GetLast7DaysAssets',
      ($0.GetLast7DaysAssetsRequest value) => value.writeToBuffer(),
      $0.GetLast7DaysAssetsResponse.fromBuffer);
  static final _$getLast6MonthsEndOfMonthAssets = $grpc.ClientMethod<
          $0.GetLast6MonthsEndOfMonthAssetsRequest,
          $0.GetLast6MonthsEndOfMonthAssetsResponse>(
      '/sg.flow.account.v1.AccountService/GetLast6MonthsEndOfMonthAssets',
      ($0.GetLast6MonthsEndOfMonthAssetsRequest value) => value.writeToBuffer(),
      $0.GetLast6MonthsEndOfMonthAssetsResponse.fromBuffer);
}

@$pb.GrpcServiceName('sg.flow.account.v1.AccountService')
abstract class AccountServiceBase extends $grpc.Service {
  $core.String get $name => 'sg.flow.account.v1.AccountService';

  AccountServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.GetAccountsRequest, $0.GetAccountsResponse>(
            'GetAccounts',
            getAccounts_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetAccountsRequest.fromBuffer(value),
            ($0.GetAccountsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAccountsWithTransactionHistoryRequest,
            $0.GetAccountsWithTransactionHistoryResponse>(
        'GetAccountsWithTransactionHistory',
        getAccountsWithTransactionHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAccountsWithTransactionHistoryRequest.fromBuffer(value),
        ($0.GetAccountsWithTransactionHistoryResponse value) =>
            value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAccountRequest, $1.Account>(
        'GetAccount',
        getAccount_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetAccountRequest.fromBuffer(value),
        ($1.Account value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetAccountWithTransactionHistoryRequest,
            $0.AccountWithTransactionHistory>(
        'GetAccountWithTransactionHistory',
        getAccountWithTransactionHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetAccountWithTransactionHistoryRequest.fromBuffer(value),
        ($0.AccountWithTransactionHistory value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDailyAssetsRequest,
            $0.GetDailyAssetsResponse>(
        'GetDailyAssets',
        getDailyAssets_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetDailyAssetsRequest.fromBuffer(value),
        ($0.GetDailyAssetsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLast7DaysAssetsRequest,
            $0.GetLast7DaysAssetsResponse>(
        'GetLast7DaysAssets',
        getLast7DaysAssets_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLast7DaysAssetsRequest.fromBuffer(value),
        ($0.GetLast7DaysAssetsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLast6MonthsEndOfMonthAssetsRequest,
            $0.GetLast6MonthsEndOfMonthAssetsResponse>(
        'GetLast6MonthsEndOfMonthAssets',
        getLast6MonthsEndOfMonthAssets_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLast6MonthsEndOfMonthAssetsRequest.fromBuffer(value),
        ($0.GetLast6MonthsEndOfMonthAssetsResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.GetAccountsResponse> getAccounts_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetAccountsRequest> $request) async {
    return getAccounts($call, await $request);
  }

  $async.Future<$0.GetAccountsResponse> getAccounts(
      $grpc.ServiceCall call, $0.GetAccountsRequest request);

  $async.Future<$0.GetAccountsWithTransactionHistoryResponse>
      getAccountsWithTransactionHistory_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.GetAccountsWithTransactionHistoryRequest>
              $request) async {
    return getAccountsWithTransactionHistory($call, await $request);
  }

  $async.Future<$0.GetAccountsWithTransactionHistoryResponse>
      getAccountsWithTransactionHistory($grpc.ServiceCall call,
          $0.GetAccountsWithTransactionHistoryRequest request);

  $async.Future<$1.Account> getAccount_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetAccountRequest> $request) async {
    return getAccount($call, await $request);
  }

  $async.Future<$1.Account> getAccount(
      $grpc.ServiceCall call, $0.GetAccountRequest request);

  $async.Future<$0.AccountWithTransactionHistory>
      getAccountWithTransactionHistory_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.GetAccountWithTransactionHistoryRequest>
              $request) async {
    return getAccountWithTransactionHistory($call, await $request);
  }

  $async.Future<$0.AccountWithTransactionHistory>
      getAccountWithTransactionHistory($grpc.ServiceCall call,
          $0.GetAccountWithTransactionHistoryRequest request);

  $async.Future<$0.GetDailyAssetsResponse> getDailyAssets_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDailyAssetsRequest> $request) async {
    return getDailyAssets($call, await $request);
  }

  $async.Future<$0.GetDailyAssetsResponse> getDailyAssets(
      $grpc.ServiceCall call, $0.GetDailyAssetsRequest request);

  $async.Future<$0.GetLast7DaysAssetsResponse> getLast7DaysAssets_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetLast7DaysAssetsRequest> $request) async {
    return getLast7DaysAssets($call, await $request);
  }

  $async.Future<$0.GetLast7DaysAssetsResponse> getLast7DaysAssets(
      $grpc.ServiceCall call, $0.GetLast7DaysAssetsRequest request);

  $async.Future<$0.GetLast6MonthsEndOfMonthAssetsResponse>
      getLast6MonthsEndOfMonthAssets_Pre(
          $grpc.ServiceCall $call,
          $async.Future<$0.GetLast6MonthsEndOfMonthAssetsRequest>
              $request) async {
    return getLast6MonthsEndOfMonthAssets($call, await $request);
  }

  $async.Future<$0.GetLast6MonthsEndOfMonthAssetsResponse>
      getLast6MonthsEndOfMonthAssets($grpc.ServiceCall call,
          $0.GetLast6MonthsEndOfMonthAssetsRequest request);
}
