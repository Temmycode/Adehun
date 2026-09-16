import 'package:adehun_mvp/core/resources/service_locator.dart';
import 'package:adehun_mvp/data/local/token_storage.dart';
import 'package:adehun_mvp/router/auth_route_notifier.dart';
import 'package:adehun_mvp/theme/theme_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
  final prefs = await SharedPreferences.getInstance();

  // Seed the route guard from what is actually on disk. Token presence, not a
  // prefs flag, decides whether the user has a session.
  final token = await const TokenStorage(FlutterSecureStorage()).getAccessToken();
  authRouteNotifier.seed(
    hasSession: token != null && token.isNotEmpty,
    isFirstLaunch: prefs.getBool('is_first_launch') ?? true,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const AdehunApp(),
    ),
  );
}

class AdehunApp extends ConsumerWidget {
  const AdehunApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      title: 'Adehun',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: theme,
      routerConfig: appRouter,
    );
  }
}
