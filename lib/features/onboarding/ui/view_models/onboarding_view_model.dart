import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/constants/strings/app_strings.dart';
import 'package:logistic_by_strom/core/providers/onboarding_provider.dart';
import 'package:logistic_by_strom/features/onboarding/data/onboarding_slides.dart';

part 'onboarding_view_model.g.dart';

@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  int build() => 0;

  int get currentPage => state;
  bool get isLastPage => state == onboardingSlides.length - 1;
  String get primaryActionLabel =>
      isLastPage ? AppStrings.start : AppStrings.nextCapitalized;

  void updatePage(int index) {
    if (state == index) {
      return;
    }
    state = index;
  }

  Future<void> completeOnboarding() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
  }
}
