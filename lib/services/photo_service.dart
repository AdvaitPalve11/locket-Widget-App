import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/photo.dart';

class PhotoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Upload a photo
  Future<String?> uploadPhoto(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Create a unique filename
      final fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('photos/$fileName');

      // Upload the file
      await ref.putFile(imageFile);

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading photo: $e');
      return null;
    }
  }

  // Share a photo with friends (24-hour expiration)
  Future<bool> sharePhoto(String imageUrl, String? caption) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Get user's friends
      final friendsDoc = await _firestore.collection('users').doc(user.uid).get();
      final friends = List<String>.from(friendsDoc.data()?['friends'] ?? []);

      // Create photo document with 24-hour expiration
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));
      
      final photoData = Photo(
        id: '',
        userId: user.uid,
        userName: user.displayName ?? user.email ?? 'Unknown',
        mediaUrl: imageUrl,
        mediaType: 'photo',
        timestamp: now,
        expiresAt: expiresAt,
        caption: caption,
      ).toMap();

      // Add photo to each friend's feed
      final batch = _firestore.batch();
      
      for (String friendId in friends) {
        final photoRef = _firestore
            .collection('users')
            .doc(friendId)
            .collection('photos')
            .doc();
        batch.set(photoRef, photoData);
      }

      // Also add to user's own photos
      final userPhotoRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('myPhotos')
          .doc();
      batch.set(userPhotoRef, photoData);

      await batch.commit();
      
      // Schedule cleanup for expired photos
      _schedulePhotoCleanup();
      
      return true;
    } catch (e) {
      print('Error sharing photo: $e');
      return false;
    }
  }

  // Enhanced upload method supporting both photos and videos
  Future<bool> uploadMedia(
    File mediaFile, {
    String? caption,
    Map<String, dynamic>? captionStyle,
    String mediaType = 'photo',
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Upload the media file
      final mediaUrl = await _uploadMediaFile(mediaFile, mediaType);
      if (mediaUrl == null) return false;

      // For videos, generate thumbnail
      String? thumbnailUrl;
      double? videoDuration;
      
      if (mediaType == 'video') {
        // In a real implementation, you'd extract video thumbnail and duration
        // For now, we'll use placeholder values
        videoDuration = 15.0; // Default duration
        // thumbnailUrl = await _generateVideoThumbnail(mediaFile);
      }

      // Create the photo/video object
      final now = DateTime.now();
      final expiresAt = now.add(const Duration(hours: 24));

      final photo = Photo(
        id: '', // Firestore will generate this
        userId: user.uid,
        userName: user.displayName ?? user.email ?? 'Unknown User',
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        timestamp: now,
        expiresAt: expiresAt,
        caption: caption,
        captionStyle: captionStyle,
        videoDuration: videoDuration,
        thumbnailUrl: thumbnailUrl,
      );

      // Save to Firestore and share with friends
      return await _shareMediaWithFriends(photo);
    } catch (e) {
      print('Error uploading media: $e');
      return false;
    }
  }

  // Upload media file to Firebase Storage
  Future<String?> _uploadMediaFile(File mediaFile, String mediaType) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      // Create a unique filename with correct extension
      final extension = mediaType == 'video' ? 'mp4' : 'jpg';
      final fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.$extension';
      final ref = _storage.ref().child('${mediaType}s/$fileName');

      // Upload the file
      final uploadTask = ref.putFile(mediaFile);
      
      // You can listen to upload progress here if needed
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(progress * 100).toStringAsFixed(1)}%');
      });

      await uploadTask;

      // Get the download URL
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading media file: $e');
      return null;
    }
  }

  // Share media with friends
  Future<bool> _shareMediaWithFriends(Photo photo) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Get user's friends
      final friendsDoc = await _firestore.collection('users').doc(user.uid).get();
      final friends = List<String>.from(friendsDoc.data()?['friends'] ?? []);

      final batch = _firestore.batch();

      // Save to user's own photos
      final userPhotoRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('myPhotos')
          .doc();
      
      batch.set(userPhotoRef, photo.toMap());

      // Share with friends
      for (String friendId in friends) {
        final friendPhotoRef = _firestore
            .collection('users')
            .doc(friendId)
            .collection('photos')
            .doc();
        
        batch.set(friendPhotoRef, photo.toMap());
      }

      await batch.commit();

      // Schedule cleanup for when the photo expires
      _schedulePhotoCleanup();

      return true;
    } catch (e) {
      print('Error sharing media with friends: $e');
      return false;
    }
  }

  // Get photos from friends (only non-expired ones)
  Future<List<Photo>> getFriendPhotos() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final now = DateTime.now();
      
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('photos')
          .where('expiresAt', isGreaterThan: now.millisecondsSinceEpoch)
          .orderBy('expiresAt')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      final photos = snapshot.docs
          .map((doc) => Photo.fromMap(doc.data(), doc.id))
          .where((photo) => photo.isValid)
          .toList();

      // Clean up any expired photos we might have missed
      _cleanupExpiredPhotos();

      return photos;
    } catch (e) {
      print('Error getting friend photos: $e');
      return [];
    }
  }

  // Get user's own photos (only non-expired ones)
  Future<List<Photo>> getMyPhotos() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final now = DateTime.now();

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('myPhotos')
          .where('expiresAt', isGreaterThan: now.millisecondsSinceEpoch)
          .orderBy('expiresAt')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => Photo.fromMap(doc.data(), doc.id))
          .where((photo) => photo.isValid)
          .toList();
    } catch (e) {
      print('Error getting my photos: $e');
      return [];
    }
  }

  // Download a photo to device storage
  Future<String?> downloadPhoto(Photo photo) async {
    try {
      if (!photo.isValid) {
        throw Exception('Media has expired and cannot be downloaded');
      }

      // Get the media data from URL
      final response = await http.get(Uri.parse(photo.mediaUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download media');
      }

      // Get the downloads directory
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/Locket_Downloads');
      
      // Create directory if it doesn't exist
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Create filename with timestamp and correct extension
      final timestamp = photo.timestamp.millisecondsSinceEpoch;
      final extension = photo.isVideo ? 'mp4' : 'jpg';
      final mediaType = photo.isVideo ? 'video' : 'photo';
      final fileName = 'locket_${photo.userName}_${mediaType}_$timestamp.$extension';
      final filePath = '${downloadsDir.path}/$fileName';

      // Write the file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print('${photo.isVideo ? 'Video' : 'Photo'} downloaded to: $filePath');
      return filePath;
    } catch (e) {
      print('Error downloading ${photo.isVideo ? 'video' : 'photo'}: $e');
      return null;
    }
  }

  // Get download history
  Future<List<String>> getDownloadedPhotos() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/Locket_Downloads');
      
      if (!await downloadsDir.exists()) {
        return [];
      }

      final files = await downloadsDir.list().toList();
      return files
          .where((file) => file is File && file.path.endsWith('.jpg'))
          .map((file) => file.path)
          .toList();
    } catch (e) {
      print('Error getting downloaded photos: $e');
      return [];
    }
  }

  // Clean up expired photos from Firestore
  Future<void> _cleanupExpiredPhotos() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final now = DateTime.now();
      
      // Clean up expired photos from user's feed
      final expiredPhotos = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('photos')
          .where('expiresAt', isLessThan: now.millisecondsSinceEpoch)
          .get();

      final batch = _firestore.batch();
      for (var doc in expiredPhotos.docs) {
        batch.delete(doc.reference);
      }

      // Clean up expired photos from user's own photos
      final expiredMyPhotos = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('myPhotos')
          .where('expiresAt', isLessThan: now.millisecondsSinceEpoch)
          .get();

      for (var doc in expiredMyPhotos.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Error cleaning up expired photos: $e');
    }
  }

  // Schedule periodic cleanup of expired photos
  void _schedulePhotoCleanup() {
    // In a real app, you might use Cloud Functions for this
    // For now, we'll clean up whenever we fetch photos
    Future.delayed(const Duration(minutes: 5), () {
      _cleanupExpiredPhotos();
    });
  }

  // Delete a photo (if it's the user's own photo)
  Future<bool> deletePhoto(String photoId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Delete from user's own photos
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('myPhotos')
          .doc(photoId)
          .delete();

      // Note: In a real app, you might also want to delete from friends' feeds
      // and remove the actual image from Firebase Storage

      return true;
    } catch (e) {
      print('Error deleting photo: $e');
      return false;
    }
  }

  // Get storage usage info
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final downloadedPhotos = await getDownloadedPhotos();
      int totalSize = 0;
      
      for (String path in downloadedPhotos) {
        final file = File(path);
        if (await file.exists()) {
          final stat = await file.stat();
          totalSize += stat.size;
        }
      }

      return {
        'downloadedCount': downloadedPhotos.length,
        'totalSizeBytes': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      print('Error getting storage info: $e');
      return {
        'downloadedCount': 0,
        'totalSizeBytes': 0,
        'totalSizeMB': '0.00',
      };
    }
  }

  // Clear all downloaded photos
  Future<bool> clearDownloads() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${directory.path}/Locket_Downloads');
      
      if (await downloadsDir.exists()) {
        await downloadsDir.delete(recursive: true);
      }
      
      return true;
    } catch (e) {
      print('Error clearing downloads: $e');
      return false;
    }
  }

  // Add or remove reaction to a photo
  Future<bool> toggleReaction(String photoId, String emoji) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final photoRef = _firestore.collection('photos').doc(photoId);
      
      return await _firestore.runTransaction((transaction) async {
        final photoDoc = await transaction.get(photoRef);
        if (!photoDoc.exists) return false;

        final data = photoDoc.data()!;
        final reactions = Map<String, List<dynamic>>.from(data['reactions'] ?? {});
        
        // Check if user already reacted with this emoji
        final currentUsers = List<String>.from(reactions[emoji] ?? []);
        
        if (currentUsers.contains(user.uid)) {
          // Remove reaction
          currentUsers.remove(user.uid);
          if (currentUsers.isEmpty) {
            reactions.remove(emoji);
          } else {
            reactions[emoji] = currentUsers;
          }
        } else {
          // Remove any existing reaction from this user
          reactions.forEach((key, users) {
            users.remove(user.uid);
          });
          reactions.removeWhere((key, users) => users.isEmpty);
          
          // Add new reaction
          reactions[emoji] = [...currentUsers, user.uid];
        }

        transaction.update(photoRef, {'reactions': reactions});
        return true;
      });
    } catch (e) {
      print('Error toggling reaction: $e');
      return false;
    }
  }

  // Get available reaction emojis
  static const List<String> availableReactions = [
    '❤️', '😂', '😍', '😢', '😮', '😡', '👍', '👎', '🔥', '⭐'
  ];
}