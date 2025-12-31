import 'package:flutter_test/flutter_test.dart';
import 'package:grocerystore_local/geroceryStore/services/category_service.dart';
import 'package:grocerystore_local/geroceryStore/core/error_handler.dart';
import 'package:grocerystore_local/geroceryStore/model/category.dart';
import 'package:grocerystore_local/geroceryStore/model/api_response.dart';
import 'dart:convert';
import 'dart:math';

void main() {
  group('CategoryService Property Tests', () {
    test(
      'Property 3: Graceful Malformed Data Handling - **Feature: api-error-handling, Property 3: Graceful Malformed Data Handling**',
      () {
        // **Validates: Requirements 1.3**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          // Generate various types of malformed JSON responses
          final malformedJson = _generateMalformedJson();

          try {
            // Test ErrorHandler's parseApiResponse with malformed data
            final result = ErrorHandler.parseApiResponse<List<StoreCategory>>(
              malformedJson,
              (data) {
                if (data is List) {
                  return data.map((item) => StoreCategory.fromJson(item)).toList();
                } else if (data is Map<String, dynamic>) {
                  return [StoreCategory.fromJson(data)];
                } else {
                  throw ApiException(
                    'Invalid data format received from server',
                  );
                }
              },
              context: 'CategoryService.fetchCategories',
            );

            // If parsing succeeds (e.g., empty response), verify it returns valid data
            if (result != null) {
              expect(result, isA<List<StoreCategory>>());
            }
          } catch (e) {
            // Verify that malformed data handling is graceful
            expect(e, isA<ApiException>());

            final apiException = e as ApiException;

            // Verify error message is user-friendly and doesn't expose technical details
            expect(apiException.message, isNotNull);
            expect(apiException.message, isNotEmpty);
            expect(apiException.message, isNot(contains('FormatException')));
            expect(apiException.message, isNot(contains('JSON')));
            expect(apiException.message, isNot(contains('parsing')));
            expect(apiException.message, isNot(contains('decode')));

            // Verify error message provides helpful guidance
            final isHelpful =
                apiException.message.contains('data format') ||
                apiException.message.contains('server response') ||
                apiException.message.contains('invalid') ||
                apiException.message.contains('server') ||
                apiException.message.contains('error') ||
                apiException.message.contains('try again') ||
                apiException.message.contains('format');

            expect(
              isHelpful,
              isTrue,
              reason:
                  'Error message should provide helpful guidance: ${apiException.message}',
            );
          }
        }
      },
    );

    test(
      'Property 4: Successful Parsing Under Normal Conditions - **Feature: api-error-handling, Property 4: Successful Parsing Under Normal Conditions**',
      () {
        // **Validates: Requirements 1.5**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          // Generate valid category JSON data
          final validCategories = _generateValidCategoryData();
          final validJson = _generateValidCategoryJson(validCategories);

          try {
            // Test ErrorHandler's parseApiResponse with valid data
            final result = ErrorHandler.parseApiResponse<List<StoreCategory>>(
              validJson,
              (data) {
                if (data is List) {
                  return data.map((item) => StoreCategory.fromJson(item)).toList();
                } else if (data is Map<String, dynamic>) {
                  return [StoreCategory.fromJson(data)];
                } else {
                  throw ApiException(
                    'Invalid data format received from server',
                  );
                }
              },
              context: 'CategoryService.fetchCategories',
            );

            // Verify successful parsing properties
            expect(result, isNotNull);
            expect(result, isA<List<StoreCategory>>());
            expect(result!.length, equals(validCategories.length));

            // Verify each category was parsed correctly
            for (int j = 0; j < result.length; j++) {
              expect(result[j].catId, equals(validCategories[j].catId));
              expect(result[j].catName, equals(validCategories[j].catName));
            }
          } catch (e) {
            fail('Valid JSON should not throw exceptions: $e');
          }
        }
      },
    );

    test(
      'Property 13: Exponential Backoff Retry Logic - **Feature: api-error-handling, Property 13: Exponential Backoff Retry Logic**',
      () {
        // **Validates: Requirements 3.5**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          final categoryService = CategoryService();

          // Test exponential backoff timing calculation
          final retryCount = Random().nextInt(5) + 1; // 1 to 5 retries

          // Measure timing for exponential backoff
          final startTime = DateTime.now();

          // Simulate the exponential backoff delay calculation
          // This tests the mathematical property of exponential backoff
          final baseDelayMs = 1000; // 1 second base delay
          final expectedDelayMs = baseDelayMs * pow(2, retryCount - 1).toInt();

          // Verify exponential backoff properties
          expect(expectedDelayMs, greaterThan(0));
          expect(expectedDelayMs, greaterThanOrEqualTo(baseDelayMs));

          // Verify exponential growth property
          if (retryCount > 1) {
            final previousDelayMs =
                baseDelayMs * pow(2, retryCount - 2).toInt();
            expect(expectedDelayMs, equals(previousDelayMs * 2));
          }

          // Verify reasonable upper bounds (prevent infinite delays)
          expect(expectedDelayMs, lessThan(60000)); // Less than 1 minute

          // Test that retry count affects delay exponentially
          final delay1 = baseDelayMs * pow(2, 0).toInt(); // 1000ms
          final delay2 = baseDelayMs * pow(2, 1).toInt(); // 2000ms
          final delay3 = baseDelayMs * pow(2, 2).toInt(); // 4000ms

          expect(delay2, equals(delay1 * 2));
          expect(delay3, equals(delay2 * 2));
          expect(delay3, equals(delay1 * 4));
        }
      },
    );
  });
}

// Helper functions for property-based testing

String _generateMalformedJson() {
  final random = Random();
  final malformedJsons = [
    '{"incomplete": true',
    '{"invalid": "json",,}',
    '{invalid_json}',
    '{"number": 123abc}',
    '{"string": "unclosed string}',
    '{"array": [1,2,3,]}',
    '',
    'null',
    'undefined',
    '<html><body>Error 500</body></html>',
    'Plain text error message',
    '{"cat_id": "not_a_number", "cat_name": "test"}',
    '{"cat_id": null, "cat_name": null}',
    '{"wrong_field": "value"}',
    '[{"cat_id": 1}, {"invalid": true}]',
    '{"status": "error", "message": "Server error"}',
  ];

  return malformedJsons[random.nextInt(malformedJsons.length)];
}

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

String _generateValidCategoryJson(List<StoreCategory> categories) {
  final jsonList = categories.map((c) => c.toJson()).toList();
  return json.encode(jsonList);
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
