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
  List course_doc_id = [];
  try {
    // Step 1: Retrieve the Course Collection.
    // QuerySnapshot querySnapshot =
    //     await FirebaseFirestore.instance.collection('Courses').get();

    DocumentSnapshot documentSnapshot;
    // Retreiving course document ids

    DocumentSnapshot student_details = await FirebaseFirestore.instance
        .collection("Students")
        .doc(emailName)
        .get();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Courses")
        .where('Semester', isEqualTo: student_details['Semester'])
        .where('Section', isEqualTo: student_details['Section'])
        .where('Branch', isEqualTo: student_details['Branch'])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      for (var course_id in querySnapshot.docs) {
        documentSnapshot = await FirebaseFirestore.instance
            .collection('Courses')
            .doc(course_id.id)
            .get();

        if (documentSnapshot.exists) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;

          // Extracting data

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
          print('Document does not exist for course ID:');
        }
      }
    } else {
      print("Does not exist");
    }
  } catch (e) {
    print('Error fetching course data: $e');
  }

  // print("Cccccc ${Course_Names}");
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
  int _currentIndex = 0;
  late PageController _pageController;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: 0); // Initialize _pageController in initState

    _screens = [
      Student_Home_Page(),
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
          // Icon(Icons.add, size: 35), // Icon for the Home tab.
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
  // late indicates the compiler it may be non nullable value.
  // Future represents a value or error in future
  late Future<List<CourseData>> _courseDataFuture;

  @override
  void initState() {
    super.initState();
    // Example of fetching teacher ID from Firebase Authentication
    String? teacherId = FirebaseAuth.instance.currentUser?.email;
    if (teacherId != null) {
      _courseDataFuture =
          fetchCourseData(); // Initialize _courseDataFuture with teacherId
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           Broadcast_Land(courseData.CourseID)),
                          // );
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
