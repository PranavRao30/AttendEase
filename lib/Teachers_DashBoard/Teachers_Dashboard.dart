import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attend_ease/Teachers_DashBoard/Add_Subject.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

void main() {
  runApp(const Teachers_Dashboard());
}

var flag = 0;
// Variables
var Course_Names = [];

var Course_Code = [];

var classesHeld = [];

var sections_branch_list = [];

class Teachers_Dashboard extends StatelessWidget {
  const Teachers_Dashboard({super.key});

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

class Teacher_Home_Page extends StatelessWidget {
  const Teacher_Home_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(184, 163, 255, 0.1),
      body: Column(children: [
        const SizedBox(height: 25),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
              "Your Courses",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  print("Pressed Card");
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(184, 163, 255, 1),
                        offset: Offset(6, 6),
                        blurRadius: 0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      side: BorderSide(
                        color: Color.fromRGBO(215, 196, 223, 1),
                        width: 2.0,
                      ),
                    ),
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              Course_Names[index],
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
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
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: Course_Names.length,
          ),
        ),
      ]),
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
  final PageController _pageController = PageController(initialPage: 1);

  final List<Widget> _screens = [
    add_a_subject(),
    Teacher_Home_Page(),
    ProfileScreen(), // Make sure to define ProfileScreen or any other screen you intend to navigate to
  ];

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
        color: Color.fromRGBO(184, 163, 255, 1), // Background color of the bottom navigation bar.
        buttonBackgroundColor: const Color.fromRGBO(
            184, 163, 255, 0), // Background color of the active item.
        backgroundColor: const Color.fromRGBO(
            184, 163, 255, 0.1), // Background color of the navigation bar.
        animationDuration: Duration(
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
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            ); // Animate to the selected page.
          });
        },
      ),
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
        child: const Text('Profile Screen'),
      ),
    );
  }
}
