// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:attend_ease/Bluetooth/broadcast.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:attend_ease/gradient_container.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Backend/fetch_data.dart';
import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Teachers_DashBoard/Add_Subject.dart';
import 'package:attend_ease/Bluetooth/broadcast.dart';
// import 'Teachers_Profile.dart';

var students_list;

class get_table {
  final int slno;
  final String name;
  String Present;
  final String Email_ID;

  get_table({
    required this.slno,
    required this.name,
    required this.Present,
    required this.Email_ID,
  });
}

// Fetch course data from Firestore
Future<List<CourseData>> fetchCourseData(String teacherId) async {
  List<CourseData> courseDataList = [];

  try {
    DocumentSnapshot teacherSnapshot = await FirebaseFirestore.instance
        .collection('Teachers')
        .doc(teacherId)
        .get();

    if (teacherSnapshot.exists) {
      List<String> courseIds =
          List<String>.from(teacherSnapshot['Course_id'] ?? []);

      for (String courseId in courseIds) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('Courses')
            .doc(courseId)
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          CourseData courseData = CourseData(
            name: data['Course_Name'] ?? '',
            code: data['Course_Code'] ?? '',
            section:
                '${data['Semester']}${data['Section']} | ${data['Branch']}',
            classesHeld: data['Classes_Held'] ?? '',
            CourseID: data['Course_id'] ?? '',
          );

          courseDataList.add(courseData);
        } else {
          print('Document does not exist for course ID: $courseId');
        }
      }
    } else {
      print('Teacher document not found for ID: $teacherId');
    }
  } catch (e) {
    print('Error fetching course data: $e');
  }

  return courseDataList;
}

// Data model for Course
class CourseData {
  final String name;
  final String code;
  final String section;
  final String classesHeld;
  final String CourseID;

  CourseData({
    required this.name,
    required this.code,
    required this.section,
    required this.classesHeld,
    required this.CourseID,
  });
}

// List<get_table>? Students_data = [];

class Teachers_Dashboard extends StatelessWidget {
  const Teachers_Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(184, 163, 255, 1),
        ),
        useMaterial3: true,
      ),
      home: BottomNavigationExample(),
    );
  }
}

class Teacher_Home_Page extends StatefulWidget {
  const Teacher_Home_Page({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<Teacher_Home_Page> {
  late Future<List<CourseData>> _courseDataFuture;

  List<get_table> _data = [];

  @override
  void initState() {
    super.initState();
    String? teacherId = FirebaseAuth.instance.currentUser?.email;
    if (teacherId != null) {
      _courseDataFuture = fetchCourseData(teacherId);
    } else {
      print('User not logged in');
    }
  }

  Future<void> _deleteCourse(CourseData courseData) async {
    String courseId = courseData.CourseID;
    String? teacherId = FirebaseAuth.instance.currentUser?.email;

    try {
      // Remove the course immediately from UI
      setState(() {
        _courseDataFuture = _courseDataFuture.then((courseDataList) {
          return courseDataList
              .where((course) => course.CourseID != courseId)
              .toList();
        });
      });

      // Show SnackBar with undo option
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${courseData.name} deleted"),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Undo the deletion
              undoDeleteCourse(courseData);
            },
          ),
        ),
      );

      // Delete the course document from Firestore
      await FirebaseFirestore.instance
          .collection('Courses')
          .doc(courseId)
          .delete();

      // Optionally, update the teacher's course list if necessary
      if (teacherId != null) {
        await FirebaseFirestore.instance
            .collection('Teachers')
            .doc(teacherId)
            .update({
          'Course_id': FieldValue.arrayRemove([courseId])
        });
      }
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

  Future<void> undoDeleteCourse(CourseData courseData) async {
    String? teacherId = FirebaseAuth.instance.currentUser?.email;

    try {
      // Add the course back to Firestore
      await FirebaseFirestore.instance
          .collection('Courses')
          .doc(courseData.CourseID)
          .set({
        'Course_Name': courseData.name,
        'Course_Code': courseData.code,
        'Semester': courseData.section
            .substring(0, 1), // Assuming format SemesterSection | Branch
        'Section': courseData.section
            .substring(1, 2), // Assuming format SemesterSection | Branch
        'Branch': courseData.section
            .substring(5), // Assuming format SemesterSection | Branch
        'Classes_Held': courseData.classesHeld,
        'Course_id': courseData.CourseID,
      });

      // Optionally, update the teacher's course list if necessary
      if (teacherId != null) {
        await FirebaseFirestore.instance
            .collection('Teachers')
            .doc(teacherId)
            .update({
          'Course_id': FieldValue.arrayUnion([courseData.CourseID])
        });
      }

      // Refresh the UI
      setState(() {
        _courseDataFuture = fetchCourseData(teacherId!);
      });
    } catch (e) {
      print('Error undoing delete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(184, 163, 255, 0.1),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            height: 70,
            width: 330,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(184, 163, 255, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "Your Courses",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: FutureBuilder<List<CourseData>>(
              future: _courseDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No courses available'));
                } else {
                  List<CourseData> courseDataList = snapshot.data!;
                  return ListView.builder(
                    itemCount: courseDataList.length,
                    itemBuilder: (context, index) {
                      CourseData courseData = courseDataList[index];
                      return Dismissible(
                        key: Key(courseData.CourseID),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteCourse(courseData);
                        },
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: AlignmentDirectional.centerEnd,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
                            print("Inside Card");

                            print("Pressed Card: ${courseData.CourseID}");

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Broadcast_Land(courseData.CourseID),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(184, 163, 255, 1),
                                  offset: Offset(4, 4),
                                  blurRadius: 0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                side: BorderSide(
                                  color: Color.fromRGBO(215, 196, 223, 1),
                                  width: 2.0,
                                ),
                              ),
                              color: const Color.fromRGBO(255, 255, 255, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        courseData.name,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          courseData.code,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 6, 0, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Section: " + courseData.section,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              "Classes Held: " +
                                                  courseData.classesHeld,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavigationExample extends StatefulWidget {
  @override
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigationExample> {
  int _currentIndex = 1;
  late PageController _pageController;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    _screens = [
      add_a_subject(controller: _pageController),
      Teacher_Home_Page(),
      ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        color: Color.fromRGBO(184, 163, 255, 1),
        buttonBackgroundColor: const Color.fromRGBO(184, 163, 255, 0),
        backgroundColor: const Color.fromRGBO(184, 163, 255, 0.1),
        animationDuration: const Duration(milliseconds: 300),
        height: 70.0,
        items: const <Widget>[
          Icon(Icons.add, size: 35),
          Icon(Icons.home, size: 35),
          Icon(Icons.person, size: 35),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(184, 163, 255, 1),
            foregroundColor: Colors.black,
          ),
          onPressed: () async {
            final provider =
                Provider.of<GoogleSignInProvider>(context, listen: false);
            await provider.googleLogout();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GradientContainer(
                  Color.fromARGB(255, 150, 120, 255),
                  Color.fromARGB(255, 150, 67, 183),
                  child: StartScreen(),
                ),
              ),
            );
          },
          child: Text(
            "LOGOUT",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
