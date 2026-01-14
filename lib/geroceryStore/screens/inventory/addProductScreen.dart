import 'package:flutter/material.dart';
import '../../core/appColors.dart';
import '../../services/product_service.dart';
import '../../model/category.dart';
import '../../model/api_response.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _quanCtrl = TextEditingController();
  final _dateController = TextEditingController();

  String? _selectedCategory; // Holds the ID of selected category
  List<StoreCategory> _categories = []; // Loaded from Database
  bool _isLoadingCategories = false;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    _fetchCats();
    _dateController.text = _formatDate(DateTime.now());
  }

  // Helper to format date consistently for MySQL (YYYY-MM-DD)
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // 3. Function to open the Manual Date Picker
  // 2. The function to change the date manually
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        // Formats it to YYYY-MM-DD for your MySQL database
        _dateController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }
// Inside _AddProductScreenState
  bool _isSaving = false; // Added to track saving state

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      // 1. Check if category is actually selected to avoid null error
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a category")),
        );
        return;
      }

      setState(() => _isSaving = true);

      // 2. Call the service with clean data
      bool ok = await ProductService().addProduct(
        _nameCtrl.text.trim(),
        _priceCtrl.text.trim(),
        _stockCtrl.text.trim(),
        _quanCtrl.text.trim(),
        _selectedCategory!, // This should be the ID string (e.g., "1")
        _dateController.text,
      );

      if (!mounted) return;
      setState(() => _isSaving = false);

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Product Saved Successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Success: Go back and refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to save. Check Console for Error details."),
            backgroundColor: Color(0xFFC73E3E), // Your Primary Red
          ),
        );
        print("Failed to save. Check Console for Error details.");
      }
    }
  }
  void _fetchCats() async {
    final data = await ProductService().fetchAllCategories();
    setState(() => _categories = data);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ADD Product NEW')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInput(_nameCtrl, "Product Name", Icons.edit),
              const SizedBox(height: 15),
              _buildCategoryDropdown(), // SELECTABLE CATEGORIES
              const SizedBox(height: 15),
              _buildInput(_priceCtrl, "Price", Icons.attach_money, isNum: true),
              const SizedBox(height: 15),
              _buildInput(
                _stockCtrl,
                "Initial Stock",
                Icons.inventory,
                isNum: true,
              ),
              const SizedBox(height: 15), _buildInput(
                _quanCtrl,
                "qantity",
                Icons.inventory,
                isNum: true,
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _pickDate, // Opens the calendar when tapped
                child: AbsorbPointer(
                  // Prevents the keyboard from popping up
                  child: _buildInput(
                    _dateController,
                    "Date",
                    Icons.date_range_outlined,
                    isNum:
                        false, // Change to false because it's a date string now
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed:  _isSaving ? null : _handleSave,
                  child: const Text(
                    "Save Product",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNum = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }

  Widget _buildCategoryDropdown() {
    // 1. Prevent opening if the list hasn't loaded yet
    if (_categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show loading indicator
    if (_isLoadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error message
    if (_categoryError != null) {
      return Column(
        children: [
          Text(
            'Error: $_categoryError',
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _fetchCats, child: const Text('Retry')),
        ],
      );
    }

    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Select Category",
        prefixIcon: Icon(Icons.category),
        border:
            OutlineInputBorder(), // Added border to see the click area better
      ),
      value: _selectedCategory, // Must match a value in the list exactly
      isExpanded: true, // IMPORTANT: Makes it easier to click
      items: _categories.map((category) {
        return DropdownMenuItem<String>(
          // Use the Category model properties
          value: category.catId.toString(),
          child: Text(category.catName),
        );
      }).toList(),
      onChanged: (val) {
        setState(() {
          _selectedCategory = val;
        });
        print("Selected Category ID: $val");
      },
      validator: (v) => v == null ? "Select a category" : null,
    );
  }
}
