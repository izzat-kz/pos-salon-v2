import 'package:flutter/material.dart';
import '../models/staff_model.dart';

class StaffBadge extends StatelessWidget {
  final Staff staff;
  const StaffBadge({required this.staff});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFF6C746),
      ),
      child: Text(
        "[STAFF USING]\n${staff.name}\n(ID: ${staff.id})",
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontFamily: "Oswald",
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}
