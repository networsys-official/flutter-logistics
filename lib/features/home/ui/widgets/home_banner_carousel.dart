import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:logistic_by_strom/core/constants/app_images.dart';
import 'package:logistic_by_strom/core/theme/app_colors.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key});

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  static const List<_BannerData> _banners = [
    _BannerData(
      headline: 'SERVICES',
      subtitle: 'Reliable global shipping solutions',
      bgColor: AppColors.accentContainer,
      accentColor: AppColors.primary,
    ),
    _BannerData(
      headline: 'TRACKING',
      subtitle: 'Real-time shipment visibility',
      bgColor: AppColors.infoContainer,
      accentColor: AppColors.secondary,
    ),
    _BannerData(
      headline: 'SUPPORT',
      subtitle: '24/7 dedicated logistics support',
      bgColor: AppColors.highlightContainer,
      accentColor: AppColors.primaryDark,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final next = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _BannerSlide(data: _banners[index]),
          ),
        ),
        const SizedBox(height: 12),
        _PageIndicator(count: _banners.length, current: _currentPage),
      ],
    );
  }
}

class _BannerData {
  final String headline;
  final String subtitle;
  final Color bgColor;
  final Color accentColor;

  const _BannerData({
    required this.headline,
    required this.subtitle,
    required this.bgColor,
    required this.accentColor,
  });
}

class _BannerSlide extends StatelessWidget {
  final _BannerData data;

  const _BannerSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: data.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Decorative circle blobs
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: data.accentColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: data.accentColor.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Logo badge (top right)

          // Truck / illustration area
          Positioned(
            left: 0,
            bottom: 0,
            child: SizedBox(
              width: 160,
              height: 120,
              child: Image.asset(
                AppImages.cargoShip,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) => const HugeIcon(
                  icon: HugeIcons.strokeRoundedDeliveryTruck01,
                  size: 80,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          // Headline & subtitle
          Positioned(
            right: 16,
            bottom: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.headline,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: data.accentColor,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: data.accentColor.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _PageIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: index == current ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: index == current ? AppColors.primary : AppColors.neutral200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
