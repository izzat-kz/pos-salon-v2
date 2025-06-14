import 'package:flutter/material.dart';
import '../models/item_catalog.dart';
import '../services/bill_service.dart';
import '../services/db_helper.dart';
import '../widgets/popups.dart';
import 'payment_option.dart';
import '../utils/validators.dart';
import '../styles/button_styles.dart';
import '../styles/text_styles.dart';
import '../widgets/left_sidebar.dart';
import '../widgets/staff_badge.dart';
import '../utils/session.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> itemTypes = [];
  List<Item> services = [];
  List<Item> products = [];

  @override
  void initState() {
    super.initState();
    loadItemTypes();
  }

  void loadItemTypes() async {
    final db = await DBHelper().database;
    final result = await db.query('item_type');
    setState(() {
      itemTypes = result;
    });
  }

  bool showServices = true;

  void updateQuantity(Item option, int change) {
    setState(() {
      BillService.updateQuantity(option, change);
    });
  }

  Future<void> _showSubItemPopup(Map<String, dynamic> item) async {
    final db = await DBHelper().database;
    final result = await db.query(
      'item_option',
      where: 'item_id = ?',
      whereArgs: [item['item_id']],
    );

    final options = result
        .map((row) => Item(
              id: row['sub_id'] as int,
              name: row['name'].toString(),
              price: (row['price'] as num).toDouble(),
              parentItemName: item['name'].toString(),
              category: item['category'] == 'Services'
                  ? ItemCategory.service
                  : ItemCategory.product,
            ))
        .toList();

    showDialog(
      context: context,
      builder: (_) => SubItemPopup(
        itemName: item['name'],
        options: options,
        onOptionAdded: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final currentStaff = Session.currentStaff;
    // final bill = BillService.bill.entries.toList().reversed.toList();

    return Scaffold(
      backgroundColor: Color(0xFFD5D5D5),
      body: Row(
        children: [
          // ⏹️ LEFT SIDEBAR
          LeftSidebar(),

          // ⏹️ MENU AREA
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 6),
                // Padding(
                //   padding: const EdgeInsets.only(left: 16.0),
                //   child: Session.currentStaff != null
                //       ? StaffBadge(staff: Session.currentStaff!)
                //       : SizedBox.shrink(),
                // ),
                const SizedBox(height: 24),

                Center(
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
                    children: itemTypes
                        .where((item) =>
                            item['category'] ==
                            (showServices ? 'Services' : 'Products'))
                        .map((item) {
                      return GestureDetector(
                        onTap: () => _showSubItemPopup(item),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          color: Color(0xFF3F3E3A),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(item['name'],
                                    style: TextStyle(
                                        fontFamily: "Oswald",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                        color: Colors.white),
                                    textAlign: TextAlign.center),
                                SizedBox(height: 6),
                                Text("Tap to view options",
                                    style: TextStyle(
                                        color: Colors.white54, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // ⏹️ DIVIDER
          Container(
            width: 2,
            color: Colors.black54,
            margin: EdgeInsets.symmetric(vertical: 12),
          ),

          // ⏹️ BILLS PANEL (Grouped by item_type)
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
                      final option = entry.key;
                      final quantity = entry.value;
                      return Card(
                        color: Color(0xFF46303C),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option.parentItemName,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      option.name,
                                      style: TextStyle(
                                        fontFamily: "Oswald",
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "RM ${(option.price * quantity).toStringAsFixed(2)}",
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
                                              updateQuantity(option, -1),
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
                                              updateQuantity(option, 1),
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
                            color: Colors.white,
                          ),
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
