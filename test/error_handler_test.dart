import 'package:flutter_test/flutter_test.dart';
import 'package:grocerystore_local/geroceryStore/core/error_handler.dart';
import 'package:grocerystore_local/geroceryStore/model/category.dart';
import 'dart:math';

void main() {
  group('ErrorHandler Property Tests', () {
    test(
      'Property 2: Safe Error Message Format - **Feature: api-error-handling, Property 2: Safe Error Message Format**',
      () {
        // **Validates: Requirements 1.2, 2.2**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          // Generate various types of errors
          final errors = _generateVariousErrors();

          for (final error in errors) {
            final userFriendlyMessage = ErrorHandler.getUserFriendlyError(
              error,
            );

            // Verify error message safety properties
            expect(userFriendlyMessage, isNotNull);
            expect(userFriendlyMessage, isNotEmpty);

            // Verify no sensitive information is exposed
            expect(userFriendlyMessage, isNot(contains('Exception')));
            expect(userFriendlyMessage, isNot(contains('Stack trace')));
            expect(userFriendlyMessage, isNot(contains('at ')));
            expect(userFriendlyMessage, isNot(contains('lib/')));
            expect(userFriendlyMessage, isNot(contains('.dart')));

            // Verify message is user-friendly (no technical jargon in production)
            if (!ErrorHandler.isDebugMode) {
              expect(userFriendlyMessage, isNot(contains('Error:')));
              expect(userFriendlyMessage, isNot(contains('Failed assertion')));
              expect(userFriendlyMessage, isNot(contains('RangeError')));
              expect(userFriendlyMessage, isNot(contains('FormatException')));
            }

            // Verify message provides helpful guidance
            final isHelpfulMessage =
                userFriendlyMessage.contains('try again') ||
                userFriendlyMessage.contains('check') ||
                userFriendlyMessage.contains('connection') ||
                userFriendlyMessage.contains('server') ||
                userFriendlyMessage.contains('unexpected error');

            expect(
              isHelpfulMessage,
              isTrue,
              reason:
                  'Error message should provide helpful guidance: $userFriendlyMessage',
            );
          }
        }
      },
    );

    test(
      'Property 2 Extended: API Exception handling maintains safety - **Feature: api-error-handling, Property 2: Safe Error Message Format**',
      () {
        // **Validates: Requirements 1.2, 2.2**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          // Generate random API exceptions
          final message = _generateRandomErrorMessage();
          final code = _generateRandomErrorCode();
          final details = _generateRandomErrorDetails();

          final apiException = ApiException(
            message,
            code: code,
            details: details,
          );
          final userFriendlyMessage = ErrorHandler.getUserFriendlyError(
            apiException,
          );

          // Verify API exception message safety
          expect(
            userFriendlyMessage,
            equals(message),
          ); // API exceptions should return their message directly
          expect(userFriendlyMessage, isNotNull);
          expect(userFriendlyMessage, isNotEmpty);

          // Verify no internal details are exposed in the message itself
          expect(userFriendlyMessage, isNot(contains('ApiException')));
          expect(userFriendlyMessage, isNot(contains('code:')));
          expect(userFriendlyMessage, isNot(contains('details:')));
        }
      },
    );

    test(
      'Property 2 Network Errors: Network error messages are safe and helpful - **Feature: api-error-handling, Property 2: Safe Error Message Format**',
      () {
        // **Validates: Requirements 1.2, 2.2**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          // Generate network-related error messages
          final networkErrors = _generateNetworkErrors();

          for (final error in networkErrors) {
            final userFriendlyMessage = ErrorHandler.getUserFriendlyError(
              error,
            );

            // Verify network error message safety and helpfulness
            expect(userFriendlyMessage, isNotNull);
            expect(userFriendlyMessage, isNotEmpty);

            // Should provide helpful network-related guidance
            final isNetworkHelpful =
                userFriendlyMessage.contains('connection') ||
                userFriendlyMessage.contains('internet') ||
                userFriendlyMessage.contains('server') ||
                userFriendlyMessage.contains('network') ||
                userFriendlyMessage.contains('timeout');

            expect(
              isNetworkHelpful,
              isTrue,
              reason:
                  'Network error should provide connection guidance: $userFriendlyMessage',
            );

            // Should not expose technical details
            expect(userFriendlyMessage, isNot(contains('SocketException')));
            expect(userFriendlyMessage, isNot(contains('TimeoutException')));
            expect(userFriendlyMessage, isNot(contains('host lookup')));
          }
        }
      },
    );

    test(
      'Property 2 JSON Parsing: Malformed JSON errors are safe - **Feature: api-error-handling, Property 2: Safe Error Message Format**',
      () {
        // **Validates: Requirements 1.2, 2.2**

        // Run property test with 100 iterations
        for (int i = 0; i < 100; i++) {
          // Generate malformed JSON responses
          final malformedJson = _generateMalformedJson();

          try {
            ErrorHandler.parseApiResponse<List<StoreCategory>>(
              malformedJson,
              (data) => (data as List)
                  .map((item) => StoreCategory.fromJson(item))
                  .toList(),
              context: 'test',
            );
            // If no exception is thrown, that's also valid (empty response handling)
          } catch (e) {
            final userFriendlyMessage = ErrorHandler.getUserFriendlyError(e);

            // Verify malformed JSON error message safety
            expect(userFriendlyMessage, isNotNull);
            expect(userFriendlyMessage, isNotEmpty);

            // Should not expose JSON parsing technical details
            expect(userFriendlyMessage, isNot(contains('FormatException')));
            expect(userFriendlyMessage, isNot(contains('JSON')));
            expect(userFriendlyMessage, isNot(contains('parsing')));
            expect(userFriendlyMessage, isNot(contains('decode')));

            // Should provide user-friendly guidance
            final isHelpful =
                userFriendlyMessage.contains('data format') ||
                userFriendlyMessage.contains('server response') ||
                userFriendlyMessage.contains('try again') ||
                userFriendlyMessage.contains('unexpected error');

            expect(
              isHelpful,
              isTrue,
              reason:
                  'JSON error should provide helpful guidance: $userFriendlyMessage',
            );
          }
        }
      },
    );
  });
}

