import 'package:flutter_test/flutter_test.dart';


import 'package:my_payment_ozow_package/my_payment_ozow_package.dart';

void main() {
  group('PaymentService tests', () {
    // Initialize PaymentService with test configuration
    PaymentService paymentService = PaymentService(
      config: PaymentConfig(
        apiKey: 'your_api_key',
        privateKey: 'your_private_key',
        siteCode: 'your_site_code',
      ),
    );

    test('Test generateRequestHashCheck', () {
      // Test generateRequestHashCheck function
      String inputString = 'test_input_string';
      String expectedHash = paymentService.generateRequestHashCheck(inputString);
      expect(expectedHash, isNotNull);
      // Add more assertions as needed
    });

    test('Test generateRequestHash', () {
      // Test generateRequestHash function
      double amount = 100.0; // Sample amount for testing
      String hash = paymentService.generateRequestHash(amount);
      expect(hash, isNotNull);
      // Add more assertions as needed
    });

    test('Test makePaymentRequest', () async {
      // Test makePaymentRequest function
      double amount = 100.0; // Sample amount for testing
      String cancelUrl = 'http://test.cancel.com';
      String notifyUrl = 'http://test.notify.com';
      String successUrl = 'http://test.success.com';

      // Test making a payment request
      try {
        await paymentService.makePaymentRequest(
          amount: amount,
          cancelUrl: cancelUrl,
          notifyUrl: notifyUrl,
          successUrl: successUrl,
        );
        // Add assertions based on the expected behavior of makePaymentRequest
      } catch (e) {
        // Handle any exceptions that might occur during the payment request
        fail('Exception occurred during payment request: $e');
      }
    });
  });
}
