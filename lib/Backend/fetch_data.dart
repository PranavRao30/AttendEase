import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';
import 'package:attend_ease/Teachers_DashBoard/Add_Subject.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

var Teachers_data;
// var course_list = [];

fetch_Teachers_Data(course_id) async {
  // var fetch_initial_Teachers =
  //     await FirebaseFirestore.instance.collection("Teachers").doc(email).get();
  // Teachers_data = fetch_initial_Teachers.data();
  print("inside fect");
  print(course_id);

  var course_data;
  for (int i = 0; i < course_id.length; i++) {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Courses")
        .doc(course_id[i])
        .get();
    course_data = documentSnapshot.data();
    print("Cour ${i + 1}");
    print(course_data);

    Course_Names.add(course_data["Course_Name"]);
    Course_Code.add(course_data['Course_Code']);
    sections_branch_list.add(
        "${course_data['Semester']}${course_data['Section']} | ${course_data['Branch']}");
    classesHeld.add(course_data['Classes_Held']);
  }

  print(Course_Names);
  // _MyHomePageState_Teacher()
  // Navigator.push(
  //     context, MaterialPageRoute(builder: (context) => Teachers_Dashboard()));
  // Teacher_Home_Page(
  //   title: "Teacher_Home_Page",
  // );
}

// get_teachers_data() async {
//   var querySnapshot =
//       await FirebaseFirestore.instance.collection('Teachers').get();
//   // if (querySnapshot.docs.isNotEmpty) {
//   //   for (var document in querySnapshot.docs) {
//   //     print(document.id);
//   //   }
//   // }
//   if (querySnapshot.docs.isEmpty) {
//     // Variables
//     var Course_Names = [];

//     var Course_Code = [];

//     var classesHeld = [];

//     var sections_branch_list = [];
//     return [Course_Names, Course_Code, classesHeld, sections_branch_list];
//   } else
//     return false;
// }

// // var document in course_list
// get_teachers_details() {
//   // async
//   // try {
//   //   for (int i = 1; i < course_id.length; i++) {
//   //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//   //         .collection('Courses')
//   //         .doc(course_id[i][0])
//   //         .get();

//   //     if (documentSnapshot.exists)
//   //       print(documentSnapshot.data());
//   //     else
//   //       print("Document does not exist");
//   //   }
//   // } catch (e) {
//   //   print("Document does not exist");
//   // }
//   print("Inside get_teachers ${course_list.length}");
// }
