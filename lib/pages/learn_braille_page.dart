import 'package:flutter/material.dart';
import '../core/theme.dart';

class LearnBraillePage extends StatelessWidget {
  const LearnBraillePage({super.key});

  static const Map<String, String> _brailleAlphabet = {
    'A': '⠁', 'B': '⠃', 'C': '⠉', 'D': '⠙', 'E': '⠑',
    'F': '⠋', 'G': '⠛', 'H': '⠓', 'I': '⠊', 'J': '⠚',
    'K': '⠅', 'L': '⠇', 'M': '⠍', 'N': '⠝', 'O': '⠕',
    'P': '⠏', 'Q': '⠟', 'R': '⠗', 'S': '⠎', 'T': '⠞',
    'U': '⠥', 'V': '⠧', 'W': '⠺', 'X': '⠭', 'Y': '⠽', 'Z': '⠵',
  };

  @override
  Widget build(BuildContext context) {
    final entries = _brailleAlphabet.entries.toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DotlyTheme.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DotlyTheme.accent.withOpacity(0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, color: DotlyTheme.accentLight, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Each braille cell uses 6 dots in a 2×3 grid',
                      style: TextStyle(color: DotlyTheme.accentLight, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final entry = entries[i];
                return Container(
                  decoration: BoxDecoration(
                    color: DotlyTheme.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: DotlyTheme.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        entry.value,
                        style: const TextStyle(fontSize: 28, color: DotlyTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: DotlyTheme.accent,
                        ),
                      ),
                    ],
                  ),
                );
              },
              childCount: entries.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
          ),
        ),
      ],
    );
  }
}
