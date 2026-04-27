import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logistic_by_strom/core/router/app_routes.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';
import 'package:logistic_by_strom/core/theme/app_spacing.dart';


import 'package:logistic_by_strom/features/onboarding/data/onboarding_slides.dart';
import 'package:logistic_by_strom/features/onboarding/data/models/onboarding_slide.dart';
import 'package:logistic_by_strom/features/onboarding/ui/view_models/onboarding_view_model.dart';
import 'package:logistic_by_strom/features/onboarding/ui/widgets/onboarding_asset_illustration.dart';
import 'package:logistic_by_strom/features/onboarding/ui/widgets/onboarding_page_indicator.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToDashboard() {
    context.go(AppRoutes.register);
  }

  Future<void> _next() async {
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    if (viewModel.isLastPage) {
      _goToDashboard();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _handlePageChanged(int index) {
    ref.read(onboardingViewModelProvider.notifier).updatePage(index);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    final currentPage = ref.watch(onboardingViewModelProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space4,
            vertical: AppSpacing.space3,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: OnboardingPageIndicator(
                  count: onboardingSlides.length,
                  currentIndex: currentPage,
                ),
              ),
              const SizedBox(height: AppSpacing.space4),
              const SizedBox(height: AppSpacing.space5),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _handlePageChanged,
                  itemCount: onboardingSlides.length,
                  itemBuilder: (context, index) {
                    final OnboardingSlide slide = onboardingSlides[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          Expanded(
                            flex: 5,
                            child: Center(
                              child: OnboardingAssetIllustration(
                                imagePath: slide.imagePath,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(
                                    milliseconds: 280,
                                  ),
                                  child: Text(
                                    slide.title,
                                    key: ValueKey(slide.title),
                                    textAlign: TextAlign.center,
                                    style: textTheme.headlineMedium?.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      height: 1.3,
                                      color: const Color(0xFF222222),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.space3),
                                AnimatedSwitcher(
                                  duration: const Duration(
                                    milliseconds: 280,
                                  ),
                                  child: Text(
                                    slide.description,
                                    key: ValueKey(slide.description),
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: const Color(0xFFA4A4A4),
                                      height: 1.55,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: _goToDashboard,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF222222),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Skip'),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 146,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _next,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF131516),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(viewModel.primaryActionLabel),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
