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
}
