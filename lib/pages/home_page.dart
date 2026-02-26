import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../core/theme.dart';
import '../services/firebase_service.dart';
import '../services/gemini_service.dart';
import '../models/scan_history.dart';
import '../widgets/history_card.dart';
import 'scan_result_page.dart';
import 'learn_braille_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showScanSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: DotlyTheme.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: DotlyTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Scan Braille',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: DotlyTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you want to capture the braille',
                style: TextStyle(color: DotlyTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _ScanOption(
                icon: Icons.camera_alt_rounded,
                label: 'Take Photo',
                subtitle: 'Use camera to capture braille',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              _ScanOption(
                icon: Icons.photo_library_rounded,
                label: 'Choose from Gallery',
                subtitle: 'Select an existing image',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 90);
    if (picked == null) return;

    setState(() => _scanning = true);

    try {
      final apiKey = await FirebaseService.instance.getApiKey();
      if (apiKey.isEmpty) {
        _showError('API key not configured. Contact developer.');
        return;
      }

      final result = await GeminiService.translateBraille(apiKey, File(picked.path));

      // Save to history
      final scan = ScanHistory(
        id: '',
        translatedText: result,
        timestamp: DateTime.now(),
        imagePath: picked.path,
      );
      await FirebaseService.instance.saveScan(scan);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ScanResultPage(scan: scan, imagePath: picked.path)),
      );
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _scanning = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade900,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DotlyTheme.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: DotlyTheme.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Dotly',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: DotlyTheme.textPrimary,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Braille translator',
                        style: TextStyle(color: DotlyTheme.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: DotlyTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: DotlyTheme.border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: DotlyTheme.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: DotlyTheme.textSecondary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  tabs: const [
                    Tab(text: 'History'),
                    Tab(text: 'Learn Braille'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _HistoryTab(),
                  const LearnBraillePage(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _scanning
          ? Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: DotlyTheme.accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                ),
              ),
            )
          : FloatingActionButton(
              onPressed: _showScanSheet,
              backgroundColor: DotlyTheme.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.document_scanner_rounded, color: Colors.white),
            ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScanHistory>>(
      stream: FirebaseService.instance.watchHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: DotlyTheme.accent));
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_rounded, size: 48, color: DotlyTheme.textSecondary.withOpacity(0.4)),
                const SizedBox(height: 16),
                const Text(
                  'No scans yet',
                  style: TextStyle(color: DotlyTheme.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the scan button to get started',
                  style: TextStyle(color: DotlyTheme.textSecondary, fontSize: 13),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (ctx, i) => HistoryCard(scan: items[i]),
        );
      },
    );
  }
}

class _ScanOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ScanOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DotlyTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DotlyTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: DotlyTheme.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: DotlyTheme.accent, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: DotlyTheme.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: DotlyTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: DotlyTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}