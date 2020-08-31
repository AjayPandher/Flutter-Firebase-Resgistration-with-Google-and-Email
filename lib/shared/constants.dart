import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.transparent,
  filled: true,
  floatingLabelBehavior: FloatingLabelBehavior.auto,
labelStyle: TextStyle(color: Colors.blue), contentPadding: EdgeInsets.all(0.0),
    errorStyle: TextStyle(color: Colors.blueAccent),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Color(0xff29b6f6), width: 3.0),
  ),
);