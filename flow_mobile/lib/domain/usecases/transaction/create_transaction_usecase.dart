import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/repositories/transaction_repository.dart';

/// Use case for creating transactions
abstract class CreateTransactionUseCase {
  Future<void> execute(Transaction transaction);
}

/// Implementation of create transaction use case
class CreateTransactionUseCaseImpl implements CreateTransactionUseCase {
  final TransactionRepository _transactionRepository;

  CreateTransactionUseCaseImpl(this._transactionRepository);

  @override
  Future<void> execute(Transaction transaction) async {
    await _transactionRepository.addTransaction(transaction);
  }
}