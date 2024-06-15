import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_DashBoard.dart';
import 'package:provider/provider.dart';
import 'package:attend_ease/Backend/add_data.dart';
import  'package:google_fonts/google_fonts.dart';
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(
            'AttendEase',
            style: GoogleFonts.poppins(
              color: Color.fromARGB(255, 255, 255, 255),
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
            onPressed: () async {
              // Provider is used to call google signin methods
              // listen = false indicates the widget in signin screen does not rebuild
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              await provider.googleLogin();
              // User is signed in
              // Navigate to the next screen.
              add_Teachers_data();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Teachers_Dashboard()),
              );
              print("Inside button:${emailName.toString()}");
                        },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(width: 2.0, color: Colors.white),
            ),
            icon: const Icon(Icons.arrow_right_alt),
            label: Text(
            'Get Started',
            style: GoogleFonts.poppins(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          ),
        ],
      ),
    );
  }
}
