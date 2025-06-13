import 'dart:convert';

class Loan {
  final String id;
  String name;
  String phone;
  String address;
  double totalAmount;
  Map<String, int> billItems;
  String dateTime;

  Loan({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.totalAmount,
    required this.billItems,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'loan_id': id,
      'cust_name': name,
      'cust_phone': phone,
      'cust_address': address,
      'totalAmount': totalAmount.toInt(),
      'billItems': jsonEncode(billItems),
      'dateTime': dateTime,
    };
  }

  factory Loan.fromMap(Map<String, dynamic> map) {
    return Loan(
      id: map['loan_id'],
      name: map['cust_name'],
      phone: map['cust_phone'],
      address: map['cust_address'],
      totalAmount: (map['totalAmount'] as num).toDouble(),
      billItems: Map<String, int>.from(jsonDecode(map['billItems'])),
      dateTime: map['dateTime'],
    );
  }
}
