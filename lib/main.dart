import 'package:dotly/pages/home_page.dart';
import 'package:dotly/pages/maintenance_page.dart';
import 'package:dotly/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme.dart';
import 'core/routes.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DotlyApp());
}

class DotlyApp extends StatelessWidget {
  const DotlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dotly',
      debugShowCheckedModeBanner: false,
      theme: DotlyTheme.theme,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: const AppGate(),
    );
  }
}

class AppGate extends StatelessWidget {
  const AppGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppSettings>(
      stream: FirebaseService.instance.watchAppSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashPage();
        }
        final settings = snapshot.data;
        if (settings == null || !settings.isAppActive) {
          return const MaintenancePage();
        }
        return const HomePage();
      },
    );
  }
}