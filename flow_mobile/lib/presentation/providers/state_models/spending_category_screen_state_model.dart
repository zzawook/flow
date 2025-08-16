import 'package:freezed_annotation/freezed_annotation.dart';

part 'spending_category_screen_state_model.freezed.dart';

@freezed
class SpendingCategoryScreenStateModel with _$SpendingCategoryScreenStateModel {
  const factory SpendingCategoryScreenStateModel({
    required DateTime displayedMonth,
  }) = _SpendingCategoryScreenStateModel;

  factory SpendingCategoryScreenStateModel.initial() {
    return SpendingCategoryScreenStateModel(
      displayedMonth: DateTime(DateTime.now().year, DateTime.now().month),
    );
  }
}