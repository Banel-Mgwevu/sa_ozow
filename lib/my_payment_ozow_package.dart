
library my_payment_ozow_package;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentConfig {
  final String apiKey;
  final String privateKey;
  final String siteCode;

  PaymentConfig({
    required this.apiKey,
    required this.privateKey,
    required this.siteCode,
  });
}

class PaymentService {
  PaymentConfig config;

  PaymentService({required this.config});

  String generateRequestHashCheck(String inputString) {
    var sha = sha512.convert(utf8.encode(inputString));
    return sha.toString();
  }

  String generateRequestHash(double amount) {
    String siteCode = config.siteCode;
    String countryCode = 'ZA';
    String currencyCode = 'ZAR';
    String transactionReference = 'monaa';
    String bankReference = 'monaa';
    String cancelUrl = 'http://test.i-pay.co.za/responsetest.php';
    String errorUrl = 'http://test.i-pay.co.za/responsetest.php';
    String successUrl = 'http://test.i-pay.co.za/responsetest.php';
    String notifyUrl = 'http://test.i-pay.co.za/responsetest.php';
    String privateKey = config.privateKey;
    bool isTest = false;

    String inputString = (siteCode +
        countryCode +
        currencyCode +
        amount.toString() +
        transactionReference +
        bankReference +
        cancelUrl +
        errorUrl +
        successUrl +
        notifyUrl +
        isTest.toString() +
        privateKey);

    inputString = inputString.toLowerCase();
    String calculatedHashResult = generateRequestHashCheck(inputString);
   // print("Hashcheck: $calculatedHashResult");
    return calculatedHashResult;
  }

  Future<void> makePaymentRequest({
    required double amount,
    required String cancelUrl,
    required String notifyUrl,
    required String successUrl,
  }) async {
    String url = "https://api.ozow.com/postpaymentrequest";
    String hash = generateRequestHash(amount);

    Map<String, dynamic> data = {
      "countryCode": "ZA",
      "amount": amount.toString(),
      "transactionReference": "monaa",
      "bankReference": "monaa",
      "cancelUrl": cancelUrl,
      "currencyCode": "ZAR",
      "errorUrl": cancelUrl,
      "isTest": false,
      "notifyUrl": notifyUrl,
      "siteCode": config.siteCode,
      "successUrl": successUrl,
      "hashCheck": hash
    };

    var headers = {
      "Accept": "application/json",
      "ApiKey": config.apiKey,
      "Content-Type": "application/json"
    };

   
  try {
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print(responseData);
        var successResponseUrl = responseData['url']; // Assuming the URL is in a 'url' field of the response

        if (successResponseUrl != null && successResponseUrl.isNotEmpty) {
          await launchUrl(Uri.parse(successResponseUrl)); // Opens successResponseUrl in the default browser
          print(successResponseUrl);
        } else {
          print('No valid URL found in the response.');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
