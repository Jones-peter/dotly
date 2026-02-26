import 'dart:io';
import 'package:image/image.dart' as img;

class ImageProcessor {
  static Future<File> enhance(File imageFile) async {
    final bytes = await imageFile.readAsBytes();

    // Decode image
    img.Image? image = img.decodeImage(bytes);
    if (image == null) return imageFile; // fallback to original if decode fails

    // Step 1: Convert to grayscale
    image = img.grayscale(image);

    // Step 2: Boost contrast
    image = img.adjustColor(image, contrast: 2.0);

    // Step 3: Sharpen to make dots pop
    image = img.convolution(image, filter: [
      0, -1,  0,
     -1,  5, -1,
      0, -1,  0,
    ], div: 1);

    // Save enhanced image to temp file
    final tempPath =
        '${imageFile.parent.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final outFile = File(tempPath);
    await outFile.writeAsBytes(img.encodeJpg(image, quality: 95));

    return outFile;
  }
}