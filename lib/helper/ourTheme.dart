import 'package:flutter/material.dart';

class OurTheme {
  Color mPurple = const Color(0xFFf62459);
  Color pinkShade = const Color(0xFFf62459).withAlpha(120);
  Color pinkShade2 = const Color(0xFFf62459).withOpacity(0.8);

  Color purpleShade = const Color(0xFF5A60B7).withAlpha(150);
  Color purple = const Color(0xFF5A60B7);

  Color lPurple =const Color(0xFF868ACB);
  Color black = const Color(0xFF001011);
  Color green = const Color(0xFF26c485);
  Color ourGrey = const Color(0xFF5D5D5D);
  Color secGrey = const Color(0xFF919191);

  ThemeData buildTheme() {
    return ThemeData(
      primaryColor: mPurple,
      appBarTheme: AppBarTheme(
          color: mPurple, backgroundColor: mPurple, foregroundColor: mPurple),
      scaffoldBackgroundColor: Colors.grey[200],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'PopR',
      accentColor: green,
    );
  }
}
