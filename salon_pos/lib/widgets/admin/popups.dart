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

// ⚙️ Add Item Popup
class InventoryPopups {
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

                // ➕ Inline pending input
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
                        const SizedBox(width: 42) // space holder
                      else
                        SizedBox(
                          width: 42,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () {
                              final name = subItemNameController.text.trim();
                              final price = subItemPriceController.text.trim();

                              final nameError =
                                  InventoryValidators.validateOptionName(name);
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
                            child: const Icon(Icons.add, size: 22, color: Colors.black),
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
                          const SnackBar(content: Text("Add at least one sub item.")),
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

                      await onSave(capitalizeEachWord(name), category, options);
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
  required String initialName,
  required String initialCategory,
  required List<Map<String, dynamic>> itemOptions,
  required OnSaveItem onSave,
  required OnDeleteItem onDelete,
}) {
  final itemNameController = TextEditingController(text: initialName);
  String selectedCategory = initialCategory;

  final nameControllers = itemOptions
      .map((opt) => TextEditingController(text: opt['name']))
      .toList();

  final priceControllers = itemOptions
      .map((opt) => TextEditingController(
            text: (opt['price'] as num).toStringAsFixed(2),
          ))
      .toList();

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
      builder: (context, setState) {
        void addOption() {
          setState(() {
            itemOptions.add({'name': '', 'price': 0.0});
            nameControllers.add(TextEditingController());
            priceControllers.add(TextEditingController());
          });
        }

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
                      fontWeight: FontWeight.bold,
                    ),
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

                  // Category
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Category",
                      labelStyle: TextStyle(fontFamily: "Oswald"),
                      border: OutlineInputBorder(),
                    ),
                    items: ["Services", "Products"]
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  const Divider(),

                  ...itemOptions.asMap().entries.map((entry) {
                    final index = entry.key;
                    return Column(
                      children: [
                        Row(
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
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: "Price (RM)",
                                  labelStyle: TextStyle(fontFamily: "Oswald"),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  itemOptions.removeAt(index);
                                  nameControllers.removeAt(index);
                                  priceControllers.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),

                  TextButton.icon(
                    onPressed: addOption,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Sub Item",
                        style: TextStyle(fontFamily: "Oswald")),
                  ),
                  const SizedBox(height: 10),

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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: const Text(
                                  "Delete Item",
                                  style: TextStyle(
                                    fontFamily: "Oswald",
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                content: const Text(
                                  "Are you sure you want to delete this item?",
                                  style: TextStyle(
                                    fontFamily: "Oswald",
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
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
                                      Navigator.pop(context); // confirm
                                      Navigator.pop(context); // dialog
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
                            backgroundColor: Colors.red.shade700,
                          ),
                          child: const Text(
                            "Delete Item",
                            style: TextStyle(
                              fontFamily: "Oswald",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final name = itemNameController.text.trim();
                            final nameError = InventoryValidators.validateItemName(name);
                            if (nameError != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(nameError)),
                              );
                              return;
                            }

                            if (itemOptions.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Include at least one sub item.")),
                              );
                              return;
                            }

                            for (int i = 0; i < itemOptions.length; i++) {
                              final subName = nameControllers[i].text.trim();
                              final subPrice = priceControllers[i].text.trim();

                              final nameError = InventoryValidators.validateOptionName(subName);
                              final priceError = InventoryValidators.validatePrice(subPrice);

                              if (nameError != null || priceError != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          nameError ?? priceError ?? "Invalid input")),
                                );
                                return;
                              }

                              itemOptions[i]['name'] = capitalizeEachWord(subName);
                              itemOptions[i]['price'] =
                                  double.tryParse(subPrice) ?? 0.0;
                            }

                            await onSave(
                              capitalizeEachWord(name),
                              selectedCategory,
                              itemOptions,
                            );
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A163),
                          ),
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontFamily: "Oswald",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
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
