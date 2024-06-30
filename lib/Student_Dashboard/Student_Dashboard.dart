import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:attend_ease/gradient_container.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(184, 163, 255, 1),
        ),
        useMaterial3: true,
      ),
      home: BottomNavigationExample(),
    );
  }
}

class BottomNavigationExample extends StatefulWidget {
  @override
  _BottomNavigationExampleState createState() =>
      _BottomNavigationExampleState();
}

class _BottomNavigationExampleState extends State<BottomNavigationExample> {
  int _currentIndex = 1;
  late PageController _pageController;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: 1); // Initialize _pageController in initState

    _screens = [
      ProfileScreen(),
      Student_Home_Page(),
      ProfileScreen(), // Make sure to define ProfileScreen or any other screen you intend to navigate to
    ];
  }

  @override
  void dispose() {
    _pageController
        .dispose(); // Dispose _pageController when it's no longer needed
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex, // The currently selected index.
        color: Color.fromRGBO(
            184, 163, 255, 1), // Background color of the bottom navigation bar.
        buttonBackgroundColor: const Color.fromRGBO(
            184, 163, 255, 0), // Background color of the active item.
        backgroundColor: const Color.fromRGBO(
            184, 163, 255, 0.1), // Background color of the navigation bar.
        animationDuration: const Duration(
            milliseconds: 300), // Duration of animation when switching tabs.
        height: 70.0, // Height of the bottom navigation bar.
        items: const <Widget>[
          Icon(Icons.add, size: 35), // Icon for the Home tab.
          Icon(Icons.home, size: 35), // Icon for the Access Time tab.
          Icon(Icons.person, size: 35), // Icon for the Person tab.
        ],
        onTap: (index) {
          // Callback function when a tab is tapped.
          setState(() {
            _currentIndex = index; // Update the current index.
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            ); // Animate to the selected page.
          });
        },
      ),
    );
  }
}

class Student_Home_Page extends StatefulWidget {
  const Student_Home_Page({Key? key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<Student_Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Color of the home page.
      backgroundColor: const Color.fromRGBO(184, 163, 255, 0.1),

      // UI
      body: Column(children: [
        const SizedBox(
          height: 25,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 45),
          height: 70,
          width: 330,

          // Decoration
          decoration: const BoxDecoration(
              color: Color.fromRGBO(184, 163, 255, 1),
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
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            sections_branch_list[index],
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            classesHeld[index],
                                            // "Classes Held: ${attended_class[index]}/${total_class[index]}",
                                            style:
                                                const TextStyle(fontSize: 12),
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

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(184, 163, 255, 1),
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
                    color: Colors.white),
              ),
            )),
      ),
    );
  }
}