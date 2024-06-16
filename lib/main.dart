import 'package:attend_ease/Sign_in/Sign_In.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:attend_ease/start_screen.dart';
import 'package:attend_ease/gradient_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAssxds3OW3obpQorBTiqDfFJv_4BXN2Vo",
          appId: "1:814534653957:android:d087e6d377e21aaa0b446c",
          messagingSenderId: "814534653957",
          projectId: "attendease-f1528"));

  const String androidClientId =
      '814534653957-sohpr687be1snd1brolorci10fs22nsg.apps.googleusercontent.com';
  const String iosClientId =
      '814534653957-ellhmoefk28i6h9klq3b7ppsdsvc8167.apps.googleusercontent.com';

  const String webClientId =
      "814534653957-2uccgqsjhg9dfuc8hro2e7q6rpm9di8d.apps.googleusercontent.com";
  runApp(
    const MyApp(
        androidClientId: androidClientId,
        iosClientId: iosClientId,
        webClientId: webClientId),
  );
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,
      required this.androidClientId,
      required this.iosClientId,
      required this.webClientId});
  final String androidClientId;
  final String iosClientId;
  final String webClientId;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(
          clientId: defaultTargetPlatform == TargetPlatform.android
              ? webClientId
              : defaultTargetPlatform == TargetPlatform.iOS
                  ? iosClientId
                  : webClientId,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Consumer<GoogleSignInProvider>(
            builder: (context, provider, _) {
              print(provider.user);
              if (provider.user != null) {
                // User is signed in
                final emailName = provider.user!.email.split('@').first;

                if (emailName.contains("cse")) {
                  return Teachers_Dashboard(); // Navigate to Teachers Dashboard
                } else {
                  // Handle other conditions or show appropriate screen
                  return Scaffold(
                    body: GradientContainerWithStartScreen(),
                  );
                }
              } else {
                // User is not signed in
                return Scaffold(
                  body: GradientContainerWithStartScreen(),
                );
              }
            },
          ),
        ),
      );
}

class GradientContainerWithStartScreen extends StatelessWidget {
  const GradientContainerWithStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GradientContainer(
      Color.fromARGB(255, 150, 120, 255),
      Color.fromARGB(255, 150, 67, 183),
      child: StartScreen(),
    );
  }
}
