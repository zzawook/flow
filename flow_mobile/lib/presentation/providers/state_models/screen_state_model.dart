import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/presentation/providers/state_models/spending_screen_state_model.dart';
import 'package:flow_mobile/presentation/providers/state_models/refresh_screen_state_model.dart';
import 'package:flow_mobile/presentation/providers/state_models/spending_category_screen_state_model.dart';

part 'screen_state_model.freezed.dart';

@freezed
class ScreenStateModel with _$ScreenStateModel {
  const factory ScreenStateModel({
    required String screenName,
    required SpendingScreenStateModel spendingScreenState,
    required RefreshScreenStateModel refreshScreenState,
    required SpendingCategoryScreenStateModel spendingCategoryScreenState,
    required bool isRefreshing,
  }) = _ScreenStateModel;

  factory ScreenStateModel.initial() {
    return ScreenStateModel(
      screenName: '/home',
      spendingScreenState: SpendingScreenStateModel.initial(),
      isRefreshing: false,
      refreshScreenState: RefreshScreenStateModel.initial(),
      spendingCategoryScreenState: SpendingCategoryScreenStateModel.initial(),
    );
  }
}