import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Teachers_DashBoard/Sections.dart';
import 'package:attend_ease/ui_components/util.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';
import 'package:attend_ease/Teachers_DashBoard/Subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_popup/info_popup.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// void main() {
//   runApp(add_a_subject());
// }

class add_a_subject extends StatelessWidget {
  add_a_subject({super.key, required this.controller});

  final PageController controller;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context,child) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(215, 130, 255, 1),
          ),
          useMaterial3: true,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page', controller: controller),
      ),
      designSize: const Size(360,690),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.controller});

  final String title;
  final PageController controller;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Variables Required
var validate_course_name = false;
var validate_course_code = false;
var validate_classes_held = false;
var add_course_code, sem_sec_branch;
var branch_codes = [
  'AE',
  'AIDS',
  'AIML',
  'BT',
  'CH',
  'CSBS',
  'CSDS',
  'CSE',
  'CSIOT',
  'CV',
  'EC',
  'EEE',
  'EI',
  'ET',
  'IEM',
  'ISE',
  'MD',
  'ME'
];

var dropdownvalue_branch = "CSE";
var dropdownvalue_semester = 2;
var current_cycle = "Even";
var dropdownvalue_section = 'A';
var sem = [2, 4, 6, 8];
var section = ['A', 'B'];
var course_name = TextEditingController();
var course_code = TextEditingController();
var classes_held = TextEditingController();

var dropdown_course = "Applied Physics for Computer Science Stream";
var cse1 = [
  "Mathematical foundation for Computer Science Stream-2",
  "Applied Physics for Computer Science Stream",
  "Principles of Programming in C",
  "Professional Writing Skills in English",
  "Innovation and Design Thinking",
  "Introduction to Electronics Engineering",
  "Introduction to Electrical Engineering",
  "Introduction to Civil Engineering",
  "Introduction to Mechanical Engineering",
  "Introduction to Python Programing",
  "Introduction to Web Programing",
  "Samskrutika Kannada",
  "Balake Kannada",
];

var cse_courses = cse1;
bool enable_section = false;
bool enable_Course = true;
bool enable_manual_course_name = false;
bool disable_dropdown_cse = true;
bool _isLoading = false;
var Section;

