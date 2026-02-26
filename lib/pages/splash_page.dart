import 'package:flutter/material.dart';
import '../core/theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DotlyTheme.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DotlyLogo(size: 72),
            const SizedBox(height: 24),
            Text(
              'Dotly',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: DotlyTheme.textPrimary,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: DotlyTheme.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotlyLogo extends StatelessWidget {
  final double size;
  const _DotlyLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: DotlyTheme.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DotlyTheme.accent.withOpacity(0.3), width: 1.5),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(size * 0.2),
        mainAxisSpacing: size * 0.08,
        crossAxisSpacing: size * 0.08,
        physics: const NeverScrollableScrollPhysics(),
        children: [true, false, true, true, false, true].take(4).map((filled) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? DotlyTheme.accent : DotlyTheme.accent.withOpacity(0.2),
            ),
          );
        }).toList(),
      ),
    );
  }
}