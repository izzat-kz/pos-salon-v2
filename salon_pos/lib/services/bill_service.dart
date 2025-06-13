import '../models/item_catalog.dart';

class BillService {
  static Map<Item, int> bill = {};

  static void addToBill(Item option) {
    bill.update(option, (value) => value + 1, ifAbsent: () => 1);
  }

  static void updateQuantity(Item option, int change) {
    final newVal = (bill[option] ?? 0) + change;
    if (newVal <= 0) {
      bill.remove(option);
    } else {
      bill[option] = newVal;
    }
  }

  static double calculateSubtotal() {
    return bill.entries
        .fold(0, (sum, entry) => sum + (entry.key.price * entry.value));
  }

  static void clearBill() {
    bill.clear();
  }
}
