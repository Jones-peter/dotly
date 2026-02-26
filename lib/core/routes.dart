import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/scan_result_page.dart';
import '../pages/maintenance_page.dart';
import '../models/scan_history.dart';

class AppRoutes {
  static const String home = '/';
  static const String scanResult = '/scan-result';
  static const String maintenance = '/maintenance';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _fade(const HomePage());

      case maintenance:
        return _fade(const MaintenancePage());

      case scanResult:
        final args = settings.arguments as ScanResultArgs;
        return _slide(
          ScanResultPage(scan: args.scan, imagePath: args.imagePath),
        );

      default:
        return _fade(const HomePage());
    }
  }

  static PageRoute _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      );

  static PageRoute _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      );
}

/// Typed args for scan result navigation
class ScanResultArgs {
  final ScanHistory scan;
  final String imagePath;

  const ScanResultArgs({required this.scan, required this.imagePath});
}