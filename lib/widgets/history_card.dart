import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../core/theme.dart';
import '../models/scan_history.dart';
import '../services/firebase_service.dart';

class HistoryCard extends StatefulWidget {
  final ScanHistory scan;
  const HistoryCard({super.key, required this.scan});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  final FlutterTts _tts = FlutterTts();
  bool _speaking = false;

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleSpeak() async {
    if (_speaking) {
      await _tts.stop();
      setState(() => _speaking = false);
    } else {
      await _tts.speak(widget.scan.translatedText);
      setState(() => _speaking = true);
      _tts.setCompletionHandler(() => setState(() => _speaking = false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DotlyTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DotlyTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image thumb
          if (widget.scan.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(widget.scan.imagePath!),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              ),
            )
          else
            _placeholder(),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.scan.translatedText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: DotlyTheme.textPrimary, height: 1.5),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(widget.scan.timestamp),
                  style: const TextStyle(fontSize: 11, color: DotlyTheme.textSecondary),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Play button
          GestureDetector(
            onTap: _toggleSpeak,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _speaking ? Colors.red.withOpacity(0.15) : DotlyTheme.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _speaking ? Icons.stop_rounded : Icons.play_arrow_rounded,
                color: _speaking ? Colors.red : DotlyTheme.accent,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Delete
          GestureDetector(
            onTap: () => FirebaseService.instance.deleteHistory(widget.scan.id),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: DotlyTheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.text_fields_rounded, color: DotlyTheme.textSecondary, size: 24),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}