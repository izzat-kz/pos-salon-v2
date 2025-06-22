class SalesReport {
  final int billId;
  final String date;
  final double totalAmount;
  final int pax;
  final int staffId;

  SalesReport({
    required this.billId,
    required this.date,
    required this.totalAmount,
    required this.pax,
    required this.staffId,
  });

  Map<String, dynamic> toMap() => {
        'bill_id': billId,
        'date': date,
        'total_amount': totalAmount,
        'pax': pax,
        'staff_id': staffId,
      };

  factory SalesReport.fromMap(Map<String, dynamic> map) => SalesReport(
        billId: map['bill_id'],
        date: map['date'],
        totalAmount: (map['total_amount'] as num).toDouble(),
        pax: map['pax'],
        staffId: map['staff_id'],
      );
}
