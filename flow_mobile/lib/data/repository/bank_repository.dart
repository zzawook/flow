import 'package:flow_mobile/domain/entities/bank.dart';

abstract class BankRepository {
  Future<List<Bank>> getBanks();
  Future<Bank> getBank(String name);
}