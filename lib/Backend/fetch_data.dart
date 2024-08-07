import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class get_table1 {
  final int slno;
  final String name;
  String Present;
  final String email_id;

  get_table1({
    required this.slno,
    required this.name,
    required this.Present,
    required this.email_id,
  });
}

// Table

var attendance_id;
var attendance_course_id;
List attendees = [];
var attendance_map;

// Creating Attendance Collections
creating_attendance_collection(uid) async {
  DateTime now = DateTime.now();
  // Format the date
  String formattedDate = DateFormat('dd-MM-yyyy').format(now);
  DateFormat format = DateFormat("HH");
  String hour = format.format(now);
  attendance_id = '${formattedDate}_${uid}_${hour}';
  attendance_course_id = uid;
  attendees = [];

  attendance_map = {
    "Course_id": attendance_course_id,
    "Attendees": attendees,
    "Date": formattedDate,
    "Attendance_Status": false
  };
  await FirebaseFirestore.instance
      .collection("Attendance")
      .doc(attendance_id)
      .set(attendance_map)
      .then((value) => print("Attendance collection created"));
}
