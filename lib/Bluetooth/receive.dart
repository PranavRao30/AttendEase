import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
String searchUUID="";
class BeaconPage extends StatefulWidget {

  final String text;
  BeaconPage(this.text){
    searchUUID=text;
  }

  @override
  _BeaconPageState createState() => _BeaconPageState();
}

class _BeaconPageState extends State<BeaconPage> {
  String genratedUUID="";
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
  try {
    await flutterBeacon.initializeScanning;
    await requestPermissions();
    if (!mounted) return;

    regions.add(Region(identifier: 'AltBeacon Region'));

    _streamRanging = flutterBeacon.ranging(regions).listen((RangingResult result) {
      if (result.beacons.isNotEmpty) {
        setState(() {
          genratedUUID = result.beacons.first.proximityUUID;
        });
        for (var beacon in result.beacons) {
          print('Beacon detected: ${beacon.proximityUUID} - ${beacon.accuracy} meters away');
        }
      }
    });
  } catch (e) {
    print('Error initializing beacon scanning: $e');
  }
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
            ]
          )
    );
  }
}
