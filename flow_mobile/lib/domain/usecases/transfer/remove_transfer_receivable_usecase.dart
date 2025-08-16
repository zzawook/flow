import 'package:flow_mobile/domain/entities/transfer_receivable.dart';
import 'package:flow_mobile/domain/repositories/transfer_repository.dart';

/// Use case for removing transfer receivables
abstract class RemoveTransferReceivableUseCase {
  Future<void> execute(TransferReceivable transferReceivable);
}

/// Implementation of remove transfer receivable use case
class RemoveTransferReceivableUseCaseImpl implements RemoveTransferReceivableUseCase {
  final TransferRepository _transferRepository;

  RemoveTransferReceivableUseCaseImpl(this._transferRepository);

  @override
  Future<void> execute(TransferReceivable transferReceivable) async {
    await _transferRepository.removeTransferReceivable(transferReceivable);
  }
}