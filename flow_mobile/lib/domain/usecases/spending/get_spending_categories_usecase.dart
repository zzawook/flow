import 'package:flow_mobile/domain/repositories/spending_repository.dart';

/// Use case for getting spending categories
abstract class GetSpendingCategoriesUseCase {
  Future<List<String>> execute();
}

/// Implementation of get spending categories use case
class GetSpendingCategoriesUseCaseImpl implements GetSpendingCategoriesUseCase {
  final SpendingRepository _spendingRepository;

  GetSpendingCategoriesUseCaseImpl(this._spendingRepository);

  @override
  Future<List<String>> execute() async {
    return await _spendingRepository.getSpendingCategories();
  }
}