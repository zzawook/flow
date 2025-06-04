import 'package:flow_mobile/domain/manager/transfer_receiveble_manager.dart';
import 'package:flow_mobile/domain/entity/transfer_receivable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../service/local_source/local_secure_hive.dart';

class TransferReceivebleManagerImpl implements TransferReceivebleManager {
  final Box<TransferReceivable> _transferReceivableBox;

  static TransferReceivebleManagerImpl? _instance;

  TransferReceivebleManagerImpl._(
    this._transferReceivableBox,
  );
  static Future<TransferReceivebleManagerImpl> getInstance() async {
    if (_instance == null) {
      final transferReceivableBox = await SecureHive.getBox<TransferReceivable>(
        'transferReceivable',
      );
      _instance = TransferReceivebleManagerImpl._(
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
