import 'dart:async';
import 'package:attend_ease/Bluetooth/receive.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Student_Dashboard/Add_Details.dart';
import 'package:attend_ease/gradient_container.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(const Student_Dashboard());
}

// Fetch teachers courses
Future<List<CourseData>> fetchCourseData() async {
  List<CourseData> courseDataList = [];
  try {
    DocumentSnapshot studentDetails = await FirebaseFirestore.instance
        .collection("Students")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();

    List<dynamic> courseIDs = studentDetails['Courses_list'];

    for (String courseId in courseIDs) {
      DocumentSnapshot courseDoc = await FirebaseFirestore.instance
          .collection('Courses')
          .doc(courseId)
          .get();

      if (courseDoc.exists) {
        Map<String, dynamic> data = courseDoc.data() as Map<String, dynamic>;
        CourseData courseData = CourseData(
          name: data['Course_Name'] ?? '',
          code: data['Course_Code'] ?? '',
          section: '${data['Semester']}${data['Section']} | ${data['Branch']}',
          classesHeld: data['Classes_Held'] ?? '',
          CourseID: data['Course_id'] ?? '',
        );
        courseDataList.add(courseData);
      }
    }
  } catch (e) {
    print('Error fetching course data: $e');
  }

  return courseDataList;
}

class Student_Dashboard extends StatelessWidget {
  const Student_Dashboard({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(215, 130, 255, 1),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

var flag = 0;
// Variables
var Course_Names = [];

var Course_Code = [];

var classesHeld = [];
var total_class = [18, 22, 26, 16, 23, 26];
var attended_class = [18, 20, 23, 16, 20, 25];
var sections_branch_list = [];
// var section = "4D";
// var branch = "CSE";
// var sec_branch = section + " | " + branch;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      CourseSelectionPage(),
      Student_Home_Page(), // Add this line
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
          Icon(Icons.home, size: 35), // Add this icon
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

// Global lists for course data
var SCourse_Names = <String>[];
var SCourse_Code = <String>[];
var SclassesHeld = <String>[];
var Ssections_branch_list = <String>[];

class Student_Home_Page extends StatefulWidget {
  const Student_Home_Page({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<Student_Home_Page> {
  late Future<List<CourseData>> _courseDataFuture;

  @override
  void initState() {
    super.initState();
    _courseDataFuture = fetchCourseData();
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
                      return InkWell(
                        onTap: () {
                          print("Pressed Card: ${courseData.CourseID}");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BeaconPage(courseData.CourseID)));
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
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Classes Held: ",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            courseData.classesHeld,
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Section: ",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            courseData.section,
                                            style:
                                                const TextStyle(fontSize: 10),
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
              foregroundColor: Colors.black, // Black text
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
                        )),
              );
            },
            child: Text(
              "LOGOUT",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            )),
      ),
    );
  }
}

class CourseSelectionPage extends StatefulWidget {
  @override
  _CourseSelectionPageState createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  String? selectedCourse;
  List<CourseData> availableCourses = []; // To be fetched from the backend

  @override
  void initState() {
    super.initState();
    fetchAvailableCourses(); // Fetch the courses on page load
  }

  Future<void> fetchAvailableCourses() async {
    try {
      // Fetch current student's branch, section, and semester
      DocumentSnapshot studentDetails = await FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();

      String branch = studentDetails['Branch'];
      String section = studentDetails['Section'];
      int semester = studentDetails['Semester'];

      // Query the courses collection to get courses matching the student's branch, section, and semester
      QuerySnapshot coursesSnapshot = await FirebaseFirestore.instance
          .collection('Courses')
          .where('Branch', isEqualTo: branch)
          .where('Section', isEqualTo: section)
          .where('Semester', isEqualTo: semester)
          .get();

      List<CourseData> fetchedCourses = coursesSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CourseData(
          name: data['Course_Name'] ?? '',
          code: data['Course_Code'] ?? '',
          section: '${data['Semester']}${data['Section']} | ${data['Branch']}',
          classesHeld: data['Classes_Held'] ??'',
          CourseID: doc.id,
        );
      }).toList();

      setState(() {
        availableCourses = fetchedCourses;
      });
    } catch (e) {
      print('Error fetching available courses: $e');
    }
  }

  Future<void> joinCourse(String courseId) async {
    try {
      DocumentReference studentRef = FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email);

      DocumentSnapshot studentDoc = await studentRef.get();

      List<dynamic> courseIDs = studentDoc['Courses_list'];

      // Add the course ID if it's not already in the list
      if (!courseIDs.contains(courseId)) {
        courseIDs.add(courseId);

        // Update the student's document with the new list of course IDs
        await studentRef.update({'Courses_list': courseIDs});
      }
      Timer(const Duration(seconds: 1), () =>
        Navigator.push(context, MaterialPageRoute(builder: (context) => Student_Dashboard())));
    } catch (e) {
      print('Error joining course: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    // Background Color of the home page.
    backgroundColor: const Color.fromRGBO(184, 163, 255, 0.1),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                  "Select Courses",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            DropdownButton<String>(
              hint: Text('Select a course'),
              value: selectedCourse,
              isExpanded: true,
              items: availableCourses.map((CourseData course) {
                return DropdownMenuItem<String>(
                  value: course.CourseID,
                  child: Text(course.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (selectedCourse != null) {
                  await joinCourse(selectedCourse!);
                  // Update the UI or show a success message
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(184, 163, 255, 1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Join Course',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}