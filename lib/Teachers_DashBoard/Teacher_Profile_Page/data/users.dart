// import '../model/user.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';



// final allUsers = <User1>[
//   // User1(
//   //     slno: 1,
//   //     firstName: "PPPP",
//   //     total_attended: 20,
//   //     total_conducted: 20,
//   //     percentage: 100),
// ];

// add_profile_details() async {
//   var get_data, students_list, count = 0, doc1;
//   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//       .collection("Courses")
//       .doc("e51038fb-93de-4d25-ad04-f8c8cd5d6c0b")
//       .get();

//   if (documentSnapshot.exists) get_data = documentSnapshot.data();

//   // Accessing students_list from courses collection
//   students_list = List<String>.from(get_data["Student_list"]);
//   allUsers?.clear();
//   for (var docid in students_list) {
//     count++;
//     // To get details of that particular Course.
//     DocumentSnapshot documentSnapshot1 = await FirebaseFirestore.instance
//         .collection("Students")
//         .doc(docid)
//         .get();

//     if (documentSnapshot1.exists) {
//       doc1 = documentSnapshot1.data();
//       if (allUsers.isEmpty) {
//         allUsers.add(User1(
//             slno: count,
//             firstName: doc1['student_name'],
//             total_attended: 20,
//             total_conducted: 20,
//             percentage: 100));
//       }
//     }
//   }
// }


// User(firstName: 'Max', lastName: 'Stone', age: 27),
//   User(firstName: 'Sarah', lastName: 'Winter', age: 20),
//   User(firstName: 'James', lastName: 'Summer', age: 21),
//   User(firstName: 'Lorita', lastName: 'Wilcher', age: 18),
//   User(firstName: 'Anton', lastName: 'Wilbur', age: 32),
//   User(firstName: 'Salina', lastName: 'Monsour', age: 24),
//   User(firstName: 'Sunday', lastName: 'Salem', age: 42),
//   User(firstName: 'Alva', lastName: 'Cowen', age: 47),
//   User(firstName: 'Jonah', lastName: 'Lintz', age: 18),
//   User(firstName: 'Kimberley', lastName: 'Kelson', age: 33),
//   User(firstName: 'Waldo', lastName: 'Cybart', age: 19),
//   User(firstName: 'Garret', lastName: 'Hoffmann', age: 27),
//   User(firstName: 'Margaret', lastName: 'Yarger', age: 25),
//   User(firstName: 'Foster', lastName: 'Lamp', age: 53),
//   User(firstName: 'Samuel', lastName: 'Testa', age: 58),
//   User(firstName: 'Sam', lastName: 'Schug', age: 44),
//   User(firstName: 'Alise', lastName: 'Bryden', age: 41),