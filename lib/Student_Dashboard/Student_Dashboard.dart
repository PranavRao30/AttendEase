import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(const Student_Dashboard());
}

class Student_Dashboard extends StatelessWidget {
  const Student_Dashboard({super.key});

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
      home: const MyHomePage(
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
var total_class = [18, 22, 26, 16, 23, 26];
var attended_class = [18, 20, 23, 16, 20, 25];
var sections_branch_list = [];
// var section = "4D";
// var branch = "CSE";
// var sec_branch = section + " | " + branch;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
      ]),
    );
  }
}
