import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/core/services/storage_service.dart';

part 'onboarding_provider.g.dart';

@Riverpod(keepAlive: true)
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  FutureOr<bool> build() async {
    final storage = ref.watch(storageServiceProvider.notifier);
    return await storage.getHasSeenOnboarding();
  }

  Future<void> completeOnboarding() async {
    final storage = ref.read(storageServiceProvider.notifier);
    await storage.setHasSeenOnboarding();
    state = const AsyncValue.data(true);
  }
}
