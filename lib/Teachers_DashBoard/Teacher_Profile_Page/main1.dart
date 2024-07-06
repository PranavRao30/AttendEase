import 'package:attend_ease/Teachers_DashBoard/Teacher_Profile_Page/page/editable_page.dart';
import 'page/editable_page.dart';
import 'widget/tabbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';



// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   runApp(Teacher_Profile_Table());
// }

class Teacher_Profile_Table extends StatelessWidget {
  static final String title = 'Data Table';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => TabBarWidget(
        title: 'Data Table',
        tabs: [
          Tab(icon: Icon(Icons.edit), text: 'Editable'),
          Tab(icon: Icon(Icons.sort_by_alpha), text: 'Sortable'),
          Tab(icon: Icon(Icons.select_all), text: 'Selectable'),
        ],
        children: [
          EditablePage(),
          Container(),
          Container(),
        ],
      );
}
