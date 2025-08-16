import 'package:flow_mobile/domain/repositories/transfer_repository.dart';

/// Use case for clearing all transfer receivables
abstract class ClearTransferReceivablesUseCase {
  Future<void> execute();
}

/// Implementation of clear transfer receivables use case
class ClearTransferReceivablesUseCaseImpl implements ClearTransferReceivablesUseCase {
  final TransferRepository _transferRepository;

  ClearTransferReceivablesUseCaseImpl(this._transferRepository);

  @override
  Future<void> execute() async {
    await _transferRepository.clearTransferReceivables();
  }
}