import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/alert_bar.dart';
import '../utils/watermark_helper.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Pick single image from gallery
  Future<File?> pickImage({
    required BuildContext context,
    ImageSource source = ImageSource.gallery,
    bool addWatermark = true,
    String watermarkText = 'Chit Fund App',
  }) async {
    try {
      // Check and request permission
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          AlertBar.showError(
            context: context,
            message: 'Camera permission is required',
          );
          return null;
        }
      } else {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          AlertBar.showError(
            context: context,
            message: 'Photo library permission is required',
          );
          return null;
        }
      }

      // Pick image
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Add watermark if enabled
        if (addWatermark) {
          imageFile = await WatermarkHelper.addWatermark(
            imageFile,
            text: watermarkText,
            position: WatermarkPosition.bottomRight,
            textColor: Colors.white,
            backgroundColor: Colors.black54,
            textSize: 24.0,
            padding: 20.0,
          );
        }

        return imageFile;
      }
    } on Exception catch (e) {
      AlertBar.showError(
        context: context,
        message: 'Failed to pick image: ${e.toString()}',
      );
    }

    return null;
  }

  // Pick multiple images from gallery
  Future<List<File>> pickMultipleImages({
    required BuildContext context,
    int maxImages = 10,
    bool addWatermark = true,
    String watermarkText = 'Chit Fund App',
  }) async {
    try {
      // Check and request permission
      final status = await Permission.photos.request();
      if (!status.isGranted) {
        AlertBar.showError(
          context: context,
          message: 'Photo library permission is required',
        );
        return [];
      }

      // Pick multiple images
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFiles.isNotEmpty) {
        List<File> imageFiles = [];

        for (var pickedFile in pickedFiles.take(maxImages)) {
          File imageFile = File(pickedFile.path);

          // Add watermark if enabled
          if (addWatermark) {
            imageFile = await WatermarkHelper.addWatermark(
              imageFile,
              text: watermarkText,
              position: WatermarkPosition.bottomRight,
              textColor: Colors.white,
              backgroundColor: Colors.black54,
              textSize: 20.0,
              padding: 15.0,
            );
          }

          imageFiles.add(imageFile);
        }

        return imageFiles;
      }
    } on Exception catch (e) {
      AlertBar.showError(
        context: context,
        message: 'Failed to pick images: ${e.toString()}',
      );
    }

    return [];
  }

  // Capture image from camera
  Future<File?> captureImage({
    required BuildContext context,
    bool addWatermark = true,
    String watermarkText = 'Chit Fund App',
  }) async {
    return pickImage(
      context: context,
      source: ImageSource.camera,
      addWatermark: addWatermark,
      watermarkText: watermarkText,
    );
  }

  // Show image source selection dialog
  Future<File?> showImageSourceDialog({
    required BuildContext context,
    bool addWatermark = true,
    String watermarkText = 'Chit Fund App',
  }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      return pickImage(
        context: context,
        source: source,
        addWatermark: addWatermark,
        watermarkText: watermarkText,
      );
    }

    return null;
  }

  // Compress image
  Future<File> compressImage(File imageFile, {int quality = 85}) async {
    // Note: For actual compression, you might want to use flutter_image_compress package
    // This is a simplified version
    return imageFile;
  }

  // Get image size
  Future<double> getImageSize(File imageFile) async {
    final size = await imageFile.length();
    return size / (1024 * 1024); // Convert to MB
  }

  // Check if image size is within limit
  Future<bool> isImageSizeWithinLimit(
    File imageFile, {
    double maxSizeMB = 10,
  }) async {
    final sizeMB = await getImageSize(imageFile);
    return sizeMB <= maxSizeMB;
  }
}
