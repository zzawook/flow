import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/domain/usecases/usecases.dart';
import 'package:flow_mobile/core/providers/repository_providers.dart';

// User Use Case Providers

/// Provider for GetUserUseCase
final getUserUseCaseProvider = FutureProvider<GetUserUseCase>((ref) async {
  final repository = await ref.read(userRepositoryProvider.future);
  return GetUserUseCaseImpl(repository);
});

/// Provider for UpdateUserUseCase
final updateUserUseCaseProvider = FutureProvider<UpdateUserUseCase>((ref) async {
  final repository = await ref.read(userRepositoryProvider.future);
  return UpdateUserUseCaseImpl(repository);
});

/// Provider for DeleteUserUseCase
final deleteUserUseCaseProvider = FutureProvider<DeleteUserUseCase>((ref) async {
  final repository = await ref.read(userRepositoryProvider.future);
  return DeleteUserUseCaseImpl(repository);
});

// Transaction Use Case Providers

/// Provider for GetTransactionsUseCase
final getTransactionsUseCaseProvider = FutureProvider<GetTransactionsUseCase>((ref) async {
  final repository = await ref.read(transactionRepositoryProvider.future);
  return GetTransactionsUseCaseImpl(repository);
});

/// Provider for CreateTransactionUseCase
final createTransactionUseCaseProvider = FutureProvider<CreateTransactionUseCase>((ref) async {
  final repository = await ref.read(transactionRepositoryProvider.future);
  return CreateTransactionUseCaseImpl(repository);
});

/// Provider for UpdateTransactionUseCase
final updateTransactionUseCaseProvider = FutureProvider<UpdateTransactionUseCase>((ref) async {
  final repository = await ref.read(transactionRepositoryProvider.future);
  return UpdateTransactionUseCaseImpl(repository);
});

/// Provider for DeleteTransactionUseCase
final deleteTransactionUseCaseProvider = FutureProvider<DeleteTransactionUseCase>((ref) async {
  final repository = await ref.read(transactionRepositoryProvider.future);
  return DeleteTransactionUseCaseImpl(repository);
});

// Account Use Case Providers

/// Provider for GetAccountsUseCase
final getAccountsUseCaseProvider = FutureProvider<GetAccountsUseCase>((ref) async {
  final repository = await ref.read(accountRepositoryProvider.future);
  return GetAccountsUseCaseImpl(repository);
});

/// Provider for CreateAccountUseCase
final createAccountUseCaseProvider = FutureProvider<CreateAccountUseCase>((ref) async {
  final repository = await ref.read(accountRepositoryProvider.future);
  return CreateAccountUseCaseImpl(repository);
});

/// Provider for UpdateAccountUseCase
final updateAccountUseCaseProvider = FutureProvider<UpdateAccountUseCase>((ref) async {
  final repository = await ref.read(accountRepositoryProvider.future);
  return UpdateAccountUseCaseImpl(repository);
});

/// Provider for DeleteAccountUseCase
final deleteAccountUseCaseProvider = FutureProvider<DeleteAccountUseCase>((ref) async {
  final repository = await ref.read(accountRepositoryProvider.future);
  return DeleteAccountUseCaseImpl(repository);
});

// Auth Use Case Providers

/// Provider for LoginUseCase
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCaseImpl(repository);
});

/// Provider for LogoutUseCase
final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return LogoutUseCaseImpl(repository);
});

/// Provider for GetAuthStatusUseCase
final getAuthStatusUseCaseProvider = Provider<GetAuthStatusUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetAuthStatusUseCaseImpl(repository);
});

/// Provider for RefreshTokenUseCase
final refreshTokenUseCaseProvider = Provider<RefreshTokenUseCase>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return RefreshTokenUseCaseImpl(repository);
});

// Bank Use Case Providers
// TODO: Uncomment when BankRepositoryImpl is created

// /// Provider for GetBanksUseCase
// final getBanksUseCaseProvider = Provider<GetBanksUseCase>((ref) {
//   return GetBanksUseCaseImpl(ref.read(bankRepositoryProvider));
// });

// /// Provider for GetBankUseCase
// final getBankUseCaseProvider = Provider<GetBankUseCase>((ref) {
//   return GetBankUseCaseImpl(ref.read(bankRepositoryProvider));
// });

// Notification Use Case Providers

/// Provider for GetNotificationsUseCase
final getNotificationsUseCaseProvider = FutureProvider<GetNotificationsUseCase>((ref) async {
  final repository = await ref.read(notificationRepositoryProvider.future);
  return GetNotificationsUseCaseImpl(repository);
});

/// Provider for MarkNotificationReadUseCase
final markNotificationReadUseCaseProvider = FutureProvider<MarkNotificationReadUseCase>((ref) async {
  final repository = await ref.read(notificationRepositoryProvider.future);
  return MarkNotificationReadUseCaseImpl(repository);
});

