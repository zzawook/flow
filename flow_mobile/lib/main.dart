import 'package:flow_mobile/initialization/app_initializer.dart';
import 'package:flow_mobile/initialization/riverpod_app_initializer.dart';
import 'package:flow_mobile/initialization/theme_store.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/navigation/app_router.dart';



Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize the application
  await AppInitializer.initializeApplication();

  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      child: FlowApplication(),
    ),
  );
}

class FlowApplication extends ConsumerStatefulWidget {
  const FlowApplication({
    super.key,
  });

  @override
  ConsumerState<FlowApplication> createState() => _FlowApplicationState();
}

class _FlowApplicationState extends ConsumerState<FlowApplication> {

  @override
  void initState() {
    super.initState();
    _initializeProviders();
  }

  Future<void> _initializeProviders() async {
    // Initialize Riverpod providers after Redux state is ready
    try {
      await RiverpodAppInitializer.initializeProviders(ref);
    } catch (e) {
      debugPrint('Provider initialization failed: $e');
      // Continue with app even if provider initialization fails
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use default theme - settings will be loaded through Riverpod providers
    final theme = ThemeStore.buildDefaultTheme();
    
    // Try to use GoRouter, but fall back to a simple MaterialApp if it fails
    Widget app;
    try {
      final router = ref.watch(routerProvider);
      app = MaterialApp.router(
        title: 'Flow',
        theme: theme,
        routerConfig: router,
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: theme.scaffoldBackgroundColor,
            statusBarIconBrightness:
                theme.brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
            systemNavigationBarContrastEnforced: true,
          ),
          child: child ?? const SizedBox.shrink(),
        ),
      );
    } catch (e) {
      debugPrint('GoRouter initialization failed: $e');
      // Fallback to a simple MaterialApp
      app = MaterialApp(
        title: 'Flow',
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF50C878),
                ),
                const SizedBox(height: 16),
                Text(
                  'Initializing Flow App...',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: theme.scaffoldBackgroundColor,
            statusBarIconBrightness:
                theme.brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
            systemNavigationBarContrastEnforced: true,
          ),
          child: child ?? const SizedBox.shrink(),
        ),
      );
    }

    return app;
  }
}
