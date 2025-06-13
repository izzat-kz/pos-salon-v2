import 'package:flutter/material.dart';
import '../../models/staff_model.dart';
import '../../services/admin/staff_crud.dart';
import '../../utils/validators.dart';

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
                              "Add New Staff",
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
      backgroundColor: const Color(0xFFFFEAD1),
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

// ⚙️ Add Item Popup
class InventoryPopups {
  static void showAddItemPopup({
    required BuildContext context,
    required String category,
    required OnSaveItem onSave,
  }) {
    final itemController = TextEditingController();
    final optionNameController = TextEditingController();
    final optionPriceController = TextEditingController();
    List<Map<String, String>> itemOptions = [];

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
        builder: (context, setState) => AlertDialog(
          title: Text('Add $category Type'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: itemController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                Divider(),
                ...itemOptions.map((s) => ListTile(
                      title: Text(s['name'] ?? ''),
                      subtitle: Text("RM ${s['price']}"),
                    )),
                TextField(
                  controller: optionNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: 'Sub Item Name'),
                ),
                TextField(
                  controller: optionPriceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Sub Item Price'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final name = optionNameController.text.trim();
                final price = optionPriceController.text.trim();

                final nameError = InventoryValidators.validateOptionName(name);
                final priceError = InventoryValidators.validatePrice(price);

                if (nameError != null || priceError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(nameError ?? priceError ?? "Invalid input")),
                  );
                  return;
                }

                setState(() {
                  itemOptions.add({
                    'name': capitalizeEachWord(name),
                    'price': price,
                  });
                  optionNameController.clear();
                  optionPriceController.clear();
                });
              },
              child: Text('Add Sub Item'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = itemController.text.trim();
                final nameError = InventoryValidators.validateItemName(name);

                if (nameError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(nameError)),
                  );
                  return;
                }

                if (itemOptions.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Please add at least one sub item.")),
                  );
                  return;
                }

                final options = itemOptions
                    .map((e) => {
                          'name': e['name'],
                          'price': double.tryParse(e['price'] ?? '0') ?? 0.0,
                        })
                    .toList();

                await onSave(capitalizeEachWord(name), category, options);
                Navigator.pop(context);
              },
              child: Text('Save All'),
            ),
          ],
        ),
      ),
    );
  }

// ⚙️ Edit Item Popup
  static void showEditItemPopup({
    required BuildContext context,
    required String initialName,
    required String initialCategory,
    required List<Map<String, dynamic>> itemOptions,
    required OnSaveItem onSave,
    required OnDeleteItem onDelete,
  }) {
    final itemNameController = TextEditingController(text: initialName);
    String selectedCategory = initialCategory;

    String capitalizeEachWord(String text) {
      return text
          .split(' ')
          .map((word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }

    // Syncing controllers
    final nameControllers = itemOptions
        .map((opt) => TextEditingController(text: opt['name']))
        .toList();

    final priceControllers = itemOptions
        .map((opt) => TextEditingController(
              text: (opt['price'] as num).toStringAsFixed(2),
            ))
        .toList();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          void addOption() {
            setState(() {
              itemOptions.add({'name': '', 'price': 0.0});
              nameControllers.add(TextEditingController());
              priceControllers.add(TextEditingController());
            });
          }

          return AlertDialog(
            scrollable: true,
            title: Text("Edit Item & Options"),
            content: Column(
              children: [
                TextField(
                  controller: itemNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(labelText: "Item Name"),
                ),
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => selectedCategory = val);
                    }
                  },
                  items: ["Services", "Products"]
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                ),
                Divider(),
                ...itemOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  return ListTile(
                    title: TextField(
                      controller: nameControllers[index],
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(labelText: "Sub Item Name"),
                    ),
                    subtitle: TextField(
                      controller: priceControllers[index],
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: "Price (RM)"),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          itemOptions.removeAt(index);
                          nameControllers.removeAt(index);
                          priceControllers.removeAt(index);
                        });
                      },
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: addOption,
                  icon: Icon(Icons.add),
                  label: Text("Add Sub Item"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await onDelete();
                  Navigator.pop(context);
                },
                child: Text("Delete Item", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () async {
                  final name = itemNameController.text.trim();
                  final nameError = InventoryValidators.validateItemName(name);

                  if (nameError != null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(nameError)));
                    return;
                  }

                  if (itemOptions.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Please include at least one sub item.")),
                    );
                    return;
                  }

                  // Sync controller data back into itemOptions and validate
                  for (int i = 0; i < itemOptions.length; i++) {
                    final subName = nameControllers[i].text.trim();
                    final subPrice = priceControllers[i].text.trim();

                    final nameError =
                        InventoryValidators.validateOptionName(subName);
                    final priceError =
                        InventoryValidators.validatePrice(subPrice);

                    if (nameError != null || priceError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                nameError ?? priceError ?? "Invalid input")),
                      );
                      return;
                    }

                    itemOptions[i]['name'] = capitalizeEachWord(subName);
                    itemOptions[i]['price'] = double.tryParse(subPrice) ?? 0.0;
                  }

                  await onSave(
                    capitalizeEachWord(name),
                    selectedCategory,
                    itemOptions,
                  );
                  Navigator.pop(context);
                },
                child: Text("Save Changes"),
              ),
            ],
          );
        },
      ),
    );
  }
}
