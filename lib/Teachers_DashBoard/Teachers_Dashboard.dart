import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Teachers_DashBoard/Add_Subject.dart';
import 'package:attend_ease/gradient_container.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:attend_ease/Backend/fetch_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:provider/provider.dart';
import 'package:attend_ease/Bluetooth/broadcast.dart';

// void main() {
//   runApp(const Teachers_Dashboard());
// }

// Fetch teachers courses
Future<List<CourseData>> fetchCourseData(String teacherId) async {
  List<CourseData> courseDataList = [];

  try {
    // Step 1: Retrieve the teacher document using teacherId
    DocumentSnapshot teacherSnapshot = await FirebaseFirestore.instance
        .collection('Teachers')
        .doc(teacherId)
        .get();

    if (teacherSnapshot.exists) {
      // Step 2: Extract course IDs from the teacher document
      List<String> courseIds =
          List<String>.from(teacherSnapshot['Course_id'] ?? []);

      // Step 3: Iterate through course IDs and fetch course data
      for (String courseId in courseIds) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('Courses')
            .doc(courseId)
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          // // for duplicates
          // Course_Names.add(data["Course_Name"]);

          // Course_Code.add(data['Course_Code']);
          // sections_branch_list
          //     .add("${data['Semester']}${data['Section']} | ${data['Branch']}");
          // classesHeld.add("Classes Held: ${data['Classes_Held']}");

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

  print("Cccccc ${Course_Names}");
  return courseDataList;
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
var Course_Names = <String>[];
var Course_Code = <String>[];
var classesHeld = <String>[];
var sections_branch_list = <String>[];

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
  // late indicates the compiler it may be non nullable value.
  // Future represents a value or error in future
  late Future<List<CourseData>> _courseDataFuture;

  @override
  void initState() {
    super.initState();
    // Example of fetching teacher ID from Firebase Authentication
    String? teacherId = FirebaseAuth.instance.currentUser?.email;
    if (teacherId != null) {
      _courseDataFuture = fetchCourseData(
          teacherId); // Initialize _courseDataFuture with teacherId
    } else {
      print('User not logged in');
      // Handle the case where user is not logged in
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
                      return InkWell(
                        onTap: () {
                          print("Pressed Card: ${courseData.CourseID}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Broadcast_Land(courseData.CourseID)),
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
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 6, 0, 0),
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


// Navigation bar
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
  
    _pageController = PageController(
        initialPage: 1); // Initialize _pageController in initState

    _screens = [
      add_a_subject(controller: _pageController),
      Teacher_Home_Page(),
      ProfileScreen(), // Make sure to define ProfileScreen or any other screen you intend to navigate to
    ];
  }

  @override
  void dispose() {
    _pageController
        .dispose(); // Dispose _pageController when it's no longer needed
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
        index: _currentIndex, // The currently selected index.
        color: Color.fromRGBO(
            184, 163, 255, 1), // Background color of the bottom navigation bar.
        buttonBackgroundColor: const Color.fromRGBO(
            184, 163, 255, 0), // Background color of the active item.
        backgroundColor: const Color.fromRGBO(
            184, 163, 255, 0.1), // Background color of the navigation bar.
        animationDuration: const Duration(
            milliseconds: 300), // Duration of animation when switching tabs.
        height: 70.0, // Height of the bottom navigation bar.
        items: const <Widget>[
          Icon(Icons.add, size: 35), // Icon for the Home tab.
          Icon(Icons.home, size: 35), // Icon for the Access Time tab.
          Icon(Icons.person, size: 35), // Icon for the Person tab.
        ],
        onTap: (index) {
          // Callback function when a tab is tapped.
          setState(() {
            _currentIndex = index; // Update the current index.
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            ); // Animate to the selected page.
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
