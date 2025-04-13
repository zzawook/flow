import 'package:flow_mobile/data/repository/transfer_receiveble_repository.dart';
import 'package:flow_mobile/domain/entities/transfer_receivable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../source/local_secure_hive.dart';

class TransferReceivebleRepositoryImpl implements TransferReceivebleRepository {
  final Box<TransferReceivable> _transferReceivableBox;

  static TransferReceivebleRepositoryImpl? _instance;

  TransferReceivebleRepositoryImpl._(
    this._transferReceivableBox,
  );
  static Future<TransferReceivebleRepositoryImpl> getInstance() async {
    if (_instance == null) {
      final transferReceivableBox = await SecureHive.getBox<TransferReceivable>(
        'transferReceivable',
      );
      _instance = TransferReceivebleRepositoryImpl._(
        transferReceivableBox,
      );
    }
    return _instance!;
  }

  @override
  Future<List<TransferReceivable>> getTransferReceivables() async {
    List<TransferReceivable> transferReceivableList =
        _transferReceivableBox.values.toList();
    return transferReceivableList;
  }

  @override
  Future<void> addTransferReceivable(
    TransferReceivable transferReceivable,
  ) async {
    await _transferReceivableBox.add(transferReceivable);
  }

  @override
  Future<void> clearTransferReceivables() async {
    await _transferReceivableBox.clear();
  }

  @override
  Future<void> removeTransferReceivable(
    TransferReceivable transferReceivable,
  ) async {
    final key = _transferReceivableBox.keys.firstWhere(
      (k) => _transferReceivableBox.get(k) == transferReceivable,
      orElse: () => -1,
    );
    if (key != -1) {
      await _transferReceivableBox.delete(key);
    }
  }
}
