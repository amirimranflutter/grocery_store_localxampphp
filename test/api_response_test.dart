import 'package:flutter_test/flutter_test.dart';
import 'package:grocerystore_local/geroceryStore/model/api_response.dart';
import 'package:grocerystore_local/geroceryStore/model/category.dart';
import 'dart:math';

void main() {
  group('ApiResponse Property Tests', () {
    test(
      'Property 1: Valid JSON Response Structure - **Feature: api-error-handling, Property 1: Valid JSON Response Structure**',
      () {
        // **Validates: Requirements 1.1, 1.4**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          // Generate random valid category data
          final testData = _generateValidCategoryData();

          // Test successful response creation
          final successResponse = ApiResponse<List<StoreCategory>>.success(
            testData,
            200,
          );

          // Verify response structure properties
          expect(successResponse.success, isTrue);
          expect(successResponse.data, equals(testData));
          expect(successResponse.error, isNull);
          expect(successResponse.statusCode, equals(200));

          // Test error response creation
          final errorMessage = _generateRandomString();
          final statusCode = _generateRandomErrorStatusCode();
          final errorResponse = ApiResponse<List<StoreCategory>>.error(
            errorMessage,
            statusCode,
          );

          // Verify error response structure properties
          expect(errorResponse.success, isFalse);
          expect(errorResponse.data, isNull);
          expect(errorResponse.error, equals(errorMessage));
          expect(errorResponse.statusCode, equals(statusCode));
        }
      },
    );

    test(
      'Property 1 Extended: JSON Parsing maintains structure - **Feature: api-error-handling, Property 1: Valid JSON Response Structure**',
      () {
        // **Validates: Requirements 1.1, 1.4**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          // Generate random valid JSON for categories
          final categories = _generateValidCategoryData();
          final jsonData = categories.map((c) => c.toJson()).toList();

          // Test fromJson parsing - simulate API response format
          final response = ApiResponse<List<StoreCategory>>.fromJson(
            jsonData
                .cast<Map<String, dynamic>>()
                .first, // Take first category as single response
            (data) => [StoreCategory.fromJson(data)],
          );

          // Verify parsed response maintains structure
          expect(response.success, isTrue);
          expect(response.data, isNotNull);
          expect(response.data!.length, equals(1));

          // Verify category maintains its structure
          expect(response.data![0].catId, equals(categories[0].catId));
          expect(response.data![0].catName, equals(categories[0].catName));
        }
      },
    );

    test(
      'Property 1 Error Handling: Error JSON maintains structure - **Feature: api-error-handling, Property 1: Valid JSON Response Structure**',
      () {
        // **Validates: Requirements 1.1, 1.4**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          // Generate random error JSON
          final errorMessage = _generateRandomString();
          final errorJson = {'status': 'error', 'message': errorMessage};

          // Test error JSON parsing
          final response = ApiResponse<List<StoreCategory>>.fromJson(
            errorJson,
            (data) =>
                (data as List).map((item) => StoreCategory.fromJson(item)).toList(),
          );

          // Verify error response maintains structure
          expect(response.success, isFalse);
          expect(response.data, isNull);
          expect(response.error, equals(errorMessage));
          expect(response.message, equals(errorMessage));
          expect(
            response.statusCode,
            equals(200),
          ); // Server returned 200 but with error status
        }
      },
    );
  });
}

// Helper functions for property-based testing

List<StoreCategory> _generateValidCategoryData() {
  final random = Random();
  final count = random.nextInt(10) + 1; // 1 to 10 categories

  return List.generate(count, (index) {
    return StoreCategory(
      catId: random.nextInt(1000) + 1, // 1 to 1000
      catName: _generateRandomString(),
    );
  });
}

String _generateRandomString() {
  final random = Random();
  final length = random.nextInt(20) + 1; // 1 to 20 characters
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ';

  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}

int _generateRandomErrorStatusCode() {
  final random = Random();
  final errorCodes = [400, 401, 403, 404, 500, 502, 503, 504];
  return errorCodes[random.nextInt(errorCodes.length)];
}
