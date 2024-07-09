import 'package:attend_ease/Student_Dashboard/Student_Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

String courseID = "";
var Eligibilty;
var total_class;
var total_attended;
var Absent;

class Student_Status_Page extends StatelessWidget {
  var cid, ta, tch, el, ab;
  Student_Status_Page(this.cid, this.ta, this.tch, this.el, this.ab) {
    courseID = cid;
    total_attended = ta;
    total_class = tch;
    Eligibilty = el;
    Absent = ab;
    print("Inside Status $courseID");
    print(total_attended);
    print(total_class);
    print(Eligibilty);
    print(Absent);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(215, 130, 255, 1),
        ),
        useMaterial3: true,
      ),
      home: Students_Home_Page(),
    );
  }
}

class Students_Home_Page extends StatefulWidget {
  const Students_Home_Page({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<Students_Home_Page> {
  @override
  void initState() {
    super.initState();
    print("Inside init $courseID");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              height: 70.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(184, 163, 255, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Text(
                  "Attendance Status",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Wavy container
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: LiquidLinearProgressIndicator(
                          value: Eligibilty / 100,
                          backgroundColor:
                              Colors.white, // Explicitly set backgroundColor
                          borderColor: Color.fromRGBO(184, 163, 255, 1),
                          borderWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(
                              Color.fromRGBO(184, 163, 255, 1)),
                          center: Text(
                            '${Eligibilty.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          borderRadius: 20.0,
                          direction: Axis.vertical,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Present and Absent classes in one row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildInfoCard('Present', total_attended),
                          _buildInfoCard('Absent', Absent),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Total classes in a separate row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInfoCard('Total', total_class),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Student_Dashboard(),
              ),
            );
          },
          child: Icon(Icons.arrow_back),
          backgroundColor: Color.fromRGBO(
              184, 163, 255, 1), // Change floating action button color
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, int value) {
    return Card(
      color: Color.fromRGBO(184, 163, 255, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        width: 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              value.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
