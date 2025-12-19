import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

enum WatermarkPosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

class WatermarkHelper {
  static Future<File> addWatermark(
    File originalImage, {
    required String text,
    WatermarkPosition position = WatermarkPosition.bottomRight,
    Color textColor = Colors.white,
    double textSize = 24.0,
    Color backgroundColor = Colors.black54,
    double padding = 10.0,
  }) async {
    try {
      // Load original image
      final bytes = await originalImage.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // Create picture recorder
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Draw original image
      canvas.drawImage(image, Offset.zero, Paint());

      // Prepare text
      final paragraphBuilder =
          ui.ParagraphBuilder(
              ui.ParagraphStyle(
                textAlign: TextAlign.center,
                fontSize: textSize,
              ),
            )
            ..pushStyle(
              ui.TextStyle(
                color: textColor,
                background: Paint()..color = backgroundColor,
              ),
            )
            ..addText(text);

      final paragraph = paragraphBuilder.build();
      paragraph.layout(const ui.ParagraphConstraints(width: 300));

      // Calculate position
      final offset = _calculatePosition(
        image.width.toDouble(),
        image.height.toDouble(),
        paragraph.width,
        paragraph.height,
        position,
        padding,
      );

      // Draw watermark
      canvas.drawParagraph(paragraph, offset);

      // Convert to image
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/watermarked_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await tempFile.writeAsBytes(pngBytes);
      return tempFile;
    } catch (e) {
      // If watermark fails, return original image
      return originalImage;
    }
  }

  static Offset _calculatePosition(
    double imageWidth,
    double imageHeight,
    double watermarkWidth,
    double watermarkHeight,
    WatermarkPosition position,
    double padding,
  ) {
    double x, y;

    switch (position) {
      case WatermarkPosition.topLeft:
        x = padding;
        y = padding;
        break;
      case WatermarkPosition.topCenter:
        x = (imageWidth - watermarkWidth) / 2;
        y = padding;
        break;
      case WatermarkPosition.topRight:
        x = imageWidth - watermarkWidth - padding;
        y = padding;
        break;
      case WatermarkPosition.centerLeft:
        x = padding;
        y = (imageHeight - watermarkHeight) / 2;
        break;
      case WatermarkPosition.center:
        x = (imageWidth - watermarkWidth) / 2;
        y = (imageHeight - watermarkHeight) / 2;
        break;
      case WatermarkPosition.centerRight:
        x = imageWidth - watermarkWidth - padding;
        y = (imageHeight - watermarkHeight) / 2;
        break;
      case WatermarkPosition.bottomLeft:
        x = padding;
        y = imageHeight - watermarkHeight - padding;
        break;
      case WatermarkPosition.bottomCenter:
        x = (imageWidth - watermarkWidth) / 2;
        y = imageHeight - watermarkHeight - padding;
        break;
      case WatermarkPosition.bottomRight:
        x = imageWidth - watermarkWidth - padding;
        y = imageHeight - watermarkHeight - padding;
        break;
    }

    return Offset(x, y);
  }

  // Add watermark with image
  static Future<File> addImageWatermark(
    File originalImage,
    File watermarkImage, {
    WatermarkPosition position = WatermarkPosition.bottomRight,
    double opacity = 0.5,
    double scale = 0.2,
    double padding = 10.0,
  }) async {
    try {
      // Load original image
      final originalBytes = await originalImage.readAsBytes();
      final originalCodec = await ui.instantiateImageCodec(originalBytes);
      final originalFrame = await originalCodec.getNextFrame();
      final image = originalFrame.image;

      // Load watermark image
      final watermarkBytes = await watermarkImage.readAsBytes();
      final watermarkCodec = await ui.instantiateImageCodec(watermarkBytes);
      final watermarkFrame = await watermarkCodec.getNextFrame();
      final watermark = watermarkFrame.image;

      // Calculate watermark size
      final watermarkWidth = image.width * scale;
      final watermarkHeight =
          (watermark.height * watermarkWidth) / watermark.width;

      // Create picture recorder
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Draw original image
      canvas.drawImage(image, Offset.zero, Paint());

      // Calculate position
      final offset = _calculatePosition(
        image.width.toDouble(),
        image.height.toDouble(),
        watermarkWidth,
        watermarkHeight,
        position,
        padding,
      );

      // Draw watermark with opacity
      final paint = Paint()
        ..colorFilter = ColorFilter.mode(
          Colors.white.withOpacity(opacity),
          BlendMode.modulate,
        );

      canvas.drawImageRect(
        watermark,
        Rect.fromLTWH(
          0,
          0,
          watermark.width.toDouble(),
          watermark.height.toDouble(),
        ),
        Rect.fromLTWH(offset.dx, offset.dy, watermarkWidth, watermarkHeight),
        paint,
      );

      // Convert to image
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/watermarked_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      await tempFile.writeAsBytes(pngBytes);
      return tempFile;
    } catch (e) {
      return originalImage;
    }
  }

  // Batch watermark multiple images
  static Future<List<File>> addWatermarkToMultiple(
    List<File> images, {
    required String text,
    WatermarkPosition position = WatermarkPosition.bottomRight,
    Color textColor = Colors.white,
    double textSize = 24.0,
  }) async {
    final List<File> watermarkedImages = [];

    for (final image in images) {
      try {
        final watermarked = await addWatermark(
          image,
          text: text,
          position: position,
          textColor: textColor,
          textSize: textSize,
        );
        watermarkedImages.add(watermarked);
      } catch (e) {
        watermarkedImages.add(image);
      }
    }

    return watermarkedImages;
  }
}
