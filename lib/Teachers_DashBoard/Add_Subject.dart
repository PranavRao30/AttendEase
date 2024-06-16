// import 'dart:ffi';
import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Teachers_DashBoard/Sections.dart';
import 'package:attend_ease/ui_components/util.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';
import 'package:attend_ease/Teachers_DashBoard/Subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:info_popup/info_popup.dart';

// void main() {
//   runApp(add_a_subject());
// }

class add_a_subject extends StatelessWidget {

  add_a_subject({super.key, required this.controller});

  final PageController controller;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(215, 130, 255, 1),
        ),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        controller: controller
      ),
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
  "Mathematical foundation for Computer SCience Stream-2",
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

// to catch the index of duplicate entry
var position;

var Section;

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
      setState(() {});
    }

    if ((dropdownvalue_branch == "CSIOT" ||
            dropdownvalue_branch == "AIDS" ||
            dropdownvalue_branch == "CSDS") &&
        (currentCycle == "Even")) {
      sem = [2, 4];
      dropdownvalue_semester = 2;
      setState(() {});
    }
  }

// Start
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Background Color of the home page.
        backgroundColor: const Color.fromRGBO(184, 163, 255, 0.1),
        body: Column(children: [
          const SizedBox(height: 25),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            height: 70,
            width: 330,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(184, 163, 255, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                // bottomLeft: Radius.circular(20),
                // topRight: Radius.circular(20)
              ),
              // boxShadow: [
              //   BoxShadow(
              //     spreadRadius: 3,
              //     blurRadius: 11,
              //     color: Color.fromRGBO(184, 163, 255, 1),
              //   ),
              // ],
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
              child: SingleChildScrollView(
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
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Row(
                                      children: [
                                        Align(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: Container(
                                              child: Text(
                                            "Select Branch:",
                                            style: font_details(),
                                          )),
                                        ),
                                        // options
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 46),
                                            child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                            value:
                                                                dropdownvalue_branch,
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),
                                                            // Items from the array
                                                            items: branch_codes
                                                                .map(
                                                                    (String s) {
                                                              return DropdownMenuItem(
                                                                  value: s,
                                                                  child:
                                                                      Text(s));
                                                            }).toList(),

                                                            //
                                                            onChanged: (String?
                                                                newVal) {
                                                              setState(() {
                                                                dropdownvalue_branch =
                                                                    newVal!;

                                                                // Newly Arrived Branches
                                                                if (dropdownvalue_branch == "CSIOT" ||
                                                                    dropdownvalue_branch ==
                                                                        "AIDS" ||
                                                                    dropdownvalue_branch ==
                                                                        "CSDS") {
                                                                  if (dropdownvalue_semester == 1 ||
                                                                      dropdownvalue_semester ==
                                                                          3 ||
                                                                      dropdownvalue_semester ==
                                                                          5 ||
                                                                      dropdownvalue_semester ==
                                                                          7) {
                                                                    dropdownvalue_semester =
                                                                        1;
                                                                  }
                                                                  if (dropdownvalue_semester == 2 ||
                                                                      dropdownvalue_semester ==
                                                                          4 ||
                                                                      dropdownvalue_semester ==
                                                                          6 ||
                                                                      dropdownvalue_semester ==
                                                                          8) {
                                                                    dropdownvalue_semester =
                                                                        2;
                                                                  }
                                                                  sem = new_Arrival(
                                                                      dropdownvalue_branch,
                                                                      current_cycle);
                                                                } else {
                                                                  check(
                                                                      current_cycle);
                                                                }

                                                                // Dropdown for CSE else enalbing maual entry for other branches
                                                                if (dropdownvalue_branch ==
                                                                    "CSE") {
                                                                  cse_courses =
                                                                      get_courses(
                                                                          dropdownvalue_branch,
                                                                          dropdownvalue_semester);
                                                                  enable_Course =
                                                                      true;
                                                                  enable_manual_course_name =
                                                                      false;
                                                                  validate_course_name =
                                                                      false;
                                                                } else {
                                                                  enable_manual_course_name =
                                                                      true;
                                                                  enable_Course =
                                                                      false;
                                                                }
                                                                enable_section =
                                                                    false;
                                                              });
                                                            })))),
                                      ],
                                    ),
                                  ),

                                  // Cycle Selection
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Current Cycle:",
                                          style: font_details(),
                                        ),

                                        // options
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 50),
                                            child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                            value:
                                                                current_cycle,
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),
                                                            // Items from the array
                                                            items: [
                                                              'Even',
                                                              "Odd"
                                                            ].map((String s) {
                                                              return DropdownMenuItem(
                                                                  value: s,
                                                                  child:
                                                                      Text(s));
                                                            }).toList(),
                                                            onChanged: (String?
                                                                newVal) {
                                                              current_cycle =
                                                                  newVal!;
                                                              setState(() {
                                                                check(
                                                                    current_cycle);

                                                                // Dropdown for CSE
                                                                if (dropdownvalue_branch ==
                                                                    "CSE") {
                                                                  cse_courses =
                                                                      get_courses(
                                                                          dropdownvalue_branch,
                                                                          dropdownvalue_semester);
                                                                }
                                                              });
                                                            })))),
                                      ],
                                    ),
                                  ),

                                  // Semester Selection
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Select Semester:",
                                          style: font_details(),
                                        ),

                                        // options
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 30),
                                            child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                            value:
                                                                dropdownvalue_semester,
                                                            icon: const Icon(Icons
                                                                .keyboard_arrow_down),

                                                            // Items from the array
                                                            items: sem
                                                                .map((int s) {
                                                              return DropdownMenuItem(
                                                                  value: s,
                                                                  child: Text(
                                                                      "$s"));
                                                            }).toList(),

                                                            //
                                                            onChanged:
                                                                (int? newVal) {
                                                              setState(() {
                                                                dropdownvalue_semester =
                                                                    newVal!;
                                                                if (dropdownvalue_branch != "CSIOT" ||
                                                                    dropdownvalue_branch !=
                                                                        "AIDS" ||
                                                                    dropdownvalue_branch !=
                                                                        "CSDS") {
                                                                  select_sections(
                                                                      dropdownvalue_branch,
                                                                      current_cycle);
                                                                }

                                                                //Extracting section
                                                                section = sections[
                                                                    '$dropdownvalue_semester'];

                                                                enable_section =
                                                                    newVal !=
                                                                        null;

                                                                if (dropdownvalue_branch ==
                                                                    "CSE") {
                                                                  cse_courses =
                                                                      get_courses(
                                                                          dropdownvalue_branch,
                                                                          dropdownvalue_semester);
                                                                }
                                                              });
                                                            })))),
                                      ],
                                    ),
                                  ),

                                  // Section Selection
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Select Section:",
                                          style: font_details(),
                                        ),

                                        // options
                                        Padding(
                                            padding:
                                                const EdgeInsets.only(left: 44),
                                            child: Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.white,
                                                ),
                                                padding: EdgeInsets.all(10),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                  value: dropdownvalue_section,
                                                  icon: const Icon(Icons
                                                      .keyboard_arrow_down),
                                                  // Items from the array
                                                  items:
                                                      section.map((String s) {
                                                    return DropdownMenuItem(
                                                        value: s,
                                                        child: Text(s));
                                                  }).toList(),

                                                  //
                                                  onChanged: enable_section
                                                      ? (String? newVal) {
                                                          setState(() {
                                                            dropdownvalue_section =
                                                                newVal!;
                                                            enable_Course =
                                                                newVal != null;
                                                          });
                                                        }
                                                      : null,
                                                )))),
                                      ],
                                    ),
                                  ),

                                  // Course Selection
                                  if (dropdownvalue_branch == "CSE")
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Course:",
                                            style: font_details(),
                                          ),

                                          // options

                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Container(
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: Colors.white,
                                                  ),
                                                  padding: EdgeInsets.all(0),
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                          child: ButtonTheme(
                                                              alignedDropdown:
                                                                  true,
                                                              child:
                                                                  DropdownButton(
                                                                value:
                                                                    dropdown_course,
                                                                icon: const Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down),
                                                                // Items from the array
                                                                items: cse_courses
                                                                    .map((String
                                                                        s) {
                                                                  return DropdownMenuItem(
                                                                      value: s,
                                                                      child: Row(
                                                                          children: [
                                                                            const SingleChildScrollView(
                                                                              scrollDirection: Axis.horizontal,
                                                                            ),
                                                                            // fit: BoxFit.contain,
                                                                            // MediaQuery.of(context)
                                                                            //         .size
                                                                            //         .width -
                                                                            // width: 160,

                                                                            SizedBox(
                                                                              width: 160,
                                                                              child: Text(
                                                                                s,
                                                                              ),
                                                                            ),
                                                                          ]));
                                                                }).toList(),

                                                                //
                                                                onChanged:
                                                                    enable_Course
                                                                        ? (String?
                                                                            newVal) {
                                                                            setState(() {
                                                                              dropdown_course = newVal!;
                                                                              print(dropdown_course);
                                                                            });
                                                                          }
                                                                        : null,
                                                              ))))),
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
                                  InfoPopupWidget(
                                    contentTitle: "Already Exists",
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromRGBO(184, 163, 255, 1),
                                          foregroundColor:
                                              Colors.black, // Black text
                                        ),
                                        onPressed: () {
                                          // Validating Part
                                          validate_course_name =
                                              course_name.text.isEmpty;
                                          validate_course_code =
                                              course_code.text.isEmpty;
                                          validate_classes_held =
                                              classes_held.text.isEmpty;

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

                                            if (!check_duplicates(
                                                add_course_code,
                                                sem_sec_branch,
                                                Course_Code,
                                                sections_branch_list)) {
                                              Course_Names.add(
                                                  Store_Course_Name);
                                              Course_Code.add(
                                                  Store_Course_Code);
                                              classesHeld.add(
                                                  "Classes Held: ${classes_held.text.toString()}");

                                              sections_branch_list.add(
                                                  "$dropdownvalue_semester$dropdownvalue_section | $dropdownvalue_branch");

                                              // Adding Data to firebase
                                              // add_course_data("");
                                              add_Teachers_data(1);
                                              // Navigating
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Teacher_Home_Page(),
                                                  ));
                                            } else {
                                              // Text(
                                              //   "Course Already Exists!!",
                                              //   style: TextStyle(fontSize: 10, color: Colors.red),
                                              // );
                                              print("D");
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

                                            if (!check_duplicates(
                                                addCourseCode,
                                                semSecBranch,
                                                Course_Code,
                                                sections_branch_list)) {
                                              Course_Names.add(dropdown_course);
                                              Course_Code.add(addCourseCode);
                                              classesHeld.add(
                                                  "Classes Held: ${classes_held.text.toString()}");

                                              sections_branch_list.add(
                                                  "$dropdownvalue_semester$dropdownvalue_section | $dropdownvalue_branch");

                                              // Adding Data to firebase
                                              // add_course_data("");
                                              add_Teachers_data(1);

                                              widget.controller.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.ease);
                                            } else {
                                              print("D");
                                            }
                                          }

                                          // print(Course_Names);
                                          // print(Course_Code);
                                          // print(sections_branch_list);
                                          // print(classesHeld);

                                          setState(() {});

                                          // if (!validate_classes_held &&
                                          //     !validate_course_code &&
                                          //     !validate_course_name) {
                                          //   Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //         builder: (context) => MyApp(),
                                          //       ));
                                          // }
                                          setState(() {});
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
                                  )
                                ],
                              ),
                            ),
                          ]))))
        ]));
  }
}

