// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:attend_ease/Teachers_DashBoard/Teacher_Profile_Page/model/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:attend_ease/Bluetooth/broadcast.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:attend_ease/gradient_container.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Teachers_DashBoard/Add_Subject.dart';
import 'package:attend_ease/Teachers_DashBoard/Teacher_Profile_Page/main1.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

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

  // Show confirmation dialog
  bool shouldDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to delete the course ${courseData.name}? This action cannot be undone and all associated data will be permanently deleted.'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false to indicate cancellation
            },
          ),
          TextButton(
            child: Text('Proceed'),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true to indicate confirmation
            },
          ),
        ],
      );
    },
  );

  if (!shouldDelete) {
    return; // If the user cancels, do nothing
  }

  try {
    // Remove the course immediately from UI
    setState(() {
      _courseDataFuture = _courseDataFuture.then((courseDataList) {
        return courseDataList
            .where((course) => course.CourseID != courseId)
            .toList();
      });
    });

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Courses")
        .doc(courseId)
        .get();
    var get_data;
    if (documentSnapshot.exists) get_data = documentSnapshot.data();

    // Accessing students_list from courses collection
    students_list = List<String>.from(get_data["Student_list"]);

    for (int i = 0; i < students_list.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Students")
          .doc(students_list[i])
          .get();

      var get_data;

      if (documentSnapshot.exists) get_data = documentSnapshot.data();

      // Accessing courses_list from courses collection
      List courses_list = List<String>.from(get_data["Courses_list"]);
      courses_list.remove(courseId);

      var stud_data = documentSnapshot.data() as Map<String, dynamic>?;

      if (documentSnapshot.exists && stud_data != null) {
        Map<String, dynamic> Attend_Map = Map.from(stud_data["Attendance_data"] ?? {});
        Attend_Map.remove(courseId);

        await FirebaseFirestore.instance.collection("Students").doc(students_list[i]).update({
          "Courses_list": courses_list,
          "Attendance_data": Attend_Map
        });
      }
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Attendance").get();

    for (var doc in querySnapshot.docs) {
      String docid = doc.id;
      if (docid.contains(courseId)) {
        await FirebaseFirestore.instance.collection("Attendance").doc(docid).delete();
      }
    }

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


//   Future<void> undoDeleteCourse(CourseData courseData) async {
//     String? teacherId = FirebaseAuth.instance.currentUser?.email;

//     try {
//       // Add the course back to Firestore
//       await FirebaseFirestore.instance
//           .collection('Courses')
//           .doc(courseData.CourseID)
//           .set({
//         'Course_Name': courseData.name,
//         'Course_Code': courseData.code,
//         'Semester': courseData.section
//             .substring(0, 1), // Assuming format SemesterSection | Branch
//         'Section': courseData.section
//             .substring(1, 2), // Assuming format SemesterSection | Branch
//         'Branch': courseData.section
//             .substring(5), // Assuming format SemesterSection | Branch
//         'Classes_Held': courseData.classesHeld,
//         'Course_id': courseData.CourseID,
//         "Student_list": students_list,
//         "Teacher_id": 
//       });

//       // Optionally, update the teacher's course list if necessary
//       if (teacherId != null) {
//         await FirebaseFirestore.instance
//             .collection('Teachers')
//             .doc(teacherId)
//             .update({
//           'Course_id': FieldValue.arrayUnion([courseData.CourseID])
//         });
//       }

// DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//         .collection("Courses")
//         .doc(courseData.CourseID)
//         .get();
//     var get_data;
//     if (documentSnapshot.exists) get_data = documentSnapshot.data();

//     // Accessing students_list from courses collection
//     students_list = List<String>.from(get_data["Student_list"]);

//     for(int i = 0;i<students_list.length;i++)
//     {
//       DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//         .collection("Students")
//         .doc(students_list[i])
//         .get();

//         var get_data;
        
//     if (documentSnapshot.exists) get_data = documentSnapshot.data();

//     // Accessing courses_list from courses collection
//     List courses_list = List<String>.from(get_data["Courses_list"]);
//     courses_list.add(courseData.CourseID);
//     }

//       // Refresh the UI
//       setState(() {
//         _courseDataFuture = fetchCourseData(teacherId!);
//       });
//     } catch (e) {
//       print('Error undoing delete: $e');
//     }
//   }

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

class User1 {
  final int slno;
  final String firstName;
  final String email;
  final Map<String, String> attendance;

  User1({
    required this.slno,
    required this.firstName,
    required this.email,
    required this.attendance,
  });

  User1 copy({
    int? slno,
    String? firstName,
    String? email,
    Map<String, String>? attendance,
  }) =>
      User1(
        slno: slno ?? this.slno,
        firstName: firstName ?? this.firstName,
        email: email ?? this.email,
        attendance: attendance ?? this.attendance,
      );
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _photoUrlController = TextEditingController();
  late Future<List<CourseData>> _courseDataFuture;
  late List<User1> users;
  late List<Map<String, String>> attendanceRecords;

  @override
  void initState() {
    super.initState();
    users = [];
    attendanceRecords = [];
    _fetchUserDetails();
    String? teacherId = FirebaseAuth.instance.currentUser?.email;
    if (teacherId != null) _courseDataFuture = fetchCourseData(teacherId);
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
    }
  }

  Future<void> _exportToExcel(String courseId) async {
    try {
      // Fetch users and attendance records
      List<User1> users = await fetchUsers(courseId);
      List<Map<String, String>> attendanceRecords =
          await fetchAttendance(courseId, users);

      // Create a new Excel workbook
      final xlsio.Workbook workbook = xlsio.Workbook(); // Use the alias here
      final xlsio.Worksheet sheet =
          workbook.worksheets[0]; // Use the alias here

      // Header columns
      List<String> columns = ['Sl no', 'Student Name', 'Email'];
      columns
          .addAll(attendanceRecords.map((record) => record['date']!).toList());
      columns.add('Eligibility');

      // Add headers to the sheet
      for (int i = 0; i < columns.length; i++) {
        sheet.getRangeByIndex(1, i + 1).setText(columns[i]);
      }

      // Data rows
      int rowIndex = 2; // Start after header row
      for (User1 user in users) {
        List<dynamic> dataRow = [
          user.slno, // Example: Assuming slno is an integer
          user.firstName ?? '',
          user.email ?? '',
        ];

        dataRow.addAll(attendanceRecords.map((record) {
          final date = record['date']!;
          final attendanceId = record['id']!;
          return user.attendance['${date}_$attendanceId'] ?? 'A';
        }));

        // Calculate eligibility and add to data
        dataRow.add(calculateEligibility(user));

        // Add data row to the sheet
        for (int i = 0; i < dataRow.length; i++) {
          sheet.getRangeByIndex(rowIndex, i + 1).setText(dataRow[i].toString());
        }
        rowIndex++;
      }

      // Save file
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final filePath = '${directory.path}/Attendance_${courseId}.xlsx';
        final File file = File(filePath);
        await file.writeAsBytes(workbook.saveAsStream());
        _showSnackBar('Excel file saved to $filePath');
      } else {
        _showErrorSnackBar('Failed to access external storage directory.');
      }
    } catch (e) {
      _showErrorSnackBar('Error exporting to Excel: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<List<User1>> fetchUsers(String courseId) async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Courses")
          .doc(courseId)
          .get();

      if (documentSnapshot.exists) {
        final Map<String, dynamic>? getData =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (getData != null) {
          final List<String> studentsList =
              List<String>.from(getData["Student_list"]);
          int count = 0;
          List<User1> allUsers = [];

          for (String docId in studentsList) {
            count++;
            final DocumentSnapshot studentSnapshot = await FirebaseFirestore
                .instance
                .collection("Students")
                .doc(docId)
                .get();

            if (studentSnapshot.exists) {
              final Map<String, dynamic>? studentData =
                  studentSnapshot.data() as Map<String, dynamic>?;
              if (studentData != null) {
                allUsers.add(User1(
                  slno: count,
                  firstName: studentData['student_name'],
                  email: studentData['student_id'],
                  attendance: {},
                ));
              }
            }
          }
          return allUsers;
        }
      }
      throw 'Course data not found';
    } catch (e) {
      throw 'Failed to fetch users: $e';
    }
  }

  Future<List<Map<String, String>>> fetchAttendance(
      String courseId, List<User1> users) async {
    try {
      final QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
          .collection("Attendance")
          .where("Course_id", isEqualTo: courseId)
          .get();

      List<Map<String, String>> attendanceRecordsList = [];

      for (var doc in attendanceSnapshot.docs) {
        final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('Date')) {
          String date = data['Date'];
          String attendanceId = doc.id; // Unique identifier for attendance
          attendanceRecordsList.add({'date': date, 'id': attendanceId});
          List<String> attendees = List<String>.from(data['Attendees']);
          for (var user in users) {
            if (attendees.contains(user.email)) {
              user.attendance['${date}_$attendanceId'] = 'P'; // Present
            } else {
              user.attendance['${date}_$attendanceId'] = 'A'; // Absent
            }
          }
        }
      }

      return attendanceRecordsList;
    } catch (e) {
      throw 'Failed to fetch attendance records: $e';
    }
  }

  String calculateEligibility(User1 user) {
    if (user.attendance.isEmpty) {
      return 'N/A';
    }

    int presentClasses = 0;
    int totalClasses = user.attendance.length;

    user.attendance.forEach((date, status) {
      if (status == 'P') {
        presentClasses++;
      }
    });

    if (totalClasses == 0) {
      return 'N/A';
    }

    double percentage = (presentClasses / totalClasses) * 100;
    return '${percentage.toStringAsFixed(2)}%';
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
                    physics: NeverScrollableScrollPhysics(), // Add this line
                    itemCount: courseDataList.length,
                    itemBuilder: (context, index) {
                      CourseData courseData = courseDataList[index];
                      return InkWell(
                        onTap: () {
                          print("Pressed Card: ${courseData.CourseID}");
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courseData.name,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              courseData.code,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
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
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit,
                                                  size: 20),
                                              onPressed: () {
                                                get_courseid(
                                                    courseData.CourseID);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Teacher_Profile_Table(),
                                                  ),
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.download,
                                                  size: 20),
                                              onPressed: () {
                                                _exportToExcel(
                                                    courseData.CourseID);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
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
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
