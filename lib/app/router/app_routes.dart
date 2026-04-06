class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String shipments = '/shipments';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String register = '/register';

  static const List<String> bottomNavLocations = [
    home,
    shipments,
    settings,
  ];

  static int indexFromLocation(String location) {
    if (location.startsWith(shipments)) {
      return 1;
    }
    if (location.startsWith(settings)) {
      return 2;
    }
    return 0;
  }
}
