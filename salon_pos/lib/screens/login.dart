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
  bool _obscurePassword = true;

  String _weekday(int day) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];
  String _month(int month) => [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][month - 1];

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

    // ⚙️ Attempt to find matching staff by staff_name OR staff_id
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
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAC1A2), Color(0xFFF7F3ED)],
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              // Left: Salon Image
              Expanded(
                flex: 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    
                    ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.43, 0.6, 1.0],
                          colors: [
                            Colors.black.withOpacity(0.0),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(1.0),
                          ],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'assets/Salon login banner.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    // 🕒 Clock and date overlay
                    Positioned(
                      top: 92,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          StreamBuilder<DateTime>(
                            stream: Stream.periodic(
                                Duration(seconds: 1), (_) => DateTime.now()),
                            builder: (context, snapshot) {
                              final now = snapshot.data ?? DateTime.now();
                              final time =
                                  "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
                              final date =
                                  "${_weekday(now.weekday)}, ${_month(now.month)} ${now.day}, ${now.year}";

                              return Column(
                                children: [
                                  Text(
                                    time,
                                    style: TextStyle(
                                      fontFamily: "Oswald",
                                      fontSize: 104,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 12,
                                            offset: Offset(1, 2),
                                            color: Colors.black54)
                                      ],
                                    ),
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(
                                      fontFamily: "Oswald",
                                      fontSize: 20,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            blurRadius: 12,
                                            offset: Offset(1, 2),
                                            color: Colors.black54)
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Login Interface
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    width: 400,
                    height: 600,
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 30),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F4F3),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: const Color(0xFF46303C), width: 4),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 🖼️ Team logo
                        Image.asset(
                          'assets/Gr8 logo.png',
                          height: 100,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Salon POS",
                          style: TextStyle(
                            fontFamily: "Oswald",
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: "Username / Staff ID",
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontFamily: "Oswald"),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 18),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            border: const OutlineInputBorder(),
                            labelStyle: const TextStyle(fontFamily: "Oswald"),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 18),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.black87,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6E4E57),
                            ),
                            child: Text(
                              _isLoading ? "Logging in..." : "Login",
                              style: const TextStyle(
                                fontFamily: "Oswald",
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
