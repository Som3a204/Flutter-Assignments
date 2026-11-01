import 'package:e_commerce/core/router/auth_notifier.dart';
import 'package:e_commerce/core/services/service_locator.dart';
import 'package:e_commerce/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register Dio, DioClient, token storage and all services.
  await configureDependencies();

  // Local-cache-first: skip login when a cached session exists.
  final authNotifier = getIt<AuthNotifier>();
  if (await getIt<AuthRepository>().isLoggedIn()) {
    authNotifier.markLoggedIn();
  }
  runApp(MyApp(router: createRouter(authNotifier)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'E-Commerce',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
