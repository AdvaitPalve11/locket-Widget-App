import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class MediaProcessingHelper {
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1080;
  static const double compressionQuality = 0.8;

  // Compress image file
  static Future<File?> compressImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: maxImageWidth,
        targetHeight: maxImageHeight,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      
      if (byteData == null) return null;

      final tempDir = await getTemporaryDirectory();
      final compressedFile = File(
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      
      await compressedFile.writeAsBytes(byteData.buffer.asUint8List());
      return compressedFile;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  // Generate thumbnail from image
  static Future<File?> generateImageThumbnail(File imageFile) async {
    try {
      const thumbnailSize = 200;
      final bytes = await imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: thumbnailSize,
        targetHeight: thumbnailSize,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      
      if (byteData == null) return null;

      final tempDir = await getTemporaryDirectory();
      final thumbnailFile = File(
        '${tempDir.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      
      await thumbnailFile.writeAsBytes(byteData.buffer.asUint8List());
      return thumbnailFile;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  // Capture widget as image
  static Future<File?> captureWidget(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      
      if (byteData == null) return null;

      final tempDir = await getTemporaryDirectory();
      final file = File(
        '${tempDir.path}/widget_capture_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file;
    } catch (e) {
      print('Error capturing widget: $e');
      return null;
    }
  }

  // Pick and process image
  static Future<ProcessedMedia?> pickAndProcessImage({
    ImageSource source = ImageSource.camera,
    bool compress = true,
    bool generateThumbnail = true,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: maxImageWidth.toDouble(),
        maxHeight: maxImageHeight.toDouble(),
        imageQuality: (compressionQuality * 100).round(),
      );

      if (pickedFile == null) return null;

      File imageFile = File(pickedFile.path);
      File? compressedFile;
      File? thumbnailFile;

      if (compress) {
        compressedFile = await compressImage(imageFile);
      }

      if (generateThumbnail) {
        thumbnailFile = await generateImageThumbnail(imageFile);
      }

      return ProcessedMedia(
        originalFile: imageFile,
        compressedFile: compressedFile,
        thumbnailFile: thumbnailFile,
        mediaType: MediaType.image,
      );
    } catch (e) {
      print('Error picking and processing image: $e');
      return null;
    }
  }

  // Pick and process video
  static Future<ProcessedMedia?> pickAndProcessVideo({
    ImageSource source = ImageSource.camera,
    Duration? maxDuration,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(
        source: source,
        maxDuration: maxDuration ?? const Duration(seconds: 30),
      );

      if (pickedFile == null) return null;

      File videoFile = File(pickedFile.path);
      File? thumbnailFile = await generateVideoThumbnail(videoFile);

      return ProcessedMedia(
        originalFile: videoFile,
        thumbnailFile: thumbnailFile,
        mediaType: MediaType.video,
      );
    } catch (e) {
      print('Error picking and processing video: $e');
      return null;
    }
  }

  // Generate video thumbnail (placeholder implementation)
  static Future<File?> generateVideoThumbnail(File videoFile) async {
    try {
      // This is a placeholder. In a real app, you'd use a video processing library
      // like video_thumbnail or ffmpeg_kit_flutter
      
      final tempDir = await getTemporaryDirectory();
      final thumbnailFile = File(
        '${tempDir.path}/video_thumb_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      
      // For now, just create a placeholder image
      const thumbnailData = '''
        iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==
      ''';
      
      final dataUri = Uri.dataFromString(thumbnailData);
      final bytes = dataUri.data?.contentAsBytes() ?? <int>[];
      await thumbnailFile.writeAsBytes(bytes);
      
      return thumbnailFile;
    } catch (e) {
      print('Error generating video thumbnail: $e');
      return null;
    }
  }

  // Get file size in MB
  static Future<double> getFileSizeInMB(File file) async {
    try {
      final bytes = await file.length();
      return bytes / (1024 * 1024);
    } catch (e) {
      print('Error getting file size: $e');
      return 0.0;
    }
  }

  // Check if file size is within limits
  static Future<bool> isFileSizeValid(File file, double maxSizeMB) async {
    final sizeMB = await getFileSizeInMB(file);
    return sizeMB <= maxSizeMB;
  }

  // Clean up temporary files
  static Future<void> cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();
      
      for (final file in files) {
        if (file is File && 
            (file.path.contains('compressed_') ||
             file.path.contains('thumb_') ||
             file.path.contains('widget_capture_') ||
             file.path.contains('video_thumb_'))) {
          
          // Delete files older than 1 hour
          final stats = await file.stat();
          final age = DateTime.now().difference(stats.modified);
          if (age.inHours > 1) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      print('Error cleaning up temp files: $e');
    }
  }

  // Resize image to specific dimensions
  static Future<File?> resizeImage(
    File imageFile, {
    required int width,
    required int height,
  }) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: width,
        targetHeight: height,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      
      if (byteData == null) return null;

      final tempDir = await getTemporaryDirectory();
      final resizedFile = File(
        '${tempDir.path}/resized_${width}x${height}_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      
      await resizedFile.writeAsBytes(byteData.buffer.asUint8List());
      return resizedFile;
    } catch (e) {
      print('Error resizing image: $e');
      return null;
    }
  }

  // Apply blur effect to image
  static Future<File?> applyBlurEffect(File imageFile, double sigma) async {
    try {
      // This would require image processing libraries like image package
      // For now, return original file
      return imageFile;
    } catch (e) {
      print('Error applying blur effect: $e');
      return null;
    }
  }
}

// Data class for processed media
class ProcessedMedia {
  final File originalFile;
  final File? compressedFile;
  final File? thumbnailFile;
  final MediaType mediaType;

  ProcessedMedia({
    required this.originalFile,
    this.compressedFile,
    this.thumbnailFile,
    required this.mediaType,
  });

  // Get the best quality file available
  File get bestQualityFile => compressedFile ?? originalFile;

  // Get display file (thumbnail for videos, compressed for images)
  File get displayFile {
    if (mediaType == MediaType.video) {
      return thumbnailFile ?? originalFile;
    }
    return compressedFile ?? originalFile;
  }
}

enum MediaType {
  image,
  video,
}