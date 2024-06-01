import 'package:flutter/cupertino.dart';
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
  return TextStyle(fontSize: 17, fontWeight: FontWeight.w300);
}

Radius radius_12() {
  return Radius.circular(12);
}
