class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int statusCode;
  final String? message;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    required this.statusCode,
    this.message,
  });

  factory ApiResponse.success(T data, int statusCode) {
    return ApiResponse<T>(success: true, data: data, statusCode: statusCode);
  }

  factory ApiResponse.error(String error, int statusCode, {String? message}) {
    return ApiResponse<T>(
      success: false,
      error: error,
      statusCode: statusCode,
      message: message,
    );
  }

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    if (json.containsKey('status') && json['status'] == 'error') {
      return ApiResponse<T>.error(
        json['message'] ?? 'Unknown error',
        200, // Server returned 200 but with error status
        message: json['message'],
      );
    }

    return ApiResponse<T>.success(fromJsonT(json), 200);
  }

  @override
  String toString() {
    return 'ApiResponse{success: $success, data: $data, error: $error, statusCode: $statusCode, message: $message}';
  }
}
