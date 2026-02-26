import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../core/theme.dart';
import '../models/scan_history.dart';

class ScanResultPage extends StatefulWidget {
  final ScanHistory scan;
  final String imagePath;

  const ScanResultPage({super.key, required this.scan, required this.imagePath});

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _tts.setCompletionHandler(() => setState(() => _isSpeaking = false));
    _tts.setCancelHandler(() => setState(() => _isSpeaking = false));
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _toggleSpeak() async {
    if (_isSpeaking) {
      await _tts.stop();
      setState(() => _isSpeaking = false);
    } else {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.45);
      await _tts.speak(widget.scan.translatedText);
      setState(() => _isSpeaking = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DotlyTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: DotlyTheme.textPrimary),
                  ),
                  const Text(
                    'Translation Result',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: DotlyTheme.textPrimary),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(widget.imagePath),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Label
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 18,
                          decoration: BoxDecoration(
                            color: DotlyTheme.accent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Translated Text',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: DotlyTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Result card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: DotlyTheme.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: DotlyTheme.border),
                      ),
                      child: Text(
                        widget.scan.translatedText,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.7,
                          color: DotlyTheme.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Speak button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _toggleSpeak,
                        icon: Icon(_isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded),
                        label: Text(_isSpeaking ? 'Stop Speaking' : 'Speak Text'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isSpeaking ? Colors.red.shade900 : DotlyTheme.accent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Timestamp
                    Center(
                      child: Text(
                        'Scanned ${_formatDate(widget.scan.timestamp)}',
                        style: const TextStyle(color: DotlyTheme.textSecondary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} at ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}