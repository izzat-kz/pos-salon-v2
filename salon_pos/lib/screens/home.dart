import 'package:flutter/material.dart';
import 'dart:io';
import '../models/item_catalog.dart';
import '../services/bill_service.dart';
import 'receipt.dart';
import 'payment_option.dart';
import '../utils/validators.dart';
import '../widgets/popups.dart';
import '../styles/button_styles.dart';
import '../styles/text_styles.dart';
import 'loan_list.dart';
import '../widgets/left_sidebar.dart';

class HomeMenuScreen extends StatefulWidget {
  @override
  _HomeMenuScreenState createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  List<Item> services = ItemCatalog.services;
  List<Item> products = ItemCatalog.products;
  Map<Item, int> bill = {};
  bool showServices = true;

  void addToBill(Item item) {
    setState(() {
      BillService.addToBill(item);
    });
  }

  void updateQuantity(Item item, int change) {
    setState(() {
      BillService.updateQuantity(item, change);
    });
  }

  double subtotal = BillService.calculateSubtotal();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD5D5D5),
      body: Row(
        children: [
          /* ⏹️ Left Sidebar */
          LeftSidebar(),

          /* ⏹️ Menu Area */
          Expanded(
            flex: 1,
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ToggleButtons(
                    isSelected: [showServices, !showServices],
                    onPressed: (index) {
                      setState(() {
                        showServices = index == 0;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    color: Colors.black54,
                    fillColor: Colors.pink,
                    disabledColor: Color(0xFF3F3E3A),
                    constraints: BoxConstraints.expand(width: 120, height: 40),
                    children: [
                      Text("Services", style: TextStyle(fontSize: 16)),
                      Text("Products", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: (showServices ? services : products).map((item) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        color: Color(0xFF3F3E3A),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(item.name,
                                  style: TextStyle(
                                      fontFamily: "Oswald",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.white),
                                  textAlign: TextAlign.center),
                              SizedBox(height: 6),
                              Text("RM ${item.price.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              SizedBox(height: 33),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFEF3A5D),
                                    minimumSize: Size(double.infinity, 65),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                child: Text("ADD",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                                onPressed: () => addToBill(item),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          /* ⏹️ Vertical Divider */
          Container(
            width: 2,
            color: Colors.black54,
            margin: EdgeInsets.symmetric(vertical: 12),
          ),

          /* ⏹️ Bills Panel */
          Container(
            width: 350,
            color: Color(0xFFD5D5D5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Bills",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Divider(thickness: 2),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    children:
                        BillService.bill.entries.toList().reversed.map((entry) {
                      final item = entry.key;
                      final quantity = entry.value;
                      return Card(
                        color: Color(0xFF46303C),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontFamily: "Oswald",
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "RM ${(item.price * quantity).toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontFamily: "Oswald",
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFD5D5D5),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        alignment: Alignment.center,
                                        child: IconButton(
                                          icon: Icon(Icons.remove,
                                              size: 18, color: Colors.black),
                                          onPressed: () =>
                                              updateQuantity(item, -1),
                                          constraints: BoxConstraints(
                                              maxWidth: 30, maxHeight: 30),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "$quantity",
                                        style: TextStyle(
                                          fontFamily: "Oswald",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        alignment: Alignment.center,
                                        child: IconButton(
                                          icon: Icon(Icons.add,
                                              size: 18, color: Colors.white),
                                          onPressed: () =>
                                              updateQuantity(item, 1),
                                          constraints: BoxConstraints(
                                              maxWidth: 30, maxHeight: 30),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 10),

                /* ⏹️ Clear bill button */
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      BillService.clearBill();
                    });
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text("Clear Bill", style: AppTextStyles.buttonText),
                  style: AppButtonStyles.clearBillButton,
                ),
                Divider(thickness: 2),
                Card(
                  color: Color(0xFF46303C),
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          "Subtotal: RM ${BillService.calculateSubtotal().toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (isBillEmpty(BillService.bill)) {
                              popupEmtpyBill(context, "Bill Is Empty",
                                  "Please add something before proceeding.");
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentOptionsScreen(
                                    totalAmount:
                                        BillService.calculateSubtotal(),
                                    bill: BillService.bill,
                                  ),
                                ),
                              );
                            }
                          },
                          style: AppButtonStyles.confirmButton,
                          child: Text("Confirm Bills",
                              style: AppTextStyles.buttonText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
