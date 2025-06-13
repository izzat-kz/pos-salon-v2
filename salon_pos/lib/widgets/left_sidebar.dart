import 'package:flutter/material.dart';
import 'package:salon_pos/screens/home.dart';
import '../screens/loan_list.dart';
import '../screens/admin/dashboard.dart';
import '../styles/button_styles.dart';
import '../styles/text_styles.dart';
import 'popups.dart';

class LeftSidebar extends StatelessWidget {
  final bool isLoanListScreen;
  final bool isAdmin;

  const LeftSidebar({this.isLoanListScreen = false, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      color: Colors.grey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Image.asset(
            'assets/logo.png',
            width: 80,
            height: 80,
            errorBuilder: (_, __, ___) => const Placeholder(
              fallbackWidth: 60,
              fallbackHeight: 60,
            ),
          ),
          const SizedBox(height: 10),

          // Only show Home <-> Loan List toggle if not admin
          if (!isAdmin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (isLoanListScreen) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeMenuScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoanListScreen(),
                      ),
                    );
                  }
                },
                style: AppButtonStyles.navButton,
                child: Text(
                  isLoanListScreen ? "Home" : "Loan List",
                  style: AppTextStyles.navText,
                ),
              ),
            ),

          // Admin back-to-dashboard nav (only if admin)
          if (isAdmin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminDashboard()),
                  );
                },
                style: AppButtonStyles.navButton,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),

          const Spacer(),

          // Exit only for non-admins
          if (!isAdmin)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => popupExitConfirmation(context),
                style: AppButtonStyles.exitButton,
                child: const Icon(Icons.exit_to_app,
                    size: 22, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
