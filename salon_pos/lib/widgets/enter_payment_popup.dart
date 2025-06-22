import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/loan_model.dart';

class EnterPaymentPopup extends StatefulWidget {
  final Loan loan;
  final double remainingBalance;
  final Function(double amount) onPay;

  const EnterPaymentPopup({
    required this.loan,
    required this.remainingBalance,
    required this.onPay,
  });

  @override
  _EnterPaymentPopupState createState() => _EnterPaymentPopupState();
}

class _EnterPaymentPopupState extends State<EnterPaymentPopup> {
  final TextEditingController _controller = TextEditingController(text: "0.00");
  final FocusNode _focusNode = FocusNode();
  double? enteredAmount;
  String? errorText;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasRealInput {
    final text = _controller.text.trim();
    return text.isNotEmpty && text != "0.00";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF46303C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(24),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Enter Payment (RM)",
                style: const TextStyle(
                  fontFamily: "Oswald",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF5E4A56),
                borderRadius: BorderRadius.circular(8),
              ),
              child: EditableText(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Oswald",
                  color: _hasRealInput
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                ),
                cursorColor: Colors.amber,
                backgroundCursorColor: Colors.transparent,
                textAlign: TextAlign.center,
                selectionControls: materialTextSelectionControls,
                onChanged: (val) {
                  final parsed = double.tryParse(val);
                  setState(() {
                    enteredAmount = parsed;
                    if (parsed == null ||
                        parsed < 1 ||
                        parsed > widget.remainingBalance) {
                      errorText =
                          "Enter between RM1.00 - RM${widget.remainingBalance.toStringAsFixed(2)}";
                    } else {
                      errorText = null;
                    }
                  });
                },
              ),
            ),
            if (errorText != null) ...[
              const SizedBox(height: 8),
              Text(errorText!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "Oswald",
                    color: Colors.redAccent,
                  )),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (enteredAmount != null && errorText == null) {
                  Navigator.pop(context);
                  widget.onPay(enteredAmount!);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDCB6E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                child: Text("Pay",
                    style: TextStyle(
                        fontFamily: "Oswald",
                        fontWeight: FontWeight.bold,
                        color: Colors.black87)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
