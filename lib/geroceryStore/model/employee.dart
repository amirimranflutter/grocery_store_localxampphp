class Employee {
  final String id;
  final String name;
  final String salary;

  Employee({required this.id, required this.name, required this.salary});

  // Convert JSON from PHP into a Flutter Object
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['empid'].toString(),
      name: json['empName'],
      salary: json['empSalary'].toString(),
    );
  }
}