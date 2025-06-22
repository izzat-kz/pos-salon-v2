import 'dart:convert';

class Booking {
  final int? bookingId;
  String custName;
  String custPhone;
  String time;
  String date;

  Booking({
    this.bookingId,
    required this.custName,
    required this.custPhone,
    required this.time,
    required this.date,
  });

  factory Booking.fromMap(Map<String, dynamic> map) => Booking(
        bookingId: map['booking_id'],
        custName: map['cust_name'],
        custPhone: map['cust_phone'],
        time: map['time'],
        date: map['date'],
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'cust_name': custName,
      'cust_phone': custPhone,
      'time': time,
      'date': date,
    };
    if (bookingId != null) {
      map['booking_id'] = bookingId;
    }
    return map;
  }
}
