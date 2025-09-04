import 'package:flow_mobile/domain/manager/bank_manager.dart';
import 'package:flow_mobile/domain/entity/bank.dart';

class BankManagerImpl implements BankManager {
  List<Bank> banks = [
    Bank(name: 'DBS', bankId: 1),
    Bank(name: 'UOB', bankId: 2),
    Bank(name: 'Maybank', bankId: 3),
  ];

  static BankManagerImpl? _instance;

  BankManagerImpl._();

  static Future<BankManagerImpl> getInstance() async {
    _instance ??= BankManagerImpl._();
    return _instance!;
  }

  @override
  Future<Bank> getBank(String name) {
    for (var bank in banks) {
      if (bank.name == name) {
        return Future.value(bank);
      }
    }
    // ignore: null_argument_to_non_null_type
    return Future.value(null);
  }

  @override
  Future<void> clearBanks() {
    banks.clear();
    return Future.value();
  }

  @override
  Future<List<Bank>> getBanks() {
    return Future.value(banks);
  }

  @override
  Future<void> fetchBanksFromRemote() async {
    //TODO: Implement fetching banks from remote API
  }
}
