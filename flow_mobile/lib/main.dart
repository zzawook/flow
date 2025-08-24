import 'package:flow_mobile/initialization/app_initializer.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/initialization/theme_store.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'domain/redux/flow_state.dart';
import 'domain/redux/store.dart';
import 'presentation/navigation/app_routes.dart';
import 'presentation/navigation/redux_route_observer.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final initialState = await AppInitializer.initializeApplication();

  FlutterNativeSplash.remove();

  runApp(
    StoreProvider<FlowState>(
      store: flowStateStore(initialState),
      child: FlowApplication(initialState: initialState),
    ),
  );
}

class FlowApplication extends StatelessWidget {
  final FlowState initialState;

  const FlowApplication({super.key, required this.initialState});

  @override
  Widget build(BuildContext context) {
    // Grab store once
    final store = StoreProvider.of<FlowState>(context);

    return StoreConnector<FlowState, String>(
      converter: (store) => store.state.settingsState.settings.theme,
      builder: (context, themeName) {
        final theme = ThemeStore.buildTheme(store.state.settingsState.settings);
        return MaterialApp(
          title: 'Flow',
          theme: theme,
          navigatorKey: getIt<NavigationService>().navigatorKey,
          navigatorObservers: [ReduxRouteObserver(store)],
          builder:
              (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: theme.scaffoldBackgroundColor,
                  statusBarIconBrightness:
                      theme.brightness == Brightness.light
                          ? Brightness.dark
                          : Brightness.light,
                  systemNavigationBarContrastEnforced: true,
                ),
                child: child ?? SizedBox.shrink(),
              ),

          initialRoute:
              initialState.authState.isAuthenticated
                  ? AppRoutes.home
                  : AppRoutes.welcome,
          onGenerateRoute:
              (settings) => AppRoutes.generate(settings, store.dispatch),
        );
      },
    );
  }
}
