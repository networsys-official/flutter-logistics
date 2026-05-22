import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  static const String configuredBaseUrl = String.fromEnvironment(
    'BASE_URL',
    // defaultValue: '',
    defaultValue: 'https://logisticsystems.webandappdevelopmenttech.com/api/v1',
  );

  static String get baseUrl {
    if (configuredBaseUrl.isNotEmpty) {
      return configuredBaseUrl;
    }

    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api/v1';
    }
    return 'http://localhost:8080/api/v1';
  }

  static String get storageBaseUrl {
    return baseUrl.replaceAll('/api/v1', '');
  }

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/send-otp';
  static const String forgetPassword = '/auth/forgot-password';
  static const String restPassword = '/auth/reset-password';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String updatePassword = '/update-password';

  // User/Account endpoints
  static const String updateProfile = '/profile';
  static const String showProfile = '/profile';
  static const String userAddresses = '/user-addresses';
  static const String countries = '/countries';
  static String locations(int countryId) => '/countries/$countryId/locations';
  static const String userAddressesLocations = '/user-addresses/locations';

  // Calculator endpoints
  static const String shipmentEstimates = '/shipment-estimates';

  // Shipment endpoints
  static const String suppliers = '/suppliers';
  static const String customsDuties = '/customs-duties';
  static const String shipmentRequests = '/shipment-requests';
  static String shipmentInvoice(int id) => '/shipment-request-invoice/$id';
  static String payInvoice(int id) => '/invoices/$id/pay';
  static String downloadInvoice(int id) =>
      '/shipment-request-invoice/$id/download';
}
