import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';
import 'package:attend_ease/Bluetooth/broadcast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// class get_table {
//   final int slno;
//   final String name;
//   final String Present;

//   get_table({
//     required this.slno,
//     required this.name,
//     required this.Present,
//   });
// }

// Table


var attendance_id;
  var attendance_course_id;
  List attendees=[];
  var attendance_map;
creating_attendance_collection(uid) async {
  DateTime now = DateTime.now();
  // Format the date
  String formattedDate = DateFormat('dd-MM-yyyy').format(now);
  DateFormat format = DateFormat("HH");
  String hour = format.format(now);
  attendance_id = '${formattedDate}_${uid}_${hour}';
  attendance_course_id = uid;
  attendees =[];

  attendance_map = {"Course_id": attendance_course_id, "Attendees":attendees, "Date": formattedDate,};
await FirebaseFirestore.instance.collection("Attendance").doc(attendance_id).set(
    attendance_map
  ).then((value) => print("Attendance collection created"));

}



// List<get_table> Students_data = [
//   get_table(
//       slno: 1,
//       name: "Prajwal P",
  
//       Present: "P",
//       ),
//   get_table(
//       slno: 2,
//       name: "Pannaga R Bhat",
      
//       Present: "A",
//       ),
//   get_table(
//       slno: 3,
//       name: "Pranav Anantha Rao",
//       Present: "P",
//       ),
//   get_table(
//       slno: 4,
//       name: "Pradeep P T",
//       Present: "A",
//       ),
// ];