// Display duplicates
void displayDuplicatesMessage(BuildContext context) {
  final snackbar = SnackBar(
    content: Text("Course Already Exists for this Class"),
    duration: Duration(seconds: 3),
    action: SnackBarAction(
        label: "Ok",
        onPressed: () {
          print("Duplicates");
        }),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

class _MyHomePageState extends State<MyHomePage> {
  check(currentCycle) {
    if (currentCycle == "Even") {
      sem = [2, 4, 6, 8];
      dropdownvalue_semester = 2;
      setState(() {});
    }
    if (currentCycle == "Odd") {
      sem = [1, 3, 5, 7];
      dropdownvalue_semester = 1;
      setState(() {});
    }

    if ((dropdownvalue_branch == "CSIOT" ||
            dropdownvalue_branch == "AIDS" ||
            dropdownvalue_branch == "CSDS") &&
        (currentCycle == "Odd")) {
      sem = [1, 3];

      dropdownvalue_semester = 1;
      dropdownvalue_section = 'A';
      setState(() {});
    }

    if ((dropdownvalue_branch == "CSIOT" ||
            dropdownvalue_branch == "AIDS" ||
            dropdownvalue_branch == "CSDS") &&
        (currentCycle == "Even")) {
      sem = [2, 4];
      dropdownvalue_semester = 2;
      dropdownvalue_section = 'A';
      setState(() {});
    }
  }

// Start
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Background Color of the home page.
        backgroundColor: const Color.fromRGBO(184, 163, 255, 0.1),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              height: 70.0.h,
              width: 330.0.w,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(184, 163, 255, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  // bottomLeft: Radius.circular(20),
                  // topRight: Radius.circular(20)
                ),
              ),
              child: Center(
                child: Text(
                  "Add Course",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Container(
                            // height: 800, // Replace with your container's height
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                              Container(
                                // width: 400,
                                // margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Enter Course Details",
                                      style: GoogleFonts.poppins(
                                          textStyle: font25(
                                              textColor: Color.fromRGBO(
                                                  184, 163, 255, 1)),
                                          fontWeight: FontWeight.w600
          
                                          // Retreiving from the theme
          
                                          // Theme.of(context).textTheme.displayLarge
                                          // !.copyWith(color: Colors.deepPurpleAccent[500]),
                                          ),
                                    ),
// Branch Selection
Padding(
  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
  child: Row(
    children: [
      Flexible(
        flex: 2, // Adjust the flex value as needed
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Select Branch:",
            style: font_details(),
          ),
        ),
      ),
      // options
      Flexible(
        flex: 3, // Adjust the flex value as needed
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: dropdownvalue_branch,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                // Items from the array
                items: branch_codes.map((String s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  );
                }).toList(),
                onChanged: (String? newVal) {
                  setState(() {
                    dropdownvalue_branch = newVal!;

                    // Newly Arrived Branches
                    if (dropdownvalue_branch == "CSIOT" ||
                        dropdownvalue_branch == "AIDS" ||
                        dropdownvalue_branch == "CSDS") {
                      if (dropdownvalue_semester == 1 ||
                          dropdownvalue_semester == 3 ||
                          dropdownvalue_semester == 5 ||
                          dropdownvalue_semester == 7) {
                        dropdownvalue_semester = 1;
                      }
                      if (dropdownvalue_semester == 2 ||
                          dropdownvalue_semester == 4 ||
                          dropdownvalue_semester == 6 ||
                          dropdownvalue_semester == 8) {
                        dropdownvalue_semester = 2;
                      }
                      sem = new_Arrival(dropdownvalue_branch, current_cycle);
                      dropdownvalue_section = "A";
                    } else {
                      check(current_cycle);
                    }

                    // Dropdown for CSE else enabling manual entry for other branches
                    if (dropdownvalue_branch == "CSE") {
                      cse_courses = get_courses(dropdownvalue_branch, dropdownvalue_semester);
                      enable_Course = true;
                      enable_manual_course_name = false;
                      validate_course_name = false;
                    } else {
                      enable_manual_course_name = true;
                      enable_Course = false;
                    }
                    enable_section = false;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),


          // Cycle Selection
Padding(
  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        flex: 2, // Adjust the flex value as needed
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Current Cycle:",
            style: font_details(),
          ),
        ),
      ),
      // options
      Flexible(
        flex: 3, // Adjust the flex value as needed
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: current_cycle,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                // Items from the array
                items: ['Even', 'Odd'].map((String s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  );
                }).toList(),
                onChanged: (String? newVal) {
                  setState(() {
                    current_cycle = newVal!;
                    check(current_cycle);

                    // Dropdown for CSE
                    if (dropdownvalue_branch == "CSE") {
                      cse_courses = get_courses(
                          dropdownvalue_branch, dropdownvalue_semester);
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),

// Semester Selection
Padding(
  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        flex: 2, // Adjust the flex value as needed
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Select Semester:",
            style: font_details(),
          ),
        ),
      ),
      // options
      Flexible(
        flex: 3, // Adjust the flex value as needed
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: dropdownvalue_semester,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                // Items from the array
                items: sem.map((int s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text("$s"),
                  );
                }).toList(),
                onChanged: (int? newVal) {
                  setState(() {
                    dropdownvalue_semester = newVal!;
                    if (dropdownvalue_branch != "CSIOT" &&
                        dropdownvalue_branch != "AIDS" &&
                        dropdownvalue_branch != "CSDS") {
                      select_sections(dropdownvalue_branch, current_cycle);
                    }

                    // Extracting section
                    section = sections['$dropdownvalue_semester'];

                    enable_section = newVal != null;

                    if (dropdownvalue_branch == "CSE") {
                      cse_courses = get_courses(
                          dropdownvalue_branch, dropdownvalue_semester);
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),

          
                                    // Section Selection
Padding(
  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        flex: 2, // Adjust the flex value as needed
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Select Section:",
            style: font_details(),
          ),
        ),
      ),
      // options
      Flexible(
        flex: 3, // Adjust the flex value as needed
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(10),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: dropdownvalue_section,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                // Items from the array
                items: section.map((String s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s),
                  );
                }).toList(),
                onChanged: enable_section
                    ? (String? newVal) {
                        setState(() {
                          dropdownvalue_section = newVal!;
                          enable_Course = newVal != null;
                        });
                      }
                    : null,
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),

                                    // Course Selection
                                    if (dropdownvalue_branch == "CSE")
                                    Padding(
  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Flexible(
        flex: 2,
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Select Course:",
            style: font_details(),
          ),
        ),
      ),
      Flexible(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                value: dropdown_course,
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                // Ensure the dropdown menu width adjusts with window size
                // Set a minimum width for larger items
                // Example: dropdownWidth: MediaQuery.of(context).size.width * 0.5,
                // or use a fixed width that suits your design
                items: cse_courses.map((String s) {
                  return DropdownMenuItem(
                    value: s,
                    child: SizedBox(
                      width: double.infinity, // Full width for text
                      child: Text(
                        ' $s ', // Add spaces around the text
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: enable_Course
                    ? (String? newVal) {
                        setState(() {
                          dropdown_course = newVal!;
                          print(dropdown_course);
                        });
                      }
                    : null,
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),



          
                                    // Course Name
                                    if (dropdownvalue_branch != "CSE")
                                      const Get_Course_Name(),
          
                                    // Course code
                                    const Get_Course_Code(),
          
                                    // Classes Held
                                    const Get_Classes_Held(),
          
                                    Container(
                                      height: 10,
                                    ),
          
                                    // Submit
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromRGBO(184, 163, 255, 1),
                                          foregroundColor:
                                              Colors.black, // Black text
                                        ),
                                        onPressed: () async {
                                          // Validating Part
                                          // setState(() {
                                          validate_course_name =
                                              course_name.text.isEmpty;
                                          validate_course_code =
                                              course_code.text.isEmpty;
                                          validate_classes_held =
                                              classes_held.text.isEmpty;
                                          // });
          
                                          // Apppending
                                          // For Other Branches
                                          if (!validate_classes_held &&
                                              !validate_course_code &&
                                              !validate_course_name &&
                                              dropdownvalue_branch != "CSE") {
                                            Store_Course_Name =
                                                course_name.text.toString();
                                            sem_sec_branch =
                                                "$dropdownvalue_semester$dropdownvalue_section | $dropdownvalue_branch";
          
                                            // Checking Duplicates
                                            if ((await check_duplicates2(
                                                course_code.text.toString(),
                                                dropdownvalue_semester,
                                                dropdownvalue_section,
                                                dropdownvalue_branch))) {
                                              setState(() {
                                                _isLoading = true;
                                              });
          
                                              print("in non cse");
                                              // Adding Data to firebase
                                              add_Teachers_data(1);
          
                                              Timer(Duration(seconds: 1), () {
                                                widget.controller.animateToPage(1,
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.ease);
                                              });
                                            } else {
                                              _isLoading = false;
                                              displayDuplicatesMessage(context);
                                            }
                                          }
          
                                          // For CSE
                                          if (!validate_classes_held &&
                                              !validate_course_code &&
                                              dropdownvalue_branch == "CSE") {
                                            //
                                            var semSecBranch =
                                                "$dropdownvalue_semester$dropdownvalue_section | $dropdownvalue_branch";
                                            var addCourseCode =
                                                course_code.text.toString();
          
                                            // Checking Duplicates
                                            if ((await check_duplicates2(
                                                addCourseCode,
                                                dropdownvalue_semester,
                                                dropdownvalue_section,
                                                dropdownvalue_branch))) {
                                              setState(() {
                                                _isLoading = true;
                                              });
          
                                              // Adding Data to firebase
                                              add_Teachers_data(1);
          
                                              Timer(Duration(seconds: 1), () {
                                                widget.controller.animateToPage(1,
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    curve: Curves.ease);
                                              });
                                            } else {
                                              _isLoading = false;
                                              displayDuplicatesMessage(context);
                                            }
                                          }
          
                                          // transition fixed
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                        child: Text(
                                          "ADD",
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ]))))
          ])),
        ));
  }
}

