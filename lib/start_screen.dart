import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Student_Dashboard/Student_Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_DashBoard.dart';
import 'package:provider/provider.dart';
import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Student_Dashboard/Add_Details.dart';
import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Backend/fetch_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

var get_student_data;

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

              if (provider.user != null) {
                // User is signed in
                // Navigate to the next screen.
                var current_user = provider.user!.displayName;
                var email_list = emailName.toString().split('.');

                // DateTime time = DateTime.now();
                // String formatted_time = DateFormat("HH:mm:ss").format(time);
                
                print(email_list[1].substring(0, 2));
                if (emailName.toString().contains("cse")) {
                  add_Teachers_data(0);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Teachers_Dashboard()),
                  );
                } else if (email_list[1].substring(0, 2) == "cs") {
                  // create a collection
                  DocumentSnapshot documentSnapshot = await FirebaseFirestore
                      .instance
                      .collection("Students")
                      .doc(emailName)
                      .get();
                  print(documentSnapshot.exists);
                  // creating a document
                  if (!documentSnapshot.exists) {
                    

                    add_student_map = {
                      "student_name": current_user,
                      "status_of_joining": false,
                      "student_id": emailName,
                      "Student_name": emailName.toString(),
                      "Branch": "",
                      "Semester": "",
                      "Section": "",
                      "Courses_list": [],
                    };

                    await FirebaseFirestore.instance
                        .collection("Students")
                        .doc(emailName)
                        .set(add_student_map);

                    // Join class page
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddASubject()));
                  } else {
                    // if exists
                    get_student_data = documentSnapshot.data();
                    if (get_student_data["status_of_joining"] == true) {
                      print("controol");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => Student_Dashboard())));
                      // Navi to dashboard
                    } else if (get_student_data["status_of_joining"] == false) {
                      // Join class page
                      print("Second time login");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddASubject()));
                    }
                  }
                }

                print("Inside button:${emailName.toString()}");
              }
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
