import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../styles/text_styles.dart';
import '../services/admin/staff_crud.dart';
import '../models/staff_model.dart';
import 'menu.dart';
import 'admin/dashboard.dart';
import '../utils/session.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _isLoading = true);

    // Admin login (hardcoded)
    if (username == 'admin' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminDashboard()),
      );
      return;
    }

    // Attempt to find matching staff by staff_name OR staff_id
    final allStaff = await StaffService.getAllStaff();
    final Staff? found = allStaff.firstWhereOrNull(
      (s) =>
          (s.name.toLowerCase() == username.toLowerCase() ||
              s.id.toString() == username) &&
          s.password == password,
    );

    setState(() => _isLoading = false);

    if (found != null) {
      Session.currentStaff = found; // ✅ Track who’s logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MenuScreen()),        
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid credentials")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEAD1), // peach
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF00B25D), width: 4),
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFFFEAD1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Salon POS Login",
                style: TextStyle(
                  fontFamily: "Oswald",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // Username/staff ID
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username / Staff ID",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontFamily: "Oswald"),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Password
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(fontFamily: "Oswald"),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B25D),
                  ),
                  child: Text(
                    _isLoading ? "Logging in..." : "Login",
                    style: const TextStyle(
                      fontFamily: "Oswald",
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
