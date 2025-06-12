import 'package:flutter/material.dart';
import '../widgets/popups.dart';
import '../models/item_catalog.dart';
import '../models/loan_model.dart';

/// ⚙️ validate an empty bill
bool isBillEmpty(Map<dynamic, int> bill) {
  return bill.isEmpty;
}

/// ⚙️ validate Transaction
void validateTransaction(
    BuildContext context,
    String action,
    double totalAmount,
    TextEditingController cashController,
    Map<Item, int> bill,
    bool isLoanTransaction,
    Loan? selectedLoan) {
  if (cashController.text.isEmpty) {
    popupEmtpyBill(context, "Missing Input", "Please enter the cash amount.");
    return;
  }

  try {
    double cashPaid = double.parse(cashController.text);

    if (cashPaid < totalAmount) {
      popupEmtpyBill(
          context, "Not Enough", "Entered amount is less than the total.");
      return;
    }

    double changeAmount = cashPaid - totalAmount;

    popupChangeDue(
        context,
        "Change Due",
        "RM ${changeAmount.toStringAsFixed(2)}",
        action,
        bill,
        totalAmount,
        isLoanTransaction,
        selectedLoan);
  } catch (e) {
    popupEmtpyBill(
        context, "Invalid Input", "Please enter a valid cash amount.");
  }
}

/// ⚙️ validate Loan Book's textfields
class Validators {
  static String? validateName(String name) {
    try {
      if (name.isEmpty) throw Exception("Name cannot be empty");
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  static String? validateAddress(String address) {
    try {
      if (address.isEmpty) throw Exception("Address cannot be empty");
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  static String? validatePhone(String phone) {
    try {
      if (phone.isEmpty) throw Exception("Phone number cannot be empty");
      if (phone.contains(RegExp(r'[a-zA-Z]'))) {
        throw Exception("Phone number cannot contain letters");
      }
      // if (!(phone.startsWith("01") || phone.startsWith("+01"))) {
      //   throw Exception("Phone number not valid");
      // }
      if (phone.length < 10 || phone.length > 11) {
        throw Exception("Phone number must be 8 or 11 digits long");
      }
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}
