import 'package:flutter/material.dart';
import 'package:rick_and_morty/page/home.dart';
import 'package:rick_and_morty/theme/colors.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: primary
    ),
    home: HomePage(),
  ));
}
