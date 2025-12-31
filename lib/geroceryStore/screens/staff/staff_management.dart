import 'package:flutter/material.dart';
import '../../core/appColors.dart';
import '../../model/employee.dart';
import '../../services/staff_service.dart';
import 'add_staff.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  late Future<List<Employee>> _staffList;

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  void _loadStaff() {
    setState(() {
      _staffList = StaffService().fetchEmployees();
    });
  }
  Future<bool?> _showDeleteDialog(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to remove $name from the staff list?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Management'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadStaff),
        ],
      ),
      body: FutureBuilder<List<Employee>>(
        future: _staffList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Always good to check if there was an error fetching data
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final staff = snapshot.data ?? [];

          if (staff.isEmpty) {
            return const Center(child: Text("No employees found"));
          }

          // FIX: ADD THE 'return' KEYWORD HERE
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            itemCount: staff.length,
            itemBuilder: (context, index) {
              final employee = staff[index];

              return Dismissible(
                key: Key(employee.id.toString()),
                direction: DismissDirection.endToStart,

                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                confirmDismiss: (direction) async {
                  final bool? resolved = await _showDeleteDialog(context, employee.name);
                  return resolved ?? false; //
                },

                onDismissed: (direction) async {
                  bool success = await StaffService().deleteEmployee(employee.id);
                  if (success) {
                    // 2. Refresh the list only AFTER the database confirms deletion
                    _loadStaff();
                  } else {
                    // 3. If it failed, show an error!
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to delete from database")),
                    );
                    _loadStaff(); // Reload to bring the item back to the UI
                  }
                },

                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Salary: ${employee.salary}"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(employee.name.isNotEmpty ? employee.name[0] : "?"),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigate and wait for a result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStaffScreen()),
          );

          // If the result is true, it means a new staff was added, so refresh the list
          if (result == true) {
            _loadStaff(); // This is the function we made earlier to fetch data
          }
        },
        label: const Text('Add Staff'),
        icon: const Icon(Icons.person_add),
        backgroundColor: AppColors.primary,
      ),
    );
  }

}