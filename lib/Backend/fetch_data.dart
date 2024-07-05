import 'package:attend_ease/Teachers_DashBoard/Teachers_Dashboard.dart';
import 'package:attend_ease/Bluetooth/broadcast.dart';

class get_table1 {
  final int slno;
  final String name;
  String Present;
  final String email_id;

  get_table1({
    required this.slno,
    required this.name,
    required this.Present,
    required this.email_id,
  });
}

// Table
getting_students_table() async {}

List<get_table1> Students_data = [
  get_table1(
    slno: 1,
    name: "Prajwal P",
    Present: "P",
    email_id: "Asd",
  ),
  get_table1(
    slno: 2,
    name: "Pannaga R Bhat",
    Present: "A",
    email_id: "asd",
  ),
  get_table1(
    slno: 2,
    name: "Pannaga R Bhat",
    Present: "A",
    email_id: "asd",
  ),
  get_table1(
    slno: 2,
    name: "Pannaga R Bhat",
    Present: "A",
    email_id: "asd",
  ),
];
