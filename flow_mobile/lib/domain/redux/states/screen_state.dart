import 'package:flow_mobile/domain/redux/states/account_detail_screen_state.dart';
import 'package:flow_mobile/domain/redux/states/asset_screen_state.dart';
import 'package:flow_mobile/domain/redux/states/refresh_screen_state.dart';
import 'package:flow_mobile/domain/redux/states/spending_category_screen_state.dart';
import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';

class ScreenState {
  final String screenName;
  final SpendingScreenState spendingScreenState;
  final RefreshScreenState refreshScreenState;
  final SpendingCategoryScreenState spendingCategoryScreenState;
  final AccountDetailScreenState accountDetailScreenState;
  final AssetScreenState assetScreenState;
  final bool isRefreshing;

  ScreenState({
    required this.screenName,
    required this.spendingScreenState,
    required this.isRefreshing,
    required this.refreshScreenState,
    required this.spendingCategoryScreenState,
    required this.accountDetailScreenState,
    required this.assetScreenState,
  });

  ScreenState copyWith({
    required String screenName,
    required SpendingScreenState spendingScreenState,
    required bool isRefreshing,
    required RefreshScreenState refreshScreenState,
    required SpendingCategoryScreenState spendingCategoryScreenState,
    required AccountDetailScreenState accountDetailScreenState,
    required AssetScreenState assetScreenState,
  }) {
    return ScreenState(
      screenName: screenName,
      spendingScreenState: spendingScreenState,
      isRefreshing: isRefreshing,
      refreshScreenState: refreshScreenState,
      spendingCategoryScreenState: spendingCategoryScreenState,
      accountDetailScreenState: accountDetailScreenState,
      assetScreenState: assetScreenState,
    );
  }

  static ScreenState initial() {
    return ScreenState(
      screenName: "/home",
      spendingScreenState: SpendingScreenState.initial(),
      isRefreshing: false,
      refreshScreenState: RefreshScreenState.initial(),
      spendingCategoryScreenState: SpendingCategoryScreenState.initial(),
      accountDetailScreenState: AccountDetailScreenState.initial(),
      assetScreenState: AssetScreenState.initial(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenState &&
          runtimeType == other.runtimeType &&
          screenName == other.screenName &&
          spendingScreenState == other.spendingScreenState &&
          isRefreshing == other.isRefreshing &&
          refreshScreenState == other.refreshScreenState &&
          spendingCategoryScreenState == other.spendingCategoryScreenState &&
          accountDetailScreenState == other.accountDetailScreenState &&
          assetScreenState == other.assetScreenState;

  @override
  int get hashCode => screenName.hashCode;

  @override
  String toString() {
    return 'ScreenState{screenName: $screenName}';
  }
}
