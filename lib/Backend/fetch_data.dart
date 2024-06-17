import 'package:cloud_firestore/cloud_firestore.dart';

var Course_Names = <String>[];
var Course_Code = <String>[];
var classesHeld = <String>[];
var sections_branch_list = <String>[];

fetch_Teachers_Data(List<String> course_id) async {
  var course_data;
  for (int i = 0; i < course_id.length; i++) {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Courses")
        .doc(course_id[i])
        .get();
    course_data = documentSnapshot.data();
    Course_Names.add(course_data["Course_Name"]);

    Course_Code.add(course_data['Course_Code']);
    sections_branch_list.add(
        "${course_data['Semester']}${course_data['Section']} | ${course_data['Branch']}");
    classesHeld.add("Classes Held: ${course_data['Classes_Held']}");
  }

  print(Course_Code);
}
