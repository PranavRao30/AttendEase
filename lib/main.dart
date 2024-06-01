import 'package:flutter/material.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:attend_ease/gradient_container.dart'; 

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
      Color.fromARGB(255, 255, 255, 255),
      Color.fromARGB(255, 150, 67, 183),
      child: StartScreen(
        () {
        },
      ),
    );
  }
}
