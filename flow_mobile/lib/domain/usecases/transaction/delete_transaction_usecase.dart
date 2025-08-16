import 'package:flow_mobile/domain/repositories/transaction_repository.dart';

/// Use case for deleting transactions
abstract class DeleteTransactionUseCase {
  Future<void> execute();
  Future<void> executeAll();
}

/// Implementation of delete transaction use case
class DeleteTransactionUseCaseImpl implements DeleteTransactionUseCase {
  final TransactionRepository _transactionRepository;

  DeleteTransactionUseCaseImpl(this._transactionRepository);

  @override
  Future<void> execute() async {
    // Note: This is a placeholder - in a real implementation,
    // this would need a transaction ID or other identifier
    throw UnimplementedError('Delete specific transaction not implemented - needs transaction identifier');
  }

  @override
  Future<void> executeAll() async {
    await _transactionRepository.clearTransactions();
  }
}