import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_DashBoard.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          Image.asset(
            'assets/images/MAD.png',
            width: 300,
          ),
          const SizedBox(height: 50),
          OutlinedButton.icon(
            onPressed: () {
              // calling c
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
              if (provider.user != null) {
                // User is signed in
                // Navigate to the next screen or perform any other action
              }
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Teachers_Dashboard()),
              // );
            },
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
