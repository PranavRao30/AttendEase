import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'dart:async';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; 
String genratedUUID="";
class Broadcast_Land extends StatelessWidget {
  final String text;
  Broadcast_Land(this.text){
    genratedUUID=text;
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

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Glowing Button Page'),
      ),
      body: Column(
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
                    icon: Icon(Icons.add, color: const Color.fromARGB(255, 255, 206, 248)),
                    onPressed: () async {
                      _startGlow();
                      await FlutterBluePlus.turnOn();
                      await requestPermissions();
                      await startBeaconBroadcast();
                      print("Button Pressed");
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
                Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "UUID:\n"+genratedUUID,
                  style: TextStyle(fontSize: 18.0),
                ),
                )
              ),
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
            ElevatedButton(
              child: Text('Go Back'),
              onPressed: () {
              
              },
            ),
            ]
          )
        ],
      ),
    );
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
        .setTransmissionPower(-59);
      
    // Check if the device supports beacon transmission
    BeaconStatus transmissionSupportStatus = await beaconBroadcast.checkTransmissionSupported();
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


