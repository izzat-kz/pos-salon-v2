import 'package:flutter/material.dart';
import '../../models/staff_model.dart';
import '../../services/admin/staff_crud.dart';
import '../../utils/validators.dart';
import '../../services/loan_crud.dart';
import '../../services/admin/inv_crud.dart';
import '../../services/db_helper.dart';

// ⚙️ Add Staff Popup
Future<void> showAddStaffPopup({
  required BuildContext context,
  required int nextId,
  required VoidCallback onSaved,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  await showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: const Color(0xFFFDF7F0),
      shape: RoundedRectangleBorder(
        // side: const BorderSide(color: Color(0xFF00B25D), width: 4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 520,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Form(
          key: formKey,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ⬅️ Left column: Compact fields
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Add New Staff",
                        style: const TextStyle(
                          fontFamily: "Oswald",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 42,
                        child: TextFormField(
                          initialValue: nextId.toString(),
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "ID",
                            labelStyle: const TextStyle(fontFamily: "Oswald"),
                            filled: true,
                            fillColor: Colors.grey[300],
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 42,
                        child: TextFormField(
                          controller: nameController,
                          validator: validateStaffName,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(fontFamily: "Oswald"),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return SizedBox(
                            height: 42,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: !showPassword,
                              validator: validateStaffPassword,
                              decoration: InputDecoration(
                                labelText: "Pass",
                                labelStyle:
                                    const TextStyle(fontFamily: "Oswald"),
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // ➡️ Right column: Square buttons stacked tall
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await StaffService.insertStaff(Staff(
                                id: nextId,
                                name: nameController.text.trim(),
                                password: passwordController.text.trim(),
                              ));
                              onSaved();
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A163),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Center(
                            child: Text(
                              "Confirm Add",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Oswald",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade700,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: "Oswald",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

// ⚙️ Edit Staff Popup
Future<void> showEditStaffPopup({
  required BuildContext context,
  required Staff staff,
  required VoidCallback onSaved,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: staff.name);
  final passwordController = TextEditingController(text: staff.password);
  bool showPassword = false;

  await showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: const Color(0xFFFDF7F0),
      shape: RoundedRectangleBorder(
        // side: const BorderSide(color: Color.fromARGB(255, 0, 136, 178), width: 4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 520,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
        child: Form(
          key: formKey,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ⬅️ Left column: Fields
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Edit Staff",
                        style: const TextStyle(
                          fontFamily: "Oswald",
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ID field (read-only)
                      SizedBox(
                        height: 42,
                        child: TextFormField(
                          initialValue: staff.id.toString(),
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "ID",
                            labelStyle: const TextStyle(fontFamily: "Oswald"),
                            filled: true,
                            fillColor: Colors.grey[300],
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Name field
                      SizedBox(
                        height: 42,
                        child: TextFormField(
                          controller: nameController,
                          validator: validateStaffName,
                          decoration: const InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(fontFamily: "Oswald"),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Password field
                      StatefulBuilder(
                        builder: (context, setState) {
                          return SizedBox(
                            height: 42,
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: !showPassword,
                              validator: validateStaffPassword,
                              decoration: InputDecoration(
                                labelText: "Pass",
                                labelStyle:
                                    const TextStyle(fontFamily: "Oswald"),
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // ➡️ Right column: Action buttons
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await StaffService.updateStaff(Staff(
                                id: staff.id,
                                name: nameController.text.trim(),
                                password: passwordController.text.trim(),
                              ));
                              onSaved();
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 98, 178),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Center(
                            child: Text(
                              "Save Changes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Oswald",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await StaffService.deleteStaff(staff.id);
                            onSaved();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Center(
                            child: Text(
                              "Remove Staff",
                              style: TextStyle(
                                fontFamily: "Oswald",
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

typedef OnSaveItem = Future<void> Function(
  String name,
  String category,
  List<Map<String, dynamic>> options,
);
typedef OnDeleteItem = Future<void> Function();
Future<void> showMinOptionsPopup(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.red.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text(
        "Deletion Restricted",
        style: TextStyle(
            fontFamily: "Oswald",
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
      content: const Text(
        "Each item type must have at least one option.\n\nYou cannot remove the last sub-item.",
        style: TextStyle(
            fontFamily: "Oswald", fontSize: 18, color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK",
              style: TextStyle(
                  fontFamily: "Oswald",
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ],
    ),
  );
}

Future<void> attemptDeleteItemOption(
    BuildContext context, int itemOptionId, int itemId) async {
  final db = await DBHelper().database;

  // TO DO: Check if THIS item option is linked to an active loan
  final List<Map<String, dynamic>> loans = await db.rawQuery(
    '''
  SELECT loan_id FROM loan WHERE item_option_id = ?
  ''',
    [itemOptionId],
  );

  if (loans.isNotEmpty) {
    showLoanRestrictionPopup(
        context, loans.map((loan) => loan['loan_id'].toString()).toList());
    return; // TO DO: Stop deletion if tied to a loan
  }

// TO DO: Proceed with deletion ONLY if the item option itself is NOT tied to a loan
  await db.delete(
    'item_option',
    where: 'sub_id = ?',
    whereArgs: [itemOptionId],
  );
}

Future<void> showLoanRestrictionPopup(
    BuildContext context, List<String> loanIds) async {
  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.red.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: const Text(
        "Modification Restricted",
        style: TextStyle(
            fontFamily: "Oswald",
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold),
      ),
      content: Text(
        "This item is tied to active loans:\n\n${loanIds.join(', ')}\n\nIt cannot be deleted or have its price changed until the loans are settled.",
        style: const TextStyle(
            fontFamily: "Oswald", fontSize: 18, color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK",
              style: TextStyle(
                  fontFamily: "Oswald",
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ],
    ),
  );
}

// ⚙️ Add Item Popup
class InventoryPopups {
  static Widget buildPendingInput(
    void Function(void Function()) setState,
    List<Map<String, dynamic>> itemOptions,
    TextEditingController subItemNameController,
    TextEditingController subItemPriceController,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: subItemNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: "Sub Item",
                  labelStyle: TextStyle(fontFamily: "Oswald"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: subItemPriceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Price (RM)",
                  labelStyle: TextStyle(fontFamily: "Oswald"),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 6),
            ElevatedButton(
              onPressed: () {
                final name = subItemNameController.text.trim();
                final price = subItemPriceController.text.trim();

                if (name.isEmpty || price.isEmpty) return;

                setState(() {
                  itemOptions.add({"name": name, "price": price});
                  subItemNameController.clear();
                  subItemPriceController.clear();
                });
              },
              child: const Icon(Icons.add, size: 20, color: Colors.white),
            ),
          ],
        ),
      );

  static void showAddItemPopup({
    required BuildContext context,
    required String category,
    required OnSaveItem onSave,
  }) {
    final itemController = TextEditingController();
    final subItemNameController = TextEditingController();
    final subItemPriceController = TextEditingController();
    List<Map<String, String>> itemOptions = [];

    bool isPendingRowActive() =>
        subItemNameController.text.trim().isNotEmpty ||
        subItemPriceController.text.trim().isNotEmpty;

    String capitalizeEachWord(String text) {
      return text
          .split(' ')
          .map((word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: const Color(0xFFFDF7F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Color(0xFF00B25D), width: 4),
          ),
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Add $category Type",
                    style: const TextStyle(
                      fontFamily: "Oswald",
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Item Name
                  TextField(
                    controller: itemController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
                      labelStyle: TextStyle(fontFamily: "Oswald"),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Divider(),

                  ...itemOptions.map((opt) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                readOnly: true,
                                controller:
                                    TextEditingController(text: opt['name']),
                                decoration: const InputDecoration(
                                  labelText: "Sub Item",
                                  labelStyle: TextStyle(fontFamily: "Oswald"),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                controller:
                                    TextEditingController(text: opt['price']),
                                decoration: const InputDecoration(
                                  labelText: "Price (RM)",
                                  prefixText: "RM ",
                                  labelStyle: TextStyle(fontFamily: "Oswald"),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: subItemNameController,
                            onChanged: (val) => setState(() {}),
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: "Sub Item",
                              labelStyle: TextStyle(fontFamily: "Oswald"),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: subItemPriceController,
                            onChanged: (val) => setState(() {}),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Price (RM)",
                              prefixText: "RM ",
                              labelStyle: TextStyle(fontFamily: "Oswald"),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (!isPendingRowActive())
                          const SizedBox(width: 42)
                        else
                          SizedBox(
                            width: 42,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () {
                                final name = subItemNameController.text.trim();
                                final price =
                                    subItemPriceController.text.trim();

                                final nameError =
                                    InventoryValidators.validateOptionName(
                                        name);
                                final priceError =
                                    InventoryValidators.validatePrice(price);

                                if (nameError != null || priceError != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(nameError ??
                                            priceError ??
                                            "Invalid sub item")),
                                  );
                                  return;
                                }

                                setState(() {
                                  itemOptions.add({
                                    'name': capitalizeEachWord(name),
                                    'price': price,
                                  });
                                  subItemNameController.clear();
                                  subItemPriceController.clear();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: const Color(0xFF00B25D),
                              ),
                              child: const Icon(Icons.add,
                                  size: 22, color: Colors.black),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save All Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = itemController.text.trim();
                        final nameError =
                            InventoryValidators.validateItemName(name);

                        if (nameError != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(nameError)),
                          );
                          return;
                        }

                        if (itemOptions.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Add at least one sub item.")),
                          );
                          return;
                        }

                        final options = itemOptions
                            .map((e) => {
                                  'name': e['name'],
                                  'price':
                                      double.tryParse(e['price'] ?? '0') ?? 0.0,
                                })
                            .toList();

                        await onSave(
                            capitalizeEachWord(name), category, options);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007A50),
                      ),
                      child: const Text(
                        "Save All",
                        style: TextStyle(
                          fontFamily: "Oswald",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ⚙️ Edit Item Popup
  static void showEditItemPopup({
    required BuildContext context,
    required int itemId,
    required String initialName,
    required String initialCategory,
    required List<Map<String, dynamic>> itemOptions,
    required OnSaveItem onSave,
    required OnDeleteItem onDelete,
  }) async {
    final itemNameController = TextEditingController(text: initialName);
    String selectedCategory = initialCategory;

    final nameControllers = itemOptions
        .map((opt) => TextEditingController(text: opt['name']))
        .toList();
    final priceControllers = itemOptions
        .map((opt) => TextEditingController(
            text: (opt['price'] as num).toStringAsFixed(2)))
        .toList();
    final subItemNameController = TextEditingController();
    final subItemPriceController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: const Color(0xFFFDF7F0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Color(0xFF00B25D), width: 4),
            ),
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Edit Item & Options",
                      style: TextStyle(
                          fontFamily: "Oswald",
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Item Name
                    TextField(
                      controller: itemNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: "Item Name",
                        labelStyle: TextStyle(fontFamily: "Oswald"),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        labelStyle: TextStyle(fontFamily: "Oswald"),
                        border: OutlineInputBorder(),
                      ),
                      items: ["Services", "Products"]
                          .map((cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Divider(),

                    // Item Options with Delete Button
                    ...itemOptions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final itemOptionId = itemOptions[index]['item_id'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: nameControllers[index],
                                textCapitalization: TextCapitalization.words,
                                decoration: const InputDecoration(
                                  labelText: "Sub Item",
                                  labelStyle: TextStyle(fontFamily: "Oswald"),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: priceControllers[index],
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                decoration: const InputDecoration(
                                  labelText: "Price (RM)",
                                  labelStyle: TextStyle(fontFamily: "Oswald"),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Delete Button
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () async {
                                if (itemOptions.length > 1) {
                                  setState(() {
                                    itemOptions.removeAt(index);
                                    nameControllers.removeAt(index);
                                    priceControllers.removeAt(index);
                                  });
                                  await InventoryService.deleteItemOption(
                                      itemOptionId);
                                } else {
                                  showMinOptionsPopup(context);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: subItemNameController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: "Sub Item",
                                labelStyle: TextStyle(fontFamily: "Oswald"),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: subItemPriceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Price (RM)",
                                labelStyle: TextStyle(fontFamily: "Oswald"),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          ElevatedButton(
                            onPressed: () {
                              final name = subItemNameController.text.trim();
                              final price = subItemPriceController.text.trim();

                              if (name.isEmpty || price.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Sub-item name and price cannot be empty")),
                                );
                                return;
                              }

                              setState(() {
                                itemOptions.add({'name': name, 'price': price});
                                nameControllers
                                    .add(TextEditingController(text: name));
                                priceControllers
                                    .add(TextEditingController(text: price));
                                subItemNameController.clear();
                                subItemPriceController.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00B25D)),
                            child: const Icon(Icons.add,
                                size: 22, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Save Changes Button
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: const Color(0xFF46303C),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  title: const Text(
                                    "Delete Item",
                                    style: TextStyle(
                                        fontFamily: "Oswald",
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  content: const Text(
                                    "Are you sure you want to delete this item?",
                                    style: TextStyle(
                                        fontFamily: "Oswald",
                                        fontSize: 18,
                                        color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel",
                                          style: TextStyle(
                                              fontFamily: "Oswald",
                                              color: Colors.white)),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        await onDelete();
                                      },
                                      child: const Text("Delete",
                                          style: TextStyle(
                                              fontFamily: "Oswald",
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700),
                            child: const Text("Delete Item",
                                style: TextStyle(
                                    fontFamily: "Oswald",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final updatedOptions =
                                  List<Map<String, dynamic>>.generate(
                                itemOptions.length,
                                (index) => {
                                  'name': nameControllers[index].text.trim(),
                                  'price': priceControllers[index].text.trim(),
                                  'item_id': itemOptions[index]['item_id'],
                                },
                              );

                              await onSave(
                                itemNameController.text.trim(),
                                selectedCategory,
                                updatedOptions,
                              );

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00A163)),
                            child: const Text("Save Changes",
                                style: TextStyle(
                                    fontFamily: "Oswald",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
