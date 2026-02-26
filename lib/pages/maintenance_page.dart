import 'package:flutter/material.dart';
import '../core/theme.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DotlyTheme.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1.5),
                  ),
                  child: const Icon(Icons.construction_rounded, color: Colors.orange, size: 40),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Under Maintenance',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: DotlyTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Dotly is currently unavailable.\nPlease contact the developer.',
                  style: TextStyle(
                    fontSize: 15,
                    color: DotlyTheme.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: DotlyTheme.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: DotlyTheme.border),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.mail_outline_rounded, size: 16, color: DotlyTheme.textSecondary),
                      SizedBox(width: 8),
                      Text(
                        'support@dotly.app',
                        style: TextStyle(color: DotlyTheme.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}