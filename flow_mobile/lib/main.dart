import 'package:flow_mobile/bootstrap/app_initializer.dart';
import 'package:flow_mobile/domain/entities/setting.dart';
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
    final theme = _buildTheme(store.state.settingsState.settings);

    return MaterialApp(
      title: 'Flow',
      theme: theme,
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

      initialRoute: AppRoutes.home,
      onGenerateRoute:
          (settings) => AppRoutes.generate(settings, store.dispatch),
    );
  }

  ThemeData _buildTheme(Settings settings) {
    if (settings.theme == "light") {
      return ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        primaryColor: Color(0xFF50C878),
        primaryColorLight: Color(0x8850C878),
        canvasColor: Color(0xFFF0F0F0),
        cardColor: Color(0xFFFFFFFF),
        dividerColor: Color(0xFFE0E0E0),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        disabledColor: Color(0xFFBDBDBD),
        scaffoldBackgroundColor: Color(0xFFF0F0F0),
        brightness: Brightness.light,
      );
    } else {
      return ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        primaryColor: Color(0xFF50C878),
        primaryColorLight: Color(0x8850C878),
        scaffoldBackgroundColor: Color(0xFF242424),

        dividerColor: Color(0xFFE0E0E0),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white.withAlpha(220),
          ),
          titleMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.normal,
            color: Colors.white.withAlpha(240),
          ),
          titleSmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white.withAlpha(240),
          ),
          labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        cardColor: Color(0xFF292929),
        canvasColor: Color(0xFF242424),
        disabledColor: Color(0xFF444444),
        brightness: Brightness.dark,
      );
    }
  }
}
