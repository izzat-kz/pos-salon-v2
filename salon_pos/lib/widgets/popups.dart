import 'package:flutter/material.dart';
import '../screens/menu.dart';
import '../screens/receipt.dart';
import '../services/bill_service.dart';
import '../models/item_catalog.dart';
import 'dart:io';
import '../models/loan_model.dart';
import '../services/loan_crud.dart';
import '../screens/transaction.dart';
import '../screens/login.dart';
import '../services/sales_crud.dart';
import '../models/sales_model.dart';
import '../utils/session.dart';
import '../services/db_helper.dart';
import 'enter_payment_popup.dart';
import 'payment_history_popup.dart';
import '../models/loan_payment.dart';
import '../services/loan_payment_crud.dart';

/// 📌 **Customer Pax Popups**
class CustomerPaxPopup extends StatefulWidget {
  final Function(int pax) onConfirm;

  const CustomerPaxPopup({required this.onConfirm});

  @override
  _CustomerPaxPopupState createState() => _CustomerPaxPopupState();
}

class _CustomerPaxPopupState extends State<CustomerPaxPopup> {
  int selectedPax = 1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF46303C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Number of Customers",
              style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 40,
                diameterRatio: 1.3,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedPax = index + 1;
                  });
                },
                physics: FixedExtentScrollPhysics(),
                perspective: 0.003,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 10,
                  builder: (context, index) => Center(
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onConfirm(selectedPax);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDCB6E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      fontFamily: "Oswald",
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

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

/// 📌 **Popup for Change Due - Successful Transaction**
void popupChangeDue(
  BuildContext context,
  String title,
  String message,
  String action,
  Map<Item, int> bill,
  double totalAmount,
  bool isLoanTransaction,
  Loan? selectedLoan,
  int customerPax, {
  bool shouldRemoveLoan =
      false, // Only true when called from "Clear Loan" or max payment
}) {
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
              color: Colors.white,
            )),
        content: Text(message,
            style: TextStyle(
              fontFamily: "Oswald",
              fontSize: 65,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              final sale = SalesReport(
                billId: DateTime.now().millisecondsSinceEpoch,
                date: DateTime.now().toIso8601String(),
                totalAmount: totalAmount,
                pax: customerPax,
                staffId: Session.currentStaff!.id,
              );
              await SalesService.insertSale(sale);

              if (isLoanTransaction &&
                  selectedLoan != null &&
                  !shouldRemoveLoan) {
                await LoanPaymentService.insertPayment(
                  LoanPayment(
                    id: 0,
                    loanId: selectedLoan.id,
                    amountPaid: totalAmount,
                    paymentDate: DateTime.now().toIso8601String(),
                  ),
                );
              }

              Navigator.pop(context);

              if (isLoanTransaction &&
                  selectedLoan != null &&
                  shouldRemoveLoan) {
                await LoanService.removeLoan(selectedLoan.id);
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReceiptScreen(
                    bill: bill,
                    subtotal: totalAmount,
                    customerPax: customerPax,
                  ),
                ),
              );
            },
            child: Text("RECEIPT",
                style: TextStyle(
                  fontFamily: "Oswald",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
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
void popupLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF46303C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Logout Application",
            style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        content: Text("Are you sure you want to logout?",
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            },
            child: Text("Logout",
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

// ⚙️ Async helper to convert stored loan item IDs into actual Item objects
Future<Map<Item, int>> convertLoanToBill(Loan loan) async {
  final db = await DBHelper().database;

  final entries = await Future.wait(
    loan.billItems.entries.map((entry) async {
      final int subId = int.tryParse(entry.key.toString()) ?? -1;

      final itemOption = await db.query(
        'item_option',
        where: 'sub_id = ?',
        whereArgs: [subId],
      );

      final itemType = await db.query(
        'item_type',
        where: 'item_id = ?',
        whereArgs: [itemOption.first['item_id']],
      );

      final item = Item(
        id: subId,
        name: "${itemType.first['name']} - ${itemOption.first['name']}",
        price: (itemOption.first['price'] as num?)?.toDouble() ?? 0.0,
        parentItemName: itemType.first['name'] as String,
        category: itemType.first['category'] == "Services"
            ? ItemCategory.service
            : ItemCategory.product,
      );

      return MapEntry(item, entry.value);
    }),
  );

  return Map<Item, int>.fromEntries(entries);
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
void showLoanDetailsPopup(
    BuildContext context, List<String> loanedItems, Loan loan) {
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
              SizedBox(height: 3),
              Text("Customer pax: ${loan.customerPax}",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              SizedBox(height: 10),
              Text("Name:        ${loan.name}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              SizedBox(height: 7),
              Text("IC Num:     ${loan.icNumber}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              SizedBox(height: 7),
              Text("Phone:       ${loan.phone}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              SizedBox(height: 7),
              Text("Address:    ${loan.address}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Oswald",
                      color: Colors.grey[900])),
              SizedBox(height: 10),
              Divider(color: Colors.grey[900], thickness: 2.0),
              SizedBox(height: 10),

              // ⏹️ Tabulated bill item
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: FutureBuilder<List<TableRow>>(
                      future: Future.wait(
                        loan.billItems.entries.map((entry) async {
                          final db = await DBHelper().database;

                          // ⚙️ Fetch item type and option details
                          final List<Map<String, dynamic>> itemOption =
                              await db.query(
                            'item_option',
                            where: 'sub_id = ?',
                            whereArgs: [entry.key],
                          );

                          final List<Map<String, dynamic>> itemType =
                              await db.query(
                            'item_type',
                            where: 'item_id = ?',
                            whereArgs: [
                              itemOption.isNotEmpty
                                  ? itemOption.first['item_id']
                                  : 0
                            ],
                          );

                          final itemName = itemType.isNotEmpty
                              ? itemType.first['name']
                              : 'Unknown Type';
                          final optionName = itemOption.isNotEmpty
                              ? itemOption.first['name']
                              : 'Unknown Option';

                          return TableRow(children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text("$itemName - $optionName",
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
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text("Error loading items"));
                        }
                        return Table(
                          columnWidths: {
                            0: FlexColumnWidth(4),
                            1: FlexColumnWidth(1),
                          },
                          children: snapshot.data!,
                        );
                      },
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
                        FutureBuilder<double>(
                          future: LoanPaymentService.getTotalPaid(loan.id),
                          builder: (context, snapshot) {
                            final totalPaid = snapshot.data ?? 0.0;
                            final remaining = loan.totalAmount - totalPaid;

                            return Text("RM ${remaining.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 85,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Oswald",
                                    color: Colors.red));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // ⏹️ Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Payment History Button
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => PaymentHistoryPopup(loanId: loan.id),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[800],
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("History Payment",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Oswald",
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),

                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[900],
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Back",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Oswald",
                                color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      // Enter Payment Button
                      ElevatedButton(
                        onPressed: () async {
                          // ⚙️ Rebuild Bill & Calculate Remaining Before Showing Popup
                          final db = await DBHelper().database;

                          final totalPaid =
                              await LoanPaymentService.getTotalPaid(loan.id);
                          final remainingBalance = loan.totalAmount - totalPaid;

                          final entries = await Future.wait(
                            loan.billItems.entries.map((entry) async {
                              final int subId =
                                  int.tryParse(entry.key.toString()) ?? -1;

                              final itemOption = await db.query(
                                'item_option',
                                where: 'sub_id = ?',
                                whereArgs: [subId],
                              );
                              final itemType = await db.query(
                                'item_type',
                                where: 'item_id = ?',
                                whereArgs: [itemOption.first['item_id']],
                              );

                              final item = Item(
                                id: subId,
                                name:
                                    "${itemType.first['name']} - ${itemOption.first['name']}",
                                price: (itemOption.first['price'] as num?)
                                        ?.toDouble() ??
                                    0.0,
                                parentItemName:
                                    itemType.first['name'] as String,
                                category:
                                    itemType.first['category'] == "Services"
                                        ? ItemCategory.service
                                        : ItemCategory.product,
                              );

                              return MapEntry(item, entry.value);
                            }),
                          );

                          final convertedBill = Map<Item, int>.fromEntries(
                            entries.map((e) => MapEntry(e.key, e.value)),
                          );

                          showDialog(
                            context: context,
                            builder: (_) => EnterPaymentPopup(
                              loan: loan,
                              remainingBalance: remainingBalance,
                              onPay: (amount) async {
                                final totalPaidSoFar =
                                    await LoanPaymentService.getTotalPaid(
                                        loan.id);
                                final remaining =
                                    loan.totalAmount - totalPaidSoFar;
                                final isFinalPayment = (amount >= remaining);

                                final convertedBill =
                                    await LoanService.convertLoanToBill(loan);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TransactionScreen(
                                      bill: convertedBill,
                                      totalAmount: amount,
                                      paymentMethod: "cash",
                                      isLoanTransaction: true,
                                      selectedLoan: loan,
                                      customerPax: loan.customerPax,
                                      shouldRemoveLoan: isFinalPayment,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFDCB6E),
                          padding: EdgeInsets.symmetric(
                              horizontal: 26, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Enter Payment",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Oswald",
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                      ),

                      const SizedBox(width: 12),

                      // Clear Loan Button (for Full Payment)
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
                            final convertedBill = await convertLoanToBill(loan);
                            final totalPaid =
                                await LoanPaymentService.getTotalPaid(loan.id);
                            final remainingAmount =
                                loan.totalAmount - totalPaid;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TransactionScreen(
                                  totalAmount: remainingAmount,
                                  bill: convertedBill,
                                  paymentMethod: "cash",
                                  isLoanTransaction: true,
                                  selectedLoan: loan,
                                  customerPax: loan.customerPax,
                                  shouldRemoveLoan: true,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 38, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            shadowColor: Colors.transparent,
                          ),
                          child: Text("Clear Loan",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Oswald",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
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

/// 📌 **Popup for Loan Restrictions**
void showLoanRestrictPopup(BuildContext context) {
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

/// 📌 **Popup for Sub Items in menu.dart**
class SubItemPopup extends StatelessWidget {
  final String itemName;
  final List<Item> options;
  final VoidCallback onOptionAdded;

  const SubItemPopup({
    required this.itemName,
    required this.options,
    required this.onOptionAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2B2D42),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              itemName,
              style: const TextStyle(
                fontFamily: 'Oswald',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFDCB6E),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: options.map((option) {
                return Container(
                  width: 250,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF414863),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Option name
                      Expanded(
                        child: Text(
                          option.name,
                          style: const TextStyle(
                            fontFamily: "Oswald",
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(width: 4),

                      // Price + ADD
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "RM ${option.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            height: 34,
                            child: ElevatedButton(
                              onPressed: () {
                                BillService.addToBill(option);
                                onOptionAdded();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00B894),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text("ADD",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close",
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 📌 Popup for Deleting Booking Confirmation
Future<bool?> showDeleteBookingPopup(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF46303C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          "Delete Booking",
          style: TextStyle(
            fontFamily: "Oswald",
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this booking?",
          style: TextStyle(
            fontFamily: "Oswald",
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFFEF3A5D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Delete",
              style: TextStyle(
                fontFamily: "Oswald",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}

void showBookingSuccessPopup(BuildContext context, VoidCallback onConfirmed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text("Booking Confirmed!",
            style: TextStyle(
              fontFamily: "Oswald",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        content: Text(
          "Your booking has been successfully created.",
          style: TextStyle(
            fontFamily: "Oswald",
            fontSize: 18,
            color: Colors.white70,
          ),
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
                  color: Colors.white,
                )),
          ),
        ],
      );
    },
  );
}
