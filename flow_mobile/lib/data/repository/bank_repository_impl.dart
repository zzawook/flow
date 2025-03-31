import 'package:flow_mobile/data/repository/bank_repository.dart';
import 'package:flow_mobile/domain/entities/bank.dart';

class BankRepositoryImpl implements BankRepository {
  List<Bank> banks = [
    Bank(logoPath: 'assets/bank_logos/DBS.png', name: 'DBS'),
    Bank(logoPath: 'assets/bank_logos/UOB.png', name: 'UOB'),
    Bank(logoPath: 'assets/bank_logos/Maybank.png', name: 'Maybank'),
  ];

  static BankRepositoryImpl? _instance;

  BankRepositoryImpl._();

  static Future<BankRepositoryImpl> getInstance() async {
    _instance ??= BankRepositoryImpl._();
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
