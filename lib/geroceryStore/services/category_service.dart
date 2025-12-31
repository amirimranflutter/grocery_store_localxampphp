import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../core/appConstant.dart';
import '../core/error_handler.dart';
import '../model/api_response.dart';
import '../model/category.dart';

class CategoryService {
  static const int _maxRetries = 3;
  static const Duration _baseDelay = Duration(seconds: 1);
  static const Duration _requestTimeout = Duration(seconds: 30);

  /// Fetches categories with robust error handling and retry logic
  Future<ApiResponse<List<StoreCategory>>> fetchCategories() async {
    int retryCount = 0;

    while (retryCount <= _maxRetries) {
      try {
        final url = "${AppConstants.baseUrl}/products/get_categories.php";

        // Log the request for debugging
        ErrorHandler.logApiRequest(url);

        final response = await http
            .get(Uri.parse(url))
            .timeout(_requestTimeout);

        // Log the response for debugging
        ErrorHandler.logApiResponse(
          response.statusCode,
          response.body,
          url: url,
        );

        if (response.statusCode == 200) {
          try {
            // Use ErrorHandler for robust JSON parsing
            final categories = ErrorHandler.parseApiResponse<List<StoreCategory>>(
              response.body,
              (data) {
                // Handle new standardized response format
                if (data is Map<String, dynamic> && data.containsKey('data')) {
                  final categoryData = data['data'];
                  if (categoryData is List) {
                    return categoryData
                        .map((item) => StoreCategory.fromJson(item))
                        .toList();
                  } else if (categoryData is Map<String, dynamic>) {
                    return [StoreCategory.fromJson(categoryData)];
                  }
                }
                // Handle legacy direct array format
                else if (data is List) {
                  return data.map((item) => StoreCategory.fromJson(item)).toList();
                } else if (data is Map<String, dynamic>) {
                  // Handle single category response
                  return [StoreCategory.fromJson(data)];
                } else {
                  throw ApiException(
                    'Invalid data format received from server',
                  );
                }
                return <StoreCategory>[];
              },
              context: 'CategoryService.fetchCategories',
            );

            return ApiResponse.success(categories ?? [], response.statusCode);
          } catch (e) {
            if (e is ApiException) {
              return ApiResponse.error(
                e.message,
                response.statusCode,
                message: e.message,
              );
            }
            return ApiResponse.error(
              ErrorHandler.getUserFriendlyError(e),
              response.statusCode,
            );
          }
        } else {
          // Handle HTTP error status codes
          String errorMessage = _getHttpErrorMessage(response.statusCode);
          return ApiResponse.error(errorMessage, response.statusCode);
        }
      } on SocketException catch (e) {
        if (retryCount < _maxRetries) {
          retryCount++;
          await _waitWithExponentialBackoff(retryCount);
          continue;
        }
        return ApiResponse.error(
          'Unable to connect to server. Please check your internet connection.',
          0,
        );
      } on HttpException catch (e) {
        if (retryCount < _maxRetries) {
          retryCount++;
          await _waitWithExponentialBackoff(retryCount);
          continue;
        }
        return ApiResponse.error(
          'Network error occurred. Please try again.',
          0,
        );
      } catch (e) {
        if (retryCount < _maxRetries && _isRetryableError(e)) {
          retryCount++;
          await _waitWithExponentialBackoff(retryCount);
          continue;
        }
        return ApiResponse.error(ErrorHandler.getUserFriendlyError(e), 0);
      }
    }

    return ApiResponse.error(
      'Failed to fetch categories after multiple attempts. Please try again later.',
      0,
    );
  }

  /// Implements exponential backoff for retry logic
  Future<void> _waitWithExponentialBackoff(int retryCount) async {
    final delay = Duration(
      milliseconds: _baseDelay.inMilliseconds * pow(2, retryCount - 1).toInt(),
    );
    await Future.delayed(delay);
  }

  /// Determines if an error is retryable
  bool _isRetryableError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('timeout') ||
        errorString.contains('connection') ||
        errorString.contains('network') ||
        errorString.contains('socket');
  }

  /// Gets user-friendly HTTP error messages
  String _getHttpErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please try again.';
      case 401:
        return 'Authentication required. Please log in.';
      case 403:
        return 'Access denied. You do not have permission to access this resource.';
      case 404:
        return 'Categories not found. Please contact support.';
      case 500:
        return 'Server error occurred. Please try again later.';
      case 502:
        return 'Server temporarily unavailable. Please try again.';
      case 503:
        return 'Service temporarily unavailable. Please try again later.';
      case 504:
        return 'Request timed out. Please try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
