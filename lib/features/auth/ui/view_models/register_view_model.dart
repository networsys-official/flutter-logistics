import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logistic_by_strom/features/auth/providers/auth_provider.dart';
import 'package:logistic_by_strom/features/auth/data/models/registration_response.dart';

part 'register_view_model.g.dart';

@riverpod
class RegisterViewModel extends _$RegisterViewModel {
  @override
  AsyncValue<RegistrationResponse?> build() => const AsyncValue.data(null);

  Future<RegistrationResponse?> register({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String password,
    required int countryId,
    required int locationId,
  }) async {
    state = const AsyncValue.loading();
    
    RegistrationResponse? response;
    state = await AsyncValue.guard(() async {
      final repository = ref.read(authRepositoryProvider);
      response = await repository.register(
        name: name,
        email: email,
        phone: phone,
        address: address,
        password: password,
        countryId: countryId,
        locationId: locationId,
      );
      return response;
    });
    
    return response;
  }
}
