import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:async';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';
import 'package:attend_ease/Backend/fetch_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attend_ease/Backend/fetch_data.dart';
import 'package:attend_ease/ui_components/util.dart';

String genratedUUID = "";
ValueNotifier<bool> util_flag = ValueNotifier(false);
// List<get_table>? Students_data = [];

// class get_table {
//   final int slno;
//   final String name;
//   final String Present;

//   get_table({
//     required this.slno,
//     required this.name,
//     required this.Present,
//   });
// }

class Broadcast_Land extends StatelessWidget {
  String text;
  Broadcast_Land(this.text) {
    genratedUUID = text;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
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
    Timer(Duration(seconds: 3), () => setState(() {}));
    
    // Add listener to util_flag
    util_flag.addListener(() {
      if (util_flag.value) {
        setState(() {
          _data = List.from(Stud_details);
        });
        util_flag.value = false; // Reset the flag after updating
      }
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
    Students_data?.clear();

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
          Students_data!.add(
            get_table(
                slno: 1,
                name: get_data["student_name"],
                Present: "A",
                Email_ID: "${get_data['student_id']}"),
          );
        }

        // Next entries
        else {
          if (!Students_data!.contains(get_data["student_name"])) {
            slno++;
            Students_data!.add(
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

  // void update_A_P(attend_stud) {
  //   for (int i = 0; i < attend_stud.length; i++) {
  //     for (int j = 0; j < Students_data.length; j++) {
  //       if (Students_data[j].Email_ID == attend_stud[i]) {
  //         Students_data[j].Present = "P";
  //       }
  //     }
  //     setState(() {});
  //   }
  // }

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
                          _startGlow();
                          await FlutterBluePlus.turnOn();
                          await requestPermissions();
                          await startBeaconBroadcast();
                          print("Button Pressed");

                          creating_attendance_collection(genratedUUID);
                          // update_A_P(["pannaga.cs22@bmsce.ac.in","pradeep.cs22@bmace.ac.in","pranavar.cs22@bmsce.ac.in"]);
                          



                        },
                      ),
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

                        //   Card(
                        //   elevation: 4.0,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(16.0),
                        //     child: Text(
                        //       genratedUUID,
                        //       style: TextStyle(fontSize: 18.0),
                        //     ),
                        //   ),
                        // ),

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
    onTap: () {
      setState(() {
        e.Present = e.Present == 'P' ? 'A' : 'P';
      });
    },
    child: Container(
      padding: EdgeInsets.all(16.0),  // Adjust the padding as needed
      child: Text(
        e.Present,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,  // Increase the font size
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
  Timer(Duration(seconds: 10), () {
    beaconBroadcast.stop();
    print('Beacon broadcasting stopped after 10 seconds.');
  });
}
