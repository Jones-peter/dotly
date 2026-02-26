import 'package:cloud_firestore/cloud_firestore.dart';

class ScanHistory {
  final String id;
  final String translatedText;
  final DateTime timestamp;
  final String? imagePath;

  ScanHistory({
    required this.id,
    required this.translatedText,
    required this.timestamp,
    this.imagePath,
  });

  Map<String, dynamic> toMap() => {
        'translatedText': translatedText,
        'timestamp': Timestamp.fromDate(timestamp),
        'imagePath': imagePath,
      };

  factory ScanHistory.fromMap(String id, Map<String, dynamic> map) => ScanHistory(
        id: id,
        translatedText: map['translatedText'] ?? '',
        timestamp: (map['timestamp'] as Timestamp).toDate(),
        imagePath: map['imagePath'],
      );
}