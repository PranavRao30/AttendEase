import '../data/users.dart';
import '../model/user.dart';
import 'package:attend_ease/Teachers_DashBoard/Teacher_Profile_Page/utils.dart';
import 'package:attend_ease/Teachers_DashBoard/Teacher_Profile_Page/widget/scrollable_widget.dart';
import 'package:attend_ease/Teachers_DashBoard/Teacher_Profile_Page/widget/text_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditablePage extends StatefulWidget {
  @override
  _EditablePageState createState() => _EditablePageState();
}

class _EditablePageState extends State<EditablePage> {
  late List<User1> users;
  // final allUsers = <User1>[
  //   // User1(
  //   //     slno: 1,
  //   //     firstName: "PPPP",
  //   //     total_attended: 20,
  //   //     total_conducted: 20,
  //   //     percentage: 100),
  // ];

  @override
  void initState() {
    super.initState();
    users = [];
    addProfileDetails();

    // setState(() {
    //   this.users = List.of(allUsers);
    // });
  }

  Future<void> addProfileDetails() async {
    try {
      print("kj0");
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Courses")
          .doc("e51038fb-93de-4d25-ad04-f8c8cd5d6c0b")
          .get();
      print(documentSnapshot.exists);

      if (documentSnapshot.exists) {
        Map<String, dynamic>? getData =
            documentSnapshot.data() as Map<String, dynamic>?;
        if (getData != null) {
          List<String> studentsList =
              List<String>.from(getData["Student_list"]);
          int count = 0;
          List<User1> allUsers = [];

          for (String docId in studentsList) {
            count++;

            DocumentSnapshot studentSnapshot = await FirebaseFirestore.instance
                .collection("Students")
                .doc(docId)
                .get();

            if (studentSnapshot.exists) {
              print("Ad");
              Map<String, dynamic>? studentData =
                  studentSnapshot.data() as Map<String, dynamic>?;
              if (studentData != null) {
                print("RECEIVER NAME ${studentData["student_name"]}");
                allUsers.add(User1(
                  slno: count,
                  firstName: studentData['student_name'],
                  total_attended: 20,
                  total_conducted: 20,
                  percentage: 100,
                ));
              }
            }
          }

          setState(() {
            users = allUsers;
          });
        }
      }
    } catch (e) {
      print("Error fetching student details: $e");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ScrollableWidget(child: buildDataTable()),
      );

  Widget buildDataTable() {
    final columns = [
      'Sl no',
      'Student Name',
      'Total Attended',
      'Total Classes Held',
      "Eligibility"
    ];

    return DataTable(
      columns: getColumns(columns),
      rows: getRows(users),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    // mapping from columns list
    return columns.map((String column) {
      final isAge = column == columns[2];

      return DataColumn(
        // label used for text

        label: Text(column),

        // numeric used for numbers
        numeric: isAge,
      );
    }).toList();
  }

  List<DataRow> getRows(List<User1> users) => users.map((User1 user) {
        final cells = [
          user.slno,
          user.firstName,
          user.total_attended,
          user.total_conducted,
          user.percentage
        ];

        return DataRow(
          cells: Utils.modelBuilder(cells, (index, cell) {
            // Showing edit icon
            final showEditIcon = index == 1;
            // || index == 2 || index == 3;
            return DataCell(
              Text('$cell'),

              // showing edit icon
              showEditIcon: showEditIcon,
              onTap: () {
                // Looking for index
                switch (index) {
                  case 1:
                    editFirstName(user);
                    break;
                  // case 2:
                  //   edittotalattended(user);
                  //   break;
                  // case 3:
                  //   edit_total_class_held(user);
                  //   break;
                }
              },
            );
          }),
        );
      }).toList();

  Future editFirstName(User1 editUser) async {
    // getting first name
    final firstName = await showTextDialog(
      context,
      title: 'Change First Name',
      value: editUser.firstName,
    );

    setState(() => users = users.map((user) {
          // status of changing
          final isEditedUser = user == editUser;

          return isEditedUser ? user.copy(firstName: firstName) : user;
        }).toList());
  }

  // Future edittotalattended(User1 editUser) async {
  //   final total_attended = await showTextDialog(
  //     context,
  //     title: 'Change total',
  //     value: editUser.total_attended,
  //   );

  //   setState(() => users = users.map((user) {
  //         final isEditedUser = user == editUser;

  //         return isEditedUser ? user.copy(firstName: total_attended) : user;
  //       }).toList());
  // }

  // Future edit_total_class_held(User1 editUser) async {
  //   final total_class = await showTextDialog(
  //     context,
  //     title: 'Change Last Name',
  //     value: editUser.firstName,
  //   );

  //   setState(() => users = users.map((user) {
  //         final isEditedUser = user == editUser;

  //         return isEditedUser ? user.copy(firstName: lastName) : user;
  //       }).toList());
  // }
}
