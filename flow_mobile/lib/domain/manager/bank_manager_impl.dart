import 'package:flow_mobile/domain/manager/bank_manager.dart';
import 'package:flow_mobile/domain/entity/bank.dart';

class BankManagerImpl implements BankManager {
  List<Bank> banks = [
    Bank(logoPath: 'assets/bank_logos/DBS.png', name: 'DBS'),
    Bank(logoPath: 'assets/bank_logos/UOB.png', name: 'UOB'),
    Bank(logoPath: 'assets/bank_logos/Maybank.png', name: 'Maybank'),
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
  Future<List<Bank>> getBanks() {
    return Future.value(banks);
  }
}
