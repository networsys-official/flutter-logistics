class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String shipments = '/shipments';
  static const String support = '/support';
  static const String account = '/account';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';

  // Order must match StatefulShellRoute branches in AppRouter
  static const List<String> bottomNavLocations = [
    home,
    shipments,
    support,
    account,
  ];
}
