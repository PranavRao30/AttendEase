import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.getStarted, {super.key});
  
  final void Function() getStarted;

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'AttendEase',
            style: TextStyle(
              color: Color.fromARGB(255, 195, 106, 203),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          // Use a placeholder in case the image fails to load
          Image.asset(
            'assets/images/MAD.png',
            width: 300,
          ),
          const SizedBox(height: 50),
          OutlinedButton.icon(
            onPressed: getStarted,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.arrow_right_alt),
            label: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}
