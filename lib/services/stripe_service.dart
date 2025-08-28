import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';

class StripeService {
  // Replace with your actual publishable key (this is safe to have in the app)
  static const String _publishableKey = 'pk_test_51S0NA4Q471tlxA0yDRCiJSANd9dYZ3aPdZSHMqzSe9xldy1YwoRN53AV12DmugpKwT8lV2eiorTRqPuF6FQYkozY00ccRcoiGr';
  
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
      
      //print('Creating payment intent for amount: $amount $currency');
      
      // TODO: Replace this with a call to your backend server
      // For now, we'll return a mock response for testing
      // In production, this should call your Firebase Cloud Function or backend API
      
      // Mock response for testing - replace with actual backend call
      return {
        'id': 'pi_test_${DateTime.now().millisecondsSinceEpoch}',
        'client_secret': 'pi_test_secret_${DateTime.now().millisecondsSinceEpoch}',
        'amount': (amount * 100).round(),
        'currency': currency,
        'status': 'requires_payment_method',
      };
      
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
      //print('Payment sheet presentation failed: $e');
      throw Exception('Payment sheet presentation failed: $e');
    }
  }

  // Confirm Payment Sheet Payment
  static Future<void> confirmPaymentSheetPayment() async {
    try {
      //print('Confirming payment sheet payment...');
      await Stripe.instance.confirmPaymentSheetPayment();
      //print('Payment sheet payment confirmed successfully');
    } catch (e) {
      //print('Payment sheet confirmation failed: $e');
      throw Exception('Payment sheet confirmation failed: $e');
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
