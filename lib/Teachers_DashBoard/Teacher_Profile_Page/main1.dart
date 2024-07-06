import 'package:attend_ease/Backend/add_data.dart';
import 'package:attend_ease/Teachers_DashBoard/Teacher_Profile_Page/page/editable_page.dart';
import 'page/editable_page.dart';
import 'widget/tabbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';



// Future main() async {/
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   runApp(Teacher_Profile_Table());
// }

class Teacher_Profile_Table extends StatelessWidget {
  static final String title = 'Data Table';
  // final String courseid;

  // Teacher_Profile_Table({required this.courseid});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}
String courseID="";
void get_courseid(var temp){
  
  courseID=temp;
  print("Inside get course0 $courseID");
  initializecourse_id(courseID);
  print("Inside get course0 $courseID");
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
        title: Text('Data Table'),
      ),
      body: TabBarWidget(
        title: 'Data Table',
        tabs: [
          Tab(icon: Icon(Icons.edit), text: 'Editable'),
        ],
        children: [
          EditablePage(courseID),
        ],
      ),
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
      ),
    );
  }
}
