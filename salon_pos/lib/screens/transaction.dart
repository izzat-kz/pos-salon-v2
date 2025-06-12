import 'package:flutter/material.dart';
import '../models/item_catalog.dart';
import 'loan_book.dart';
import 'receipt.dart';
import 'home.dart';
import '../services/bill_service.dart';
import '../utils/validators.dart';
import '../widgets/popups.dart';
import '../models/loan_model.dart';
import '../styles/button_styles.dart';

class TransactionScreen extends StatefulWidget {
  final double totalAmount;
  final Map<Item, int> bill;
  final String paymentMethod;
  final bool isLoanTransaction;
  final Loan? selectedLoan;

  TransactionScreen({
    Key? key,
    required this.totalAmount,
    required this.bill,
    required this.paymentMethod,
    this.isLoanTransaction = false,
    this.selectedLoan,
  }) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TextEditingController _cashAmountController = TextEditingController();
  double _changeAmount = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.paymentMethod == 'loan') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoanBookScreen(totalAmount: widget.totalAmount)),
        );
      });
    } else if (widget.paymentMethod != 'cash') {
      _cashAmountController.text = widget.totalAmount.toStringAsFixed(2);
      _calculateChange();
    }
  }

  void _calculateChange() {
    if (widget.paymentMethod == 'cash') {
      try {
        double cashPaid = double.parse(_cashAmountController.text);
        setState(() {
          _changeAmount = cashPaid - widget.totalAmount;
        });
      } catch (e) {
        setState(() {
          _changeAmount = 0.0;
        });
      }
    } else {
      setState(() {
        _changeAmount = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5D5D5),
      body: Stack(
        children: [
          // ⏹️ Back Button (Top Left)
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 740,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ⏹️ Top Content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 110),
                          const Text("TOTAL",
                              style: TextStyle(
                                  fontSize: 24, fontFamily: "Oswald")),
                          Text(
                            "RM ${widget.totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Oswald"),
                          ),
                          const SizedBox(height: 30),
                          const Text("CASH AMOUNT",
                              style: TextStyle(
                                  fontSize: 24, fontFamily: "Oswald")),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 450,
                            child: TextField(
                              controller: _cashAmountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 42, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixText: "RM ",
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onChanged: (_) => _calculateChange(),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ⏹️ Ribbon Container
                              GestureDetector(
                                onTap: widget.isLoanTransaction
                                    ? () => showLoanPopup(context)
                                    : () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoanBookScreen(
                                              totalAmount: widget.totalAmount,
                                            ),
                                          ),
                                        );
                                      },
                                child: Container(
                                  width: 220,
                                  height: 90,
                                  color: widget.isLoanTransaction
                                      ? Colors.grey
                                      : Colors.pink[200],
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "LOAN?",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Oswald",
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 40),

                              // ⏹️ Change display
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "CHANGE:",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Oswald"),
                                  ),
                                  Text(
                                    "RM ${_changeAmount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Oswald"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      // ⏹️ RECEIPT Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              validateTransaction(
                                context,
                                "receipt",
                                widget.totalAmount,
                                _cashAmountController,
                                widget.bill,
                                widget.isLoanTransaction,
                                widget.selectedLoan,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.orangeAccent.withOpacity(0.7),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 65, vertical: 20),
                              textStyle: const TextStyle(fontSize: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text("COMPLETE",
                                style: TextStyle(
                                    color: Colors.black, fontFamily: "Oswald")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 70),

                // ⏹️ RIGHT SIDE (QR Section)
                SizedBox(
                  width: 420,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Powered by",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 70,
                          child: Image.asset(
                            'assets/duitnow_logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                const Text("DuitNow Logo"),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.orangeAccent, width: 6),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Image.asset(
                            'assets/qrsalonpos.png',
                            width: 420,
                            height: 410,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Text("QR Code Not Found"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
