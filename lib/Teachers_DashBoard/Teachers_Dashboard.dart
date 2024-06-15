import 'dart:io';
import 'package:attend_ease/Backend/fetch_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attend_ease/Teachers_DashBoard/Add_Subject.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const Teachers_Dashboard());
}

class Teachers_Dashboard extends StatelessWidget {
  const Teachers_Dashboard({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(215, 130, 255, 1),
        ),
        useMaterial3: true,
      ),
      home: const Teacher_Home_Page(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

var flag = 0;
// Variables
var Course_Names = [];

var Course_Code = [];

var classesHeld = [];

var sections_branch_list = [];
// var total_class = [18, 22, 26, 16, 23, 26];
// var attended_class = [18, 20, 23, 16, 20, 25];
// var section = "4D";
// var branch = "CSE";
// var sec_branch = section + " | " + branch;

class Teacher_Home_Page extends StatefulWidget {
  const Teacher_Home_Page({super.key, required this.title});

  final String title;

  @override
  State<Teacher_Home_Page> createState() => _MyHomePageState_Teacher();
}

class _MyHomePageState_Teacher extends State<Teacher_Home_Page> {
  @override
  Widget build(BuildContext context) {
    print(Course_Code);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Center(
            child: Text('AttendEase'),
          )),

      // Background Color of the home page.
      backgroundColor: const Color.fromRGBO(255, 246, 254, 1),

      // UI
      body: Column(children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 45),
          height: 70,
          width: 330,

          // Decoration
          decoration: const BoxDecoration(
              color: Color.fromRGBO(233, 187, 255, 1),
              // border: Border.all(width: 2, color: Colors.black),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: 3,
                  blurRadius: 11,
                  color: Color.fromRGBO(224, 210, 230, 1),
                ),
              ]),
          child: Center(
            child: Text(
              "Your Courses",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ),

        // Utilizing the remaining child space using expanded
        Expanded(
            flex: 5,
            child: ListTile(
              title: ListView.builder(
                // Dynaimic Builder
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        print("Pressed Card");
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(215, 130, 255, 1),
                              offset: Offset(6, 6),
                              blurRadius: 0),
                        ], borderRadius: BorderRadius.circular(20)),

                        // Card
                        child: Card(
                          // Border of the card and its shadow
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(
                              color: Color.fromRGBO(
                                  215, 196, 223, 1), // Border color
                              width: 2.0,
                              // Border width
                            ),
                          ),
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          // elevation: 10,

                          // columnwise arrangement of the details
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(

                                // Course Names
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      Course_Names[index],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),

                                  // Course Code
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        Course_Code[index],
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),

                                  // Section | Branch | Attended
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            sections_branch_list[index],
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            classesHeld[index],
                                            // "Classes Held: ${attended_class[index]}/${total_class[index]}",
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ));
                },
                itemCount: Course_Names.length,
              ),
            )
            // Dynamic Fetching of data using listview.builder
            ),

        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: const Color.fromRGBO(169, 36, 231, 1),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => add_a_subject()));
                  },
                  child: const Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
// Separator

// separatorBuilder: (context, index) {
//   return Divider(
//     height: 30,
//     // thickness: 0,
//     // color: Colors.red,
//   );
// },

// itemExtent: 100,

// List View

// ListView(
//   scrollDirection: Axis.horizontal,
//   children: [
//     Text(
//       "A",
//       style: TextStyle(fontSize: 50, fontWeight: FontWeight.w400),
//     ),

//     Padding(padding: EdgeInsets.all(60)),

//     Text(
//       "B",
//       style: TextStyle(fontSize: 50, fontWeight: FontWeight.w400),
//     ),

//     Padding(padding: EdgeInsets.all(60)),

//     Text(
//       "C",
//       style: TextStyle(fontSize: 50, fontWeight: FontWeight.w400),
//     ),

//     Padding(padding: EdgeInsets.fromLTRB(60)),

