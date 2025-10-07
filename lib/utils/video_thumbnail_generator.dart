import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';

class VideoThumbnailGenerator {
  static Future<File?> generateThumbnail(String videoPath) async {
    try {
      VideoPlayerController controller;
      
      if (videoPath.startsWith('http')) {
        controller = VideoPlayerController.networkUrl(Uri.parse(videoPath));
      } else {
        controller = VideoPlayerController.file(File(videoPath));
      }

      await controller.initialize();
      
      // Get frame at 1 second or beginning if video is shorter
      final duration = controller.value.duration;
      final seekTime = duration.inSeconds > 1 
          ? const Duration(seconds: 1) 
          : Duration(milliseconds: duration.inMilliseconds ~/ 2);
      
      await controller.seekTo(seekTime);
      
      // In a real implementation, you would capture the frame here
      // For now, we'll create a placeholder file
      final tempDir = await getTemporaryDirectory();
      final thumbnailFile = File('${tempDir.path}/thumb_${DateTime.now().millisecondsSinceEpoch}.jpg');
      
      // Create an empty placeholder file
      await thumbnailFile.writeAsBytes([]);
      
      controller.dispose();
      
      return thumbnailFile;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  static Future<double> getVideoDuration(String videoPath) async {
    try {
      VideoPlayerController controller;
      
      if (videoPath.startsWith('http')) {
        controller = VideoPlayerController.networkUrl(Uri.parse(videoPath));
      } else {
        controller = VideoPlayerController.file(File(videoPath));
      }

      await controller.initialize();
      final duration = controller.value.duration.inSeconds.toDouble();
      controller.dispose();
      
      return duration;
    } catch (e) {
      print('Error getting video duration: $e');
      return 0.0;
    }
  }

  static String formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.round());
    if (duration.inHours > 0) {
      return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}