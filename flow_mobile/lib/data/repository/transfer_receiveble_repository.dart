import 'package:flow_mobile/domain/entities/transfer_receivable.dart';

abstract class TransferReceivebleRepository {
  Future<List<TransferReceivable>> getTransferReceivables();

  Future<void> addTransferReceivable(TransferReceivable transferReceivable);
  Future<void> clearTransferReceivables();
  Future<void> removeTransferReceivable(TransferReceivable transferReceivable);
}