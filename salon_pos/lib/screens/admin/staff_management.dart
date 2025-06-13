import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../styles/text_styles.dart';
import '../../widgets/left_sidebar.dart';
import '../../services/admin/staff_crud.dart';
import '../../models/staff_model.dart';
import '../../widgets/admin/popups.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  List<Staff> _staffList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final staff = await StaffService.getAllStaff();
    setState(() {
      _staffList = staff;
      _isLoading = false;
    });
  }

  void _handleAddStaff() async {
    final staffList = await StaffService.getAllStaff();
    final nextId = (staffList.isNotEmpty
            ? staffList.map((s) => s.id).reduce((a, b) => a > b ? a : b)
            : 3000) +
        1;

    showAddStaffPopup(
      context: context,
      nextId: nextId,
      onSaved: _loadStaff, // reload staff list after save
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5D5D5),
      body: Row(
        children: [
          const LeftSidebar(isAdmin: true),
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Staff Management", style: AppTextStyles.title),
                ),
                const Divider(thickness: 2),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 4.7,
                          ),
                          itemCount: _staffList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GestureDetector(
                                onTap: _handleAddStaff,
                                child: DottedBorder(
                                  color: Colors.grey.shade700,
                                  strokeWidth: 3,
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: [8, 6],
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontFamily: "Oswald",
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final staff = _staffList[index - 1];
                            return GestureDetector(
                              onTap: () {
                                showEditStaffPopup(
                                  context: context,
                                  staff: staff,
                                  onSaved: _loadStaff,
                                );
                              },
                              child: Card(
                                color: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            staff.name,
                                            style: AppTextStyles.subtitle2
                                                .copyWith(color: Colors.white),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            "Staff ID: ${staff.id}",
                                            style: AppTextStyles.subtitle
                                                .copyWith(
                                                    color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      const Icon(Icons.chevron_right,
                                          size: 32, color: Colors.white70),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
