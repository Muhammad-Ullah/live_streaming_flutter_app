
import 'package:flutter/material.dart';
import 'package:live_streaming_flutter_app/helper/ourTheme.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      "assets/images/logo.png",
      height: 40,
    ),
    elevation: 0.0,
    centerTitle: false,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: OurTheme().lPurple),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: OurTheme().lPurple)),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: OurTheme().lPurple)));
}

TextStyle simpleTextStyle() {
  return TextStyle(color: OurTheme().lPurple, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'PopS');
}
