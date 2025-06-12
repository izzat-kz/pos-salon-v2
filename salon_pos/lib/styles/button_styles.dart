import 'package:flutter/material.dart';

class AppButtonStyles {
  static ButtonStyle navButton = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFEF3A5D),
    minimumSize: Size(200, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  static ButtonStyle exitButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    minimumSize: Size(double.infinity, 45),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static ButtonStyle confirmButton = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFEF3A5D),
    minimumSize: Size(double.infinity, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static ButtonStyle addButton = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFFEF3A5D),
    minimumSize: Size(double.infinity, 40),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  static ButtonStyle clearBillButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.amber,
    minimumSize: Size(200, 50),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );

  static ButtonStyle backButton = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(239, 58, 93, 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    minimumSize: const Size(100, 53),
    padding: const EdgeInsets.all(0),
    elevation: 3,
  );

  static ButtonStyle squarePaymentButton = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(239, 58, 93, 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: const EdgeInsets.all(16),
  );
}
