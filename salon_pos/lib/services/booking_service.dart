import 'package:sqflite/sqflite.dart';
import '../models/booking_model.dart';
import 'db_helper.dart';

class BookingService {
  /// Adds a new booking to the database and returns the auto-generated ID
  static Future<int> addBooking(Booking booking) async {
    final db = await DBHelper().database;
    final id = await db.insert(
      'booking',
      booking.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  /// ⚙️ Fetches all booking from the database
  static Future<List<Booking>> fetchBooking() async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('booking');
    return List.generate(
      maps.length,
      (i) => Booking.fromMap(maps[i]),
    );
  }

  /// ⚙️ Deletes a booking by its ID
  static Future<void> deleteBooking(int bookingId) async {
    final db = await DBHelper().database;
    await db.delete('booking', where: 'booking_id = ?', whereArgs: [bookingId]);
  }

  /// ⚙️ Fetches only today's booking
  static Future<List<Booking>> fetchTodayBooking() async {
    final db = await DBHelper().database;
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    final List<Map<String, dynamic>> maps = await db.query(
      'booking',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );

    return List.generate(maps.length, (i) => Booking.fromMap(maps[i]));
  }

  /// ⚙️ Fetches booking for any specific date
  static Future<List<String>> getBookingsForDate(String date) async {
    final db = await DBHelper().database;
    final result = await db.query(
      'booking',
      where: 'date = ?',
      whereArgs: [date],
    );

    List<String> bookedTimes = [];
    for (var booking in result) {
      if (booking['time'] != null) {
        bookedTimes.add(booking['time'].toString());
      }
    }

    return bookedTimes;
  }

  /// ⚙️ Checks if a given time slot is already booked for a given date
  static Future<bool> isTimeSlotTaken(String time, String date) async {
    final db = await DBHelper().database;
    final result = await db.query(
      'booking',
      where: 'time = ? AND date = ?',
      whereArgs: [time, date],
    );
    return result.isNotEmpty;
  }

  /// ⚙️ Fetches full booking data for any specific date
  static Future<List<Booking>> fetchBookingsByDate(String date) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      'booking',
      where: 'date = ?',
      whereArgs: [date],
    );
    return List.generate(maps.length, (i) => Booking.fromMap(maps[i]));
  }
}
