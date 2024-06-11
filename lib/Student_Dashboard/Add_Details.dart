import 'dart:io';
import 'dart:ui';
import 'package:attend_ease/Student_DashBoard/Sections_student.dart';
import 'package:attend_ease/ui_components/util.dart';
import 'package:attend_ease/Student_DashBoard/Student_Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:info_popup/info_popup.dart';

void main() {
  runApp(const AddASubject());
}

class AddASubject extends StatelessWidget {
  const AddASubject({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(215, 130, 255, 1),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

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
  check(current_cycle) {
    if (current_cycle == "Even") {
      sem = [2, 4, 6, 8];
      dropdownvalue_semester = 2;
      setState(() {});
    }
    if (current_cycle == "Odd") {
      sem = [1, 3, 5, 7];
      dropdownvalue_semester = 1;
      setState(() {});
    }

    if ((dropdownvalue_branch == "CSIOT" ||
            dropdownvalue_branch == "AIDS" ||
            dropdownvalue_branch == "CSDS") &&
        (current_cycle == "Odd")) {
      sem = [1, 3];
      dropdownvalue_semester = 1;
      setState(() {});
    }

    if ((dropdownvalue_branch == "CSIOT" ||
            dropdownvalue_branch == "AIDS" ||
            dropdownvalue_branch == "CSDS") &&
        (current_cycle == "Even")) {
      sem = [2, 4];
      dropdownvalue_semester = 2;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Center(
              child: Text('AttendEase'),
            )),

        // Background Color of the home page.
        backgroundColor: Color.fromRGBO(255, 246, 254, 1),

        // UI
        body: Column(children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
          ),
          Container(
            width: 400,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Enter Course Details",
                  style: GoogleFonts.poppins(
                    textStyle: font25(textColor: Colors.purpleAccent),
                  ),
                ),

                // Branch Selection
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10),
                  child: Row(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Container(
                            child: Text(
                          "Select Branch:",
                          style: font_details(),
                        )),
                      ),

                      // options
                      Padding(
                          padding: EdgeInsets.only(left: 46),
                          child: Container(
                              height: 21,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      value: dropdownvalue_branch,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      // Items from the array
                                      items: branch_codes.map((String s) {
                                        return DropdownMenuItem(
                                            value: s, child: Text(s));
                                      }).toList(),

                                      //
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
                                      })))),
                    ],
                  ),
                ),

                // Cycle Selection
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Current Cycle:",
                        style: font_details(),
                      ),

                      // options
                      Padding(
                          padding: EdgeInsets.only(left: 50),
                          child: Container(
                              height: 21,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      value: current_cycle,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      // Items from the array
                                      items: ['Even', "Odd"].map((String s) {
                                        return DropdownMenuItem(
                                            value: s, child: Text(s));
                                      }).toList(),
                                      onChanged: (String? newVal) {
                                        current_cycle = newVal!;
                                        setState(() {
                                          check(current_cycle);
                                        });
                                      })))),
                    ],
                  ),
                ),

                // Semester Selection
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Select Semester:",
                        style: font_details(),
                      ),

                      // options
                      Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Container(
                              height: 21,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      value: dropdownvalue_semester,
                                      icon: Icon(Icons.keyboard_arrow_down),

                                      // Items from the array
                                      items: sem.map((int s) {
                                        return DropdownMenuItem(
                                            value: s, child: Text("$s"));
                                      }).toList(),

                                      //
                                      onChanged: (int? newVal) {
                                        setState(() {
                                          dropdownvalue_semester = newVal!;
                                          if (dropdownvalue_branch != "CSIOT" ||
                                              dropdownvalue_branch != "AIDS" ||
                                              dropdownvalue_branch != "CSDS") {
                                            select_sections(
                                                dropdownvalue_branch,
                                                current_cycle);
                                          }

                                          //Extracting section
                                          section = sections[
                                              '$dropdownvalue_semester'];

                                          enable_section = newVal != null;
                                        });
                                      })))),
                    ],
                  ),
                ),

                // Section Selection
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Select Section:",
                        style: font_details(),
                      ),

                      // options
                      Padding(
                          padding: EdgeInsets.only(left: 43),
                          child: Container(
                              height: 21,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                value: dropdownvalue_section,
                                icon: Icon(Icons.keyboard_arrow_down),
                                // Items from the array
                                items: section.map((String s) {
                                  return DropdownMenuItem(
                                      value: s, child: Text(s));
                                }).toList(),

                                //Fetching students.
                                onChanged: enable_section
                                    ? (String? newVal) {
                                        setState(() {
                                          dropdownvalue_section = newVal!;
                                          enable_section = false;
                                        });
                                      }
                                    : null,
                              )))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
