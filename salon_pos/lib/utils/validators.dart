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
  Loan? selectedLoan,
  int customerPax, {
  bool shouldRemoveLoan = false,
}) {
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
      selectedLoan,
      customerPax,
      shouldRemoveLoan: shouldRemoveLoan,
    );
  } catch (e) {
    popupEmtpyBill(
        context, "Invalid Input", "Please enter a valid cash amount.");
  }
}

/// ⚙️ validate Loan Book's textfields
class Validators {
  static String? validateIC(String ic) {
    try {
      if (ic.isEmpty) throw Exception("IC number cannot be empty");
      if (!RegExp(r'^\d{6}-\d{2}-\d{4}$').hasMatch(ic)) {
        throw Exception("Invalid IC format (e.g. 010203-10-1234)");
      }
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

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

/// ⚙️ Inventory-specific field validators
class InventoryValidators {
  static String? validateItemName(String name) {
    try {
      if (name.trim().isEmpty) throw Exception("Item name cannot be empty");
      if (name.length < 2) throw Exception("Item name is too short");
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  /// ⚙️ Validate sub item / item option
  static String? validateOptionName(String name) {
    try {
      if (name.trim().isEmpty) throw Exception("Sub item name cannot be empty");
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }

  /// ⚙️ validate sub item price
  static String? validatePrice(String value) {
    try {
      if (value.trim().isEmpty) throw Exception("Price cannot be empty");
      final double parsed = double.parse(value);
      if (parsed <= 0) throw Exception("Price must be more than 0");
      return null;
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    }
  }
}

/// ⚙️ validate staff name
String? validateStaffName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Name is required";
  }
  if (value.trim().length < 3) {
    return "Name must be at least 3 characters";
  }
  if (value == "admin") {
    return "Name cannot be set admin";
  }
  return null;
}

/// ⚙️ validate staff password
String? validateStaffPassword(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Password is required";
  }
  if (value.trim().length < 4) {
    return "Minimum 4 characters";
  }
  return null;
}