// Separate Widgets of Course Details

class Get_Course_Name extends StatelessWidget {
  const Get_Course_Name({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 2, // Adjust the flex value as needed
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Course Name:",
                style: font_details(),
              ),
            ),
          ),
          Flexible(
            flex: 3, // Adjust the flex value as needed
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.6, // Adjust width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(radius_12()),
                color: Colors.white60,
              ),
              child: TextField(
                // non CSE branches
                enabled: enable_manual_course_name,
                // Extracting course name from the text field
                controller: course_name,
                // Restriction to alphabets
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]+$')),
                ],
                decoration: InputDecoration(
                  hintText: "Enter Course Name",
                  errorText: validate_course_name ? "Field cannot be empty" : null,
                  // Initial border
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(radius_12()),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  // After selecting
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(radius_12()),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Get_Course_Code extends StatelessWidget {
  const Get_Course_Code({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 2, // Adjust the flex value as needed
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Course Code:",
                style: font_details(),
              ),
            ),
          ),
          Flexible(
            flex: 3, // Adjust the flex value as needed
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.6, // Adjust width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(radius_12()),
                color: Colors.white60,
              ),
              child: TextField(
                controller: course_code,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ]+$'))
                ],
                decoration: InputDecoration(
                  hintText: "Enter course code",
                  errorText: validate_course_code ? "Field cannot be empty" : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(radius_12()),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(radius_12()),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Get_Classes_Held extends StatelessWidget {
  const Get_Classes_Held({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 2, // Adjust the flex value as needed
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "Classes Held:",
                style: font_details(),
              ),
            ),
          ),
          Flexible(
            flex: 3, // Adjust the flex value as needed
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              width: MediaQuery.of(context).size.width * 0.6, // Adjust width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(radius_12()),
                color: Colors.white60,
              ),
              child: TextField(
                controller: classes_held,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter no of classes held",
                  errorText: validate_classes_held ? "Field cannot be empty" : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(radius_12()),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(radius_12()),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.purple,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
