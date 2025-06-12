import 'package:flutter/material.dart';
import '../models/item_catalog.dart';
import 'transaction.dart';
import '../styles/button_styles.dart';

class PaymentOptionsScreen extends StatelessWidget {
  final double totalAmount;
  final Map<Item, int> bill;

  const PaymentOptionsScreen({
    Key? key,
    required this.totalAmount,
    required this.bill,
  }) : super(key: key);

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
                    "Total:",
                    style: TextStyle(fontSize: 28),
                  ),
                  Text(
                    "RM ${totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 78,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Oswald",
                    ),
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _squarePaymentButton(
                        label: "CASH/\nQR",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionScreen(
                                totalAmount: totalAmount,
                                bill: bill,
                                paymentMethod: 'cash',
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 70),
                      _squarePaymentButton(
                        label: "LOAN",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionScreen(
                                totalAmount: totalAmount,
                                bill: bill,
                                paymentMethod: 'loan',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ⏹️ Custom Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: AppButtonStyles.backButton,
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _squarePaymentButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 330,
      height: 330,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppButtonStyles.squarePaymentButton,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Oswald",
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }
}
