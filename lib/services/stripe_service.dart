import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StripeService {
  // Get keys from environment variables
  static String get _publishableKey => 'pk_test_51S0NA4Q471tlxA0yDRCiJSANd9dYZ3aPdZSHMqzSe9xldy1YwoRN53AV12DmugpKwT8lV2eiorTRqPuF6FQYkozY00ccRcoiGr';
  static String get _secretKey => 'sk_test_51S0NA4Q471tlxA0yRywl58SVQgjQ42628zlfJMWVB7Gvo6mYlkr0CBZGRPbz83GhNbN4wLDtT837FYlC0sZgwi7P00crI34NU8';
  
  // NOTE: Secret key should NEVER be in your Flutter app!
  // It should only be on your backend server for security reasons.

  static Future<void> initialize() async {
    if (_publishableKey.isEmpty || _publishableKey == 'pk_test_your_actual_publishable_key') {
      throw Exception('Please update your Stripe publishable key in StripeService');
    }
    
    Stripe.publishableKey = _publishableKey;
    await Stripe.instance.applySettings();
    //print('Stripe initialized with publishable key: ${_publishableKey.substring(0, 20)}...');
  }

  // Create payment intent - this should call your backend server
  // In production, NEVER create payment intents directly from the mobile app
  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    String? customerId,
  }) async {
    try {
      // Validate inputs
      if (amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }
      
      if (currency.isEmpty) {
        throw Exception('Currency cannot be empty');
      }
      
      // For development/testing, create a real payment intent using Stripe's test mode
      // WARNING: This is NOT for production use!
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': (amount * 100).round().toString(), // Convert to cents
          'currency': currency,
          if (customerId != null) 'customer': customerId,
          'automatic_payment_methods[enabled]': 'true',
          'metadata[test_mode]': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        //print('Payment intent created successfully: ${data['id']}');
        return data;
      } else {
        throw Exception('Failed to create payment intent: HTTP ${response.statusCode} - ${response.body}');
      }
      
      // Example of how this should work in production:
      // final response = await http.post(
      //   Uri.parse('https://your-backend.com/api/create-payment-intent'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: json.encode({
      //     'amount': amount,
      //     'currency': currency,
      //     'customerId': customerId,
      //   }),
      // );
      // return json.decode(response.body);
    } catch (e) {
      //print('Error creating payment intent: $e');
      throw Exception('Error creating payment intent: $e');
    }
  }

  // Initialize Payment Sheet (recommended approach)
  static Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String merchantDisplayName,
  }) async {
    try {
      //print('Initializing payment sheet with client secret: ${paymentIntentClientSecret.substring(0, 20)}...');
      
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: merchantDisplayName,
          style: ThemeMode.system,
        ),
      );
      
      //print('Payment sheet initialized successfully');
    } catch (e) {
      //print('Failed to initialize payment sheet: $e');
      throw Exception('Failed to initialize payment sheet: $e');
    }
  }

  // Present Payment Sheet
  static Future<void> presentPaymentSheet() async {
    try {
      //print('Presenting payment sheet...');
      await Stripe.instance.presentPaymentSheet();
      //print('Payment sheet presented successfully');
    } catch (e) {
      //print('Failed to present payment sheet: $e');
      throw Exception('Failed to present payment sheet: $e');
    }
  }

  // Confirm Payment Sheet Payment
  static Future<void> confirmPaymentSheetPayment() async {
    try {
      //print('Confirming payment sheet payment...');
      await Stripe.instance.confirmPaymentSheetPayment();
      //print('Payment sheet payment confirmed successfully');
    } catch (e) {
      //print('Failed to confirm payment sheet payment: $e');
      throw Exception('Failed to confirm payment sheet payment: $e');
    }
  }

  // Helper methods
  static String formatAmount(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static double calculateTax(double subtotal, double taxRate) {
    return subtotal * (taxRate / 100);
  }
}
