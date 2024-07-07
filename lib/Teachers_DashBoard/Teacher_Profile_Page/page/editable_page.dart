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
  print("Inside get course0 $id");
}

class EditablePage extends StatefulWidget {
  final String courseId;

  EditablePage(this.courseId);

  @override
  _EditablePageState createState() => _EditablePageState();
}

class _EditablePageState extends State<EditablePage> {
  late List<User1> users;
  late List<String> dates;

  @override
  void initState() {
    super.initState();
    users = [];
    dates = [];
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
          List<String> attendanceDates = [];
          QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
              .collection("Attendance")
              .where("Course_id", isEqualTo: widget.courseId)
              .get();

          for (var doc in attendanceSnapshot.docs) {
            Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
            if (data != null && data.containsKey('Date')) {
              String date = data['Date'];
              attendanceDates.add(date);
              List<String> attendees = List<String>.from(data['Attendees']);
              for (var user in allUsers) {
                if (attendees.contains(user.email)) {
                  user.attendance[date] = 'P'; // Present
                } else {
                  user.attendance[date] = 'A'; // Absent
                }
              }
            }
          }

          setState(() {
            users = allUsers;
            dates = attendanceDates;
          });
        }
      }
    } catch (e) {
      print("Error fetching student details: $e");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    if (dates.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    final columns = [
      'Sl no',
      'Student Name',
      'Email',
      ...dates,
    ];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(users),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        label: Text(column),
      );
    }).toList();
  }

  List<DataRow> getRows(List<User1> users) => users.map((User1 user) {
        final cells = [
          user.slno,
          user.firstName,
          user.email,
          ...dates.map((date) => user.attendance[date] ?? 'A').toList(),
        ];

        return DataRow(
          cells: cells.map((cell) => DataCell(Text('$cell'))).toList(),
        );
      }).toList();
}
