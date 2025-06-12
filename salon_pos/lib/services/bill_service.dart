import '../models/item_catalog.dart';

class BillService {
  static Map<Item, int> bill = {}; // Store selected items and quantities

  static void addToBill(Item item) {
    bill.update(item, (value) => value + 1, ifAbsent: () => 1);
  }

  static void updateQuantity(Item item, int change) {
    final newVal = (bill[item] ?? 0) + change;
    if (newVal <= 0) {
      bill.remove(item);
    } else {
      bill[item] = newVal;
    }
  }

  static double calculateSubtotal() {
    return bill.entries.fold(0, (sum, e) => sum + (e.key.price * e.value));
  }

  static void clearBill() {
    bill.clear();
  }
}
