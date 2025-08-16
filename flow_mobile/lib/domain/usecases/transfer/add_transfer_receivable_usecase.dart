import 'package:flow_mobile/domain/entities/transfer_receivable.dart';
import 'package:flow_mobile/domain/repositories/transfer_repository.dart';

/// Use case for adding transfer receivables
abstract class AddTransferReceivableUseCase {
  Future<void> execute(TransferReceivable transferReceivable);
}

/// Implementation of add transfer receivable use case
class AddTransferReceivableUseCaseImpl implements AddTransferReceivableUseCase {
  final TransferRepository _transferRepository;

  AddTransferReceivableUseCaseImpl(this._transferRepository);

  @override
  Future<void> execute(TransferReceivable transferReceivable) async {
    await _transferRepository.addTransferReceivable(transferReceivable);
  }
}