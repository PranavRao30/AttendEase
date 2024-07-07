import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Teachers_DashBoard/Add_Subject.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'dart:async';

// Teacher Collection Variables
var email, add_teacher_map, add_student_map;
var course_id;
var uuid = Uuid();
var stud_id;
var id, f = 1;
// Courses Collection Variables
var Store_Course_Name,
    Store_Course_Code,
    Store_Branch,
    Store_Semester,
    Store_Section,
    Store_Classes_Held,
    add_courses_map;

remove_concurrency() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("Courses")
      .where('Semester', isEqualTo: dropdownvalue_semester)
      .where('Section', isEqualTo: dropdownvalue_section)
      .where('Branch', isEqualTo: dropdownvalue_branch)
      .where('Course_Code', isEqualTo: Store_Course_Code)
      .get();

  DocumentSnapshot get_concurrent_document;
  var remove_concurrent;
  var remove_list = [];
  if (querySnapshot.docs.isNotEmpty) {
    for (var course_id in querySnapshot.docs) {
      get_concurrent_document = await FirebaseFirestore.instance
          .collection("Courses")
          .doc(course_id.id)
          .get();

      remove_concurrent = get_concurrent_document.data();

      remove_list.add(remove_concurrent['Time_of_adding']);
      // print(course_id.id);
    }

    DateFormat format = DateFormat("HH:mm:ss");

    // Datetime obj list
    List<DateTime> parsed_to_time =
        remove_list.map((time) => format.parse(time)).toList();

    parsed_to_time.sort();

    // Converting time objects into string
    List<String> sortedTime =
        parsed_to_time.map((time) => format.format(time)).toList();

    print(sortedTime);

    QuerySnapshot get_removing_id;
    // get_removing_id = await FirebaseFirestore.instance
    //     .collection("Courses")
    //     .where("Time_of_adding", isEqualTo: sortedTime[1])
    //     .get();
    // for (var i in get_removing_id.docs) print(i.id);

    for (int i = 1; i < sortedTime.length; i++) {
      get_removing_id = await FirebaseFirestore.instance
          .collection("Courses")
          .where("Time_of_adding", isEqualTo: sortedTime[i])
          .get();

      // print(get_removing_id);

      for (var course_id in get_removing_id.docs) {
        print(course_id.id);

        Timer(Duration(seconds: 5), () async {
          await FirebaseFirestore.instance
              .collection("Courses")
              .doc(course_id.id)
              .delete();
        });
      }

    }
  }
}

add_course_data(id) async {
  // Gets data
  // Courses data
  Store_Course_Code = course_code.text.toString();
  Store_Branch = dropdownvalue_branch;
  Store_Semester = dropdownvalue_semester;
  Store_Section = dropdownvalue_section;
  Store_Classes_Held = classes_held.text.toString();

  DateTime time = DateTime.now();
  String formatted_time = DateFormat("HH:mm:ss").format(time);

  print(formatted_time.toString() + time.millisecond.toString());

  if (Store_Branch == "CSE")
    Store_Course_Name = dropdown_course;
  else
    Store_Course_Name = course_name.text.toString();


  add_courses_map = {
    "Course_id": id,
    "Course_Name": Store_Course_Name,
    "Course_Code": Store_Course_Code,
    "Branch": Store_Branch,
    "Semester": Store_Semester,
    "Section": Store_Section,
    "Classes_Held": Store_Classes_Held,
    "Teacher_id": email,
    "Time_of_adding": formatted_time,
    "Student_list": [],
  };

  FirebaseFirestore.instance
      .collection("Courses")
      .doc(id)
      .set(add_courses_map)
      .then((value) => print("Course data inserted"));

  Timer(Duration(seconds: 5), () {
    remove_concurrency();
  });
}

// version 3
var get_data;
add_Teachers_data(flag) async {
  email = emailName.toString();
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection("Teachers").doc(email).get();

  if (!documentSnapshot.exists) {
    print("Empty");
    add_teacher_map = {
      "Teacher_id": email,
      "email": email,
      "Teacher_Name": userName.toString(),
      "Course_id": []
    };

    // Writing to Firestore
    await FirebaseFirestore.instance
        .collection("Teachers")
        .doc(email)
        .set(add_teacher_map);
  }

  // if already exists
  else {
    // Getting data from Teachers collection
    get_data = documentSnapshot.data();
    print(get_data);

    // Checking course id from backend
    if (get_data["Course_id"] == null)
      course_id = [];
    else {
      course_id = List<String>.from(get_data["Course_id"]);
    }

    print("From Backend");
    print(course_id);
  }

  // Start screen
  if (flag == 0) {
    if (course_id.isEmpty) {
      print("Section 1");
      add_teacher_map = {
        "Teacher_id": email,
        "email": email,
        "Teacher_Name": userName.toString(),
        "Course_id": []
      };
    }
  }

  // add subject
  else if (flag == 1) {
    print("In");

    id = uuid.v4();

    course_id.add(id);
    print(course_id);
    add_teacher_map = {
      "Teacher_id": email,
      "email": email,
      "Teacher_Name": userName.toString(),
      "Course_id": course_id
    };
    // Course Details
    add_course_data(id);

    // updating to Teachers collections.
    await FirebaseFirestore.instance
        .collection("Teachers")
        .doc(email)
        .update({"Course_id": course_id}); // Use update to append

    /// Debug
    documentSnapshot = await FirebaseFirestore.instance
        .collection("Teachers")
        .doc(email)
        .get();

    // Getting data from Teachers collection
    get_data = documentSnapshot.data();

    print("After adding");
    print(get_data);
  }
}



// Students Data
get_Students_data(
    dropdownvalue_branch, dropdownvalue_semester, dropdownvalue_section) async {
  // stud_id = uuid.v4();
  print("add_student");
  print(emailName);

  // if (documentSnapshot.exists) {
  // add_student_map = {
  //   "status_of_joining": true,
  //   "student_id": email,
  //   "Student_name": emailName.toString(),
  //   "Branch": "",
  //   "Semester": "",
  //   "Section": "",
  //   "Courses_list": [],
  // };

  // await FirebaseFirestore.instance.collection("Students").doc(email).set(add_student_map);

  await FirebaseFirestore.instance
      .collection("Students")
      .doc(emailName)
      .update({
    "status_of_joining": true,
    "Branch": dropdownvalue_branch,
    "Semester": dropdownvalue_semester,
    "Section": dropdownvalue_section
  });

  
  print("students details updated");
}
