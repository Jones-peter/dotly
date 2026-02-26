import 'dart:convert';
import 'dart:io';
import 'package:dotly/services/image_processor.dart';
import 'package:http/http.dart' as http;

class GeminiService {
static Future<String> translateBraille(String apiKey, File imageFile) async {
  
  final enhanced = await ImageProcessor.enhance(imageFile);
  final bytes = await enhanced.readAsBytes();
  final base64Image = base64Encode(bytes);

  final url = Uri.parse(
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
  );

  final body = jsonEncode({
    "contents": [
      {
        "parts": [
          {
            "inline_data": {
              "mime_type": "image/jpeg",
              "data": base64Image,
            }
          },
          {
            "text": """You are an expert braille decoder with deep knowledge of Grade 1 and Grade 2 braille.

This image contains PHYSICAL EMBOSSED BRAILLE. The dots may appear low-contrast, white-on-white, or subtle — this is normal for real braille.

Instructions:
1. Scan the image carefully for raised dot patterns arranged in 2-column x 3-row cells
2. Each cell = one braille character. Read left to right, top to bottom
3. Map each dot pattern to its English letter/number/punctuation
4. If contrast is low, look for shadows or subtle height differences
5. Return ONLY the final translated English text, nothing else

Translate all braille in the image now:"""
          }
        ]
      }
    ],
    "generationConfig": {
      "temperature": 0.05,
      "maxOutputTokens": 1024,
    }
  });

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['candidates'][0]['content']['parts'][0]['text'] as String;
  } else {
    throw Exception('Gemini API error: ${response.statusCode} ${response.body}');
  }
}
}