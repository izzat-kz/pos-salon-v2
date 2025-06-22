import 'dart:convert';

class Loan {
  final String id;
  final String name;
  final String phone;
  final String address;
  final double totalAmount;
  final Map<int, int> billItems;
  final String dateTime;
  final int customerPax;
  final String icNumber;


  Loan({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.billItems,
    required this.dateTime,
    required this.customerPax,
    required this.icNumber,
  });

  /// 🔄 Converts Loan object to a database-friendly Map format
  Map<String, dynamic> toMap() {
    return {
      'loan_id': id,
      'cust_name': name,
      'cust_phone': phone,
      'cust_address': address,
      'totalAmount': totalAmount,
      'billItems': jsonEncode(
          billItems.map((key, value) => MapEntry(key.toString(), value))),
      'dateTime': dateTime,
      'customer_pax': customerPax,
      'cust_ic': icNumber,
    };
  }

  /// 🔄 Creates a Loan object from a Map (database retrieval)
  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['loan_id'],
      name: map['cust_name'],
      phone: map['cust_phone'],
      address: map['cust_address'],
      totalAmount: (map['totalAmount'] as num).toDouble(),
      billItems: Map<String, int>.from(jsonDecode(map['billItems']))
          .map((key, value) => MapEntry(int.parse(key), value)),
      dateTime: map['dateTime'],
      customerPax: map['customer_pax'] ?? 1,
      icNumber: map['cust_ic'] ?? '',
    );
  }
}
