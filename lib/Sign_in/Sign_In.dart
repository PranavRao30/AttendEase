import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

var userName, emailName, emailValidate;

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;

  GoogleSignInProvider({required String clientId})
      : googleSignIn = GoogleSignIn(clientId: clientId);

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // User canceled the login

      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Retrieve the user's details
      userName = userCredential.user?.displayName;
      print(userName);
      emailName = userCredential.user?.email;
      emailValidate = emailName?.split('.');

      print('User name: $userName');
      print('Email contains "cs": ${emailName.toString().contains("cs")}');

      notifyListeners();
    } catch (error) {
      print('Google Sign-In error: $error');
    }
  }

  Future googleLogout() async {
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> signInSilently() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
      if (googleUser != null) {
        _user = googleUser;

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);

        final User? firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          userName = firebaseUser.displayName;
          emailName = firebaseUser.email;
          emailValidate = emailName?.split('.');

          print('User name: $userName');
          print('Email contains "cs": ${emailName.toString().contains("cs")}');
        }

        notifyListeners();
      }
    } catch (error) {
      print('Sign in silently failed: $error');
    }
  }
}
