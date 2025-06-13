import 'package:flutter/material.dart';
import '../login.dart';
import 'inventory.dart';
import 'staff_management.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5D5D5),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: BoxDecoration(
                color: const Color(0xFFD5D5D5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Admin Dashboard",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Oswald",
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dashboardButton(
                        label: "MANAGE\nINVENTORY",
                        icon: Icons.inventory_2_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InventoryScreen()),
                          );
                        },
                      ),
                      const SizedBox(width: 70),
                      _dashboardButton(
                        label: "MANAGE\nSTAFF",
                        icon: Icons.people_alt_rounded,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StaffManagementScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent.shade400,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 48, vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)),
                    ),
                    child: const Text(
                      "Logout",
                      style: TextStyle(
                        fontFamily: "Oswald",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashboardButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 330,
      height: 330,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 70, color: Colors.black87),
            const SizedBox(height: 20),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Oswald",
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
