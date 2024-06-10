import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:attend_ease/Sign_in/Sign_In.dart';

var email = emailName.toString();
var add_map = {"id": email, "email": email, "Name": userName.toString()};
add_data() {
  FirebaseFirestore.instance
      .collection("Teachers")
      .doc("${email}")
      .set(add_map)
      .then((value) => print("data inserted"));
}
