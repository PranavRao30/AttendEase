import 'package:attend_ease/Teachers_DashBoard/Teacher_Profile_Page/widget/scrollable_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

String id = "";
void initializecourse_id(cid) {
  id = cid;
}

class EditablePage extends StatefulWidget {
  final String courseId;

  EditablePage(this.courseId);

  @override
  _EditablePageState createState() => _EditablePageState();
}

class _EditablePageState extends State<EditablePage> {
  late List<User1> users;
  late List<Map<String, String>> attendanceRecords;

  @override
  void initState() {
    super.initState();
    users = [];
    attendanceRecords = [];
    addProfileDetails();
  }

  Future<void> addProfileDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Courses")
          .doc(widget.courseId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? getData =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (getData != null) {
          List<String> studentsList =
              List<String>.from(getData["Student_list"]);
          int count = 0;
          List<User1> allUsers = [];

          for (String docId in studentsList) {
            count++;
            DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
                .collection("Students")
                .doc(docId)
                .get();

            if (studentSnapshot.exists) {
              Map<String, dynamic>? studentData =
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

          // Fetch attendance data
          List<Map<String, String>> attendanceRecordsList = [];
          QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
              .collection("Attendance")
              .where("Course_id", isEqualTo: widget.courseId)
              .get();


          // Iterating through document of Attendance Collection and getting data
          for (var doc in attendanceSnapshot.docs) {
            Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
            if (data != null && data.containsKey('Date')) {

              // if it date as key
              String date = data['Date'];
              String attendanceId = doc.id; // Unique identifier for attendance
              
              // attendanceRecordsList containing map date and doc id.
              attendanceRecordsList.add({'date': date, 'id': attendanceId});
                      
              // Extracting attendees list 
              List<String> attendees = List<String>.from(data['Attendees']);
              
              
              // If the user present in attendees list is there in allusers list
              for (var user in allUsers) {
                if (attendees.contains(user.email)) {
                  user.attendance['${date}_$attendanceId'] = 'P'; // Present
                } else {
                  user.attendance['${date}_$attendanceId'] = 'A'; // Absent
                }
              }
            }
          }

          setState(() {
            // rows
            users = allUsers;
            attendanceRecords = attendanceRecordsList;
          });
        }
      }
    } catch (e) {
      print("Error fetching student details: $e");
    }
  }

  Future<void> updateAttendance(String userId, String courseId, String date,
      String attendanceId, bool isPresent) async {
    final studentRef =
        FirebaseFirestore.instance.collection("Students").doc(userId);
    final attendanceRef =
        FirebaseFirestore.instance.collection("Attendance").doc(attendanceId);

    DocumentSnapshot studentSnapshot = await studentRef.get();
    
    // this contains tuple of attended and total classes held
    List<dynamic>? attendanceData =
        studentSnapshot['Attendance_data'][widget.courseId];

    if (isPresent) {
      // Change attendance from 'A' to 'P' and changing attended count 
      if (attendanceData != null && attendanceData.length >= 2) {
        int presentCount = attendanceData[0] + 1;
        await studentRef.update({
          'Attendance_data.${widget.courseId}': [
            presentCount,
            attendanceData[1]
          ],
        });
      }
      // A TO P merging attended student list 
      await attendanceRef.update({
        'Attendees': FieldValue.arrayUnion([userId]),
      });
    }

    // Change attendance from 'P' to 'A'
    else {    
      if (attendanceData != null && attendanceData.length >= 2) {
        int presentCount = attendanceData[0] - 1;
        await studentRef.update({
          'Attendance_data.${widget.courseId}': [
            presentCount,
            attendanceData[1]
          ],
        });
      }
      await attendanceRef.update({
        'Attendees': FieldValue.arrayRemove([userId]),
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    if (attendanceRecords.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final columns = [
      'Sl no',
      'Student Name',
      'Email',

      // Here ...attendanceRecords means it extends previous value along with present value
      ...attendanceRecords
          .map((record) => record['date']!)
          .toList(), 
      'Eligibility',
    ];

    // Returning to data table
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(users),
    );
  }


  // Function to get data columns
  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        label: Text(column),
      );
    }).toList();
  }

  // Function to get data rows
  List<DataRow> getRows(List<User1> users) => users.map((User1 user) {
        final cells = [
          DataCell(Text('${user.slno}')),
          DataCell(Text(user.firstName)),
          DataCell(Text(user.email)),

          // Spread operator
          ...attendanceRecords.map((record) {
            final date = record['date']!;
            final attendanceId = record['id']!;
            
            // Getting P or A
            final attendanceStatus =
                user.attendance['${date}_$attendanceId'] ?? 'A';

            Color textColor = Colors.black;
            FontWeight fontWeight = FontWeight.normal;

            if (attendanceStatus == 'P') {
              textColor = Colors.green;
              fontWeight = FontWeight.bold;
            } else if (attendanceStatus == 'A') {
              textColor = Colors.red;
              fontWeight = FontWeight.bold;
            }

            return DataCell(
              InkWell(
                onTap: () {
                  setState(() {
                    final isPresent =
                        user.attendance['${date}_$attendanceId'] == 'P';
                    user.attendance['${date}_$attendanceId'] =
                        isPresent ? 'A' : 'P';
                    updateAttendance(user.email, widget.courseId, date,
                        attendanceId, !isPresent);
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    attendanceStatus,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: fontWeight,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          // Calculate eligibility percentage here
          DataCell(calculateEligibility(user)),
        ];

        return DataRow(
          cells: cells,
        );
      }).toList();

  Widget calculateEligibility(User1 user) {
    if (user.attendance.isEmpty) {
      return Text(
        'N/A',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    int presentClasses = 0;
    int totalClasses = 0;

    // Example logic to iterate through attendance records
    user.attendance.forEach((date, status) {
      if (status == 'P') {
        presentClasses++;
      }
      totalClasses++;
    });

    if (totalClasses == 0) {
      return Text(
        'N/A',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    double percentage = (presentClasses / totalClasses) * 100;
    String eligibility = percentage.toStringAsFixed(2) + '%';

    // Determine color based on percentage
    Color color;
    if (percentage > 85) {
      color = Colors.green;
    } else if (percentage > 75) {
      color = Colors.yellow;
    } else {
      color = Colors.red;
    }

    // Return styled text with color
    return Text(
      eligibility,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
