import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/item_catalog.dart';
import 'menu.dart';
import '../services/receipt_service.dart';
import '../utils/session.dart';


class ReceiptScreen extends StatelessWidget {
  final Map<Item, int> bill;
  final double subtotal;
  final int customerPax;
  final bool isLoanTransaction;

  ReceiptScreen({
    required this.bill,
    required this.subtotal,
    required this.customerPax,
    this.isLoanTransaction = false,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat("dd/MM/yyyy  hh:mm:ss a").format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFD5D5D5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF46303C),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  "Receipt Summary",
                  style: const TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                if (Session.currentStaff != null)
                  Text(
                    "Served by: ${Session.currentStaff!.name} (ID: ${Session.currentStaff!.id})",
                    style: const TextStyle(
                      fontFamily: "Oswald",
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                Text(
                  "Customer Pax: $customerPax",
                  style: const TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                if (isLoanTransaction)
                  Text(
                    "Payment Method: Loan Settlement",
                    style: const TextStyle(
                      fontFamily: "Oswald",
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                Text(
                  "Date: $formattedDate",
                  style: const TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const Divider(thickness: 2, color: Colors.white),
                ...bill.entries.map((entry) {
                  final item = entry.key;
                  final qty = entry.value;
                  final total = (item.price * qty).toStringAsFixed(2);

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            "${item.parentItemName}, ${item.name}",
                            style: const TextStyle(
                              fontFamily: "Oswald",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "x$qty",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: "Oswald",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "RM $total",
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontFamily: "Oswald",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(thickness: 2, color: Colors.white),
                Text(
                  "Total: RM ${subtotal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "THANK YOU & PLEASE COME AGAIN!",
                  style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => ReceiptService.printReceipt(bill, subtotal),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF3A5D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(140, 50),
                ),
                child: const Text("PRINT",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Oswald",
                      color: Colors.white,
                    )),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  bill.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(140, 50),
                ),
                child: const Text("DONE",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Oswald",
                      color: Colors.black,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
