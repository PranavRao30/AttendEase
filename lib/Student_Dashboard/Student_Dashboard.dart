import 'dart:async';
import 'package:attend_ease/Bluetooth/receive.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Student_Dashboard/Add_Details.dart';
import 'package:attend_ease/Student_Dashboard/Student_Status.dart';
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
var Eligibilty;
var total_class;
var total_attended;
var Absent;
// var section = "4D";
// var branch = "CSE";
// var sec_branch = section + " | " + branch;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Display duplicates
void displayDuplicatesMessage(BuildContext context, String message) {
  final snackbar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: 3),
    action: SnackBarAction(
        label: "Ok",
        onPressed: () {
          print("Duplicates");
        }),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BeaconPage(courseData.CourseID)));
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
                                  )
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

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _photoUrlController = TextEditingController();
  final _semesterController = TextEditingController();
  final _branchController = TextEditingController();
  final _sectionController = TextEditingController();
  late Future<List<CourseData>> _courseDataFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _courseDataFuture = fetchCourseData();
  }

  Future<void> _fetchUserDetails() async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    final user = provider.user;

    if (user != null) {
      setState(() {
        _nameController.text = user.displayName ?? '';
        _emailController.text = user.email;
        _photoUrlController.text = user.photoUrl ?? '';
      });

      // final firestore = FirebaseFirestore.instance;
      // final usersCollection = firestore.collection('Students');

      // final userData = await usersCollection.doc(user.email).get();
      // print(user.email);

      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection("Students")
          .doc(user.email)
          .get();
      if (userData.exists) {
        var userDataMap = userData.data() as Map<String, dynamic>;
        setState(() {
          _semesterController.text = userDataMap["Semester"].toString();
          _branchController.text = userDataMap["Branch"] ?? '';
          _sectionController.text = userDataMap["Section"] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(184, 163, 255, 0.1),
        body: SingleChildScrollView(
          child: Column(
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
                    "Your Profile",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_photoUrlController.text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Name: ${_nameController.text}",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Email: ${_emailController.text}",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Class: ${_semesterController.text}${_sectionController.text}, ${_branchController.text}",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              FutureBuilder<List<CourseData>>(
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
                          shrinkWrap: true, // Add this line
                          physics:
                              NeverScrollableScrollPhysics(), // Add this line
                          itemCount: courseDataList.length,
                          itemBuilder: (context, index) {
                            CourseData courseData = courseDataList[index];
                            return InkWell(
                                onTap: () {
                                  print(
                                      "Profile Pressed Card: ${courseData.CourseID}");
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color:
                                              Color.fromRGBO(184, 163, 255, 1),
                                          offset: Offset(4, 4),
                                          blurRadius: 0,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Card(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        side: BorderSide(
                                          color:
                                              Color.fromRGBO(215, 196, 223, 1),
                                          width: 2.0,
                                        ),
                                      ),
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                courseData.name,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  courseData.code,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            // Align(
                                            //   alignment: Alignment.topLeft,
                                            //   child: Padding(
                                            //     padding:
                                            //         const EdgeInsets.fromLTRB(
                                            //             0, 6, 0, 0),
                                            //     child: Row(
                                            //       children: [
                                            //         const Text(
                                            //           "Classes Held: ",
                                            //           style: TextStyle(
                                            //             fontSize: 10,
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //           ),
                                            //         ),
                                            //         Text(
                                            //           courseData.classesHeld,
                                            //           style: const TextStyle(
                                            //               fontSize: 10),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ),
                                            // ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 6, 0, 0),
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      "Section: ",
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      courseData.section,
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text("Get Details"),
                                                SizedBox(width: 10),
                                                IconButton(
                                                  icon: const Icon(Icons.list_alt,
                                                      size: 20),
                                                  onPressed: () async {
                                                    print("Inside onpress");
                                                    // await fetch_student_att_details();
                                                    // print(studentId);

                                                    DocumentSnapshot
                                                        documentSnapshot1 =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "Students")
                                                            .doc(emailName)
                                                            .get();
                                                    var stud_data =
                                                        documentSnapshot1.data()
                                                            as Map<String,
                                                                dynamic>?;

                                                    if (documentSnapshot1
                                                            .exists &&
                                                        stud_data != null) {
                                                      Map<String, dynamic>
                                                          Attend_Map =
                                                          Map.from(stud_data[
                                                                  "Attendance_data"] ??
                                                              {});

                                                      print(Attend_Map[
                                                          courseData.CourseID]);

                                                      total_attended =
                                                          Attend_Map[courseData
                                                              .CourseID][0];
                                                      total_class = Attend_Map[
                                                          courseData
                                                              .CourseID][1];
                                                      Eligibilty =
                                                          (total_attended /
                                                                  total_class) *
                                                              100;
                                                      Absent = total_class -
                                                          total_attended;
                                                    }

                                                    Timer(Duration(seconds: 3),
                                                        () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Student_Status_Page(
                                                                    courseData
                                                                        .CourseID,
                                                                    total_attended,
                                                                    total_class,
                                                                    Eligibilty,
                                                                    Absent,
                                                                  )));
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )));
                          });
                    }
                  }),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 106, 106, 1),
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 106, 106, 1),
                  foregroundColor: Colors.black, // Black text
                ),
                onPressed: () async {
                  edit_delete_joining(false);
                  DocumentSnapshot documentSnapshot = await FirebaseFirestore
                      .instance
                      .collection("Students")
                      .doc(emailName)
                      .get();
                  List<dynamic> stud_course_list = documentSnapshot.exists
                      ? List<String>.from(documentSnapshot["Courses_list"])
                      : [];

                  for (int i = 0; i < stud_course_list.length; i++) {
                    //             QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    // .collection("Courses")
                    // .where('Course_id', isEqualTo: stud_course_list[i])
                    // .get();

                    DocumentSnapshot documentSnapshot1 = await FirebaseFirestore
                        .instance
                        .collection("Courses")
                        .doc(stud_course_list[i])
                        .get();
                    List<dynamic> course_stud_list = documentSnapshot1.exists
                        ? List<String>.from(documentSnapshot1["Student_list"])
                        : [];

                    course_stud_list.remove(emailName);

                    await FirebaseFirestore.instance
                        .collection("Courses")
                        .doc(stud_course_list[i])
                        .update({"Student_list": course_stud_list});
                  }

                  // await FirebaseFirestore.instance.collection("Students").doc(emailName).delete();

                  // Deleting particular fields from the document
                  // FieldValue.delete()
                  await FirebaseFirestore.instance
                      .collection("Students")
                      .doc(emailName)
                      .update({
                    'Section': "",
                    'Semester': 0,
                    'Courses_list': [],
                    // Add more fields as needed
                  });

                  // updating status to false
                  await FirebaseFirestore.instance
                      .collection("Students")
                      .doc(emailName)
                      .update({
                    'status_of_joining': false,
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GradientContainer(
                              Color.fromARGB(255, 150, 120, 255),
                              Color.fromARGB(255, 150, 67, 183),
                              child: AddASubject(),
                            )),
                  );
                },
                child: Text(
                  "LEAVE CLASS",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
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
          classesHeld: data['Classes_Held'] ?? '',
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


  // Updating Courses list in Student Collection and 
  // Students_list in that particular course id

  Future<void> joinCourse(String courseId) async {
    try {
      DocumentReference studentRef = FirebaseFirestore.instance
          .collection("Students")
          .doc(FirebaseAuth.instance.currentUser!.email);

      DocumentSnapshot studentDoc = await studentRef.get();

      List<dynamic> courseIDs = studentDoc['Courses_list'];
      Map<String, dynamic> attend_data = studentDoc['Attendance_data'];

      DocumentSnapshot courseDoc1 = await FirebaseFirestore.instance
          .collection("Courses")
          .doc(courseId)
          .get();

      var course_data;
      if(courseDoc1.exists)
        course_data = courseDoc1.data();



      // Add the course ID if it's not already in the list
      if (!courseIDs.contains(courseId)) {
        courseIDs.add(courseId);
        print(course_data["Classes_Held"]);
        attend_data[courseId] = [0, int.parse(courseDoc1["Classes_Held"])];
        // Update the student's document with the new list of course IDs
        await studentRef.update({'Courses_list': courseIDs});
        await studentRef.update({'Attendance_data': attend_data});
      } else
        displayDuplicatesMessage(context, "Course Already Joined. Try with different course");
      
      // Updating students list in Courses Collection
      var data;
      DocumentSnapshot courseDoc = await FirebaseFirestore.instance
          .collection("Courses")
          .doc(courseId)
          .get();

      if (courseDoc.exists) {
        data = courseDoc.data();
      }

      var student_list = List<String>.from(data["Student_list"]);

      // Add the Student email id if it's not already in the list
      if (!student_list.contains(emailName)) {
        student_list.add(emailName);

        // Update the course's document with the new list of Student IDs
        await FirebaseFirestore.instance
            .collection("Courses")
            .doc(courseId)
            .update({'Student_list': student_list});
      }

      Timer(
          const Duration(seconds: 1),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => Student_Dashboard())));
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
