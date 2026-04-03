import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:logistic_by_strom/app/router/app_routes.dart';
import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/app/theme/app_theme.dart';
import 'package:logistic_by_strom/core/constants/app_images.dart';
import 'package:logistic_by_strom/features/onboarding/presentation/widgets/onboarding_asset_illustration.dart';
import 'package:logistic_by_strom/features/onboarding/presentation/widgets/onboarding_logo.dart';
import 'package:logistic_by_strom/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:logistic_by_strom/features/onboarding/presentation/widgets/onboarding_permission_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _permissionPromptVisible = false;

  final List<_OnboardingSlideData> _slides = const [
    _OnboardingSlideData(
      title: 'Track every shipment from one place',
      description:
          'Manage trucks, containers, and active deliveries with a clear live operational view.',
      illustration: OnboardingAssetIllustration(imagePath: AppImages.container),
    ),
    _OnboardingSlideData(
      title: 'Pack, sort, and dispatch faster',
      description:
          'Keep warehouse handoff simple so your team can move from booking to delivery without friction.',
      illustration: OnboardingAssetIllustration(
        imagePath: AppImages.shipmentBox,
      ),
    ),
    _OnboardingSlideData(
      title: 'Stay in control across land and sea',
      description:
          'Get route visibility, faster updates, and location access for better shipment coordination.',
      illustration: OnboardingAssetIllustration(imagePath: AppImages.cargoShip),
    ),
  ];

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
    context.go(AppRoutes.dashboard);
  }

  Future<void> _next() async {
    if (_currentPage == _slides.length - 1) {
      _goToDashboard();
      return;
    }

    await _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _handlePageChanged(int index) {
    setState(() {
      _currentPage = index;
      _permissionPromptVisible = index == _slides.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space3,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: OnboardingPageIndicator(
                  count: _slides.length,
                  currentIndex: _currentPage,
                ),
              ),
              const SizedBox(height: AppTheme.space4),

              const SizedBox(height: AppTheme.space5),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: _handlePageChanged,
                      itemCount: _slides.length,
                      itemBuilder: (context, index) {
                        final slide = _slides[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              Expanded(
                                flex: 5,
                                child: Center(child: slide.illustration),
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
                                        style: textTheme.headlineMedium
                                            ?.copyWith(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                              height: 1.3,
                                              color: const Color(0xFF222222),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: AppTheme.space3),
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.space3),
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
                        child: Text(
                          _currentPage == _slides.length - 1 ? 'Start' : 'Next',
                        ),
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

class _OnboardingSlideData {
  const _OnboardingSlideData({
    required this.title,
    required this.description,
    required this.illustration,
  });

  final String title;
  final String description;
  final Widget illustration;
}
