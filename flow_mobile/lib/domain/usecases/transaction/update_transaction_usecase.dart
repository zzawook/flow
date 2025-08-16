import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/repositories/transaction_repository.dart';

/// Use case for updating transactions
abstract class UpdateTransactionUseCase {
  Future<void> execute(Transaction transaction);
}

/// Implementation of update transaction use case
class UpdateTransactionUseCaseImpl implements UpdateTransactionUseCase {
  final TransactionRepository _transactionRepository;

  UpdateTransactionUseCaseImpl(this._transactionRepository);

  @override
  Future<void> execute(Transaction transaction) async {
    // Note: This assumes the repository will handle the update logic
    // In a real implementation, this might involve finding and replacing the transaction
    await _transactionRepository.addTransaction(transaction);
  }
}