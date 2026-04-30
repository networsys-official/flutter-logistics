import 'package:logistic_by_strom/core/constants/app_images.dart';
import 'package:logistic_by_strom/features/onboarding/data/models/onboarding_slide.dart';

const List<OnboardingSlide> onboardingSlides = [
  OnboardingSlide(
    title: 'Track every shipment from one place',
    description:
        'Manage trucks, containers, and active deliveries with a clear live operational views.',
    imagePath: AppImages.container,
  ),
  OnboardingSlide(
    title: 'Pack, sort, and dispatch faster',
    description:
        'Keep warehouse handoff simple so your team can move from booking to delivery without friction.',
    imagePath: AppImages.shipmentBox,
  ),
  OnboardingSlide(
    title: 'Stay in control across land and sea',
    description:
        'Get route visibility, faster updates, and location access for better shipment coordination.',
    imagePath: AppImages.cargoShip,
  ),
];