//     Text(
//       "D",
//       style: TextStyle(fontSize: 50, fontWeight: FontWeight.w400),
//     ),
//   ],
// )

// Columns and Rows, margin, border, inkWell,

//  SingleChildScrollView(
//     child: Column(children: [
//   SingleChildScrollVColor.fromARGB(255, 37, 36, 36)  //       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//         Container(
//             height: 140,
//             width: 300,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.black,
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),

//             // Margin
//             margin: EdgeInsets.all(35),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,

//               // <WIDGET> allows to insert all widgets
//               // <Text> means specific to Text widget.

//               children: <Widget>[
//                 Text('A', style: TextStyle(fontSize: 100)),
//                 InkWell(
//                     onTap: () {
//                       print("Pressed B");
//                     },
//                     child: Text('B', style: TextStyle(fontSize: 100))),
//                 Text('C', style: TextStyle(fontSize: 100)),
//               ],
//             )),
//         Container(
//             height: 140,
//             width: 300,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.black,
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),

//             // Margin
//             margin: EdgeInsets.all(35),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,

//               // <WIDGET> allows to insert all widgets
//               // <Text> means specific to Text widget.

//               children: <Widget>[
//                 Text('A', style: TextStyle(fontSize: 100)),
//                 InkWell(
//                     onTap: () {
//                       print("Pressed B");
//                     },
//                     child: Text('B', style: TextStyle(fontSize: 100))),
//                 Text('C', style: TextStyle(fontSize: 100)),
//               ],
//             ))
//       ])),
//   Container(
//       height: 140,
//       width: 300,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.black,
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),

//       // Margin
//       margin: EdgeInsets.all(35),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,

//         // <WIDGET> allows to insert all widgets
//         // <Text> means specific to Text widget.

//         children: <Widget>[
//           Text('A', style: TextStyle(fontSize: 100)),
//           InkWell(
//               onTap: () {
//                 print("Pressed B");
//               },
//               child: Text('B', style: TextStyle(fontSize: 100))),
//           Text('C', style: TextStyle(fontSize: 100)),
//         ],
//       )),
//   Container(
//       height: 140,
//       width: 300,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.black,
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),

//       // Margin
//       margin: EdgeInsets.all(35),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,

//         // <WIDGET> allows to insert all widgets
//         // <Text> means specific to Text widget.

//         children: <Widget>[
//           Text('A', style: TextStyle(fontSize: 100)),
//           InkWell(
//               onTap: () {
//                 print("Pressed B");
//               },
//               child: Text('B', style: TextStyle(fontSize: 100))),
//           Text('C', style: TextStyle(fontSize: 100)),
//         ],
//       )),
//   Container(
//       height: 140,
//       width: 300,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.black,
//           width: 2,
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),

//       // Margin
//       margin: EdgeInsets.all(35),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,

//         // <WIDGET> allows to insert all widgets
//         // <Text> means specific to Text widget.

//         children: <Widget>[
//           Text('A', style: TextStyle(fontSize: 100)),
//           InkWell(
//               onTap: () {
//                 print("Pressed B");
//               },
//               child: Text('B', style: TextStyle(fontSize: 100))),
//           Text('C', style: TextStyle(fontSize: 100)),
//         ],
//       )),
// ]))

// Center(
//           child: Image.asset('assets/images/f2.png',
//               width: 100, height: 100, fit: BoxFit.cover),
//         )
// );

// ElevatedButton(
//   child: Text("click me"),
//   onPressed: () {
//     print("B is pressed");
//   },
//   onLongPress: () {
//     print("LP");
//   },
// ),

// Center(
//     child: Container(
//   height: 100,
//   width: 100,
//   color: Colors.blue[400],
//   child: Center(
//     child: Text(
//       "Hello",
//       style: TextStyle(
//           fontSize: 20,
//           color: Colors.amberAccent,
//           fontWeight: FontWeight.bold,
//           backgroundColor: Colors.brown[700]),
//     ),
//   ),
// )),
