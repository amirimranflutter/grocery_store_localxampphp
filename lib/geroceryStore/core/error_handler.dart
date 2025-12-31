import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class ErrorHandler {
  static bool get isDebugMode => kDebugMode;

  /// Handles API response parsing with comprehensive error handling
  static T? parseApiResponse<T>(
    String responseBody,
    T Function(dynamic) fromJson, {
    String? context,
  }) {
    try {
      // Clean the response body of any HTML content
      String cleanedBody = _cleanResponseBody(responseBody);

      if (cleanedBody.isEmpty) {
        _logError('Empty response body', context: context);
        return null;
      }

      final dynamic jsonData = json.decode(cleanedBody);

      // Check if it's an error response
      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey('status') &&
          jsonData['status'] == 'error') {
        String errorMessage = jsonData['message'] ?? 'Unknown server error';
        _logError('Server returned error: $errorMessage', context: context);
        throw ApiException(errorMessage);
      }

      return fromJson(jsonData);
    } on FormatException catch (e) {
      String errorMsg = 'Invalid JSON format: ${e.message}';
      _logError(errorMsg, context: context, details: 'Response: $responseBody');
      throw ApiException('Server returned invalid data format');
    } on ApiException {
      rethrow;
    } catch (e) {
      String errorMsg = 'Unexpected parsing error: $e';
      _logError(errorMsg, context: context);
      throw ApiException('Failed to process server response');
    }
  }

  /// Cleans response body by removing HTML content and extracting JSON
  static String _cleanResponseBody(String responseBody) {
    if (responseBody.isEmpty) return '';

    // Look for JSON content in the response (object or array)
    int jsonStart = -1;
    int jsonEnd = -1;

    // Check for JSON object
    int objStart = responseBody.indexOf('{');
    int objEnd = responseBody.lastIndexOf('}');

    // Check for JSON array
    int arrStart = responseBody.indexOf('[');
    int arrEnd = responseBody.lastIndexOf(']');

    // Use whichever comes first (object or array)
    if (objStart != -1 && (arrStart == -1 || objStart < arrStart)) {
      jsonStart = objStart;
      jsonEnd = objEnd;
    } else if (arrStart != -1) {
      jsonStart = arrStart;
      jsonEnd = arrEnd;
    }

    if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
      return responseBody.substring(jsonStart, jsonEnd + 1);
    }

    // If no JSON brackets found, return original (might be pure JSON)
    return responseBody.trim();
  }

  /// Logs errors with appropriate level based on debug mode
  static void _logError(String message, {String? context, String? details}) {
    String fullMessage = context != null ? '[$context] $message' : message;

    if (isDebugMode) {
      developer.log(fullMessage, name: 'ErrorHandler', error: details);
      // Also print for immediate visibility during development
      print('🚨 ERROR: $fullMessage');
      if (details != null) {
        print('📋 Details: $details');
      }
    } else {
      // In production, use developer.log without print
      developer.log(fullMessage, name: 'ErrorHandler');
    }
  }

  /// Logs API requests for debugging
  static void logApiRequest(
    String url, {
    Map<String, String>? headers,
    String? body,
  }) {
    if (isDebugMode) {
      print('🔍 API Request: $url');
      if (headers != null && headers.isNotEmpty) {
        print('📤 Headers: $headers');
      }
      if (body != null && body.isNotEmpty) {
        print('📤 Body: $body');
      }
    }
  }

  /// Logs API responses for debugging
  static void logApiResponse(
    int statusCode,
    String responseBody, {
    String? url,
  }) {
    if (isDebugMode) {
      String urlInfo = url != null ? ' from $url' : '';
      print('📥 Response$urlInfo: $statusCode');
      print(
        '📥 Body: ${responseBody.length > 500 ? '${responseBody.substring(0, 500)}...' : responseBody}',
      );
    }
  }

  /// Creates user-friendly error messages
  static String getUserFriendlyError(dynamic error) {
    if (error is ApiException) {
      return error.message;
    }

    if (error.toString().contains('SocketException') ||
        error.toString().contains('Failed host lookup')) {
      return 'Unable to connect to server. Please check your internet connection.';
    }

    if (error.toString().contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }

    if (isDebugMode) {
      return 'Error: ${error.toString()}';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}

/// Custom exception for API-related errors
class ApiException implements Exception {
  final String message;
  final String? code;
  final Map<String, dynamic>? details;

  ApiException(this.message, {this.code, this.details});

  @override
  String toString() => 'ApiException: $message';
}
