import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:logistic_by_strom/app/router/app_routes.dart';
import 'package:logistic_by_strom/app/theme/app_colors.dart';
import 'package:logistic_by_strom/app/theme/app_theme.dart';

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
      illustration: _OnboardingLogisticsIllustration(),
    ),
    _OnboardingSlideData(
      title: 'Pack, sort, and dispatch faster',
      description:
          'Keep warehouse handoff simple so your team can move from booking to delivery without friction.',
      illustration: _OnboardingBoxIllustration(),
    ),
    _OnboardingSlideData(
      title: 'Stay in control across land and sea',
      description:
          'Get route visibility, faster updates, and location access for better shipment coordination.',
      illustration: _OnboardingShipIllustration(),
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
                child: _PageIndicator(
                  count: _slides.length,
                  currentIndex: _currentPage,
                ),
              ),
              const SizedBox(height: AppTheme.space4),
              const _OnboardingLogo(),
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
                    if (_permissionPromptVisible)
                      const Align(
                        alignment: Alignment.center,
                        child: _LocationPermissionCard(),
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

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final bool isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 36 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1B1B1B) : const Color(0xFFB6B6B6),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _OnboardingLogo extends StatelessWidget {
  const _OnboardingLogo();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Opacity(
        opacity: 0.94,
        child: Image.asset(
          'assets/images/logo.png',
          width: 118,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _LocationPermissionCard extends StatelessWidget {
  const _LocationPermissionCard();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 40,
              offset: Offset(0, 18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 28,
                    color: Color(0xFF212121),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Allow Logistic Systems to access this device\'s location all-the-time?',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'App currently can access location only while you\'re using the app.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF5B5B5B),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            _PermissionAction(label: 'Allow all the time'),
            const Divider(height: 1),
            _PermissionAction(label: 'Keep while-in-use access'),
            const Divider(height: 1),
            _PermissionAction(label: 'Keep and don\'t ask again'),
          ],
        ),
      ),
    );
  }
}

class _PermissionAction extends StatelessWidget {
  const _PermissionAction({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF5A8DFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _OnboardingLogisticsIllustration extends StatelessWidget {
  const _OnboardingLogisticsIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 220,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 14,
            right: 6,
            child: Container(
              width: 136,
              height: 74,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4E70),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 12,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 38,
            right: 126,
            child: Column(
              children: List.generate(
                2,
                (_) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  width: 24,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2D3B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(left: 18, bottom: 26, child: _TruckIllustration()),
          Positioned(
            left: 70,
            bottom: 74,
            child: _MiniBox(size: 88, color: const Color(0xFFF8BD44)),
          ),
          const Positioned(
            left: 76,
            top: 44,
            child: _MiniBox(size: 28, color: Color(0xFFF8BD44)),
          ),
          const Positioned(
            right: 26,
            top: 102,
            child: _MiniBox(size: 44, color: Color(0xFFF8BD44)),
          ),
        ],
      ),
    );
  }
}

class _TruckIllustration extends StatelessWidget {
  const _TruckIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 106,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            bottom: 18,
            child: Container(
              width: 132,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF79D17F),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 26,
            child: Container(
              width: 136,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF69C764),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            left: 114,
            bottom: 22,
            child: Container(
              width: 78,
              height: 62,
              decoration: BoxDecoration(
                color: const Color(0xFFDDE4FE),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 12,
                    left: 10,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4E65FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...const [
            Positioned(left: 10, bottom: 0, child: _Wheel()),
            Positioned(left: 52, bottom: 0, child: _Wheel()),
            Positioned(left: 132, bottom: 0, child: _Wheel()),
            Positioned(left: 176, bottom: 0, child: _Wheel()),
          ],
        ],
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Color(0xFF4A4A57),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _MiniBox extends StatelessWidget {
  const _MiniBox({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(size * 0.12),
            ),
          ),
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: _BoxTopClipper(),
              child: Container(
                width: size,
                height: size * 0.36,
                color: Color.lerp(color, Colors.black, 0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingBoxIllustration extends StatelessWidget {
  const _OnboardingBoxIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 204,
        height: 174,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 26,
              child: Container(
                width: 96,
                height: 116,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC266),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 26,
              child: Container(
                width: 108,
                height: 116,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB246),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6),
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: ClipPath(
                clipper: _LeftFlapClipper(),
                child: Container(
                  width: 106,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFAA38),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: ClipPath(
                clipper: _RightFlapClipper(),
                child: Container(
                  width: 118,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDB8517),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 34,
              top: 54,
              child: Container(
                width: 10,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7B053),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingShipIllustration extends StatelessWidget {
  const _OnboardingShipIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 204,
      child: Stack(
        children: [
          Positioned(
            left: 28,
            right: 28,
            bottom: 0,
            child: SizedBox(
              height: 56,
              child: Column(
                children: const [_WaveRow(), SizedBox(height: 2), _WaveRow()],
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 96,
            child: Container(
              width: 70,
              height: 82,
              decoration: BoxDecoration(
                color: const Color(0xFFD9EDFF),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 6,
            left: 123,
            child: Container(
              width: 14,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6A77),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 88,
            left: 42,
            child: ClipPath(
              clipper: _ShipHullClipper(),
              child: Container(
                width: 176,
                height: 74,
                decoration: BoxDecoration(
                  color: const Color(0xFF4B4A58),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            top: 86,
            right: 54,
            child: Container(
              width: 34,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0A7),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Positioned(
            top: 96,
            right: 40,
            child: Container(
              width: 38,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A8A),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          ...const [
            Positioned(top: 110, left: 98, child: _ShipWindow()),
            Positioned(top: 110, left: 118, child: _ShipWindow()),
            Positioned(top: 110, left: 138, child: _ShipWindow()),
          ],
        ],
      ),
    );
  }
}

class _ShipWindow extends StatelessWidget {
  const _ShipWindow();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF2F2D37),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _WaveRow extends StatelessWidget {
  const _WaveRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        children: List.generate(
          4,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: const BoxDecoration(
                color: Color(0xFF8CB1FF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BoxTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.18, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * 0.82, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _LeftFlapClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, size.height * 0.45)
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _RightFlapClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.45)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _ShipHullClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(size.width * 0.15, 0, size.width * 0.32, 0)
      ..lineTo(size.width * 0.88, 0)
      ..quadraticBezierTo(
        size.width * 0.98,
        size.height * 0.02,
        size.width,
        size.height * 0.26,
      )
      ..lineTo(size.width * 0.9, size.height)
      ..lineTo(size.width * 0.14, size.height)
      ..lineTo(0, size.height * 0.44)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
