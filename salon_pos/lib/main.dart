import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(SalonPosApp());
}

class SalonPosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hair Salon POS',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: HomeMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
