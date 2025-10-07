// Enhanced media model to support both photos and videos
class Photo {
  final String id;
  final String userId;
  final String userName;
  final String mediaUrl; // Can be image or video URL
  final String mediaType; // 'photo' or 'video'
  final DateTime timestamp;
  final DateTime expiresAt;
  final String? caption;
  final Map<String, dynamic>? captionStyle; // Text styling for Snapchat-like captions
  final double? videoDuration; // Duration in seconds for videos
  final String? thumbnailUrl; // Thumbnail for videos
  final bool isExpired;
  final Map<String, List<String>> reactions; // emoji -> list of user IDs
  final int reactionCount;

  Photo({
    required this.id,
    required this.userId,
    required this.userName,
    required this.mediaUrl,
    this.mediaType = 'photo',
    required this.timestamp,
    required this.expiresAt,
    this.caption,
    this.captionStyle,
    this.videoDuration,
    this.thumbnailUrl,
    bool? isExpired,
    Map<String, List<String>>? reactions,
  }) : isExpired = isExpired ?? DateTime.now().isAfter(expiresAt),
       reactions = reactions ?? {},
       reactionCount = reactions?.values.fold<int>(0, (sum, users) => sum + users.length) ?? 0;

  // Convenience getters
  bool get isVideo => mediaType == 'video';
  bool get isPhoto => mediaType == 'photo';
  String get imageUrl => mediaUrl; // For backward compatibility

  factory Photo.fromMap(Map<String, dynamic> map, String id) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0);
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      map['expiresAt'] ?? (timestamp.millisecondsSinceEpoch + (24 * 60 * 60 * 1000))
    );
    
    // Parse reactions map
    final reactionsData = map['reactions'] as Map<String, dynamic>? ?? {};
    final reactions = <String, List<String>>{};
    reactionsData.forEach((emoji, users) {
      if (users is List) {
        reactions[emoji] = users.cast<String>();
      }
    });
    
    return Photo(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      mediaUrl: map['mediaUrl'] ?? map['imageUrl'] ?? '', // Support legacy imageUrl
      mediaType: map['mediaType'] ?? 'photo',
      timestamp: timestamp,
      expiresAt: expiresAt,
      caption: map['caption'],
      captionStyle: map['captionStyle'] as Map<String, dynamic>?,
      videoDuration: map['videoDuration']?.toDouble(),
      thumbnailUrl: map['thumbnailUrl'],
      reactions: reactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'mediaUrl': mediaUrl,
      'imageUrl': mediaUrl, // For backward compatibility
      'mediaType': mediaType,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'caption': caption,
      'captionStyle': captionStyle,
      'videoDuration': videoDuration,
      'thumbnailUrl': thumbnailUrl,
      'reactions': reactions,
    };
  }

  // Check if photo is still valid (not expired)
  bool get isValid => DateTime.now().isBefore(expiresAt);

  // Get remaining time until expiration
  Duration get timeRemaining {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  // Get time remaining as a formatted string
  String get timeRemainingString {
    final remaining = timeRemaining;
    if (remaining == Duration.zero) {
      return 'Expired';
    }
    
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m left';
    } else {
      return '${minutes}m left';
    }
  }

  // Check if current user has reacted with specific emoji
  bool hasUserReacted(String userId, String emoji) {
    return reactions[emoji]?.contains(userId) ?? false;
  }

  // Get user reaction emoji if any
  String? getUserReaction(String userId) {
    for (final entry in reactions.entries) {
      if (entry.value.contains(userId)) {
        return entry.key;
      }
    }
    return null;
  }

  // Get top 3 reactions for display
  List<MapEntry<String, int>> get topReactions {
    final reactionCounts = <String, int>{};
    reactions.forEach((emoji, users) {
      reactionCounts[emoji] = users.length;
    });
    
    final sorted = reactionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(3).toList();
  }
}