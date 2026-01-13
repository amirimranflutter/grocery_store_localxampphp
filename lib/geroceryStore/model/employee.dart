class Employee {
  final String id;
  final String name;
  final String salary;

  Employee({required this.id, required this.name, required this.salary});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['emp_id'].toString(),
      name: json['emp_name'] ?? 'Unknown',
      salary: json['emp_salary'].toString(),
    );
  }
}