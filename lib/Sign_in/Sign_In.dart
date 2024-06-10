import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:attend_ease/start_screen.dart';

var userName, emailName, email_validate;

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;

  GoogleSignInProvider({required String clientId})
      : googleSignIn = GoogleSignIn(clientId: clientId);

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Retrieve the user's details
      userName = userCredential.user!.displayName;
      emailName = userCredential.user!.email;
      // email_validate = emailName!.split('.');
      print('User name: $userName');
      print('Email: ${emailName.toString().contains("cs")}');

      notifyListeners();
    } catch (error) {
      print('Google Sign-In error: $error');
    }
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> signInSilently() async {
    try {
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signInSilently();
      if (googleUser != null) {
        _user = googleUser;
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        notifyListeners();
      }
    } catch (error) {
      print('Sign in silently failed: $error');
    }
  }
}
