import 'package:flow_mobile/domain/entity/transfer_receivable.dart';

abstract class TransferReceivebleManager {
  Future<List<TransferReceivable>> getTransferReceivables();

  Future<void> addTransferReceivable(TransferReceivable transferReceivable);
  Future<void> clearTransferReceivables();
  Future<void> removeTransferReceivable(TransferReceivable transferReceivable);
}