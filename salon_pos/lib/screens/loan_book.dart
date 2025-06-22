import 'package:flutter/material.dart';
import '../services/loan_crud.dart';
import '../models/loan_model.dart';
import '../services/bill_service.dart';
import 'loan_list.dart';
import 'package:intl/intl.dart';
import '../widgets/popups.dart';
import '../styles/button_styles.dart';
import '../utils/validators.dart';
import '../services/db_helper.dart';

class LoanBookScreen extends StatefulWidget {
  final double totalAmount;
  final int customerPax;

  const LoanBookScreen({
    Key? key,
    required this.totalAmount,
    required this.customerPax,
  }) : super(key: key);

  @override
  _LoanBookScreenState createState() => _LoanBookScreenState();
}

class _LoanBookScreenState extends State<LoanBookScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _icController = TextEditingController();

  String? _icError;
  String? _nameError;
  String? _addressError;
  String? _phoneError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _icController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    setState(() {
      _nameError = Validators.validateName(_nameController.text);
      _addressError = Validators.validateAddress(_addressController.text);
      _phoneError = Validators.validatePhone(_phoneController.text);
      _icError = Validators.validateIC(_icController.text);
    });

    return _nameError == null &&
        _addressError == null &&
        _phoneError == null &&
        _icError == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFD5D5D5),
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
              "LOAN BOOK",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: "Oswald",
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 60),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ⏹️ LEFT SIDE
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              // NAME
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text("CUSTOMER NAME",
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
                                      border: Border.all(
                                          color: _nameError != null
                                              ? Colors.red
                                              : Colors.transparent,
                                          width: 2),
                                    ),
                                    child: TextField(
                                      controller: _nameController,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Oswald",
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 22),
                                        border: InputBorder.none,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _nameError =
                                              Validators.validateName(value);
                                        });
                                      },
                                    ),
                                  ),
                                  if (_nameError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6, left: 6),
                                      child: Text(
                                        _nameError!,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 16),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 40),

                              Row(
                                children: [
                                  // IC Number
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text("IC NUMBER",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontFamily: "Oswald")),
                                        const SizedBox(height: 6),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: _icError != null
                                                    ? Colors.red
                                                    : Colors.transparent,
                                                width: 2),
                                          ),
                                          child: TextField(
                                            controller: _icController,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Oswald",
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 22),
                                              border: InputBorder.none,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _icError =
                                                    Validators.validateIC(
                                                        value);
                                              });
                                            },
                                          ),
                                        ),
                                        if (_icError != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6, left: 6),
                                            child: Text(
                                              _icError!,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),

                                  // Phone Number
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                                color: _phoneError != null
                                                    ? Colors.red
                                                    : Colors.transparent,
                                                width: 2),
                                          ),
                                          child: TextField(
                                            controller: _phoneController,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Oswald",
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 22),
                                              border: InputBorder.none,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 2,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _phoneError =
                                                    Validators.validatePhone(
                                                        value);
                                              });
                                            },
                                          ),
                                        ),
                                        if (_phoneError != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6, left: 6),
                                            child: Text(
                                              _phoneError!,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 80),

                        // ⏹️ RIGHT SIDE
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("CUSTOMER ADDRESS",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                      fontFamily: "Oswald")),
                              const SizedBox(height: 6),
                              Container(
                                width: 450,
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: _addressError != null
                                          ? Colors.red
                                          : Colors.transparent,
                                      width: 2),
                                ),
                                child: TextField(
                                  controller: _addressController,
                                  maxLines: 3,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Oswald",
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _addressError =
                                          Validators.validateAddress(value);
                                    });
                                  },
                                ),
                              ),
                              if (_addressError != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 6, left: 6),
                                  child: Text(
                                    _addressError!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 16),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              const Text("TOTAL",
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black54,
                                      fontFamily: "Oswald")),
                              const SizedBox(height: 6),
                              Text(
                                "RM ${widget.totalAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Oswald"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ⏹️ BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6E6E6E),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 75, vertical: 28),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("CANCEL",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Oswald",
                                color: Colors.black)),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_validateInputs()) {
                            final name = _nameController.text;
                            final phone = _phoneController.text;
                            final address = _addressController.text;
                            final icNumber = _icController.text;

                            final billItems = BillService.bill.map(
                                (item, quantity) =>
                                    MapEntry(item.id.toString(), quantity));

                            final String dateTime =
                                DateFormat('dd/MM/yyyy hh:mma')
                                    .format(DateTime.now());
                            final String loanId = "LN" +
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString()
                                    .substring(7);

                            LoanService.addLoan(
                              Loan(
                                id: loanId,
                                name: name,
                                phone: phone,
                                address: address,
                                totalAmount: widget.totalAmount,
                                billItems: billItems.map((key, value) =>
                                    MapEntry(int.tryParse(key) ?? 0, value)),
                                dateTime: dateTime,
                                customerPax: widget.customerPax,
                                icNumber: icNumber,
                              ),
                            );

                            BillService.clearBill();

                            showLoanSuccessPopup(context, () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoanListScreen()),
                              );
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF8C42),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 75, vertical: 28),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("SUBMIT LOAN",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Oswald",
                                color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