/// Provider for DeleteNotificationUseCase
final deleteNotificationUseCaseProvider = FutureProvider<DeleteNotificationUseCase>((ref) async {
  final repository = await ref.read(notificationRepositoryProvider.future);
  return DeleteNotificationUseCaseImpl(repository);
});

// Settings Use Case Providers

/// Provider for GetDisplayBalanceUseCase
final getDisplayBalanceUseCaseProvider = FutureProvider<GetDisplayBalanceUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return GetDisplayBalanceUseCaseImpl(repository);
});

/// Provider for SetDisplayBalanceUseCase
final setDisplayBalanceUseCaseProvider = FutureProvider<SetDisplayBalanceUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return SetDisplayBalanceUseCaseImpl(repository);
});

/// Provider for GetNotificationSettingsUseCase
final getNotificationSettingsUseCaseProvider = FutureProvider<GetNotificationSettingsUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return GetNotificationSettingsUseCaseImpl(repository);
});

/// Provider for SetNotificationSettingsUseCase
final setNotificationSettingsUseCaseProvider = FutureProvider<SetNotificationSettingsUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return SetNotificationSettingsUseCaseImpl(repository);
});

/// Provider for GetThemeUseCase
final getThemeUseCaseProvider = FutureProvider<GetThemeUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return GetThemeUseCaseImpl(repository);
});

/// Provider for SetThemeUseCase
final setThemeUseCaseProvider = FutureProvider<SetThemeUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return SetThemeUseCaseImpl(repository);
});

/// Provider for GetLanguageUseCase
final getLanguageUseCaseProvider = FutureProvider<GetLanguageUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return GetLanguageUseCaseImpl(repository);
});

/// Provider for SetLanguageUseCase
final setLanguageUseCaseProvider = FutureProvider<SetLanguageUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return SetLanguageUseCaseImpl(repository);
});

/// Provider for GetFontScaleUseCase
final getFontScaleUseCaseProvider = FutureProvider<GetFontScaleUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return GetFontScaleUseCaseImpl(repository);
});

/// Provider for SetFontScaleUseCase
final setFontScaleUseCaseProvider = FutureProvider<SetFontScaleUseCase>((ref) async {
  final repository = await ref.read(settingsRepositoryProvider.future);
  return SetFontScaleUseCaseImpl(repository);
});

// Spending Use Case Providers

/// Provider for GetSpendingUseCase
final getSpendingUseCaseProvider = FutureProvider<GetSpendingUseCase>((ref) async {
  final repository = await ref.read(spendingRepositoryProvider.future);
  return GetSpendingUseCaseImpl(repository);
});

/// Provider for CreateSpendingUseCase
final createSpendingUseCaseProvider = FutureProvider<CreateSpendingUseCase>((ref) async {
  final repository = await ref.read(spendingRepositoryProvider.future);
  return CreateSpendingUseCaseImpl(repository);
});

/// Provider for UpdateSpendingUseCase
final updateSpendingUseCaseProvider = FutureProvider<UpdateSpendingUseCase>((ref) async {
  final repository = await ref.read(spendingRepositoryProvider.future);
  return UpdateSpendingUseCaseImpl(repository);
});

/// Provider for DeleteSpendingUseCase
final deleteSpendingUseCaseProvider = FutureProvider<DeleteSpendingUseCase>((ref) async {
  final repository = await ref.read(spendingRepositoryProvider.future);
  return DeleteSpendingUseCaseImpl(repository);
});

/// Provider for GetSpendingCategoriesUseCase
final getSpendingCategoriesUseCaseProvider = FutureProvider<GetSpendingCategoriesUseCase>((ref) async {
  final repository = await ref.read(spendingRepositoryProvider.future);
  return GetSpendingCategoriesUseCaseImpl(repository);
});

// Transfer Use Case Providers
// TODO: Uncomment when TransferRepositoryImpl is created

// /// Provider for GetTransferReceivablesUseCase
// final getTransferReceivablesUseCaseProvider = Provider<GetTransferReceivablesUseCase>((ref) {
//   return GetTransferReceivablesUseCaseImpl(ref.read(transferRepositoryProvider));
// });

// /// Provider for AddTransferReceivableUseCase
// final addTransferReceivableUseCaseProvider = Provider<AddTransferReceivableUseCase>((ref) {
//   return AddTransferReceivableUseCaseImpl(ref.read(transferRepositoryProvider));
// });

// /// Provider for RemoveTransferReceivableUseCase
// final removeTransferReceivableUseCaseProvider = Provider<RemoveTransferReceivableUseCase>((ref) {
//   return RemoveTransferReceivableUseCaseImpl(ref.read(transferRepositoryProvider));
// });

// /// Provider for ClearTransferReceivablesUseCase
// final clearTransferReceivablesUseCaseProvider = Provider<ClearTransferReceivableUseCase>((ref) {
//   return ClearTransferReceivablesUseCaseImpl(ref.read(transferRepositoryProvider));
// });