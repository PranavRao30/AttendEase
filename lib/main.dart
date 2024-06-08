import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:attend_ease/gradient_container.dart';

Future main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
