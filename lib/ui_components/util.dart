import 'package:flutter/material.dart';
import 'package:attend_ease/Bluetooth/broadcast.dart';

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

int util_flag=0;
void update_A_P(attend_stud){
      for(int i=0;i<attend_stud.length;i++){
        for(int j=0;j<Stud_details.length;j++){
          if(Stud_details[j].Email_ID==attend_stud[i]){
            Stud_details[j].Present="P";
          }
        }
      }
    // Stud_details[0].Present="P";
    // Stud_details[3].Present="P";
    util_flag=1;
    }
