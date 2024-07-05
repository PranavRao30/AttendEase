import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:attend_ease/ui_components/util.dart';
String searchUUID = "";
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
    String stud_attendance_id = '${formattedDate}_${searchUUID.toLowerCase()}_14';

    regions.add(Region(identifier: 'AltBeacon Region'));

    _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) async {
      if (result.beacons.isNotEmpty) {
        setState(() {
          genratedUUID = result.beacons.first.proximityUUID;
        });

        for (var beacon in result.beacons) {
          if (beacon.proximityUUID.toLowerCase() == searchUUID && beacon.accuracy <= 10) {
            print('Beacon detected: ${beacon.proximityUUID} - ${beacon.accuracy} meters away');

            DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Attendance").doc(stud_attendance_id).get();
            List<dynamic> attendees_list = documentSnapshot.exists
                ? List<String>.from(documentSnapshot["Attendees"])
                : [];

            if (!attendees_list.contains(emailName)) {
              attendees_list.add(emailName);
              await FirebaseFirestore.instance
                  .collection("Attendance")
                  .doc(stud_attendance_id)
                  .update({"Attendees": attendees_list});
              update_A_P(attendees_list);
              
              print("Updated attendees list: $attendees_list");
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
