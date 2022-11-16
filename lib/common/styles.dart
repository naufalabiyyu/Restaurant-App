import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bgColor = Color(0xffFAFAFC);
const Color borderColor = Color(0xffC5C5C5);
const Color secondaryColor = Colors.pink;
const Color darkPrimaryColor = Color(0xFF000000);
const Color darkSecondaryColor = Color(0xff64ffda);
const Color darkColor = Color(0xff303030);
const Color secondartDarkColor = Color(0xff474747);
const Color greyColor = Color(0xff969698);

TextStyle primaryTextStyle = GoogleFonts.inter(
  color: const Color(0xff17161B),
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(elevation: 0),
  colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: bgColor,
        onPrimary: Colors.black,
        // secondary: secondaryColor,
      ),
  scaffoldBackgroundColor: Colors.white,
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: secondaryColor,
      textStyle: const TextStyle(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        primary: darkPrimaryColor,
        onPrimary: Colors.black,
        secondary: darkSecondaryColor,
      ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  // textTheme: myTextTheme,
  appBarTheme: const AppBarTheme(elevation: 0),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: secondaryColor,
      textStyle: const TextStyle(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
    ),
  ),
);
