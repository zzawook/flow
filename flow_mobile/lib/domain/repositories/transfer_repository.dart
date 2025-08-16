import 'package:flow_mobile/domain/entities/transfer_receivable.dart';

/// Repository interface for transfer receivable operations
/// Matches existing TransferReceivebleManager method signatures for compatibility
abstract class TransferRepository {
  /// Get all transfer receivables
  Future<List<TransferReceivable>> getTransferReceivables();

  /// Add a new transfer receivable
  Future<void> addTransferReceivable(TransferReceivable transferReceivable);
  
  /// Clear all transfer receivables
  Future<void> clearTransferReceivables();
  
  /// Remove a specific transfer receivable
  Future<void> removeTransferReceivable(TransferReceivable transferReceivable);
}