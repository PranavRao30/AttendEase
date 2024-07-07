import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/Student_DashBoard/Add_Details.dart';
import 'package:attend_ease/Student_DashBoard/Sections_student.dart';
import 'package:attend_ease/gradient_container.dart';
import 'package:attend_ease/ui_components/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Student_Dashboard/Student_Dashboard.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AddASubject());
}

// Display duplicates
void displayAlreadyExistingMessage(BuildContext context) {
  final snackbar = SnackBar(
    content: Text(
        "You are not registered to this section, kindly check the details"),
    duration: Duration(seconds: 3),
    action: SnackBarAction(
        label: "Ok",
        onPressed: () {
          print("Student not registered");
        }),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbar);
}

class AddASubject extends StatelessWidget {
  const AddASubject({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, child) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Color.fromARGB(255, 255, 255, 255),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(215, 130, 255, 1),
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(
          title: 'Flutter Demo Home Page',
        ),
      ),
      designSize: const Size(360, 690),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var Student_Name = TextEditingController();
bool validate_Name = false;
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

bool enable_section = false;
bool enable_Course = true;

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color.fromRGBO(241, 238, 251, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      height: 70,
                      width: 330,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(184, 163, 255, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Enter your details",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Branch Selection
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Flexible(
                            flex: 2,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                "Select Branch:",
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
                                    value: dropdownvalue_branch,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
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
                                          sem = new_Arrival(
                                              dropdownvalue_branch,
                                              current_cycle);
                                        } else {
                                          check(current_cycle);
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
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                "Current Cycle:",
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
                                    value: current_cycle,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
                                    items: ['Even', "Odd"].map((String s) {
                                      return DropdownMenuItem(
                                        value: s,
                                        child: Text(s),
                                      );
                                    }).toList(),
                                    onChanged: (String? newVal) {
                                      setState(() {
                                        current_cycle = newVal!;
                                        check(current_cycle);
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
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                "Select Semester:",
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
                                    value: dropdownvalue_semester,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
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
                                          select_sections(dropdownvalue_branch,
                                              current_cycle);
                                        }

                                        // Extracting section
                                        section =
                                            sections['$dropdownvalue_semester'];
                                        enable_section = true;
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
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                "Select Section:",
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
                                    value: dropdownvalue_section,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    isExpanded: true,
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
                                              enable_section = false;
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
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () async {
                  var validate_student_join =
                      "${dropdownvalue_semester}${dropdownvalue_section}_${dropdownvalue_branch}";
                  DocumentSnapshot documentSnapshot = await FirebaseFirestore
                      .instance
                      .collection("Students_Data")
                      .doc(validate_student_join)
                      .get();

                  List<dynamic> students_list = documentSnapshot.exists
                      ? List<String>.from(documentSnapshot["student_list"])
                      : [];
                  // if (documentSnapshot.exists) {
                  //   var get_data = documentSnapshot.data();
                  //   List<dynamic> students_list =
                  //       List.from(get_data["student_list"]);
                  if (students_list.contains(emailName)) {
                    get_Students_data(dropdownvalue_branch,
                        dropdownvalue_semester, dropdownvalue_section);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Student_Dashboard()),
                    );
                  } else {
                    displayAlreadyExistingMessage(context);
                  }
                },
                child: Text(
                  "Join Class",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(184, 163, 255, 1),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 106, 106, 1),
                  foregroundColor: Colors.black, // Black text
                ),
                onPressed: () async {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  await provider.googleLogout();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GradientContainer(
                              Color.fromARGB(255, 150, 120, 255),
                              Color.fromARGB(255, 150, 67, 183),
                              child: StartScreen(),
                            )),
                  );
                },
                child: Text(
                  "LOGOUT",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
            
          ),
        ),
      ),
    );
  }
}

// Names

class Get_Name extends StatelessWidget {
  const Get_Name({super.key});

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
              width: MediaQuery.of(context).size.width *
                  0.6, // Adjust width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(radius_12()),
                color: Colors.white60,
              ),
              child: TextField(
                controller: Student_Name,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
                ],
                decoration: InputDecoration(
                  hintText: "Enter Course Code..",
                  errorText: validate_Name ? "Field cannot be empty" : null,
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
