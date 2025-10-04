import 'package:flow_mobile/domain/manager/auth_manager.dart';
import 'package:flow_mobile/domain/manager/auth_manager_impl.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager_impl.dart';
import 'package:flow_mobile/domain/manager/bank_manager.dart';
import 'package:flow_mobile/domain/manager/bank_manager_impl.dart';
import 'package:flow_mobile/domain/manager/card_manager.dart';
import 'package:flow_mobile/domain/manager/card_manager_impl.dart';
import 'package:flow_mobile/domain/manager/notification_manager.dart';
import 'package:flow_mobile/domain/manager/notification_manager_impl.dart';
import 'package:flow_mobile/domain/manager/setting_manager.dart';
import 'package:flow_mobile/domain/manager/setting_manager_impl.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/manager/transaction_manager_impl.dart';
import 'package:flow_mobile/domain/manager/transfer_receiveble_manager.dart';
import 'package:flow_mobile/domain/manager/transfer_receiveble_manager_impl.dart';
import 'package:flow_mobile/domain/manager/user_manager.dart';
import 'package:flow_mobile/domain/manager/user_manager_impl.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

Future<void> initManagers() async {
  getIt.registerSingleton<AuthManager>(await AuthManagerImpl.getInstance());
  getIt.registerSingleton<BankAccountManager>(
    await BankAccountManagerImpl.getInstance(),
  );
  getIt.registerSingleton<SettingManager>(
    await SettingManagerImpl.getInstance(),
  );
  getIt.registerSingleton<UserManager>(await UserManagerImpl.getInstance());
  getIt.registerSingleton<TransactionManager>(
    await TransactionManagerImpl.getInstance(),
  );
  getIt.registerSingleton<TransferReceivebleManager>(
    await TransferReceivebleManagerImpl.getInstance(),
  );
  getIt.registerSingleton<NotificationManager>(
    await NotificationManagerImpl.getInstance(),
  );
  getIt.registerSingleton<BankManager>(await BankManagerImpl.getInstance());
  getIt.registerSingleton<CardManager>(await CardManagerImpl.getInstance());
}
