import 'package:flutter/material.dart';
import 'package:shop_admin/Pages/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shop Admin",
      theme: ThemeData(
        primaryColor: Color(0xFF0013A8),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
