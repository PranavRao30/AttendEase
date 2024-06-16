import 'package:attend_ease/Backend/fetch_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Teachers_DashBoard/Add_Subject.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

// Teacher Collection Variables
var email, add_teacher_map;
var course_id;
var uuid = Uuid();
var id, f = 1;
// Courses Collection Variables
var Store_Course_Name,
    Store_Course_Code,
    Store_Branch,
    Store_Semester,
    Store_Section,
    Store_Classes_Held,
    add_courses_map;

add_course_data(id) {
  // Gets data
  // initialize_data();

  // Courses data
  Store_Course_Code = course_code.text.toString();
  Store_Branch = dropdownvalue_branch;
  Store_Semester = dropdownvalue_semester;
  Store_Section = dropdownvalue_section;
  Store_Classes_Held = classes_held.text.toString();
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
    "Teacher_id": email
  };

  FirebaseFirestore.instance
      .collection("Courses")
      .doc(id)
      .set(add_courses_map)
      .then((value) => print("Course data inserted"));
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

      // Upon Login
      // if (flag == 0) {
      //   fetch_Teachers_Data(course_id);
      // }
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
    // else if (course_id.isNotEmpty) {
    //   print("Section 2");
    //   for (int i = 0; i < course_id.length; i++) {
    //     print(course_id[i]);
    //   }
    // }
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
