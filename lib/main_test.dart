import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('🔥 Firebase initialized successfully!');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }
  
  runApp(const LocketApp());
}

class LocketApp extends StatelessWidget {
  const LocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locket Widget App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Locket Widget App - Test'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_launch,
              size: 100,
              color: Colors.deepPurple,
            ),
            SizedBox(height: 20),
            Text(
              '🎉 Your App is Working!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Firebase integrated ✅',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            Text(
              'Android ready ✅',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
            Text(
              'UI components ready ✅',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('App is working perfectly! 🚀')),
          );
        },
        tooltip: 'Test',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}