// Helper functions for property-based testing

List<dynamic> _generateVariousErrors() {
  final random = Random();
  final errors = <dynamic>[];

  // Add different types of errors
  errors.add(Exception('Test exception'));
  errors.add(FormatException('Invalid format'));
  errors.add(RangeError('Index out of range'));
  errors.add(ArgumentError('Invalid argument'));
  errors.add(StateError('Invalid state'));
  errors.add(ApiException(_generateRandomErrorMessage()));

  // Add network-like errors
  errors.add(Exception('SocketException: Failed host lookup'));
  errors.add(Exception('TimeoutException after 30 seconds'));

  return errors;
}

List<dynamic> _generateNetworkErrors() {
  return [
    Exception('SocketException: Failed host lookup: \'api.example.com\''),
    Exception('SocketException: Connection refused'),
    Exception('TimeoutException after 30000ms: Reading data'),
    Exception('TimeoutException: Future not completed'),
    Exception('Failed host lookup: \'server.com\''),
    Exception('Connection timed out'),
  ];
}

String _generateRandomErrorMessage() {
  final random = Random();
  final messages = [
    'Server temporarily unavailable',
    'Invalid request format',
    'Authentication failed',
    'Resource not found',
    'Database connection error',
    'Service maintenance in progress',
    'Rate limit exceeded',
    'Invalid parameters provided',
  ];

  return messages[random.nextInt(messages.length)];
}

String _generateRandomErrorCode() {
  final random = Random();
  final codes = [
    'ERR_001',
    'ERR_002',
    'ERR_003',
    'AUTH_FAILED',
    'DB_ERROR',
    'RATE_LIMIT',
  ];
  return codes[random.nextInt(codes.length)];
}

Map<String, dynamic> _generateRandomErrorDetails() {
  final random = Random();
  return {
    'field': 'test_field_${random.nextInt(100)}',
    'value': 'test_value_${random.nextInt(100)}',
    'timestamp': DateTime.now().millisecondsSinceEpoch,
  };
}

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
    '<html><body>Error</body></html>',
    'Plain text error message',
  ];

  return malformedJsons[random.nextInt(malformedJsons.length)];
}
