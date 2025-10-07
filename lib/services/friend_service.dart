import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Friend {
  final String id;
  final String email;
  final String name;
  final DateTime addedAt;

  Friend({
    required this.id,
    required this.email,
    required this.name,
    required this.addedAt,
  });

  factory Friend.fromMap(Map<String, dynamic> map, String id) {
    return Friend(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      addedAt: DateTime.fromMillisecondsSinceEpoch(map['addedAt'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'addedAt': addedAt.millisecondsSinceEpoch,
    };
  }
}

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send friend request
  Future<bool> sendFriendRequest(String friendEmail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Find user by email
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: friendEmail)
          .get();

      if (userQuery.docs.isEmpty) {
        return false; // User not found
      }

      final friendDoc = userQuery.docs.first;
      final friendId = friendDoc.id;

      // Check if already friends
      final currentUserDoc = await _firestore.collection('users').doc(user.uid).get();
      final friends = List<String>.from(currentUserDoc.data()?['friends'] ?? []);
      
      if (friends.contains(friendId)) {
        return false; // Already friends
      }

      // Create friend request
      await _firestore
          .collection('users')
          .doc(friendId)
          .collection('friendRequests')
          .doc(user.uid)
          .set({
        'fromUserId': user.uid,
        'fromUserEmail': user.email,
        'fromUserName': user.displayName ?? user.email ?? 'Unknown',
        'timestamp': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error sending friend request: $e');
      return false;
    }
  }

  // Accept friend request
  Future<bool> acceptFriendRequest(String fromUserId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final batch = _firestore.batch();

      // Add to current user's friends list
      final userRef = _firestore.collection('users').doc(user.uid);
      batch.update(userRef, {
        'friends': FieldValue.arrayUnion([fromUserId])
      });

      // Add to friend's friends list
      final friendRef = _firestore.collection('users').doc(fromUserId);
      batch.update(friendRef, {
        'friends': FieldValue.arrayUnion([user.uid])
      });

      // Remove friend request
      final requestRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friendRequests')
          .doc(fromUserId);
      batch.delete(requestRef);

      await batch.commit();
      return true;
    } catch (e) {
      print('Error accepting friend request: $e');
      return false;
    }
  }

  // Reject friend request
  Future<bool> rejectFriendRequest(String fromUserId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friendRequests')
          .doc(fromUserId)
          .delete();

      return true;
    } catch (e) {
      print('Error rejecting friend request: $e');
      return false;
    }
  }

  // Get friends list
  Future<List<Friend>> getFriends() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final friendIds = List<String>.from(userDoc.data()?['friends'] ?? []);

      if (friendIds.isEmpty) return [];

      final friends = <Friend>[];
      for (String friendId in friendIds) {
        final friendDoc = await _firestore.collection('users').doc(friendId).get();
        if (friendDoc.exists) {
          final data = friendDoc.data()!;
          friends.add(Friend(
            id: friendId,
            email: data['email'] ?? '',
            name: data['displayName'] ?? data['email'] ?? 'Unknown',
            addedAt: DateTime.now(), // You might want to store this properly
          ));
        }
      }

      return friends;
    } catch (e) {
      print('Error getting friends: $e');
      return [];
    }
  }

  // Get friend requests
  Future<List<Map<String, dynamic>>> getFriendRequests() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('friendRequests')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting friend requests: $e');
      return [];
    }
  }

  // Remove friend
  Future<bool> removeFriend(String friendId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final batch = _firestore.batch();

      // Remove from current user's friends list
      final userRef = _firestore.collection('users').doc(user.uid);
      batch.update(userRef, {
        'friends': FieldValue.arrayRemove([friendId])
      });

      // Remove from friend's friends list
      final friendRef = _firestore.collection('users').doc(friendId);
      batch.update(friendRef, {
        'friends': FieldValue.arrayRemove([user.uid])
      });

      await batch.commit();
      return true;
    } catch (e) {
      print('Error removing friend: $e');
      return false;
    }
  }

  // Initialize user document
  Future<void> initializeUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': user.displayName ?? user.email,
          'friends': [],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error initializing user: $e');
    }
  }
}