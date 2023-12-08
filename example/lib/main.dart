

import 'package:flutter/material.dart';
import 'package:my_payment_ozow_package/my_payment_ozow_package.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PaymentConfig paymentConfig = PaymentConfig(
      apiKey: "",
      privateKey: "",
      siteCode: "",
    );

    PaymentService paymentService = PaymentService(config: paymentConfig);

    return MaterialApp(
      title: 'Payment Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Payment Example'),
        ),
        body: Center(
          child: PayButton(paymentService: paymentService),
        ),
      ),
    );
  }
}

class PayButton extends StatelessWidget {
  final PaymentService paymentService;

  const PayButton({Key? key, required this.paymentService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        makePayment();
      },
      child: Text('Pay Now Ozow'),
    );
  }

  void makePayment() async {
    await paymentService.makePaymentRequest(
      amount: 0.08, // Provide the required amount
      cancelUrl: "http://test.i-pay.co.za/responsetest.php",
      notifyUrl: "http://test.i-pay.co.za/responsetest.php",
      successUrl: "http://test.i-pay.co.za/responsetest.php",
    );
  }
}
