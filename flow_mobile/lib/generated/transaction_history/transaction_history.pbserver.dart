// This is a generated file - do not edit.
//
// Generated from transaction_history/transaction_history.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../common/v1/transaction.pb.dart' as $1;
import 'transaction_history.pb.dart' as $5;
import 'transaction_history.pbjson.dart';

export 'transaction_history.pb.dart';

abstract class TransactionHistoryServiceBase extends $pb.GeneratedService {
  $async.Future<$1.TransactionHistoryList> getLast30DaysHistoryList(
      $pb.ServerContext ctx, $5.GetLast30DaysHistoryListRequest request);
  $async.Future<$1.TransactionHistoryList> getMonthlyTransaction(
      $pb.ServerContext ctx, $5.GetMonthlyTransactionRequest request);
  $async.Future<$1.TransactionHistoryList> getDailyTransaction(
      $pb.ServerContext ctx, $5.GetDailyTransactionRequest request);
  $async.Future<$1.TransactionHistoryDetail> getTransactionDetails(
      $pb.ServerContext ctx, $5.GetTransactionDetailsRequest request);
  $async.Future<$1.TransactionHistoryList> getTransactionWithinRange(
      $pb.ServerContext ctx, $5.GetTransactionWithinRangeRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetLast30DaysHistoryList':
        return $5.GetLast30DaysHistoryListRequest();
      case 'GetMonthlyTransaction':
        return $5.GetMonthlyTransactionRequest();
      case 'GetDailyTransaction':
        return $5.GetDailyTransactionRequest();
      case 'GetTransactionDetails':
        return $5.GetTransactionDetailsRequest();
      case 'GetTransactionWithinRange':
        return $5.GetTransactionWithinRangeRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetLast30DaysHistoryList':
        return getLast30DaysHistoryList(
            ctx, request as $5.GetLast30DaysHistoryListRequest);
      case 'GetMonthlyTransaction':
        return getMonthlyTransaction(
            ctx, request as $5.GetMonthlyTransactionRequest);
      case 'GetDailyTransaction':
        return getDailyTransaction(
            ctx, request as $5.GetDailyTransactionRequest);
      case 'GetTransactionDetails':
        return getTransactionDetails(
            ctx, request as $5.GetTransactionDetailsRequest);
      case 'GetTransactionWithinRange':
        return getTransactionWithinRange(
            ctx, request as $5.GetTransactionWithinRangeRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json =>
      TransactionHistoryServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => TransactionHistoryServiceBase$messageJson;
}
