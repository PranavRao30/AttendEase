import 'package:cloud_firestore/cloud_firestore.dart';

var sections = {};
var sem;
select_sections(dropdownvalueBranch, currentCycle) {
  //Even Cycle
  if (currentCycle == "Even") {
    get_sections(dropdownvalueBranch, 2);
  } else if (currentCycle == "Odd") {
    get_sections(dropdownvalueBranch, 1);
  }

  // print(sections);
}

// Getting Sections
get_sections(dropdownvalueBranch, c) {
  if (dropdownvalueBranch == "CSE") {
    for (int i = c; i <= 8; i += 2) {
      sections['$i'] = ['A', 'B', 'C', 'D', 'E', 'F'];
    }
  } else if (dropdownvalueBranch == "AIML") {
    for (int i = c; i <= 8; i += 2) {
      sections['$i'] = ['A', 'B', 'C'];
    }
  } else if (dropdownvalueBranch == "EC") {
    for (int i = c; i <= 8; i += 2) {
      sections['$i'] = ['A', 'B', 'C', 'D', 'E'];
    }
  } else if (dropdownvalueBranch == "EI" ||
      dropdownvalueBranch == 'ET' ||
      dropdownvalueBranch == "BT") {
    for (int i = c; i <= 8; i += 2) {
      sections['$i'] = ['A'];
    }
  } else if (dropdownvalueBranch == "CSIOT" ||
      dropdownvalueBranch == "AIDS" ||
      dropdownvalueBranch == "CSDS") {
    for (int i = c; i <= 4; i += 2) {
      sections['$i'] = ['A'];
    }
  }
}

new_Arrival(dropdownvalueBranch, currentCycle) {
  if ((dropdownvalueBranch == "CSIOT" ||
          dropdownvalueBranch == "AIDS" ||
          dropdownvalueBranch == "CSDS") &&
      (currentCycle == "Even")) {
    sem = [2, 4];
    return sem;
  } else if ((dropdownvalueBranch == "CSIOT" ||
          dropdownvalueBranch == "AIDS" ||
          dropdownvalueBranch == "CSDS") &&
      (currentCycle == "Odd")) {
    sem = [1, 3];
    return sem;
  }
}

check_duplicates(addCourseCode, semSecBranch, courseCode, sectionsBranchList) {
  for (int i = 0; i < courseCode.length; i++) {
    if (addCourseCode == courseCode[i]) {
      if (sectionsBranchList[i] == semSecBranch) {
        return true;
      }
    }
  }
  return false;
}

Future<bool> check_duplicates2(
  String addCourseCode, 
  int dropdownvalue_semester, 
  String dropdownvalue_section,
  String dropdownvalue_branch
) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("Courses")
      .where('Course_Code', isEqualTo: addCourseCode)
      .where('Semester', isEqualTo: dropdownvalue_semester)
      .where('Section', isEqualTo: dropdownvalue_section)
      .where('Branch', isEqualTo: dropdownvalue_branch)
      .get();

  return querySnapshot.docs.isEmpty;
}

void main() {
  select_sections("CSE", "Odd");
}

// var branch_codes = [
//   'AE',
//   'AIDS',
//   'AIML',
//   'BT',
//   'CH',
//   'CSBS',
//   'CSDS',
//   'CSE',
//   'CSIOT',
//   'CV',
//   'EC',
//   'EEE',
//   'EI',
//   'ET',
//   'IEM',
//   'ISE',
//   'MD',
//   'ME'
// ];