import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Student_Dashboard/Student_Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_DashBoard.dart';
import 'package:provider/provider.dart';
import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Student_Dashboard/Add_Details.dart';
import 'package:google_fonts/google_fonts.dart';

var get_student_data;
var status_of_joining = false;

// if student leaves the class
edit_delete_joining(status){
  status_of_joining  = status;
}
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
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              await provider.googleLogin();

              if (provider.user != null) {
                var current_user = provider.user!.displayName;
                var email_list = emailName.toString().split('.');

                if (emailName.toString().contains("cse")) {
                  // Initially adding Teachers with flag = 0
                  add_Teachers_data(0);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Teachers_Dashboard()),
                  );
                } else if (email_list[1].substring(0, 2) == "cs") {
                  DocumentSnapshot documentSnapshot = await FirebaseFirestore
                      .instance
                      .collection("Students")
                      .doc(emailName)
                      .get();
                  if (!documentSnapshot.exists) {
                    add_student_map = {
                      "student_name": current_user,
                      "status_of_joining": status_of_joining,
                      "student_id": emailName,
                      "Branch": "",
                      "Semester": "",
                      "Section": "",
                      "Courses_list": [],
                      "Attendance_data": <String, List<int>>{},
                    };

                    await FirebaseFirestore.instance
                        .collection("Students")
                        .doc(emailName)
                        .set(add_student_map);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddASubject()));
                  } 
                  
                  // if student joins to a class
                  else {
                    get_student_data = documentSnapshot.data();
                    if (get_student_data["status_of_joining"] == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => Student_Dashboard())));
                    } 
                    
                    // if the student does not join to class on first instance
                    else if (get_student_data["status_of_joining"] == false) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddASubject()));
                    }
                  }
                } 
                
                // Show dialog box for invalid email
                else {                  
                  _showInvalidEmailDialog(context);
                }
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

  void _showInvalidEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          backgroundColor: Color.fromARGB(255, 118, 70, 166),
          title: Text(
            'Invalid Email',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Please use a valid organization email address',
            style: GoogleFonts.poppins(
              color: Colors.white70,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogout(); // Log out the user
              },
            ),
          ],
        );
      },
    );
  }
}
