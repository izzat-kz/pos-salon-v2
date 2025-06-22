import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';
import '../styles/text_styles.dart';
import '../styles/button_styles.dart';
import '../widgets/popups.dart';

class BookingFormPage extends StatefulWidget {
  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedTime;
  List<String> timeSlots = [];
  Set<String> bookedSlots = Set();

  @override
  void initState() {
    super.initState();
    _generateTimeSlots();
    _fetchBookedSlots();
  }

  void _generateTimeSlots() {
    DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day, 9, 0);
    DateTime endTime = DateTime(now.year, now.month, now.day, 22, 0);

    while (startTime.isBefore(endTime)) {
      timeSlots.add(DateFormat('hh:mm a').format(startTime));
      startTime = startTime.add(Duration(minutes: 10));
    }
  }

  Future<void> _fetchBookedSlots() async {
    final today = DateTime.now();
    final formattedDate =
        "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    final bookedTimes = await BookingService.getBookingsForDate(formattedDate);
    setState(() {
      bookedSlots = bookedTimes.toSet();
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedTime != null) {
      final formattedTime = _selectedTime!;
      final today = DateTime.now();
      final formattedDate =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

      final isTaken = bookedSlots.contains(formattedTime);
      if (isTaken) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("This time slot is already booked.")),
        );
        return;
      }

      final booking = Booking(
        custName: _nameController.text.trim(),
        custPhone: _phoneController.text.trim(),
        time: formattedTime,
        date: formattedDate,
      );

      final insertedId = await BookingService.addBooking(booking);
      print("✅ Booking inserted with ID: $insertedId");

      showBookingSuccessPopup(context, () {
        Navigator.pop(context);
      });
    } else if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a time.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5D5D5),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 100 + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              color: const Color(0xFFEF3A5D),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              "NEW APPOINTMENT",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: "Oswald",
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 60),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("NAME",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontFamily: "Oswald")),
                                    const SizedBox(height: 6),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextFormField(
                                        controller: _nameController,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Oswald",
                                          color: Colors.black,
                                        ),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 22),
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) =>
                                            value == null || value.isEmpty
                                                ? "Enter customer name"
                                                : null,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("PHONE NUMBER",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54,
                                            fontFamily: "Oswald")),
                                    const SizedBox(height: 6),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextFormField(
                                        controller: _phoneController,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Oswald",
                                          color: Colors.black,
                                        ),
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 22),
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Enter phone number";
                                          } else if (!RegExp(r'^\d{10,15}$')
                                              .hasMatch(value)) {
                                            return "Enter a valid phone number";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 80),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("SELECT A TIME SLOT",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontFamily: "Oswald")),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedTime,
                                    isExpanded: true,
                                    isDense: true,
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    decoration: const InputDecoration.collapsed(
                                        hintText: "Select time"),
                                    items: timeSlots
                                        .where((t) => !bookedSlots.contains(t))
                                        .map((t) => DropdownMenuItem(
                                              value: t,
                                              child: Text(t,
                                                  style: const TextStyle(
                                                    fontFamily: "Oswald",
                                                    fontSize: 20,
                                                  )),
                                            ))
                                        .toList(),
                                    onChanged: (newTime) =>
                                        setState(() => _selectedTime = newTime),
                                    validator: (val) => val == null
                                        ? "Please select a time"
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: 220,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("SUBMIT BOOKING",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Oswald",
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
