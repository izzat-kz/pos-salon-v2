import 'package:flutter/material.dart';
import '../../styles/text_styles.dart';
import '../../widgets/left_sidebar.dart';
import '../../widgets/admin/popups.dart';
import '../../services/admin/inv_crud.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<Map<String, dynamic>> _items = [];
  bool showServices = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final result = await InventoryService.getItemsByCategory(
        showServices ? 'Services' : 'Products');
    setState(() {
      _items = result;
    });
  }

  void _openAddPopup() {
    InventoryPopups.showAddItemPopup(
      context: context,
      category: showServices ? 'Services' : 'Products',
      onSave: (name, category, options) async {
        await InventoryService.addItemWithOptions(
          name: name,
          category: category,
          itemOptions: options,
        );
        _loadItems();
      },
    );
  }

  void _openEditPopup(Map<String, dynamic> item) async {
    final itemId = item['item_id'];
    final itemOptions = await InventoryService.getItemOptions(itemId);

    InventoryPopups.showEditItemPopup(
      context: context,
      initialName: item['name'],
      initialCategory: item['category'],
      itemOptions: itemOptions,
      onDelete: () async {
        await InventoryService.deleteItem(itemId);
        _loadItems();
      },
      onSave: (name, category, updatedOptions) async {
        await InventoryService.updateItemWithOptions(
          itemId: itemId,
          name: name,
          category: category,
          itemOptions: updatedOptions,
        );
        _loadItems();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int columns = 4;

    return Scaffold(
      backgroundColor: Color(0xFFD5D5D5),
      body: Row(
        children: [
          LeftSidebar(isAdmin: true),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("Inventory", style: AppTextStyles.title),
                ),
                ToggleButtons(
                  isSelected: [showServices, !showServices],
                  onPressed: (index) {
                    setState(() {
                      showServices = index == 0;
                      _loadItems();
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
                SizedBox(height: 20),
                Divider(thickness: 2),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: columns,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: EdgeInsets.all(10),
                    children: [
                      GestureDetector(
                        onTap: _openAddPopup,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: Colors.black45,
                              style: BorderStyle.solid,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '+',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ..._items.map((item) {
                        return GestureDetector(
                          onTap: () => _openEditPopup(item),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                            color: Color(0xFF3F3E3A),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
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
