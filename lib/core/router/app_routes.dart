class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String splash = '/splash';
  static const String register = '/register';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String onboarding = '/onboarding';
  static const String shipments = '/shipments';
  static const String support = '/support';
  static const String account = '/account';
  static const String settings = '/settings';
  static const String calculator = '/calculator';
  static const String editProfile = '/edit-profile';
  static const String shipmentAddress = '/shipment-address';
  static const String addAddress = '/add-address';
  static const String addShipment = '/add-shipment';
  static const String shipmentDetail = '/shipment-detail';
  static const String updatePassword = '/update-password';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String privacyPolicy = '/privacy-policy';
  static const String faq = '/faq';

  // Order must match StatefulShellRoute branches in AppRouter
  static const List<String> bottomNavLocations = [
    home,
    shipments,
    support,
    account,
  ];
}
