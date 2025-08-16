import 'package:flow_mobile/domain/entities/bank.dart';

/// Repository interface for bank operations
/// Matches existing BankManager method signatures for compatibility
abstract class BankRepository {
  /// Get all available banks
  Future<List<Bank>> getBanks();
  
  /// Get a specific bank by name
  Future<Bank> getBank(String name);
}