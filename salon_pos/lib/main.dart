import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'services/db_helper.dart';

void main() {
  runApp(SalonPosApp());
}

class SalonPosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hair Salon POS',
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
