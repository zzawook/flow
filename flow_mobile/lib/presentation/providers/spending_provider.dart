import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

/// StateNotifier for SpendingScreen state management
class SpendingScreenNotifier extends StateNotifier<SpendingScreenStateModel> {
  SpendingScreenNotifier() : super(SpendingScreenStateModel.initial());

  /// Update the displayed month
  void updateDisplayedMonth(DateTime month) {
    state = state.copyWith(displayedMonth: month);
  }

  /// Update the selected date
  void updateSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  /// Update the calendar selected date
  void updateCalendarSelectedDate(DateTime date) {
    state = state.copyWith(calendarSelectedDate: date);
  }

  /// Update the weekly spending calendar display week
  void updateWeeklySpendingCalendarDisplayWeek(DateTime week) {
    state = state.copyWith(weeklySpendingCalendarDisplayWeek: week);
  }

  /// Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  /// Set error state
  void setError(String error) {
    state = state.copyWith(error: error);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: '');
  }
}

/// StateNotifier for SpendingCategoryScreen state management
class SpendingCategoryScreenNotifier extends StateNotifier<SpendingCategoryScreenStateModel> {
  SpendingCategoryScreenNotifier() : super(SpendingCategoryScreenStateModel.initial());

  /// Update the displayed month
  void updateDisplayedMonth(DateTime month) {
    state = state.copyWith(displayedMonth: month);
  }
}

/// StateNotifier for RefreshScreen state management
class RefreshScreenNotifier extends StateNotifier<RefreshScreenStateModel> {
  RefreshScreenNotifier() : super(RefreshScreenStateModel.initial());

  /// Set banks to refresh
  void setBanksToRefresh(List<Bank> banks) {
    state = state.copyWith(banksToRefresh: banks);
  }

  /// Add bank to refresh
  void addBankToRefresh(Bank bank) {
    final updatedBanks = [...state.banksToRefresh, bank];
    state = state.copyWith(banksToRefresh: updatedBanks);
  }

  /// Remove bank from refresh
  void removeBankFromRefresh(Bank bank) {
    final updatedBanks = state.banksToRefresh.where((b) => b != bank).toList();
    state = state.copyWith(banksToRefresh: updatedBanks);
  }

  /// Clear banks to refresh
  void clearBanksToRefresh() {
    state = state.copyWith(banksToRefresh: []);
  }
}

/// StateNotifier for Screen state management (composite)
class ScreenNotifier extends StateNotifier<ScreenStateModel> {
  ScreenNotifier() : super(ScreenStateModel.initial());

  /// Update screen name
  void updateScreenName(String screenName) {
    state = state.copyWith(screenName: screenName);
  }

  /// Set refreshing state
  void setRefreshing(bool isRefreshing) {
    state = state.copyWith(isRefreshing: isRefreshing);
  }

  /// Update spending screen state
  void updateSpendingScreenState(SpendingScreenStateModel spendingScreenState) {
    state = state.copyWith(spendingScreenState: spendingScreenState);
  }

  /// Update refresh screen state
  void updateRefreshScreenState(RefreshScreenStateModel refreshScreenState) {
    state = state.copyWith(refreshScreenState: refreshScreenState);
  }

  /// Update spending category screen state
  void updateSpendingCategoryScreenState(SpendingCategoryScreenStateModel spendingCategoryScreenState) {
    state = state.copyWith(spendingCategoryScreenState: spendingCategoryScreenState);
  }
}

/// Provider for SpendingScreenNotifier
final spendingScreenNotifierProvider = StateNotifierProvider<SpendingScreenNotifier, SpendingScreenStateModel>((ref) {
  return SpendingScreenNotifier();
});

/// Provider for SpendingCategoryScreenNotifier
final spendingCategoryScreenNotifierProvider = StateNotifierProvider<SpendingCategoryScreenNotifier, SpendingCategoryScreenStateModel>((ref) {
  return SpendingCategoryScreenNotifier();
});

/// Provider for RefreshScreenNotifier
final refreshScreenNotifierProvider = StateNotifierProvider<RefreshScreenNotifier, RefreshScreenStateModel>((ref) {
  return RefreshScreenNotifier();
});

/// Provider for ScreenNotifier
final screenNotifierProvider = StateNotifierProvider<ScreenNotifier, ScreenStateModel>((ref) {
  return ScreenNotifier();
});

/// Convenience providers for accessing individual screen states
final spendingScreenStateProvider = Provider<SpendingScreenStateModel>((ref) {
  return ref.watch(spendingScreenNotifierProvider);
});

final spendingCategoryScreenStateProvider = Provider<SpendingCategoryScreenStateModel>((ref) {
  return ref.watch(spendingCategoryScreenNotifierProvider);
});

final refreshScreenStateProvider = Provider<RefreshScreenStateModel>((ref) {
  return ref.watch(refreshScreenNotifierProvider);
});

final screenStateProvider = Provider<ScreenStateModel>((ref) {
  return ref.watch(screenNotifierProvider);
});

/// Convenience provider for current screen name
final currentScreenProvider = Provider<String>((ref) {
  return ref.watch(screenNotifierProvider).screenName;
});

/// Convenience provider for refresh state
final isRefreshingProvider = Provider<bool>((ref) {
  return ref.watch(screenNotifierProvider).isRefreshing;
});