// class Get_Course_Drop_Down extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return;
//   }
// }

// Separate Widgets of Course Details
class Get_Course_Name extends StatelessWidget {
  const Get_Course_Name({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Course Name:",
            style: font_details(),
          ),
          Container(
            margin: const EdgeInsets.only(left: 23),
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(radius_12()),
              color: Colors.white60,
            ),
            child: TextField(
              enabled: enable_manual_course_name,
              // Extracting course name from the text field
              controller: course_name,

              // Restriction to alphabets
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]+$')),
              ],

              decoration: InputDecoration(
                  hintText: "Enter Course Name..",
                  errorText:
                      validate_course_name ? "Field cannot be empty" : null,
                  // Initial border
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(radius_12()),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )),

                  // After selecting
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(radius_12()),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.purple,
                      ))),
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
        padding: const EdgeInsets.only(top: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Text(
            "Course Code:",
            style: font_details(),
          ),
          Container(
            margin: const EdgeInsets.only(left: 27),
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(radius_12()),
              color: Colors.white60,
            ),
            child: TextField(
              // obscureText: flag,
              // obscuringCharacter: "*",

              // Extracting course code
              controller: course_code,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z ]+$'))
              ],

              decoration: InputDecoration(

                  // Password Visibility

                  // suffixIcon: InkWell(
                  //     child: Icon(Icons.remove_red_eye),
                  //     onTap: () {
                  //       if (c % 2 == 0) {
                  //         c++;
                  //         flag = false;
                  //         setState(() {});
                  //       }
                  //       else {
                  //         c++;
                  //         flag = true;
                  //         setState(() {});
                  //       }
                  //     }),
                  hintText: "Enter Course Code..",
                  errorText:
                      validate_course_code ? "Field cannot be empty" : null,
                  // Initial border
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(radius_12()),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )),

                  // Border after selecting
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(radius_12()),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.purple,
                      ))),
            ),
          ),
        ]));
  }
}

class Get_Classes_Held extends StatelessWidget {
  const Get_Classes_Held({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Classes Held:",
            style: font_details(),
          ),
          //
          Container(
            margin: const EdgeInsets.only(left: 23),
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(radius_12()),
              color: Colors.white60,
            ),
            child: TextField(
              // Extracting course name from the text field
              controller: classes_held,

              // Restriction to alphabets
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,

              decoration: InputDecoration(
                  hintText: "Enter number of classes held..",
                  errorText:
                      validate_classes_held ? "Field cannot be empty" : null,
                  // Initial border
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(radius_12()),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      )),

                  // After selecting
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(radius_12()),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.purple,
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}
