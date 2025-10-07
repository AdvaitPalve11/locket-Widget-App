class LocketNotification {
  final String id;
  final String title;
  final String body;
  final String type; // 'new_photo', 'friend_request', 'reaction'
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final bool isRead;

  LocketNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
    required this.timestamp,
    this.isRead = false,
  });

  factory LocketNotification.fromMap(Map<String, dynamic> map, String id) {
    return LocketNotification(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['type'] ?? '',
      data: Map<String, dynamic>.from(map['data'] ?? {}),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type,
      'data': data,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }

  // Factory methods for different notification types
  static LocketNotification newPhoto({
    required String fromUser,
    required String photoId,
  }) {
    return LocketNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Photo! 📸',
      body: '$fromUser just shared a new photo',
      type: 'new_photo',
      data: {'photoId': photoId, 'fromUser': fromUser},
      timestamp: DateTime.now(),
    );
  }

  static LocketNotification friendRequest({
    required String fromUser,
    required String fromUserId,
  }) {
    return LocketNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Friend Request 👋',
      body: '$fromUser wants to be your friend',
      type: 'friend_request',
      data: {'fromUserId': fromUserId, 'fromUser': fromUser},
      timestamp: DateTime.now(),
    );
  }

  static LocketNotification reaction({
    required String fromUser,
    required String emoji,
    required String photoId,
  }) {
    return LocketNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Reaction $emoji',
      body: '$fromUser reacted to your photo',
      type: 'reaction',
      data: {'photoId': photoId, 'fromUser': fromUser, 'emoji': emoji},
      timestamp: DateTime.now(),
    );
  }
}