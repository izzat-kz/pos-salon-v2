import 'package:flutter/material.dart';
import '../models/loan_payment.dart';
import '../services/loan_payment_crud.dart';
import 'package:intl/intl.dart';

class PaymentHistoryPopup extends StatelessWidget {
  final String loanId;

  const PaymentHistoryPopup({required this.loanId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF46303C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Payment History",
                style: TextStyle(
                  fontFamily: "Oswald",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            const SizedBox(height: 16),
            FutureBuilder<List<LoanPayment>>(
              future: LoanPaymentService.getPaymentsByLoanId(loanId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return const Text("Failed to load history",
                      style: TextStyle(color: Colors.white70));
                }

                if (snapshot.data!.isEmpty) {
                  return const Text("No payments made yet",
                      style: TextStyle(color: Colors.white70));
                }

                return SizedBox(
                  height: 250,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final payment = snapshot.data![index];
                      final formattedDate = DateFormat("dd/MM/yyyy  hh:mm:ss a")
                          .format(DateTime.parse(payment.paymentDate));
                      return ListTile(
                        title: Text(
                          "RM ${payment.amountPaid.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontFamily: "Oswald",
                              fontSize: 18,
                              color: Colors.amberAccent),
                        ),
                        subtitle: Text("Paid on $formattedDate",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Oswald",
                              color: Colors.white60,
                            )),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close",
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
