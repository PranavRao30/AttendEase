import 'package:attend_ease/Student_Dashboard/Student_Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    print("Inside intt $courseID");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Wavy container
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Color.fromRGBO(184, 163, 255, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '${Eligibilty.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Present, Absent, and Total classes boxes
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoCard('Present', total_attended),
                  _buildInfoCard('Absent', Absent),
                  _buildInfoCard('Total', total_class),
                ],
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
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              value.toString(),
              style: TextStyle(
                color: Colors.white,
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
