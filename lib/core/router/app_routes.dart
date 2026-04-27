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

  static const List<String> bottomNavLocations = [
    home,
    shipments,
    support,
    account,
  ];

  static int indexFromLocation(String location) {
    if (location.startsWith(shipments)) return 1;
    if (location.startsWith(support)) return 2;
    if (location.startsWith(account)) return 3;
    return 0;
  }
}
