import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:async';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';
import 'package:attend_ease/Backend/fetch_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attend_ease/ui_components/util.dart';
import 'package:intl/intl.dart';
import "dart:ui" as ui;

String genratedUUID = "";
ValueNotifier<bool> util_flag = ValueNotifier(false);

String? stud_attendance_id;

// ignore: must_be_immutable
class Broadcast_Land extends StatelessWidget {
  String text;
  Broadcast_Land(this.text) {
    genratedUUID = text;
    print("GEN$genratedUUID");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    DateFormat format = DateFormat("HH");
    String hour = format.format(now);
    stud_attendance_id =
        '${formattedDate}_${genratedUUID.toLowerCase()}_${hour}';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GlowingButtonPage(),
      ),
    );
  }
}

class GlowingButtonPage extends StatefulWidget {
  @override
  _GlowingButtonPageState createState() => _GlowingButtonPageState();
}

class _GlowingButtonPageState extends State<GlowingButtonPage> {
  // copy of list
  List<get_table> _data = [];
  List<get_table> Students_data = [];
  // Initialize _data as an empty list

  @override
  void initState() {
    super.initState();
    get_table_data();

    setState(() {
      _data = Students_data;
    });
  }

  void get_table_data() async {
    // Getting Students details on table
    int slno = 1;
    var get_data;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Courses")
        .doc(genratedUUID)
        .get();

    if (documentSnapshot.exists) get_data = documentSnapshot.data();

    // Accessing students_list from courses collection
    students_list = List<String>.from(get_data["Student_list"]);
    Students_data.clear();

    for (var docid in students_list) {
      // To get details of that particular Course.
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("Students")
          .doc(docid)
          .get();
      var get_data;
      if (documentSnapshot.exists) {
        get_data = documentSnapshot.data();
        print("RECEIVER NAME ${get_data["student_name"]}");

        // First Adding
        if (Students_data.isEmpty) {
          Students_data.add(
            get_table(
                slno: 1,
                name: get_data["student_name"],
                Present: "A",
                Email_ID: "${get_data['student_id']}"),
          );
        }

        // Next entries
        else {
          if (!Students_data.contains(get_data["student_name"])) {
            slno++;
            Students_data.add(
              get_table(
                  slno: slno,
                  name: get_data["student_name"],
                  Present: "A",
                  Email_ID: "${get_data['student_id']}"),
            );
          }
        }
        print(Students_data[0].Email_ID);

        initTemp(Students_data);
      }
    }

    setState(() {
      _data = List.from(Students_data);
    });
  }

  bool is_sort = true;
  bool _isGlowing = false;
  Timer? _glowTimer;

  void _startGlow() {
    setState(() {
      _isGlowing = true;
    });

    // Stop the glow after 10 seconds
    _glowTimer?.cancel();
    _glowTimer = Timer(Duration(seconds: 10), () {
      setState(() {
        _isGlowing = false;
      });
    });
  }

