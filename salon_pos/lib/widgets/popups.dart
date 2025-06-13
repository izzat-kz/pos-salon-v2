import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/receipt.dart';
import '../services/bill_service.dart';
import '../models/item_catalog.dart';
import 'dart:io';
import '../models/loan_model.dart';
import '../services/loan_crud.dart';
import '../screens/transaction.dart';

/// 📌 **Unified Validation Error Popup (Matching UI)**
void popupValidationErrors(BuildContext context, List<String> errors) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF46303C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Validation Error",
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: errors
              .map(
                (error) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(error,
                      style: TextStyle(
                          fontFamily: "Oswald",
                          fontSize: 18,
                          color: Colors.white70)),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK",
                style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      );
    },
  );
}

/// 📌 **Popup for Transaction Error**
void popupTransactionError(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF46303C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(title,
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        content: Text(message,
            style: TextStyle(
                fontFamily: "Oswald", fontSize: 18, color: Colors.white70)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK",
                style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      );
    },
  );
}

/// 📌 **Popup for Change Due**
void popupChangeDue(
    BuildContext context,
    String title,
    String message,
    String action,
    Map<Item, int> bill,
    double totalAmount,
    bool isLoanTransaction,
    Loan? selectedLoan) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(title,
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        content: Text(message,
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 65,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);

              if (isLoanTransaction && selectedLoan != null) {
                LoanService.removeLoan(selectedLoan.id);
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReceiptScreen(
                    bill: bill,
                    subtotal: totalAmount,
                  ),
                ),
              );
            },
            child: Text("RECEIPT",
                style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      );
    },
  );
}

/// 📌 **Popup for Empty Bill**
void popupEmtpyBill(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF46303C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(title,
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        content: Text(message,
            style: TextStyle(
                fontFamily: "Oswald", fontSize: 18, color: Colors.white70)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK",
                style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      );
    },
  );
}

/// 📌 **Popup for Exit Confirmation**
void popupExitConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF46303C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Exit Application",
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        content: Text("Are you sure you want to exit?",
            style: TextStyle(
                fontFamily: "Oswald", fontSize: 18, color: Colors.white70)),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel",
                style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFEF3A5D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              exit(0);
            },
            child: Text("Exit",
                style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      );
    },
  );
}

/// 📌 **Popup for Successfull Loan Submission**
void showLoanSuccessPopup(BuildContext context, VoidCallback onConfirmed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Submitted!",
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        content: Text(
          "Loan has been successfully recorded.",
          style: TextStyle(
              fontFamily: "Oswald", fontSize: 18, color: Colors.white70),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirmed();
            },
            child: Text("OK",
                style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      );
    },
  );
}

/// 📌 **Popup for Loan Details**
void showLoanDetailsPopup(BuildContext context, Loan loan) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.65,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFFFFF4EA),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⏹️ Customer Information
              Text("Loan created at [${loan.dateTime}]",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              Text("ID: ${loan.id}",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              SizedBox(height: 10),
              Text("Name:        ${loan.name}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              SizedBox(height: 7),
              Text("Phone:       ${loan.phone}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              SizedBox(height: 7),
              Text("Address:    ${loan.address}",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              SizedBox(height: 50),
              Divider(color: Colors.grey[900], thickness: 2.0),
              SizedBox(height: 10),

              // ⏹️ Tabulated bill item
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(children: [
                          Text("",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Oswald",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900])),
                          Text("",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Oswald",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900])),
                        ]),
                        ...loan.billItems.entries.map((entry) {
                          return TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(entry.key,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Oswald",
                                      color: Colors.grey[900])),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text("x ${entry.value}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "Oswald",
                                      color: Colors.grey[900])),
                            ),
                          ]);
                        }).toList(),
                      ],
                    ),
                  ),

                  // ⏹️ Total Amount on the Right
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Amount Due:",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Oswald",
                                color: Colors.grey[900])),
                        Text("RM ${loan.totalAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 85,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Oswald",
                                color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // ⏹️ Action Buttons (Back & Clear Loan)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Back",
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: "Oswald",
                            color: Colors.white)),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF87CB28), Color(0xFF00732D)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        final entries = await Future.wait(
                          loan.billItems.entries.map((entry) async {
                            final item =
                                await ItemCatalog.getItemByName(entry.key);
                            if (item != null) {
                              return MapEntry(item, entry.value);
                            } else {
                              throw Exception("Item '${entry.key}' not found.");
                            }
                          }),
                        );

                        final convertedBill =
                            Map<Item, int>.fromEntries(entries);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionScreen(
                              totalAmount: loan.totalAmount,
                              bill: convertedBill,
                              paymentMethod: "cash",
                              isLoanTransaction: true,
                              selectedLoan: loan,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 65, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        shadowColor: Colors.transparent,
                      ),
                      child: Text("Clear Loan",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Oswald",
                              color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showLoanPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF46303C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Loan Restriction",
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        content: Text(
          "Cannot make another loan for this transaction.",
          style: TextStyle(
              fontFamily: "Oswald", fontSize: 18, color: Colors.white70),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("OK",
                style: TextStyle(
                    fontFamily: "Oswald",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      );
    },
  );
}

void popupAddedToBill(BuildContext context, String itemName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF46303C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "Item Added",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Oswald',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        "$itemName has been added to the bill.",
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK", style: TextStyle(color: Colors.pinkAccent)),
        ),
      ],
    ),
  );
}
