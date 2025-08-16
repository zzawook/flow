import 'package:flow_mobile/domain/entities/transfer_receivable.dart';
import 'package:flow_mobile/domain/repositories/transfer_repository.dart';

/// Use case for getting transfer receivables
abstract class GetTransferReceivablesUseCase {
  Future<List<TransferReceivable>> execute();
}

/// Implementation of get transfer receivables use case
class GetTransferReceivablesUseCaseImpl implements GetTransferReceivablesUseCase {
  final TransferRepository _transferRepository;

  GetTransferReceivablesUseCaseImpl(this._transferRepository);

  @override
  Future<List<TransferReceivable>> execute() async {
    return await _transferRepository.getTransferReceivables();
  }
}