  @override
  void dispose() {
    _glowTimer?.cancel();
    super.dispose();
  }

// Display Attendance Status
  void displayAttendanceStatus(BuildContext context) {
    final snackbar = SnackBar(
      content: Text("Attendance Taken Successfully!!"),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
          label: "Ok",
          onPressed: () {
            print("Attendance Taken Successfully!!");
          }),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void retakeAttendanceStatus(BuildContext context) {
    final snackbar = SnackBar(
      content: Text("Attendance Already Taken."),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
          label: "Ok",
          onPressed: () {
            print("Attendance Already Taken");
          }),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  bool retake_attendance_flag = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // title: Text('Glowing Button Page'),
            ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80), // Adjust the height to move the button down
              Center(
                child: AvatarGlow(
                  key: UniqueKey(),
                  child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(180, 193, 95, 240),
                      child: IconButton(
                          icon: Icon(Icons.add,
                              color: const Color.fromARGB(255, 255, 206, 248)),
                          onPressed: () async {
                            print(stud_attendance_id);
                            // CREATING ATTENDANCE COLLECTION
                            DocumentSnapshot documentSnapshot0 =
                                await FirebaseFirestore.instance
                                    .collection("Attendance")
                                    .doc(stud_attendance_id)
                                    .get();
                            if (!documentSnapshot0.exists) {
                              creating_attendance_collection(genratedUUID);

                              Timer(Duration(seconds: 2), () async {
                                DocumentSnapshot documentSnapshot0 =
                                    await FirebaseFirestore.instance
                                        .collection("Attendance")
                                        .doc(stud_attendance_id)
                                        .get();
                                var stud_attendance;
                                if (documentSnapshot0.exists) {
                                  stud_attendance = documentSnapshot0.data();
                                }

                                if (stud_attendance["Attendance_Status"] ==
                                    true) {
                                  retakeAttendanceStatus(context);
                                } else {
                                  _startGlow();
                                  await FlutterBluePlus.turnOn();
                                  await requestPermissions();
                                  await startBeaconBroadcast();
                                  print("Button Pressed");


                                  Timer(Duration(seconds: 30), () async {
                                    await FirebaseFirestore.instance
                                        .collection("Attendance")
                                        .doc(stud_attendance_id)
                                        .update({"Attendance_Status": true});

                                    DocumentSnapshot documentSnapshot =
                                        await FirebaseFirestore.instance
                                            .collection("Attendance")
                                            .doc(stud_attendance_id)
                                            .get();

                                    List<dynamic> after_update_attend_list =
                                        documentSnapshot.exists
                                            ? List<String>.from(
                                                documentSnapshot["Attendees"])
                                            : [];
                                    for (int i = 0;
                                        i < after_update_attend_list.length;
                                        i++) {
                                      for (int j = 0;
                                          j < Students_data.length;
                                          j++) {
                                        if (Students_data[j].Email_ID ==
                                            after_update_attend_list[i]) {
                                          Students_data[j].Present = "P";

                                          print(Students_data[j]);
                                        }
                                      }
                                    }

                                    setState(() {
                                      _data = Students_data;
                                    });

                                    Timer(Duration(seconds: 2), () async {
                                      DocumentSnapshot documentSnapshot =
                                          await FirebaseFirestore.instance
                                              .collection("Attendance")
                                              .doc(stud_attendance_id)
                                              .get();
                                      if (documentSnapshot[
                                              "Attendance_Status"] ==
                                          true) {
                                        // retake_attendance_flag = true;
                                        displayAttendanceStatus(context);
                                      }
                                    });
                                  });

                                  // getting course collection
                                  var get_data1;
                                  DocumentSnapshot documentSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection("Courses")
                                          .doc(genratedUUID)
                                          .get();

                                  if (documentSnapshot.exists)
                                    get_data1 = documentSnapshot.data();

                                  // Accessing the class held variable from Courses collection
                                  int total_class_held =
                                      int.parse(get_data1['Classes_Held']);

                                  // Accessing students_list from courses collection
                                  students_list = List<String>.from(
                                      get_data1["Student_list"]);
                                  for (int i = 0;
                                      i < students_list.length;
                                      i++) {
                                    DocumentSnapshot documentSnapshot1 =
                                        await FirebaseFirestore.instance
                                            .collection("Students")
                                            .doc(students_list[i])
                                            .get();
                                    var stud_data = documentSnapshot1.data()
                                        as Map<String, dynamic>?;

                                    if (documentSnapshot1.exists &&
                                        stud_data != null) {
                                      Map<String, dynamic> Attend_Map =
                                          Map.from(
                                              stud_data["Attendance_data"] ??
                                                  {});

                                      Attend_Map[genratedUUID][1] =
                                          total_class_held + 1;
                                      print(
                                          "Attendance data ${Attend_Map[genratedUUID]}");

                                      await FirebaseFirestore.instance
                                          .collection("Students")
                                          .doc(students_list[i])
                                          .update(
                                              {"Attendance_data": Attend_Map});

                                      await FirebaseFirestore.instance
                                          .collection("Courses")
                                          .doc(genratedUUID)
                                          .update({
                                        "Classes_Held": Attend_Map[genratedUUID]
                                                [1]
                                            .toString()
                                      });
                                    }
                                  }
                                }
                              });
                            } else {
                              var stud_attendance;
                              if (documentSnapshot0.exists) {
                                stud_attendance = documentSnapshot0.data();
                              }

                              if (stud_attendance["Attendance_Status"] ==
                                  true) {
                                retakeAttendanceStatus(context);
                              } else {
                                _startGlow();
                                await FlutterBluePlus.turnOn();
                                await requestPermissions();
                                await startBeaconBroadcast();
                                print("Button Pressed");

                                

                                Timer(Duration(seconds: 30), () async {
                                  await FirebaseFirestore.instance
                                      .collection("Attendance")
                                      .doc(stud_attendance_id)
                                      .update({"Attendance_Status": true});

                                  DocumentSnapshot documentSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection("Attendance")
                                          .doc(stud_attendance_id)
                                          .get();

                                  List<dynamic> after_update_attend_list =
                                      documentSnapshot.exists
                                          ? List<String>.from(
                                              documentSnapshot["Attendees"])
                                          : [];

                                  for (int i = 0;
                                      i < after_update_attend_list.length;
                                      i++) {
                                    for (int j = 0;
                                        j < Students_data.length;
                                        j++) {
                                      if (Students_data[j].Email_ID ==
                                          after_update_attend_list[i]) {
                                        Students_data[j].Present = "P";
                                        print(Students_data[j].Email_ID);
                                      }
                                    }
                                  }

                                  setState(() {
                                    _data = Students_data;
                                  });

                                  Timer(Duration(seconds: 2), () async {
                                    DocumentSnapshot documentSnapshot =
                                        await FirebaseFirestore.instance
                                            .collection("Attendance")
                                            .doc(stud_attendance_id)
                                            .get();
                                    if (documentSnapshot["Attendance_Status"] ==
                                        true) {
                                      // retake_attendance_flag = true;
                                      displayAttendanceStatus(context);
                                    }
                                  });
                                });

                                // getting course collection
                                var get_data1;
                                DocumentSnapshot documentSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection("Courses")
                                        .doc(genratedUUID)
                                        .get();

                                if (documentSnapshot.exists)
                                  get_data1 = documentSnapshot.data();

                                // Accessing the class held variable from Courses collection
                                int total_class_held =
                                    int.parse(get_data1['Classes_Held']);

                                // Accessing students_list from courses collection
                                students_list = List<String>.from(
                                    get_data1["Student_list"]);
                                for (int i = 0; i < students_list.length; i++) {
                                  DocumentSnapshot documentSnapshot1 =
                                      await FirebaseFirestore.instance
                                          .collection("Students")
                                          .doc(students_list[i])
                                          .get();
                                  var stud_data = documentSnapshot1.data()
                                      as Map<String, dynamic>?;

                                  if (documentSnapshot1.exists &&
                                      stud_data != null) {
                                    Map<String, dynamic> Attend_Map = Map.from(
                                        stud_data["Attendance_data"] ?? {});

                                    Attend_Map[genratedUUID][1] =
                                        total_class_held + 1;
                                    print(
                                        "Attendance data ${Attend_Map[genratedUUID]}");

                                    await FirebaseFirestore.instance
                                        .collection("Students")
                                        .doc(students_list[i])
                                        .update(
                                            {"Attendance_data": Attend_Map});

                                    await FirebaseFirestore.instance
                                        .collection("Courses")
                                        .doc(genratedUUID)
                                        .update({
                                      "Classes_Held":
                                          Attend_Map[genratedUUID][1].toString()
                                    });
                                  }
                                }
                              }
                            }
                          }),
                      radius: 40.0,
                    ),
                  ),
                  glowCount: 3,
                  glowColor: Color.fromARGB(255, 210, 141, 241),
                  glowShape: BoxShape.circle,
                  duration: Duration(milliseconds: 1500),
                  startDelay: Duration(milliseconds: 500),
                  animate: _isGlowing,
                  repeat: _isGlowing,
                  curve: Curves.easeInOut,
                  glowRadiusFactor: 0.8,
                ),
              ),
              SizedBox(height: 80),
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Card(
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "UUID:\n" + genratedUUID,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            )),
                        SizedBox(height: 5),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              columns: _createColumns(), rows: _createRows()),
                        ),
                        ElevatedButton(
                          child: Text('Go Back'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Teachers_Dashboard()));
                          },
                        ),
                      ]))
            ],
          ),
        ));
  }

  List<DataRow> _createRows() {
    return _data.map((e) {
      return DataRow(
        cells: [
          DataCell(Text(e.slno.toString())),
          DataCell(Text(e.name)),
          DataCell(
            InkWell(
             onTap: () async {
  String newStatus = e.Present == 'P' ? 'A' : 'P';

  DocumentSnapshot documentSnapshot1 = await FirebaseFirestore
      .instance
      .collection("Students")
      .doc(e.Email_ID)
      .get();


   var stud_data = documentSnapshot1.data()
                                      as Map<String, dynamic>?;

                                  if (documentSnapshot1.exists &&
                                      stud_data != null) {
                                    Map<String, dynamic> Attend_Map = Map.from(
                                        stud_data["Attendance_data"] ?? {});

    // Check if Attend_Map[genratedUUID] is null and initialize if necessary
    if (Attend_Map[genratedUUID] == null) {
      
      Attend_Map[genratedUUID] = [0];
    }
    DocumentSnapshot documentSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection("Attendance")
                                          .doc(stud_attendance_id)
                                          .get();

                                  List<dynamic> after_update_attend_list =
                                      documentSnapshot.exists
                                          ? List<String>.from(
                                              documentSnapshot["Attendees"])
                                          : [];


    if (newStatus == 'P') {
      Attend_Map[genratedUUID][0] += 1;
      after_update_attend_list.add(e.Email_ID);
    } else if (newStatus == 'A') {
      Attend_Map[genratedUUID][0] -= 1;
      after_update_attend_list.remove(e.Email_ID);
    }

    await FirebaseFirestore.instance
        .collection("Attendance")
        .doc(stud_attendance_id)
        .update({"Attendees":after_update_attend_list});

    await FirebaseFirestore.instance
        .collection("Students")
        .doc(e.Email_ID)
        .update({"Attendance_data": Attend_Map});
  }

  setState(() {
    e.Present = newStatus;
  });
},
child: Container(
  padding: EdgeInsets.all(16.0), // Adjust the padding as needed
  child: Text(
    e.Present,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0, // Increase the font size
      color: e.Present == 'P' ? Colors.lightGreen : Colors.red[400],
    ),
  ),
),


            ),
          ),
          DataCell(Text(e.Email_ID)),
        ],
        // onSelectChanged: (_) => toggleStatus(e.Present),
      );
    }).toList();
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text("Sl no")),
      DataColumn(
        label: Text("Name"),
        onSort: (columnIndex, _) {
          setState(() {
            if (is_sort) {
              _data.sort(
                (a, b) => a.name.compareTo(b.name),
              );
            } else {
              _data.sort(
                (a, b) => b.name.compareTo(a.name),
              );
            }

            is_sort = !is_sort;
          });
        },
      ),
      DataColumn(
        label: Text("Present"),
        onSort: (columnIndex, _) {
          setState(() {
            if (is_sort) {
              _data.sort(
                (a, b) => a.Present.compareTo(b.Present),
              );
            } else {
              _data.sort(
                (a, b) => b.Present.compareTo(a.Present),
              );
            }

            is_sort = !is_sort;
          });
        },
      ),
      DataColumn(label: Text("Email ID")),
    ];
  }
}

