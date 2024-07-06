import 'package:flutter/material.dart';

TextStyle font25({
  Color textColor = Colors.brown,
}) {
  return TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w500,
    color: textColor,
  );
}

TextStyle font_details() {
  return const TextStyle(fontSize: 17, fontWeight: FontWeight.w300);
}

Radius radius_12() {
  return const Radius.circular(12);
}

var Stud_details;
void initTemp(temp){
  Stud_details=temp;
}

ValueNotifier<bool> util_flag = ValueNotifier(false);
void update_A_P(attend_stud){
      for(int i=0;i<attend_stud.length;i++){
        for(int j=0;j<Stud_details.length;j++){
          if(Stud_details[j].Email_ID==attend_stud[i]){
            Stud_details[j].Present="P";
            print(Stud_details[j]);
          }
        }
      }
    // Stud_details[0].Present="P";
    // Stud_details[3].Present="P";
    util_flag.value=true;
    }


class Utils{
  static List<T> modeBuilder<M, T>(
    List<M> models, T Function(int index, M model) builder) => 
    models.asMap().map<int, T>((index, model) => MapEntry(index, builder(index, model))).
    values.toList();

  static modelBuilder(List<dynamic> cells, DataCell Function(dynamic index, dynamic cell) param1) {}
}
