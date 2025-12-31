import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  // 1. Define the variable to hold your data
  late Future<List<dynamic>> _employeeList;

  @override
  void initState() {
    super.initState();
    // Initialize the list on startup
    _employeeList = fetchEmployees();
  }

  // --- FIX 1: Define refreshList inside the State class ---
  void _refreshList() {
    setState(() {
      _employeeList = fetchEmployees();
    });
  }

  // --- FIX 2: Define addNewEmployee ---
  Future<void> addNewEmployee(String name, String salary) async {
    // Point this to your NEW add_employee.php script
    final url = Uri.parse('http://192.168.1.20/grocery_api/add_employee.php');

    try {
      final response = await http.post(url, body: {
        "empName": name,
        "empSalary": salary,
      });

      if (response.statusCode == 200) {
        debugPrint("Success: ${response.body}");
        fetchEmployees();
      } else {
        debugPrint("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Network Error: $e");
    }
  }
  // Helper function to fetch data
  Future<List<dynamic>> fetchEmployees() async {
    final url = Uri.parse('http://192.168.1.20/grocery_api/get_employee.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Only decode if the server returned a Success code
        return json.decode(response.body);
      } else {
        debugPrint("Server Error: ${response.statusCode}");
        return []; // Return empty list so the app doesn't crash
      }
    } catch (e) {
      debugPrint("Fetch Error: $e");
      return [];
    }
  }

  // --- THE DIALOG FUNCTION ---
  void _showAddDialog(BuildContext context) {
    final nameController = TextEditingController();
    final salaryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Employee"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: salaryController, decoration: const InputDecoration(labelText: "Salary")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              // Now these functions ARE defined in the same class!
              await addNewEmployee(nameController.text, salaryController.text);
              if (mounted) Navigator.pop(context);
              _refreshList();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Manager")),
      body: FutureBuilder<List<dynamic>>(
        future: _employeeList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i) => ListTile(
              title: Text(snapshot.data![i]['empName']),
              subtitle: Text("Salary: ${snapshot.data![i]['empSalary']}"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}