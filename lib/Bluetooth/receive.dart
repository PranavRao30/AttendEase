import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

String searchUUID = "";
ValueNotifier<bool> attend_flag = ValueNotifier(false);

class BeaconPage extends StatefulWidget {
  final String text;
  BeaconPage(this.text) {
    searchUUID = text;
  }

  @override
  _BeaconPageState createState() => _BeaconPageState();
}

class _BeaconPageState extends State<BeaconPage> {
  String genratedUUID = "";
  final regions = <Region>[];
  StreamSubscription<RangingResult>? _streamRanging;
  bool hasUpdatedAttendance = false;  // Variable to track if the function has been executed

  @override
  void initState() {
    super.initState();
    initBeacon();
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  void initBeacon() async {
    await flutterBeacon.initializeScanning;
    await requestPermissions();
    if (!mounted) return;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    DateFormat format = DateFormat("HH");
    String hour = format.format(now);
    String stud_attendance_id =
        '${formattedDate}_${searchUUID.toLowerCase()}_${hour}';

    regions.add(Region(identifier: 'AltBeacon Region'));

    _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) async {
      if (result.beacons.isNotEmpty) {
        setState(() {
          genratedUUID = result.beacons.first.proximityUUID;
        });

        for (var beacon in result.beacons) {
          if (beacon.proximityUUID.toLowerCase() == searchUUID &&
              beacon.accuracy <= 10) {
            print(
                'Beacon detected: ${beacon.proximityUUID} - ${beacon.accuracy} meters away');

            DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                .collection("Attendance")
                .doc(stud_attendance_id)
                .get();
            List<dynamic> attendees_list = documentSnapshot.exists
                ? List<String>.from(documentSnapshot["Attendees"])
                : [];

            if (!attendees_list.contains(emailName)) {
              attendees_list.add(emailName);
              await FirebaseFirestore.instance
                  .collection("Attendance")
                  .doc(stud_attendance_id)
                  .update({"Attendees": attendees_list});

              print("Updated attendees list: $attendees_list");
            }
            attend_flag.value = true;
            if (!hasUpdatedAttendance) {  // Check if the function has already been called
              update_attend_count(attend_flag.value);
              hasUpdatedAttendance = true;  // Set the flag to true after calling the function
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beacon Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 100),
          ElevatedButton(
            child: Text('Go Back'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

void update_attend_count(bool flag) async {
  if (flag) {
    DocumentSnapshot documentSnapshot1 = await FirebaseFirestore.instance
        .collection("Students")
        .doc(emailName)
        .get();
    var stud_attend_data = documentSnapshot1.data() as Map<String, dynamic>?;

    if (documentSnapshot1.exists && stud_attend_data != null) {
      Map<String, dynamic> update_attend_count =
          Map.from(stud_attend_data["Attendance_data"] ?? {});
      update_attend_count[searchUUID][0] += 1;
      await FirebaseFirestore.instance
          .collection("Students")
          .doc(emailName)
          .update({"Attendance_data": update_attend_count});
    }
  }
}
