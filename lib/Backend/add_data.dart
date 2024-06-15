import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Teachers_DashBoard/Add_Subject.dart';

// Teacher Collection Variables
var email, add_teacher_map;

// Courses Collection Variables
var Store_Course_Name,
    Store_Course_Code,
    Store_Branch,
    Store_Semester,
    Store_Section,
    add_courses_map;

initialize_data() {
  // Teachers Data
  email = emailName.toString();
  add_teacher_map = {
    "Teacher_id": email,
    "email": email,
    "Teacher_Name": userName.toString()
  };

  // Courses data
  Store_Course_Code = course_code.text.toString();
  Store_Branch = dropdownvalue_branch;
  Store_Semester = dropdownvalue_semester;
  Store_Section = dropdownvalue_section;

  if (Store_Branch == "CSE") {
    Store_Course_Name = dropdown_course;
  } else {
    Store_Course_Name = course_name.text.toString();
  }

  add_courses_map = {
    "Course_Name": Store_Course_Name,
    "Course_Code": Store_Course_Code,
    "Branch": Store_Branch,
    "Semester": Store_Semester,
    "Section": Store_Section,
    "Teacher_id": email
  };
}

add_course_data() {
  // Gets data
  initialize_data();

  FirebaseFirestore.instance
      .collection("Courses")
      .doc()
      .set(add_courses_map)
      .then((value) => print("Course data inserted"));
}

add_Teachers_data() {
  initialize_data();

  // Writes data
  FirebaseFirestore.instance
      .collection("Teachers")
      .doc("$email")
      .set(add_teacher_map)
      .then((value) => print("Teacher data inserted"));
}
