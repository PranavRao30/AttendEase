import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:attend_ease/gradient_container.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAssxds3OW3obpQorBTiqDfFJv_4BXN2Vo",
          appId: "1:814534653957:android:d087e6d377e21aaa0b446c",
          messagingSenderId: "814534653957",
          projectId: "attendease-f1528"));
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GradientContainerWithStartScreen(),
      ),
    );
  }
}

class GradientContainerWithStartScreen extends StatelessWidget {
  const GradientContainerWithStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      const Color.fromARGB(255, 255, 255, 255),
      const Color.fromARGB(255, 150, 67, 183),
      child: StartScreen(),
    );
  }
}