Future<void> requestPermissions() async {
  await [
    Permission.bluetooth,
    Permission.bluetoothAdvertise,
  ].request();
}

Future<void> startBeaconBroadcast() async {
  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  // Set UUID, major, and minor values for the beacon
  beaconBroadcast
      .setUUID(genratedUUID)
      .setMajorId(100)
      .setMinorId(1)
      .setTransmissionPower(-59)
      .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24');

  // Check if the device supports beacon transmission
  BeaconStatus transmissionSupportStatus =
      await beaconBroadcast.checkTransmissionSupported();
  switch (transmissionSupportStatus) {
    case BeaconStatus.supported:
      // You're good to go, you can advertise as a beacon
      // Start broadcasting the beacon signal
      beaconBroadcast.start();
      // Listen for broadcasting state changes
      beaconBroadcast.getAdvertisingStateChange().listen((isAdvertising) {
        if (isAdvertising) {
          print('Beacon broadcasting started.');
        } else {
          print('Beacon broadcasting stopped.');
        }
      });
      break;

    case BeaconStatus.notSupportedMinSdk:
      // Your Android system version is too low (min. is 21)
      print('Android system version is too low. Minimum SDK version is 21.');
      break;
    case BeaconStatus.notSupportedBle:
      // Your device doesn't support BLE
      print('Device doesn\'t support BLE.');
      break;
    case BeaconStatus.notSupportedCannotGetAdvertiser:
      // Either your chipset or driver is incompatible
      print('Chipset or driver is incompatible.');
      break;
  }
  Timer(Duration(seconds: 30), () {
    beaconBroadcast.stop();
    print('Beacon broadcasting stopped after 10 seconds.');
  });
}
