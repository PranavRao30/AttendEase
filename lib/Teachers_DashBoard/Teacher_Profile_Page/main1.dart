import 'package:flutter/material.dart';
import 'package:attend_ease/Teachers_DashBoard/Teacher_Profile_Page/page/editable_page.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';
import 'widget/tabbar_widget.dart';

class Teacher_Profile_Table extends StatelessWidget {
  static final String title = 'Data Table';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: MainPage(),
      );
}

String courseID = "";

void get_courseid(var temp) {
  courseID = temp;
  print("Inside get course0 $courseID");
  initializecourse_id(courseID);
  print("Inside get course0 $courseID");
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Attendance'),
      ),
      body: EditablePage(courseID),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Teachers_Dashboard(),
            ),
          );
        },
        child: Icon(Icons.arrow_back),
        backgroundColor:
            Color.fromRGBO(184, 163, 255, 1), // Change floating action button color
      ),
    );
  }
}
