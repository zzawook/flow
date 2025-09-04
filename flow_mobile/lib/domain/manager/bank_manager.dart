import 'package:flow_mobile/domain/entity/bank.dart';

abstract class BankManager {
  Future<List<Bank>> getBanks();
  Future<Bank> getBank(String name);
  Future<void> clearBanks();

  Future<void> fetchBanksFromRemote() async {}
}