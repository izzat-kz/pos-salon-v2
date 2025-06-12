import 'package:flutter/material.dart';
import 'package:salon_pos/screens/home.dart';
import '../styles/button_styles.dart';
import '../styles/text_styles.dart';
import '../screens/loan_list.dart';
import 'popups.dart';

class LeftSidebar extends StatelessWidget {
  final bool isLoanListScreen;

  LeftSidebar({this.isLoanListScreen = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      color: Colors.grey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Image.asset(
            'assets/logo.png',
            width: 80,
            height: 80,
            errorBuilder: (_, __, ___) => Placeholder(
              fallbackWidth: 60,
              fallbackHeight: 60,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (isLoanListScreen) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeMenuScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoanListScreen()),
                  );
                }
              },
              style: AppButtonStyles.navButton,
              child: Text(isLoanListScreen ? "Home" : "Loan List",
                  style: AppTextStyles.navText),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                popupExitConfirmation(context);
              },
              style: AppButtonStyles.exitButton,
              child: Icon(Icons.exit_to_app, size: 22, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
