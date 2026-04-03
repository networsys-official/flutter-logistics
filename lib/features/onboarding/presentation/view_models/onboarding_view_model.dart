import 'package:flutter/foundation.dart';

import 'package:logistic_by_strom/features/onboarding/data/onboarding_slides.dart';

class OnboardingViewModel extends ChangeNotifier {
  int _currentPage = 0;

  int get currentPage => _currentPage;
  bool get isLastPage => _currentPage == onboardingSlides.length - 1;
  String get primaryActionLabel => isLastPage ? 'Start' : 'Next';

  void updatePage(int index) {
    if (_currentPage == index) {
      return;
    }

    _currentPage = index;
    notifyListeners();
  }
}
