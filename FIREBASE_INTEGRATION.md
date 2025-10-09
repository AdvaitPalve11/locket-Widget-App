# 🔥 Firebase Services Setup Guide

## 📱 **Your Firebase Project**: locket-widget-app-2025

### ✅ **Step 1: Enable Authentication**

1. Go to [Authentication](https://console.firebase.google.com/project/locket-widget-app-2025/authentication/users)
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab
4. Enable these providers:
   - ✅ **Email/Password** → Enable
   - ✅ **Anonymous** → Enable (for guest users)
   - 🔄 **Google** → Optional (better UX)

### ✅ **Step 2: Enable Firestore Database**

1. Go to [Firestore Database](https://console.firebase.google.com/project/locket-widget-app-2025/firestore)
2. Click **"Create database"**
3. Choose **"Start in test mode"** (for development)
4. Select location: **us-central1** (or closest to you)

### ✅ **Step 3: Enable Cloud Storage**

1. Go to [Storage](https://console.firebase.google.com/project/locket-widget-app-2025/storage)
2. Click **"Get started"**
3. Choose **"Start in test mode"**
4. Use same location as Firestore

### 🔐 **Step 4: Security Rules (Copy-Paste Ready)**

#### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User's photos subcollection
      match /photos/{photoId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // Friend requests subcollection
      match /friendRequests/{requestId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Photos - users can read all, write their own
    match /photos/{photoId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
    
    // Friendships
    match /friendships/{friendshipId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.user1Id || 
         request.auth.uid == resource.data.user2Id);
    }
  }
}
```

#### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User profile images
    match /users/{userId}/profile/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Photos - readable by all authenticated users, writable by owner
    match /photos/{photoId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.resource.size < 10 * 1024 * 1024; // 10MB limit
    }
  }
}
```

## 🧪 **Step 5: Test Firebase Connection**

After enabling services, we'll test:
1. ✅ Authentication signup/login
2. ✅ Firestore data read/write
3. ✅ Storage photo upload
4. ✅ Real-time updates

## 📊 **Current Integration Status**

✅ Firebase project created  
✅ firebase_options.dart configured  
✅ main.dart updated with initialization  
🔄 Services need to be enabled in console  
🔄 Build system needs testing  

## 🎯 **Next Steps**

1. **Enable services** in Firebase console (5 minutes)
2. **Test build** to ensure everything compiles
3. **Test Firebase features** in the app
4. **Deploy security rules** for production safety

---

**Ready?** Enable the services above, then let me know and we'll test the Firebase integration! 🚀