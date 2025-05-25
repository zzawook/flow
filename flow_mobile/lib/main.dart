import 'package:flow_mobile/bootstrap/app_initializer.dart';
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

  final initialState = await AppInitializer.initializeServices();

  FlutterNativeSplash.remove();

  runApp(
    StoreProvider<FlowState>(
      store: flowStateStore(initialState),
      child: const FlowApplication(),
    ),
  );
}

class FlowApplication extends StatelessWidget {
  const FlowApplication({super.key});

  @override
  Widget build(BuildContext context) {
    // Grab store once
    final store = StoreProvider.of<FlowState>(context);

    return MaterialApp(
      title: 'Flow',
      theme: _buildTheme(),
      navigatorObservers: [ReduxRouteObserver(store)],
      builder:
          (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarContrastEnforced: true,
            ),
            child: child ?? SizedBox.shrink(),
          ),

      initialRoute: AppRoutes.home,
      onGenerateRoute:
          (settings) => AppRoutes.generate(settings, store.dispatch),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      fontFamily: 'Inter',
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF50C878),
        secondary: Color(0xFF50C878),
      ),
    );
  }
}
